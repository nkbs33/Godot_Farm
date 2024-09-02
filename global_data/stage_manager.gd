extends Node

var current_stage:String
var current_tasks = []
var task_cache = {}
var npc_name:String

var goal_watchers = []
var tasks = {}

func watch_task(task):
	var goals = DatabaseAgent.query_raw("task_goal","task_id = '%s'"%task.id)
	if goals.size() == 0:
		return
	tasks[task.id] = goals
	for goal in goals:
		var goal_watcher = GoalWatcher.new(goal)
		goal_watcher.update_task = update_task
		goal_watcher.goal_watchers = goal_watchers
		goal_watchers.append(goal_watcher)

func update_task(goal):
	var goals = tasks[goal.task_id]
	var finish = true
	for g in goals:
		if g.status == 'N':
			finish = false
			break
	if finish:
		end_task(goal.task_id)

class GoalWatcher:
	var item
	var num
	var _num = 0
	var goal
	var goal_watchers:Array
	var cut_signal
	var update_task
	
	func _init(goal_):
		goal = goal_
		var move = goal.target.split(' ')
		if move[0] == 'plant':
			item = move[1]
			num = int(move[2])
			Event.crop_planted.connect(self.watch_plant)
			cut_signal = func():
				Event.crop_planted.disconnect(self.watch_plant)
		print("watch goal %s"%[goal.description])
	
	func watch_plant(coord, crop_name, atlas):
		if crop_name == item:
			_num += 1
			print("watch_plant: %s %s/%s"%[goal.description, _num, num])
			if _num == num:
				finish()
	
	func finish():
		cut_signal.call()
		DatabaseAgent.db.update_rows("task_goal", "id = '%s'"%goal.id, {'status':'Y'})
		print("finish %s"%[goal.description])
		var i = goal_watchers.find(self)
		goal_watchers.remove_at(i)
		goal.status = 'Y'
		update_task.call(goal)


func handle_dialog_event(npc_name, event_str):
	var events = event_str.split(';')
	for e in events:
		var es = e.split(' ')
		if es[0] == 'get':
			var item = es[1]
			var num = int(es[2])
			GlobalData.backpack.add_item('carrot_seed', num)
		if es[0] == 'end_task':
			var id = int(es[1])
			end_task(id)
		if es[0] == 'take_task':
			take_task(int(es[1]))
		if es[0] == 'loop':
			DatabaseAgent.db.update_rows("npc_state", "name = '%s'"%npc_name, {'loop':1})

func find_task(npc_name):
	var tasks = DatabaseAgent.query_raw("task", "status = 'R' and npc_name = '%s'"%npc_name)
	if tasks.size() > 0:
		for t in tasks:
			if not task_cache.has(t.id):
				task_cache[t.id] = t
		return tasks[0]
	return null

func get_task(task_id):
	var t = DatabaseAgent.query_raw("task", "id = '%s'"%task_id)[0]
	if not task_cache.has(t.id):
		task_cache[t.id] = t
	return t

func take_task(task_id):
	DatabaseAgent.db.update_rows("task", "id = %s"%task_id, {'status':'I'})
	var task = get_task(task_id)
	DatabaseAgent.db.update_rows("npc_state", "name = '%s'"%task.npc_name, {'stage':'%s'%task_id, 'loop':0})
	print("take task %s"%task.name)
	watch_task(task)
	

func end_task(task_id):
	var task = get_task(task_id)
	DatabaseAgent.db.update_rows("task", "id = %s"%task_id, {'status':'F'})
	DatabaseAgent.db.update_rows("npc_state", "name = '%s'"%task.npc_name, {'stage':'%sF'%task_id, 'loop':0})
	print("end task %s"%task_cache[task_id].name)

func get_dialog_id(npc_name):
	var task = find_task(npc_name)
	if task:
		return task.dialog_id
	var state = DatabaseAgent.query_raw("npc_state", "name = '%s'"%npc_name)[0]
	var behav = DatabaseAgent.query_raw("npc_behavior", "name = '%s' and task_stage = '%s'"%[npc_name, state.stage])[0]
	if state.loop:
		return behav.loop_dialog_id
	else:
		return behav.dialog_id

func get_dialog(npc_name):
	var dialog_id = get_dialog_id(npc_name)
	var dialog_data = DialogData.get_dialog(dialog_id)
	return dialog_data
	

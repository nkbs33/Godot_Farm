extends RichTextLabel

var num:int 
var target_num:int
@export var count_time = 0.5
var num_increase_timer:float

func _ready():
	var bp = GlobalData.backpack
	text = str(bp.money)
	bp.money_change.connect(func(num_):
		num = target_num
		if target_num == num_:
			return
		target_num = num_
		num_increase_timer = 0)

func _physics_process(delta):
	if num_increase_timer >= count_time:
		return
	num_increase_timer += delta
	var ratio = num_increase_timer / count_time
	if ratio > 1:
		ratio = 1
	var num_tmp = num*(1-ratio) + target_num*ratio
	text = str(int(num_tmp))
	if num_increase_timer >= count_time:
		num = target_num
	

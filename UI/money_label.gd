extends RichTextLabel

var num:int 
var target_num:int
@export var count_time = 0.5
var timer:float

func _ready():
	var bp = GlobalData.backpack
	text = str(bp.money)
	bp.money_change.connect(func(num_):
		num = target_num
		if target_num == num_:
			return
		target_num = num_
		timer = 0)

func _physics_process(delta):
	if timer >= count_time:
		return
	timer += delta
	var ratio = timer / count_time
	if ratio > 1:
		ratio = 1
	var num_tmp = num*(1-ratio) + target_num*ratio
	text = str(int(num_tmp))
	if timer >= count_time:
		num = target_num
	

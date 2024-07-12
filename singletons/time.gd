extends Node

var timer:float	
@export var stopped:bool
@export var minute_sec:float
@export var time_data:Dictionary

func _ready():
	time_data = {
		"minute":0,
		"hour":0,
		"date":1,
		"month":1,
		"year":1
	}

func _physics_process(delta):
	if stopped:
		return
	timer += delta
	if timer > minute_sec:
		timer -= minute_sec
		time_data.minute += 10
		if time_data.minute == 60:
			time_data.minute = 0
			time_data.hour += 1
		if time_data.hour == 24:
			time_data.hour = 0
			time_data.date += 1
		if time_data.date == 30:
			time_data.month += 1
			time_data.date = 0
		if time_data.month == 4:
			time_data.year += 1
			
		Event.update_time.emit(time_data)

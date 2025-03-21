extends Node

var timer:float	
@export var paused:bool
@export var sec_per_min:float
var time:MyTime

class MyTime:
	var minute
	var hour
	var day
	var month
	var year
	
	func _init():
		minute = 0
		hour = 0
		day = 1
		month = 1
		year = 1

func _ready():
	time = MyTime.new()
	
func _physics_process(delta):
	if paused:
		return
	timer += delta
	if timer > sec_per_min:
		timer -= sec_per_min
		time.minute += 10
		if time.minute == 60:
			time.minute = 0
			time.hour += 1
		if time.hour == 24:
			time.hour = 0
			time.day += 1
		if time.day == 30:
			time.month += 1
			time.day = 0
		if time.month == 4:
			time.year += 1
			
		Event.update_time.emit(time)

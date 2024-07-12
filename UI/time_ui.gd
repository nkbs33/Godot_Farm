extends Label

func _ready():
	Event.update_time.connect(set_time)

func set_time(time):
	var month_str = "%02d-%02d" %[time.month, time.date]
	var time_str = "%02d:%02d" %[time.hour, time.minute]
	text = month_str +" "+ time_str

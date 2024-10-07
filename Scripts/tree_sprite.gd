extends AnimatedSprite2D

var current_value = 0
signal has_up(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("idle")


func play_idle(_value):
	current_value = _value
	if _value < 100.0:
		play("idle")
	elif _value >= 100.0 and _value < 300.0:
		play("idle10")
	elif _value >= 300.0 and _value < 600.0:
		play("idle30")
	elif _value >= 600.0 and _value < 1000.0:
		play("idle60")
	elif _value == 1000.0:
		play("done")

func on_play_anim(_value):
	current_value = _value
	print('current_value: ' + str(current_value))
	match current_value:
		100.0:
			play("up10")
			await animation_finished
			play("idle10")
			has_up.emit(100)
		300.0:
			play("up30")
			await animation_finished
			play("idle30")
			has_up.emit(300)
		600.0:
			play("up60")
			await animation_finished
			play("idle60")
			has_up.emit(600)
		1000.0:
			play("up100")
			await animation_finished
			play("done")
			has_up.emit(1000)

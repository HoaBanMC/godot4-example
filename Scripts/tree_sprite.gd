extends AnimatedSprite2D

var current_value = 0
var grow_uping = false
signal has_up(value)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("idle")


func on_play_anim(_value):
	if _value >= 1000 and current_value < 1000:
		on_grow_up(1000)
	elif _value >= 600 and current_value < 600:
		on_grow_up(600)
	elif _value >= 300 and current_value < 300:
		on_grow_up(300)
	elif _value >= 100 and current_value < 100:
		on_grow_up(100)
	elif !grow_uping:
		play_idle(_value)
	

func play_idle(_value):
	current_value = _value
	if _value < 100:
		play("idle")
	elif _value >= 100 and _value < 300:
		play("idle10")
	elif _value >= 300 and _value < 600:
		play("idle30")
	elif _value >= 600 and _value < 1000:
		play("idle60")
	elif _value == 1000:
		play("done")


func on_grow_up(_value) -> void:
	current_value = _value
	grow_uping = true
	has_up.emit(false)
	match current_value:
		100:
			play("up10")
			await animation_finished
			play("idle10")
			has_up.emit(true)
			grow_uping = false
		300:
			play("up30")
			await animation_finished
			play("idle30")
			has_up.emit(true)
			grow_uping = false
		600:
			play("up60")
			await animation_finished
			play("idle60")
			has_up.emit(true)
			grow_uping = false
		1000:
			play("up100")
			await animation_finished
			play("done")
			has_up.emit(true)
			grow_uping = false

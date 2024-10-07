extends Control

func set_score(score) -> void:
	$Label.text = "+" + str(score)
	$AnimationPlayer.play("fly_score")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
	pass

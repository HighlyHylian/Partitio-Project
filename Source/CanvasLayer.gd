extends CanvasLayer

signal transitioned_to_black
signal transitioned_to_clear

# Called when the node enters the scene tree for the first time.
	
func transition_to_black():
	$AnimationPlayer.play("fade_to_black")
	# check

func transition_to_clear():
	$AnimationPlayer.play("fade_to_normal")
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("transitioned_to_black")
		$AnimationPlayer.play("fade_to_normal")

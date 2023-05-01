extends Node2D

signal gotten
var image = preload("res://Assets/Sprites/Flag/CP_gotten.png")
var is_collected: bool = false

func _on_area_2d_body_entered(body):
	if(!is_collected):
		emit_signal("gotten", position)
		$flag_base.texture = image
		$Yay.play()
		is_collected = true

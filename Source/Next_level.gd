extends Sprite2D

signal switch_levels_now

func _on_area_2d_body_entered(body):
	print("LEVEL OVER")
	$Area2D/CollisionShape2D.disabled = true
	emit_signal("switch_levels_now")

extends Sprite2D

signal switch_levels_now

func _on_area_2d_body_entered(body):
	print("LEVEL OVER")
	emit_signal("switch_levels_now")

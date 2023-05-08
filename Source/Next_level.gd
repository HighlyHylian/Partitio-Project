extends Sprite2D

signal switch_levels_now

func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://Mainmenu.tscn")

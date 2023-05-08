extends Node2D

signal switch_levels




func _on_player_died():
	$Player.global_position = $PlayerSpawn.global_position

func _on_next_level_switch_levels_now():
	emit_signal("switch_levels")
	print("ACTUALLY SWITCHING NOW")

func _on_cp__gotten(position):
	$PlayerSpawn.position = position




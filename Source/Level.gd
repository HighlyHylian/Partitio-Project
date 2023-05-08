extends Node2D

signal switch_levels

func _ready():
	$Music.set_volume_db(-2)
	$Music.play()

func _on_player_died():
	$Player.global_position = $PlayerSpawn.global_position
	$Player/Dead.play()

func _on_next_level_switch_levels_now():
	emit_signal("switch_levels")
	print("ACTUALLY SWITCHING NOW")

func _on_cp__gotten(position):
	$PlayerSpawn.position = position




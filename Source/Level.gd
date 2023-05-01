extends Node2D

signal switch_levels

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.set_volume_db(3)
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_died():
	$Player.global_position = $PlayerSpawn.global_position

func _on_next_level_switch_levels_now():
	emit_signal("switch_levels")
	print("ACTUALLY SWITCHING NOW")

func _on_cp__gotten(position):
	$PlayerSpawn.position = position


func _on_music_finished():
	$Music.play()

extends Node2D

var transitionNow: bool = true
var sceneNo: int = 0


const tutorialScene = preload("res://LevelL1.tscn")
const level1 = preload("res://LevelG1.tscn")

var sceneArray = [tutorialScene,level1]

# Called every frame. 'delta' is the delapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	$TransitionScene/AnimationPlayer.play("fade_to_normal")


func _on_transition_scene_transitioned():
	sceneNo+=1
	var scene = sceneArray[sceneNo].instantiate()
	scene.switch_levels.connect(on_switch_levels)
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(scene)

func on_switch_levels():
	$TransitionScene.transition()

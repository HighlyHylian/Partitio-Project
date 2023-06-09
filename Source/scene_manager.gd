extends Node2D

var transitionNow: bool = true
var sceneNo: int = 0


const tutorialScene = preload("res://LevelL1.tscn")
const level1 = preload("res://LevelG1.tscn")
const level2 = preload("res://LevelL2.tscn")

var sceneArray = [0,tutorialScene,level1,level2]

var max_scene_no = sceneArray.size()

# Called every frame. 'delta' is the delapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	$TransitionScene.transition()


func _on_transition_scene_transitioned():
	sceneNo+=1
	print("sceneNo " + str(sceneNo) + "\nsceneMax " + str(max_scene_no))
	if sceneNo == max_scene_no:
		get_tree().quit()
	else:
		var scene = sceneArray[sceneNo].instantiate()
		scene.switch_levels.connect(on_switch_levels)
		var useController = false
		if(sceneNo !=1):
			useController = $CurrentScene.get_child(0).get_child(0).controller
			$CurrentScene.get_child(0).queue_free()
		$CurrentScene.add_child(scene)
		$CurrentScene.get_child(0).get_child(0).controller = useController

func on_switch_levels():
	$TransitionScene.transition()

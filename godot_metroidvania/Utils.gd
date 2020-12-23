"""
UTILS.GD

Singleton, functions needed in multiple places.
"""
extends Node


"""
FUNC INTANCE_SCENE_ON_MAIN()

"""
func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance

"""
PLAYERGUN.GD

"""
extends Node2D


"""
FUNC _PROCESS()

It will follow the rotation of the mouse.
"""
func _process(delta):
	var player = get_parent()
	rotation = player.get_local_mouse_position().angle()

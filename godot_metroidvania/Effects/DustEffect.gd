"""
DustEffect.gd

A dust effect when the player character is moving.
"""
extends Node2D

# Random range x and Y for the particles. Y always upwards.
var motion = Vector2(rand_range(-20, 20), rand_range(-10, -40))


"""
FUNC _PROCESS()

"""
func _process(delta):
	position += motion * delta

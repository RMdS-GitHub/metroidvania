"""
WORLD.GD

Set the background to black.
"""
extends Node

# Set the background fully black.
func _ready():
	VisualServer.set_default_clear_color(Color.black)

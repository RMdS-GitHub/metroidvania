"""
HITBOX.GD

"""
extends Area2D

# How much damage this hitbox will deal.
export(int) var damage = 1


func _on_Hitbox_area_entered(hurtbox: Area2D) -> void:
	hurtbox.emit_signal("hit", damage)

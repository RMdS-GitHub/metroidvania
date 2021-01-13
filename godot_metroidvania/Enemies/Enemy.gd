"""
ENEMY.GD


"""
extends KinematicBody2D

export(int) var MAX_SPEED = 15
var motion = Vector2.ZERO

onready var stats = $EnemyStats


"""
FUNC _ON_HURTBOX_HIT()

"""
func _on_Hurtbox_hit(damage) -> void:
	stats.health -= damage


"""
FUNC _ON_ENEMYSTATS_ENEMY_DIED()

"""
func _on_EnemyStats_enemy_died() -> void:
	queue_free()

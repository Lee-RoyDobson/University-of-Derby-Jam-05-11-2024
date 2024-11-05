extends CharacterBody2D

var health = 30

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	pass

func do_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()

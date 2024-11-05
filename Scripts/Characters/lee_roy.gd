extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var jumping = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		print(anim.animation)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction and is_on_floor():
		print("in direction")
		velocity.x = direction * SPEED
		if direction > 0:
			anim.play("Run")
			anim.flip_h = true
		elif direction < 0 :
			anim.play("Run")
			anim.flip_h = false
	elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play("Idle")
			

	
	move_and_slide()

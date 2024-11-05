extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var pew: AudioStreamPlayer2D = $Pew
@onready var boing: AudioStreamPlayer2D = $Boing


const BULLET = preload("res://Scenes/Bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var facing_left = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if velocity.x == 0:
			anim.play("JumpInPlace")
		else:
			anim.play("Jump")
		boing.play()
		
	if Input.is_action_just_pressed("fire") and is_on_floor():
		if facing_left:
			var new_bullet = BULLET.instantiate()
			new_bullet.position = position
			new_bullet.position.y -= 50
			new_bullet.fire(-1)
			$Bullets.add_child(new_bullet)
		else:
			var new_bullet = BULLET.instantiate()
			new_bullet.position = position
			new_bullet.position.y -= 50
			new_bullet.fire(1)
			$Bullets.add_child(new_bullet)
		pew.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0 and (anim.animation != "Jump" or not anim.is_playing()): 
			anim.play("Run")
			anim.flip_h = true
			facing_left = false
		elif direction < 0 and (anim.animation != "Jump" or not anim.is_playing()):
			anim.play("Run")
			anim.flip_h = false
			facing_left = true
	elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play("Idle")
			

	
	move_and_slide()

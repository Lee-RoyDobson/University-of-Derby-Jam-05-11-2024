class_name Player extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var pew: AudioStreamPlayer2D = $Pew
@onready var boing: AudioStreamPlayer2D = $Boing
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_cooldown: Timer = $ShootCooldown
@onready var i_frames: Timer = $IFrames
@onready var progress_bar: ProgressBar = $ProgressBar


const BULLET = preload("res://Scenes/Bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var facing_left = true
var animating = false
var can_shoot = true
var health = 3
var can_take_damage = true

enum State {
	IDLE,
	MOVE,
	SHOOT,
	HIT,
	DIE,
	JUMP
}

var current_state = State.IDLE

func _ready() -> void:
	var sb = StyleBoxFlat.new()
	progress_bar.add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("ff0000")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0 and (anim.animation != "Jump" or not anim.is_playing()): 
			current_state = State.MOVE
			anim.flip_h = true
			facing_left = false
		elif direction < 0 and (anim.animation != "Jump" or not anim.is_playing()):
			current_state = State.MOVE
			anim.flip_h = false
			facing_left = true
	elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
			current_state = State.IDLE
			
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		current_state = State.JUMP
		boing.play()
		
	if Input.is_action_just_pressed("fire") and is_on_floor() and can_shoot:
		can_shoot = false
		shoot_cooldown.start()
		shoot_timer.start()
		pew.play()
		current_state = State.SHOOT

	ProcessState()
	
	move_and_slide()
	
func ProcessState():
	if current_state == State.JUMP:
		anim.play("Jump")
		
		
	if animating:
		return
	
	match current_state:
		State.IDLE:
			anim.play("Idle")
			
		State.MOVE:
			anim.play("Run")
			
		State.SHOOT:
			anim.play("Shoot")
			animating = true
		


func _on_animated_sprite_2d_animation_finished() -> void:
	animating = false


func _on_shoot_timer_timeout() -> void:
	if facing_left:
		var new_bullet = BULLET.instantiate()
		new_bullet.position = position
		new_bullet.position.y -= 60
		new_bullet.position.x -= 50
		new_bullet.fire(-1)
		$Bullets.add_child(new_bullet)
	else:
		var new_bullet = BULLET.instantiate()
		new_bullet.position = position
		new_bullet.position.y -= 60
		new_bullet.position.x += 50
		new_bullet.fire(1)
		$Bullets.add_child(new_bullet)


func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true
	
func do_damage():
	print(can_take_damage)
	if can_take_damage:
		progress_bar.value -= 1
		health -= 1
		if health <= 0:
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		can_take_damage = false
		i_frames.start()


func _on_i_frames_timeout() -> void:
	can_take_damage = true

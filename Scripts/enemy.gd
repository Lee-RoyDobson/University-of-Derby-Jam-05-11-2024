extends CharacterBody2D

@onready var progress_bar: ProgressBar = $ProgressBar

var health = 30

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _ready() -> void:
	var sb = StyleBoxFlat.new()
	progress_bar.add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("ff0000")

func _physics_process(delta: float) -> void:
	pass

func do_damage(amount):
	progress_bar.value -= 1
	health -= amount
	if health <= 0:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.do_damage()

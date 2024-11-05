class_name Bullet extends Area2D

var damage = 10
var direction = -1
var speed = 600

func fire(new_direction):
	direction = new_direction
	
func _process(delta: float) -> void:
	position.x += direction * speed * delta
	

func _on_body_entered(body: Node2D) -> void:
	body.do_damage(damage)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

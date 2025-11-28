extends Area2D

@export var speed = 200.0

func _physics_process(delta):
	# Di chuyển sang trái
	position.x -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	# Tự hủy khi ra khỏi màn hình (Bạn cần thêm node VisibleOnScreenNotifier2D vào scene)
	queue_free()

# Hàm xử lý khi chim va vào ống
func _on_body_entered(body):
	if body.name == "Bird":
		# Game Over logic
		get_tree().reload_current_scene()

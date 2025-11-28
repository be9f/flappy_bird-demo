extends Area2D

# Tốc độ di chuyển của ống (pixel/giây)
var speed = 200.0

func _process(delta):
	# Di chuyển toàn bộ cặp ống sang bên trái
	position.x -= speed * delta

# Hàm xử lý va chạm với Chim
func _on_body_entered(body):
	# Kiểm tra xem vật va vào có phải là Chim không (Dựa trên tên Node hoặc Class)
	if body.name == "Bird":
		print("Chim da chet! Game Over.")
		# Lệnh reload lại game ngay lập tức
		get_tree().reload_current_scene()

# Hàm xử lý khi ống đi ra khỏi màn hình (để xóa đi cho nhẹ máy)
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

extends Area2D

# Tốc độ di chuyển của ống (phải khớp với tốc độ nền nếu có)
@export var speed = 200.0

signal bird_crashed

func _process(delta):
	# Di chuyển sang trái
	position.x -= speed * delta

# Kết nối tín hiệu "body_entered" của Area2D vào đây
func _on_body_entered(body):
	# Kiểm tra xem vật va chạm có phải là Chim không
	if body.name == "Bird":
		# Gửi tín hiệu hoặc gọi hàm game over
		# Ở đây ta gọi trực tiếp hàm die() của chim cho đơn giản
		if body.has_method("die"):
			body.die()

# Kết nối tín hiệu "screen_exited" của VisibleOnScreenNotifier2D
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Xóa ống để giải phóng bộ nhớ
	# Gắn signal body_entered của ScoreArea
func _on_score_area_body_entered(body):
	if body.name == "Bird":
		# Tăng điểm (Giả sử bạn có biến Global hoặc truy cập Main)
		# Ví dụ đơn giản:
		print("Score +1")
		# Gợi ý: Dùng Signal để báo về Main cập nhật UI

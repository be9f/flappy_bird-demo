extends Area2D
signal scored
# Tốc độ di chuyển của ống (pixel/giây)
var speed = 200.0

func _process(delta):
	# Di chuyển toàn bộ cặp ống sang bên trái
	position.x -= speed * delta

# Hàm xử lý va chạm với Chim
func _on_body_entered(body):
	if body.name == "Bird":
		# THAY ĐỔI Ở ĐÂY: Không gọi reload_current_scene() nữa
		# Mà gọi hàm _game_over() ở bên World
		
		# Cách gọi hàm của node cha (World)
		var world = get_tree().current_scene
		if world.has_method("_game_over"):
			world._game_over()
# Hàm xử lý khi ống đi ra khỏi màn hình (để xóa đi cho nhẹ máy)
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_score_area_body_entered(body: Node2D) -> void:
	if body.name == "Bird":
		# QUAN TRỌNG: Kiểm tra xem chim còn sống không?
		# Nếu chim còn sống (is_alive == true) thì mới tính điểm
		if body.get("is_alive") == true:
			scored.emit()
			$ScoreArea.queue_free() # Xóa vùng điểm để không tính 2 lần

extends Node2D

# Preload scene ống để sinh ra
var pipe_scene = preload("res://Scene/PipePair.tscn")
var score = 0
func _ready():
	# Kết nối tín hiệu timeout của Timer
	$PipeSpawner.timeout.connect(_on_pipe_spawner_timeout)
	# Reset điểm khi bắt đầu
	update_score_label()

func _on_pipe_spawner_timeout():
	# 1. Tạo instance của ống
	var pipe = pipe_scene.instantiate()

	# 2. Đặt vị trí X (bên phải màn hình) và Y ngẫu nhiên
	# Giả sử màn hình rộng 480, ta đặt ở 550 để nó xuất hiện từ ngoài
	var random_y = randf_range(300, 600) # Tùy chỉnh theo độ cao màn hình của bạn
	pipe.position = Vector2(550, random_y)

	# 3. Kết nối tín hiệu va chạm (nếu chưa xử lý bên trong Pipe)
	pipe.scored.connect(_on_point_scored)
	
	add_child(pipe)

	# 4. Thêm vào World
	add_child(pipe)

func _on_pipe_hit(body):
	if body.name == "Bird":  #Kiểm tra tên của đối tượng va chạm
		print("Bird hit pipe!") # Add a print statement to confirm the code is reached.
		print("get_tree() value:", get_tree()) # Debugging - check if get_tree() is null
		if get_tree() != null:  # Check before calling reload_current_scene()
			get_tree().reload_current_scene()
		else:
			print("Error: get_tree() is null. Cannot reload scene.") # Informative message
# Hàm này được gọi khi nhận tín hiệu từ ống
func _on_point_scored():
	score += 1
	# Có thể thêm âm thanh "Ting" ở đây
	update_score_label()
# Hàm cập nhật text lên màn hình
func update_score_label():
	$CanvasLayer/ScoreLabel.text = str(score)

extends Node2D
# Khai báo biến để lấy node Menu (kéo thả hoặc gõ đúng đường dẫn)
@onready var game_over_menu = $CanvasLayer/GameOverMenu
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


func _on_point_scored():
	score += 1
	# Có thể thêm âm thanh "Ting" ở đây
	update_score_label()
# Hàm cập nhật text lên màn hình
func update_score_label():
	$CanvasLayer/ScoreLabel.text = str(score)
func _on_restart_button_pressed():
	# Bỏ tạm dừng game (nếu bạn có dùng tính năng pause)
	get_tree().paused = false
	# Load lại màn chơi hiện tại
	get_tree().reload_current_scene()
func _game_over():
	# 1. Dừng bộ đếm sinh ống
	$PipeSpawner.stop()
	
	# 2. Hiện menu Game Over
	game_over_menu.visible = true
	
	# 3. Dừng toàn bộ hoạt động của game (Chim đứng yên, ống dừng trôi)
	# Lệnh này cực mạnh, nó đóng băng toàn bộ physics
	get_tree().paused = true

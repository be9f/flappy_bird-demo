extends Node2D

# --- Node ---
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var game_over_menu = $CanvasLayer/GameOverMenu
@onready var pipe_spawner = $PipeSpawner
@onready var bird = $Bird # Kéo node Bird vào đây trong scene

# --- Cấu hình ---
var pipe_scene = preload("res://Scene/PipePair.tscn")
var score = 0

func _ready():
	# Kết nối timeout của timer
	pipe_spawner.timeout.connect(_on_pipe_spawner_timeout)
	
	
	
	# QUAN TRỌNG: Kết nối tín hiệu chết từ Bird
	bird.died.connect(_on_bird_died)
	
	# Kết nối nút Restart (giả sử nút có signal pressed)
	# Lưu ý: Trong UI, nút Restart phải có name là "RestartButton" hoặc bạn kéo thả node vào
	var restart_btn = game_over_menu.get_node("RestartButton")
	if restart_btn:
		restart_btn.pressed.connect(_on_restart_button_pressed)

	# Ẩn menu game over lúc đầu
	game_over_menu.visible = false
	update_score_label()

func _on_pipe_spawner_timeout():
	var pipe = pipe_scene.instantiate()
	
	# Tính toán vị trí spawn dựa trên chiều rộng màn hình để linh hoạt
	var screen_width = get_viewport_rect().size.x
	var spawn_x = screen_width + 50 
	var random_y = randf_range(200, 600) # Tùy chỉnh theo màn hình của bạn

	pipe.position = Vector2(spawn_x, random_y)
	
	# Kết nối tín hiệu
	pipe.scored.connect(_on_point_scored)
	# PipePair không cần gọi Main game_over nữa, nó chỉ cần báo bird đã va chạm (hoặc Bird tự báo)
	
	add_child(pipe)

func _on_point_scored():
	score += 1
	update_score_label()

func _on_bird_died():
	# Khi bird phát tín hiệu chết:
	# 1. Dừng sinh ống
	pipe_spawner.stop()
	
	# 2. Hiện menu
	game_over_menu.visible = true
	
	# 3. Pause game
	get_tree().paused = true

func update_score_label():
	score_label.text = str(score)

func _on_restart_button_pressed():
	# Bỏ pause
	get_tree().paused = false
	# Load lại scene
	get_tree().reload_current_scene()

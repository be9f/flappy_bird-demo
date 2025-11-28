extends Node2D

@export var pipe_scene: PackedScene # Kéo thả scene Pipe vào đây ở Inspector
@export var spawn_range = 150.0 # Khoảng cách random độ cao lên xuống

func _ready():
	# Kết nối signal timeout của Timer bằng code (hoặc qua giao diện)
	$Timer.timeout.connect(spawn_pipe)

func spawn_pipe():
	# Tạo instance của ống
	var pipe = pipe_scene.instantiate()
	
	# Thêm ống vào Scene chính
	add_child(pipe)
	
	# Đặt vị trí xuất phát (bên phải màn hình)
	# position.x là vị trí của Spawner, position.y sẽ random
	pipe.position.x = get_viewport_rect().size.x + 50
	pipe.position.y = randf_range(-spawn_range, spawn_range) + position.y

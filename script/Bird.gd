extends CharacterBody2D

const JUMP_VELOCITY = -400.0 # Lực nhảy
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # Lấy trọng lực mặc định
var max_rotation_degrees = 25.0

func _physics_process(delta):
	# 1. Áp dụng trọng lực
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Xử lý nhảy
	if Input.is_action_just_pressed("jump"):  
		velocity.y = JUMP_VELOCITY
		rotation_degrees = -max_rotation_degrees # Ngước đầu lên khi nhảy

	# 3. Xoay đầu chim khi rơi
	if velocity.y > 0:
		# Lerp để xoay mượt mà xuống dưới (tối đa 90 độ)
		rotation_degrees = lerp(rotation_degrees, 90.0, 5 * delta)
	
	# 4. Di chuyển
	move_and_slide()
	
	# 5. Kiểm tra va chạm sàn/trần (đơn giản hóa)
	# Nếu chim rơi quá thấp hoặc bay quá cao -> chết
	if global_position.y > 854 or global_position.y < -50:
		get_tree().reload_current_scene() # Reset game

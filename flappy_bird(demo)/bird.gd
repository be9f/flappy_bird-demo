extends CharacterBody2D
# Các biến điều chỉnh cảm giác chơi
@export var gravity = 900.0
@export var jump_force = -300.0
@export var rotation_speed = 2.0

func _physics_process(delta):
	# 1. Áp dụng trọng lực rơi xuống
	velocity.y += gravity * delta
	
	# 2. Xử lý nhảy khi bấm nút
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
		rotation = deg_to_rad(-30.0) # Ngửa đầu lên khi nhảy
		
	# 3. Hiệu ứng xoay đầu chú chim
	# Nếu đang rơi nhanh, chúc đầu xuống
	if velocity.y > 0:
		rotation = lerp(rotation, deg_to_rad(90.0), rotation_speed * delta)
	
	# 4. Thực hiện di chuyển vật lý
	move_and_slide()
	
	# 5. Kiểm tra va chạm (nếu dùng CharacterBody2D để check va chạm với đất)
	if is_on_floor():
		die()

func die():
	# Xử lý khi chết (có thể emit signal lên Main để dừng game)
	print("Game Over")
	get_tree().reload_current_scene() # Restart nhanh để test

extends CharacterBody2D

# --- Cấu hình ---
const JUMP_VELOCITY = -450.0 # Tăng nhẹ lực nhảy để cảm giác tốt hơn
const FALL_SPEED = 1000.0    # Tốc độ rơi tối đa
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_alive = true

# --- Tín hiệu ---
signal died # Gửi tin hiệu ra ngoài khi chim chết

func _ready():
	# Thêm chim vào nhóm 'player' để dễ nhận diện va chạm
	add_to_group("player")

func _physics_process(delta):
	if not is_alive:
		return

	# 1. Xử lý trọng lực
	# Áp dụng trọng lực và giới hạn tốc độ rơi
	velocity.y += gravity * delta
	if velocity.y > FALL_SPEED:
		velocity.y = FALL_SPEED

	# 2. Xử lý nhảy
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	# 3. Xử lý xoay chim mượt mà (Rotation)
	# Nếu bay lên: ngước đầu lên (-25 độ). Nếu rơi: cúi đầu xuống (tối đa 90 độ).
	var target_rotation = 90.0
	if velocity.y < 0:
		target_rotation = -25.0
	
	# Lerp để xoay từ từ, nhân delta để độc lập với framerate
	rotation_degrees = lerp(rotation_degrees, target_rotation, 10 * delta)

	# 4. Di chuyển
	move_and_slide()

	# 5. Kiểm tra rơi xuống vực hoặc bay quá cao (Dùng Viewport thay vì số cứng)
	var viewport_rect = get_viewport_rect()
	var screen_bottom = viewport_rect.size.y
	# Giả sử chạm đáy là chết
	if global_position.y > screen_bottom or global_position.y < -100:
		die()

func die():
	if is_alive:
		is_alive = false
		died.emit() # Phát tín hiệu chết (Main sẽ lắng nghe cái này)
		print("Bird died!")

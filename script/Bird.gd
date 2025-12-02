extends CharacterBody2D

const JUMP_VELOCITY = -400.0 # Lực nhảy
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # Lấy trọng lực mặc định
var max_rotation_degrees = 25.0
var is_alive = true

func _physics_process(delta):
	# Nếu chết rồi thì không cho bay nữa
	if is_alive == false:
		return
	# 1. Áp dụng trọng lực
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# === LOGIC MỚI: CHẠM SÀN GAME OVER ===
	if is_on_floor():
		die()
		velocity.y = 0 # Đảm bảo chim không bị bật lên do is_on_floor()
	# ======================================
	
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
	if global_position.y > 854 or global_position.y < -45:
		die() # Gọi hàm Game Over mới

# Tạo hàm xử lý cái chết riêng
func die():
	if is_alive == true:
		is_alive = false
		
		# === LOGIC MỚI: GỌI HÀM _GAME_OVER() TỪ WORLD ===
		var world = get_tree().current_scene
		if world.has_method("_game_over"):
			world._game_over()
		# ==================================================
		
		# Hiển thị màn hình Game Over (bạn cần tạo một scene cho màn hình này)
		print("Game Over!")
		# Bạn có thể thêm các hành động khác ở đây, ví dụ như:
		# - Điều khiển UI để hiển thị thông báo Game Over.
		# - Ngừng tất cả các hoạt động của game (ví dụ như dừng âm thanh, stop_physics).
		# - Hiển thị nút "Restart".

		# Không cần reload scene nữa vì chúng ta sẽ quản lý việc bắt đầu lại trò chơi từ màn hình này.

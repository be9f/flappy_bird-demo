extends Area2D

signal scored

@onready var score_area = $ScoreArea # Đảm bảo node ScoreArea có tên này trong scene
var speed = 250.0 # Tăng tốc độ lên chút cho khó hơn

func _ready():
	# Kết nối tín hiệu va chạm của chính Area2D này (nó là ống)
	# Nếu Bird chạm vào thân ống -> Bird chết
	body_entered.connect(_on_body_entered)

func _process(delta):
	position.x -= speed * delta

func _on_body_entered(body):
	# Kiểm tra xem vật chạm vào có thuộc nhóm "player" không
	if body.is_in_group("player"):
		# Gọi hàm die() của Bird trực tiếp thay vì reload scene
		# Cách này nhanh hơn và chuyên nghiệp hơn
		if body.has_method("die"):
			body.die()

# Xử lý khi đi ra khỏi màn hình
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Xử lý chấm điểm (Area Score riêng biệt)
func _on_score_area_body_entered(body: Node2D) -> void:
	# Lưu ý: ScoreArea cũng là một Area2D con của PipePair
	# Bạn cần đảm bảo node ScoreArea trong scene có kết nối signal body_entered vào hàm này
	if body.is_in_group("player"):
		if body.get("is_alive") == true:
			scored.emit()
			if score_area:
				score_area.queue_free() # Xóa vùng điểm để tránh tính 2 lần

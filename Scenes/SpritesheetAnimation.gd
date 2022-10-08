extends Sprite


export (float) var interval

func _ready() -> void:
	$Timer.wait_time = interval

func _on_Timer_timeout() -> void:
	frame = (frame + 1) % (hframes * vframes)

func change_animation(image: Resource, horizontalf: int, verticalf: int):
	texture = image
	hframes = horizontalf
	vframes = verticalf

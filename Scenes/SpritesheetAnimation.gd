extends Sprite


export (float) var interval

func _ready() -> void:
	$Timer.wait_time = interval

func _on_Timer_timeout() -> void:
	frame = (frame + 1) % (hframes * vframes)

func change_animation(image: Texture, horizontalf: int, verticalf: int):
	texture = image
	hframes = horizontalf
	vframes = verticalf
	
	if hframes == 1 and vframes == 1:
		$Timer.stop()
		frame = 0
	if $Timer.is_stopped():
		$Timer.start()

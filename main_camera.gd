extends Camera3D

func _process(_delta: float) -> void:
	$FPS.text = "FPS: " +  str(Engine.get_frames_per_second())
	pass

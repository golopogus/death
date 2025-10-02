extends Path2D

func _process(delta: float) -> void:
	
	$PathFollow2D.progress += 50 * delta

func start(pos):
	position = pos
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()

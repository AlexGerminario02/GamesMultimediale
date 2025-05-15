extends StaticBody3D

var speed: float = 4

func _physics_process(delta: float) -> void:
	position.z -= speed * delta
	
	# Rimuovi l'ostacolo quando è fuori schermo
	if position.z < -5:
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()  # Rimuovi ostacolo in caso di collisione

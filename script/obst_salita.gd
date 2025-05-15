extends StaticBody3D

var speed: float = 4

func _physics_process(delta: float) -> void:
	# Muovi l'ostacolo lungo l'asse Z
	position.z -= speed * delta
	
	# Rimuovi l'ostacolo quando è fuori schermo
	if position.z < -5:
		queue_free()

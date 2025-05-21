extends StaticBody3D

var speed: float = 4
var rotation_speed: float = 1.5  # velocità di rotazione in radianti/sec

func _physics_process(delta: float) -> void:
	# Sposta l'alimento lungo l'asse Z
	position.z -= speed * delta
	
	# Ruota sull'asse Y
	rotation.y += rotation_speed * delta
	
	# Rimuovi l'alimento se è fuori schermo
	if position.z < -5:
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()  # Rimuove alimento se toccato dal player

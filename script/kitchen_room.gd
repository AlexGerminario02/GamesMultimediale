extends StaticBody3D

@export var speed: float = 4
@export var acceleration: float = 0.2

@export var respawn_z: float = 320
@export var check_z: float = 10
@export var destroy_z: float = -158.0
var spawn = true

func _physics_process(delta: float) -> void:
	speed += acceleration * delta
	position.z -= speed * delta

	if position.z < destroy_z:
		queue_free()
		
	if position.z < check_z and spawn:
		spawn_clone()
		spawn=false
		
func spawn_clone():
	var clone = duplicate()  # Clone itself
	clone.position.z = respawn_z  # Reset Z position
	clone.position.x = position.x  # Optional: keep same X
	get_parent().add_child(clone)  # Add to same parent

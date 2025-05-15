extends MeshInstance3D

var offset = 0.0
var speed = 0.6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void :
	offset -= speed * delta
	if offset <= -1:
		offset = 0
	get_active_material(0).uv1_offset.x = offset

extends CharacterBody3D

const LANES: Array = [-1.4, 0, 1.4]
const ACCELERATION: float = 0.4

var GRAVITY = 24.0
var speed: float = 8.0
var starting_point: Vector3 = Vector3.ZERO
var current_lane: int = 1
var target_lane: int = 1
var max_health: int = 100
var health: int = 100
var JUMP_VELOCITY = 9
var x= true

var is_dead: bool = false
signal hit

var target_z = 0.0
var z_recovery_speed = 10
var max_z_reached := 0.0

func die() -> void:
	if is_dead:
		return
	is_dead = true
	$DamageAudio.stop()  # Ferma il suono danno
	$SubViewport/ProgressBar.hide()
	get_parent().game_over()


func update_health_bar() -> void:
	$SubViewport/ProgressBar.value = health

func life() -> int:
	return health

func take_damage(damage: int) -> void:
	if is_dead:
		return
	health -= damage
	health = clamp(health, 0, max_health)
	update_health_bar()
	if health == 0:
		die()

func _ready() -> void:
	starting_point = global_transform.origin
	target_z = starting_point.z
	max_z_reached = starting_point.z
	add_to_group("player")

func can_move_to_lane(lane_index: int) -> bool:
	if lane_index < 0 or lane_index >= LANES.size():
		return false
	
	var from = global_transform.origin
	var to = Vector3(LANES[lane_index], from.y, from.z)

	var space_state = get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(from, to)
	ray_params.collision_mask = 0b100 
	ray_params.exclude = [self]

	var result = space_state.intersect_ray(ray_params)

	return result.is_empty()

func bounce_left() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x - 0.2, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", LANES[target_lane], 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

func bounce_right() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x + 0.2, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", LANES[target_lane], 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
func _physics_process(delta: float) -> void:
	GRAVITY += ACCELERATION * delta
	speed+= ACCELERATION/2 * delta
	JUMP_VELOCITY += ACCELERATION/6 *delta
		
	# Movimento a sinistra
	if Input.is_action_just_pressed("move_left") and target_lane < LANES.size() - 1:
		var proposed_lane = target_lane + 1
		if can_move_to_lane(proposed_lane):
			target_lane = proposed_lane
		else:
			bounce_left()

	# Movimento a destra
	if Input.is_action_just_pressed("move_right") and target_lane > 0:
		var proposed_lane = target_lane - 1
		if can_move_to_lane(proposed_lane):
			target_lane = proposed_lane
		else:
			bounce_right()

	var target_x: float = LANES[target_lane]
	var current_x: float = global_transform.origin.x
	global_transform.origin.x = move_toward(current_x, target_x, speed * delta)

	if not is_on_floor():
		
		velocity.y -= GRAVITY * delta
		if Input.is_key_pressed(KEY_C) and x:
			print("jumping vel: %.1f\ngravity %.1f\nmax y jumping: %.1f\n" % [JUMP_VELOCITY, GRAVITY, global_position.y])
			x=false
	else:
		velocity.y = 0
		if Input.is_key_pressed(KEY_C) and x:
			print("jumping vel: %.1f\ngravity %.1f\nmax y jumping: %.1f\n" % [JUMP_VELOCITY, GRAVITY, global_position.y])
			x=false
		x=true
	# Controllo per il salto
	if is_on_floor() and (Input.is_action_pressed("jump") or Input.is_action_pressed("ui_accept")):
		velocity.y = JUMP_VELOCITY
		$JumpAudio.play()
	
	if not is_on_floor() and (Input.is_action_pressed("down") or Input.is_action_pressed("ui_down")):
		velocity.y = -JUMP_VELOCITY * 1.2
		
	move_and_slide()

	if target_z > position.z:
		position.z = move_toward(position.z, target_z, z_recovery_speed * delta)
		if abs(position.z - target_z) < 0.01:
			position.z = target_z

	if position.z > max_z_reached:
		max_z_reached = position.z
	elif position.z < max_z_reached:
		position.z = max_z_reached

	if not is_on_floor():
		$kid/AnimationPlayer.play("Run")
	else:
		$kid/AnimationPlayer.play("Run")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_dead:
		return  # Non fare nulla se sei già morto
	if body.name != "obst_salita":
		hit.emit()
		if not $DamageAudio.playing:
			$DamageAudio.play()

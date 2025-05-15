extends Node

@export var obstacles : Array[PackedScene]
@export var explosionred : PackedScene
@export var explosionblu : PackedScene
@export var kitchen : PackedScene
@onready var black_background = $BlackBackground 
@onready var timer = $"Timer"

var acceleration_obst = 0.2
var speed_obst = 4
var timer_decrease=0.01
var obst_damage = 50

func _physics_process(delta: float) -> void:
	speed_obst += acceleration_obst * delta
	# velocità e accelerazione ostacoli autogestita dal main
	
	
func _on_timer_timeout() -> void:
	timer.wait_time -= timer_decrease
	var positions = [-1.4, 0.0, 1.4]
	positions.shuffle()  # Per garantire posizioni X diverse

	var rand_value = randf()
	var obstacle_count = 1
	if rand_value > 0.8:
		obstacle_count = 3
	elif rand_value > 0.5:
		obstacle_count = 2
	# Altrimenti rimane 1

	var salita_x_pos : float = INF  # Per memorizzare la posizione di obst_salita, se generato

	for i in range(obstacle_count):
		
		var obs : PackedScene
		var tries := 0
		while true:
			obs = obstacles.pick_random()
			if obs.resource_path.contains("obst_salita"):
				if randi() % 2 == 0:
					break  # 50% di probabilità di accettarlo
			else:
				break  # ostacolo normale → accettalo subito
			
			# sicurezza per evitare loop infiniti
			tries += 1
			if tries > 10:
				break
		
		var obstacleIns = obs.instantiate()

		# Escludi la posizione X già occupata da obst_salita
		if salita_x_pos != INF and positions.has(salita_x_pos):
			positions.erase(salita_x_pos)

		# Nessuna posizione disponibile → esci dal ciclo
		if positions.is_empty():
			break

		var x_pos = positions.pop_front()
		var z_base = 28
		var z_offset: float
		if obstacleIns.name == "obst_salita":
			z_offset = randf_range(-2.0, 0)
		elif z_offset >=-2 and z_offset <=0:
			z_offset = randf_range(2, 4.0)
		else:
			z_offset = randf_range(-2, 3.0)
		var z_pos = z_base + z_offset

		obstacleIns.position = Vector3(x_pos, 0.25, z_pos)

		# Controllo se è l'ostacolo salita
		if obstacleIns.name == "obst_salita":
			salita_x_pos = x_pos
			obstacleIns.rotation = Vector3(0.01, 0.01, 0.01)
			obstacleIns.scale = Vector3(0.01, 0.01, 0.01)
		else:
			obstacleIns.rotation.y = deg_to_rad(randf_range(-180, 180))
			obstacleIns.scale = Vector3(0.01, 0.01, 0.01)

		# Tween di comparsa
		var tween = create_tween()
		match obstacleIns.name:
			"knife":
				tween.tween_property(obstacleIns, "scale", Vector3(1.2, 1.2, 1.2), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				obstacleIns.position.y = 0.35
			"blender":
				tween.tween_property(obstacleIns, "scale", Vector3(1.7, 1.8, 1.7), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				if randi() % 2 == 0:
					# Posizione verticale (default)
					obstacleIns.rotation = Vector3(0, deg_to_rad(randf_range(-180, 180)), 0)
					obstacleIns.position.y = 0.3
				else:
					# Posizione orizzontale sul pavimento (rotazione sull'asse X)
					obstacleIns.rotation = Vector3(deg_to_rad(90),deg_to_rad(randf_range(-180, 180)), 0)
					obstacleIns.position.y = 0.65
			"bowl":
				tween.tween_property(obstacleIns, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			"obst_salita":
				tween.tween_property(obstacleIns, "scale", Vector3(1.7, 1.7, 1.7), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			_:
				tween.tween_property(obstacleIns, "scale", Vector3(0.8, 0.8, 0.8), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		obstacleIns.speed = speed_obst
		add_child(obstacleIns)
				
func game_over() -> void:
	# Nascondi tutti gli ostacoli e il giocatore
	$Giocatore.visible = false
	for obstacle in get_children():
		if obstacle.is_in_group("obstacles"):
			obstacle.queue_free()  # Rimuovi gli ostacoli

	# Crea e mostra l'esplosione
	var expl = explosionred.instantiate()
	expl.position = $Giocatore.position
	add_child(expl)
	expl.emitting = true  # Attiva l'emissione dell'esplosione

	# Aspetta 1 secondo per mostrare l'esplosione prima di Game Over
	await get_tree().create_timer(1.0).timeout  # Aspetta un po' prima di mostrare il Game Over

	# Mostra il background nero e il testo Game Over
	$AnimationPlayer.play("fade_in_gameover")
	$"GameOver".visible = true

	# Aspetta qualche secondo per il fade in prima di cambiare scena
	await get_tree().create_timer(2.0).timeout  # Aspetta per dare tempo al fade e al Game Over

	# Cambia scena al menu principale
	print("Cambio scena in corso...")
	get_tree().change_scene_to_file("res://scene/menu_principale.tscn") # Torna al menu principale

func _on_giocatore_hit() -> void:
	$Giocatore.take_damage(obst_damage)
	if($Giocatore.life()>0):
		var expl = explosionblu.instantiate()
		expl.position = $Giocatore.position 
		expl.position.z += 0.2
		add_child(expl)
		expl.emitting = true

func _on_giocatore_dead() -> void:
	var expl = explosionred.instantiate()
	expl.position = $Giocatore.position
	add_child(expl)
	expl.emitting = true
	$Giocatore.queue_free()
	await get_tree().create_timer(2).timeout

func _on_button_pressed() -> void:
	if !get_tree().paused:
		get_tree().paused = true
		$CanvasLayer2/AnimationPlayer.play("visible")
		$CanvasLayer/PauseMenu/AnimationPlayer.play("blur")

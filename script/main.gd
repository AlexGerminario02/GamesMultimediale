extends Node

@export var obstacles = [
	preload("res://scene/obstacles/bowl.tscn"),
	preload("res://scene/obstacles/blender.tscn"),
	preload("res://scene/obstacles/knife.tscn"),
	preload("res://scene/obstacles/obst_salita.tscn"),
	preload("res://scene/obstacles/pan.tscn"),
	preload("res://scene/obstacles/plates.tscn"),
	preload("res://scene/obstacles/toaster.tscn")
]

@export var alimenti_colazione = [
	preload("res://scene/food/apple.tscn"),
	preload("res://scene/food/applejuice.tscn"),
	preload("res://scene/food/avocado.tscn"),
	preload("res://scene/food/bacon_egg.tscn"),
	preload("res://scene/food/banana.tscn"),
	preload("res://scene/food/bread.tscn"),
	preload("res://scene/food/chocolate.tscn"),
	preload("res://scene/food/croissant.tscn"),
	preload("res://scene/food/donut.tscn"),
	preload("res://scene/food/milk.tscn"),
	preload("res://scene/food/pancake.tscn"),
	preload("res://scene/food/yogurt.tscn")
]
@export var alimenti_pranzo = [
	
]
@export var alimenti_cena = [
	
]

@export var explosionred = preload("res://scene/explosionred.tscn")
@export var explosiongreen = preload("res://scene/explosiongreen.tscn")
@export var explosionblu = preload("res://scene/explosionblu.tscn")
@export var kitchen = preload("res://scene/kitchen_room.tscn")

@onready var black_background = $BlackBackground 
@onready var timer = $"Timer"

var acceleration_obst = 0.2
var speed_obst = 4
var timer_decrease=0.01
var obst_damage = 50
var life_point = 10
enum lv { colazione, pranzo, cena }
var lv_corrente = lv.colazione

func _ready():
	$WorldController.update_lighting()


func _physics_process(delta: float) -> void:
	speed_obst += acceleration_obst * delta
	# velocità e accelerazione ostacoli autogestita dal main
	
	
func _on_timer_timeout() -> void: #obstacle spawn
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
		var z_offset: float = randf_range(1, 3)
		if obstacleIns.name == "obst_salita":
			z_offset = randf_range(-3, -1)
		elif z_offset >=-3 and z_offset <=-1:
			z_offset = randf_range(1, 3)
		else:
			z_offset = randf_range(-3, -1)
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
		match_obstacle(obstacleIns, tween)
		obstacleIns.speed = speed_obst
		add_child(obstacleIns)
		
	# --- Spawning cibo (dopo ostacoli) ---
	var food_scene: PackedScene = alimenti_colazione.pick_random()
	var food_instance = food_scene.instantiate()
	
	# Tween di comparsa
	var food_tween = create_tween()
	match_food(food_instance, food_tween)

	food_instance.speed = speed_obst  # Se anche il cibo si muove come ostacoli
	add_child(food_instance)
	await get_tree().create_timer(timer.wait_time / 2.0)

	for i in range(randi() % 2 + 1):  # genera 1 o 2 cibi dietro 
		# Spawn cibo dietro
		food_scene = alimenti_colazione.pick_random()
		food_instance = food_scene.instantiate()

		# Posizioni X disponibili
		var x_positions = [-1.4, 0.0, 1.4]
		x_positions.shuffle()
		var x_pos_food = x_positions.pop_front()

		# Z dietro gli ostacoli (es. ostacoli a z=28+, quindi z=20~24 va bene)
		var z_pos_food = randf_range(20.0, 24.0)

		food_instance.position = Vector3(x_pos_food, 0.3, z_pos_food)
		food_instance.rotation.y = deg_to_rad(randf_range(-180, 180))
		food_instance.scale = Vector3(0.01, 0.01, 0.01)

		var tween = create_tween()
		match_food(food_instance, tween)

		food_instance.speed = speed_obst
		add_child(food_instance)

func match_obstacle(obstacleIns: Variant, tween: Tween) -> void:
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
			"toaster":
				obstacleIns.position.y = 0.6
				tween.tween_property(obstacleIns, "scale", Vector3(2, 2, 2), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			"obst_salita":
				tween.tween_property(obstacleIns, "scale", Vector3(1.7, 1.7, 1.7), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			_:
				tween.tween_property(obstacleIns, "scale", Vector3(0.8, 0.8, 0.8), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func match_food(food_instance: Variant, tween: Tween) -> void:
	match food_instance.name:
			"apple":
				tween.tween_property(food_instance, "scale", Vector3(1.5, 1.5, 1.5), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.6
			"bacon_egg":
				tween.tween_property(food_instance, "scale", Vector3(0.5, 0.5, 0.5), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.5
			"banana":
				tween.tween_property(food_instance, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.6
			"avocado":
				tween.tween_property(food_instance, "scale", Vector3(1.2, 1.2, 1.2), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.5
			"croissant":
				tween.tween_property(food_instance, "scale", Vector3(2, 2, 2), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.6
			"bread", "donut", "yogurt":
				tween.tween_property(food_instance, "scale", Vector3(2.5, 2.5, 2.5), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.8
			"chocolate":
				tween.tween_property(food_instance, "scale", Vector3(3, 3, 3), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.8
			"applejuice", "milk":
				tween.tween_property(food_instance, "scale", Vector3(1.5, 1.5, 1.5), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.8
			"pancake", "donut":
				tween.tween_property(food_instance, "scale", Vector3(2, 2, 2), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.5
			_:
				tween.tween_property(food_instance, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				food_instance.position.y = 0.35
				
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

func _on_giocatore_food() -> void:
	$Giocatore.gain_life(life_point)
	var expl = explosiongreen.instantiate()
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

func _on_button_pressed() -> void: #pause
	if !get_tree().paused:
		get_tree().paused = true
		$CanvasLayer2/AnimationPlayer.play("visible")
		$CanvasLayer/PauseMenu/AnimationPlayer.play("blur")

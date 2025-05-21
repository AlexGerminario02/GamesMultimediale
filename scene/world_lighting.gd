extends Node

# Enum livelli di luce
enum lv { colazione, pranzo, cena }

# Stato attuale del gioco (simula il momento della giornata)
var lv_corrente = GameState.lv_corrente

# Riferimenti alle luci/ambiente nella scena
@onready var world_lighting = $"../DirectionalLight3D"
@onready var world_sky = $"../WorldEnvironment"

func _ready():
	update_lighting()

func update_lighting():
	match lv_corrente:
		lv.colazione:
			set_light_for_morning()
		lv.pranzo:
			set_light_for_sunset()
		lv.cena:
			set_light_for_night()

# 💡 Imposta parametri specifici della luce direzionale

func set_light_for_morning():
	# Luce di mattina: morbida e calda
	world_lighting.light_color = "d4f2e4" # giallo caldo
	world_lighting.light_energy = 1.0  # Energia media per evitare una luce troppo intensa
	world_lighting.rotation_degrees = Vector3(-120, 90, 0)  # Sole alto ma non troppo (alba)
	
	# Modifica del cielo procedurale
	var sky_material = world_sky.environment.sky.sky_material
	if sky_material is ProceduralSkyMaterial:
		# Cielo scuro
		sky_material.sky_top_color = "3380ae"
		sky_material.sky_horizon_color = "53b1c3"
		sky_material.sky_curve = 0.135
		sky_material.sky_energy_multiplier = 1

		# Colori terreno più scuri
		sky_material.ground_bottom_color = "332b22"
		sky_material.ground_horizon_color = "a5a7ab"

		# Modifica del fog 
	var fog_material = world_sky.environment
	if world_sky.environment.fog_enabled:
		fog_material.fog_light_color = "4894c8"
		
func set_light_for_sunset():
	# Luce di tramonto: calda e dorata
	world_lighting.light_color = "e8cd81" # Arancio dorato
	world_lighting.light_energy = 0.7  # Energia alta, ma non troppo intensa
	world_lighting.rotation_degrees = Vector3(-60, 90, 0)  # Sole vicino all'orizzonte

		# Modifica del cielo procedurale
	var sky_material = world_sky.environment.sky.sky_material
	if sky_material is ProceduralSkyMaterial:
		# Cielo scuro
		sky_material.sky_top_color = "996c50"
		sky_material.sky_horizon_color = "aaa730"
		sky_material.sky_curve = 0.135
		sky_material.sky_energy_multiplier = 1

		# Colori terreno più scuri
		sky_material.ground_bottom_color = "332b22"
		sky_material.ground_horizon_color = "a5a7ab"
		
	# Modifica del fog 
	var fog_material = world_sky.environment
	if world_sky.environment.fog_enabled:
		fog_material.fog_light_color = "4d96bf"
		
func set_light_for_night():
	# Luce di notte: blu scuro e fredda
	world_lighting.light_color = "9ee5cd"  # Blu scuro per la notte
	world_lighting.light_energy = 0.7  # Energia bassa, luce molto fioca
	world_lighting.rotation_degrees = Vector3(-75, 90, 0)  # Sole sotto l'orizzonte (notte)
	
# Modifica del cielo procedurale
	var sky_material = world_sky.environment.sky.sky_material
	if sky_material is ProceduralSkyMaterial:
		# Cielo scuro
		sky_material.sky_top_color = "1f274a"       # blu scuro
		sky_material.sky_horizon_color = "353b5f" # blu meno scuro all’orizzonte
		sky_material.sky_curve = 0.2
		sky_material.sky_energy_multiplier = 1

		# Colori terreno più scuri
		sky_material.ground_bottom_color = Color(0.01, 0.01, 0.01)
		sky_material.ground_horizon_color = Color(0.05, 0.05, 0.1)
	
# Modifica del fog 
	var fog_material = world_sky.environment
	if world_sky.environment.fog_enabled:
		fog_material.fog_light_color = "3f77a2"

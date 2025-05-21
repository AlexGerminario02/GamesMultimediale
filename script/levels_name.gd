extends Label

@onready var label = $"."  # Il nodo Label stesso
enum lv {colazione, pranzo, cena}
var lv_corrente = GameState.lv_corrente

func _ready() -> void:
	match lv_corrente:
		lv.colazione : label.text = "Colazione"
		lv.pranzo : label.text = "Pranzo"
		lv.cena : label.text = "Cena"

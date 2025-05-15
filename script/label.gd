extends Label

@onready var score_label = $"."  # Il nodo Label stesso

var elapsed_time : float = 0.0
var score : int = 0

func _process(delta: float) -> void:
	elapsed_time += delta
	score = int(elapsed_time)

	score_label.text = "Score: %.1f\n" % elapsed_time

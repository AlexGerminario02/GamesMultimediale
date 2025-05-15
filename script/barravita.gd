extends ProgressBar

const FULL_COLOR := Color("#36d943")
const EMPTY_COLOR := Color("#d93636")

func update_color():
	var t := value / max_value
	var color := FULL_COLOR.lerp(EMPTY_COLOR, 1.0 - t)

	var style := get_theme_stylebox("fill", "ProgressBar").duplicate()
	style.border_color = color
	style.bg_color = color
	add_theme_stylebox_override("fill", style)

func _on_value_changed(value: float) -> void:
	update_color()

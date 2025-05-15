class_name SettingsTabControl
extends Control

@onready var tab_container = $TabContainer as TabContainer

signal Exit_Options_menu

func _process(delta):
	options_menu_input()

func change_tab(tab : int) -> void:
	tab_container.set_current_tab(tab)

func options_menu_input() -> void:
	# Controllo per il movimento a destra
	if Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("ui_right"):
		var next_tab = tab_container.current_tab + 1
		if next_tab >= tab_container.get_tab_count():  # Se siamo all'ultima tab, torna alla prima
			change_tab(0)
		else:
			change_tab(next_tab)

	# Controllo per il movimento a sinistra
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("ui_left"):
		var previous_tab = tab_container.current_tab - 1
		if previous_tab < 0:  # Se siamo alla prima tab, vai all'ultima
			change_tab(tab_container.get_tab_count() - 1)
		else:
			change_tab(previous_tab)

	# Controllo per annullare e uscire dal menu opzioni
	if Input.is_action_just_pressed("ui_cancel"):
		Exit_Options_menu.emit()

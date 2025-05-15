# HotKeyButton.gd
extends Control

class_name HotKeyButton  # Aggiungi questa linea per renderla globale

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button
@export var action_name : String = "move_left"

func _ready():
	add_to_group("hotkey_button")
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	load_keybinds()

func load_keybinds() -> void:
	rebind_action_key(SettingsContainer.get_keybinds(action_name))

func set_action_name() -> void:
	label.text = "Unassigned"
	match action_name:
		"move_left":
			label.text = "Move Left"
		"move_right":
			label.text = "Move Right"
		"jump":
			label.text = "Jump"
		"down":
			label.text = "Down"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() == 0:
		button.text = "Unbound"
		return

	var action_event = action_events[0]

	if action_event is InputEventKey:
		var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
		button.text = "%s" % action_keycode
	else:
		button.text = "Unsupported"

func _on_button_toggled(button_pressed):
	if button_pressed:
		button.text = "Press any key.."
		set_process_unhandled_key_input(button_pressed)

		# Iterate through hotkey_buttons in the group
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i is HotKeyButton and i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)

	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i is HotKeyButton and i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_text_for_key()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false

func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	SettingsContainer.set_keybind(action_name, event)
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()

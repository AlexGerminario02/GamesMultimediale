extends VBoxContainer

@onready var check_button := $Control/HBoxContainer/CheckButton
@onready var hotkey_rebind := $HotKey_Rebind/HBoxContainer/Button
@onready var hotkey_rebind2 := $HotKey_Rebind2/HBoxContainer/Button
@onready var hotkey_rebind3 := $HotKey_Rebind3/HBoxContainer/Button
@onready var hotkey_rebind4 := $HotKey_Rebind4/HBoxContainer/Button

func _ready():
	check_button.toggled.connect(_on_checkbox_toggled)
	_on_checkbox_toggled(check_button.button_pressed)

func _on_checkbox_toggled(pressed: bool):
	hotkey_rebind.disabled = pressed
	hotkey_rebind2.disabled = pressed
	hotkey_rebind3.disabled = pressed
	hotkey_rebind4.disabled = pressed

	if pressed:
		_set_arrow_keys()
	else:
		_set_default_keys()

func _set_arrow_keys():
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_right")
	InputMap.action_erase_events("jump")
	InputMap.action_erase_events("down")

	var left_event := InputEventKey.new()
	left_event.keycode = KEY_LEFT
	InputMap.action_add_event("move_left", left_event)

	var right_event := InputEventKey.new()
	right_event.keycode = KEY_RIGHT
	InputMap.action_add_event("move_right", right_event)

	var up_event := InputEventKey.new()
	up_event.keycode = KEY_UP
	InputMap.action_add_event("jump", up_event)
	
	var down_event := InputEventKey.new()
	up_event.keycode = KEY_UP
	InputMap.action_add_event("down", down_event)

func _set_default_keys():
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_right")
	InputMap.action_erase_events("jump")
	InputMap.action_erase_events("down")

	var a_event := InputEventKey.new()
	a_event.keycode = KEY_A
	InputMap.action_add_event("move_left", a_event)

	var d_event := InputEventKey.new()
	d_event.keycode = KEY_D
	InputMap.action_add_event("move_right", d_event)

	var w_event := InputEventKey.new()
	w_event.keycode = KEY_W
	InputMap.action_add_event("jump", w_event)
	
	var s_event := InputEventKey.new()
	s_event.keycode = KEY_S
	InputMap.action_add_event("down", s_event)

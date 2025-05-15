class_name OptionMenu
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button as Button

signal exit_option_menu

func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)
	
func on_exit_pressed() -> void:
	exit_option_menu.emit()
	SettingSignalBus.emit_set_settings_dictionary(SettingsContainer.create_storage_dictionary())
	set_process(false)

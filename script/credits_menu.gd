class_name CreditsMenu
extends Control
@onready var back_button = $MarginContainer/HBoxContainer/VBoxContainer/Back_button_2 as Button


signal back_to_main_menu


func _on_back_button_2_pressed() -> void:
	# Torna al menu principale
	var menu_scene = load("res://scene/menu_principale.tscn")
	get_tree().change_scene_to_packed(menu_scene)

class_name LevelsMenu
extends Control

@onready var level1_button = $level1_button as Button
@onready var level2_button = $level2_button as Button
@onready var level3_button = $level3_button as Button
@onready var back_button = $Back_button as Button

@export var start_level = preload("res://scene/main.tscn")

signal start_game
signal back_to_main_menu

func _on_back_button_pressed() -> void:
	var menu_scene = load("res://scene/menu_principale.tscn")
	get_tree().change_scene_to_packed(menu_scene)

func _on_level_1_button_pressed() -> void:
	GameState.lv_corrente = GameState.lv.colazione
	get_tree().change_scene_to_packed(start_level)

func _on_level_2_button_pressed() -> void:
	GameState.lv_corrente = GameState.lv.pranzo
	get_tree().change_scene_to_packed(start_level)

func _on_level_3_button_pressed() -> void:
	GameState.lv_corrente = GameState.lv.cena
	get_tree().change_scene_to_packed(start_level)

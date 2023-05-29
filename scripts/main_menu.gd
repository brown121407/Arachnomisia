extends Control

@onready var main_menu := $VBoxContainer/MainMenu
@onready var settings_menu := $VBoxContainer/SettingsMenu
@onready var music_vol_slider := $VBoxContainer/SettingsMenu/MarginContainer/VBoxContainer/MusicVolumeSlider as HSlider
@onready var sfx_vol_slider := $VBoxContainer/SettingsMenu/MarginContainer/VBoxContainer/SFXVolumeSlider as HSlider
var game_scene := preload('res://scenes/game.tscn')


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_settings_pressed() -> void:
	main_menu.visible = false
	settings_menu.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_back_pressed() -> void:
	settings_menu.visible = false
	main_menu.visible = true

@tool
class_name UI
extends Control


@onready var health_bar := $LeftStatsContainer/HealthBar as ProgressBar
@onready var stamina_bar := $LeftStatsContainer/StaminaBar as ProgressBar
@onready var ammo_count := $RightStatsContainer/PanelContainer/AmmoCount as Label
@onready var reload_warning := $RightStatsContainer/PanelContainer/ReloadWarning as Label
@onready var reload_bar := $RightStatsContainer/ReloadBar as TextureProgressBar
@onready var pause_menu := $PauseMenu
@onready var resume_button := $PauseMenu/MarginContainer/HBoxContainer/CenterContainer/VBoxContainer2/ResumeButton as Button
@onready var quit_button := $PauseMenu/MarginContainer/HBoxContainer/CenterContainer/VBoxContainer2/QuitButton as Button

@export_range(0, Constants.MAX_AMMO) var ammo := Constants.MAX_AMMO :
	set(value):
		ammo = value
		ammo_count.text = '|'.repeat(value)
		if ammo == 0:
			reload_warning.visible = true
		else:
			reload_warning.visible = false


func _ready():
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(quit_to_menu)

func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	pause_menu.visible = true
	
func unpause():
	get_tree().paused = false
	pause_menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func quit_to_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file('res://scenes/main_menu.tscn')

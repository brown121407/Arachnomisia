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
@onready var weapon_label := $RightStatsContainer/WeaponLabel as Label
@onready var end_menu := $EndMenu
@onready var end_quit_button := $EndMenu/MarginContainer/VBoxCOntainer/EndQuitButton as Button
@onready var restart_button := $EndMenu/MarginContainer/VBoxCOntainer/RestartButton as Button
@onready var kill_counter := $KillCounter

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
	end_quit_button.pressed.connect(quit_to_menu)
	restart_button.pressed.connect(restart)


func _input(event):
	if event.is_action_pressed('ui_cancel'):
		if pause_menu.visible:
			unpause()
		else:
			pause()


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
	
func end_game():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	end_menu.visible = true
	
func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

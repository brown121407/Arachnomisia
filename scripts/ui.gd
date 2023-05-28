@tool
class_name UI
extends Control


@onready var health_bar := $LeftStatsContainer/HealthBar as ProgressBar
@onready var stamina_bar := $LeftStatsContainer/StaminaBar as ProgressBar
@onready var ammo_count := $RightStatsContainer/PanelContainer/AmmoCount as Label
@onready var reload_warning := $RightStatsContainer/PanelContainer/ReloadWarning as Label
@onready var reload_bar := $RightStatsContainer/ReloadBar as TextureProgressBar

@export_range(0, Constants.MAX_AMMO) var ammo := Constants.MAX_AMMO :
	set(value):
		ammo = value
		ammo_count.text = '|'.repeat(value)
		if ammo == 0:
			reload_warning.visible = true
		else:
			reload_warning.visible = false

@tool
class_name UI
extends Control


@onready var health_bar := $LeftStatsContainer/HealthBar
@onready var stamina_bar := $LeftStatsContainer/StaminaBar
@onready var ammo_count := $RightStatsContainer/AmmoCount

@export_range(0, Constants.MAX_HEALTH) var health := Constants.MAX_HEALTH :
	set(value):
		health = value
		health_bar.value = value

@export_range(0, Constants.MAX_HEALTH) var stamina := Constants.MAX_STAMINA :
	set(value):
		stamina = value
		stamina_bar.value = value

@export_range(0, Constants.MAX_AMMO) var ammo := Constants.MAX_AMMO :
	set(value):
		ammo = value
		ammo_count.text = '|'.repeat(value)

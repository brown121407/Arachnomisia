extends Resource
class_name GunStats

@export var bullet_damage: float
@export_range(0, Constants.MAX_AMMO) var max_ammo: int
@export var current_ammo: int :
	set(value):
		current_ammo = clamp(value, 0, max_ammo)
@export var reload_time: float

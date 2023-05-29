class_name Gun
extends Node3D


@onready var reload_timer: Timer = $ReloadTimer
@onready var shot_timer: Timer = $ShotTimer
@onready var fire_particles: GPUParticles3D = $Muzzle/SmokeParticles
@onready var muzzle_flash: OmniLight3D = $Muzzle/MuzzleFlash
@onready var light_timer: Timer = $Muzzle/LightTimer
@onready var gun_mesh: MeshInstance3D = $GunMesh

var ready_to_shoot: bool :
	get:
		return shot_timer.is_stopped()
var shooting := false
@export var stats: GunStats
@export var weapon_name: String
@export var bullet_scene: PackedScene

signal ammo_changed(current: int)
signal reloading(progress: int)


var is_reloading: bool :
	get:
		return not reload_timer.is_stopped()
var reload_progress := 0 :
	set(value):
		reload_progress = clamp(value, 0, 100)

func _ready():
	stats.current_ammo = stats.max_ammo
	reload_timer.timeout.connect(track_reload)
	light_timer.timeout.connect(func (): muzzle_flash.visible = false)


func shoot() -> bool:
	if not ready_to_shoot or stats.current_ammo <= 0 or is_reloading:
		return false

	stats.current_ammo -= 1
	ammo_changed.emit(stats.current_ammo)
	
	fire_particles.emitting = true
	muzzle_flash.visible = true
	light_timer.start()
	var recoil_tween: Tween = get_tree().create_tween().bind_node(gun_mesh)
	recoil_tween.tween_property(gun_mesh, 'rotation', Vector3(-0.35, gun_mesh.rotation.y, 0), 0.05)
	recoil_tween.tween_property(gun_mesh, 'rotation', Vector3(0, gun_mesh.rotation.y, 0), 0.15)
	
	ready_to_shoot = false
	shot_timer.start()
	
	$ShotSoundPlayer.play()
	
	return true


func reload():
	if reload_timer.is_stopped():
		$ReloadSoundPlayer.play()
		reload_progress = 0
		reload_timer.start()

func track_reload():
	reload_progress += stats.reload_time / reload_timer.wait_time
	if reload_progress >= 100:
		finish_reload()
		reloading.emit(0)
	else:
		reloading.emit(reload_progress)


func finish_reload():
	reload_timer.stop()
	stats.current_ammo = stats.max_ammo
	ammo_changed.emit(stats.current_ammo)

func stop_reload():
	reload_timer.stop()
	reload_progress = 0
	reloading.emit(reload_progress)


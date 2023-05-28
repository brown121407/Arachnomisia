class_name SpawnerManager
extends Node3D


@export var player : Player
@export var spider_scene : PackedScene

var spawners := []

func _ready():
	for child in get_children():
		if child is Spawner:
			child.timer.timeout.connect(func (): child.spawn(spider_scene, player))

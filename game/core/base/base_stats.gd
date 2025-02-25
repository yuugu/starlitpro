# core/base/base_stats.gd
extends Node
class_name BaseStats

signal stat_changed(stat_name: String, value: float)

var stats: Dictionary = {}

func _ready() -> void:
	initialize_stats()

func initialize_stats() -> void:
	pass

func set_stat(stat_name: String, value: float) -> void:
	if stats.has(stat_name):
		var old_value = stats[stat_name]
		stats[stat_name] = value
		emit_signal("stat_changed", stat_name, value)

func get_stat(stat_name: String) -> float:
	return stats.get(stat_name, 0.0)

func modify_stat(stat_name: String, amount: float) -> void:
	if stats.has(stat_name):
		set_stat(stat_name, stats[stat_name] + amount)

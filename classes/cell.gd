extends Node
class_name Cell

var x : int
var y : int
var g : int
var h : int
var came_from : Cell

func _init(_x : int, _y : int) -> void:
	g = 100000
	h = 0
	x = _x
	y = _y

func get_f() -> int:
	return g + h

func clean() -> void:
	came_from = null
	g = 100000
	h = 0

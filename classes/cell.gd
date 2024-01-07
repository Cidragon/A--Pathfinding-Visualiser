extends Node
class_name Cell

var x : int
var y : int
var f : int
var g : int
var h : int
var came_from : Cell

func _init(_x : int, _y : int) -> void:
	g = 100000
	x = _x
	y = _y

func calculate_f() -> void:
	f = g + h

func get_f() -> int:
	calculate_f()
	return f

func clean() -> void:
	came_from = null
	g = 100000
	h = 0
	f = 0

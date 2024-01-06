extends Node2D

@onready var entity: Sprite2D = %entity

func _ready() -> void:
	Pathfinding.start_pathfinding_settings()
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var mouse_position : Vector2i = get_global_mouse_position()
		var grid_position = mouse_position / Vector2i(Pathfinding.astar_grid.cell_size)
		entity.objective = grid_position
		print(grid_position)

extends Node

var astar_grid : AStarGrid2D = AStarGrid2D.new()

func start_pathfinding_settings() -> void:
	astar_grid.region = Rect2i(0, 0, 80, 40)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

extends Node2D

@export var label_font_size : Theme

@onready var tiles: TileMap = %tiles

var label_score = []

var new_astar : Custom_Astar = Custom_Astar.new()

func _ready() -> void:
	
	new_astar.grid_size = Vector2i(80,40)
	new_astar.tile_size = Vector2(16,16)
	new_astar.start_grid()
	start_label_score()
	
		
	
	pass # Replace with function body.

func start_label_score() -> void:
	for col in range(new_astar.grid_size.x):
		label_score.push_back([])
		for row in range(new_astar.grid_size.y):
			var new_label : Label = Label.new()
			new_label.position = Vector2i(col,row) * new_astar.tile_size + Vector2i(3,7)
			new_label.text = "(" + str(col) + "," + str(row) + ")"
			new_label.theme = label_font_size
			new_label.scale = Vector2(0.25,0.25)
			label_score[col].push_back(new_label)
			add_child(new_label)

func reset_label_score() -> void:
	for col in range(new_astar.grid_size.x):
		label_score.push_back([])
		for row in range(new_astar.grid_size.y):
			var label = label_score[col][row]
			label.text = "(" + str(col) + "," + str(row) + ")"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		print("left click")
		var mouse_position : Vector2i = get_global_mouse_position()
		var objective_grid_position : Vector2i = mouse_position / new_astar.tile_size
		var start_position : Vector2i = Vector2i(0,0) / new_astar.tile_size
		print("start grid position: ", start_position)
		print("objective grid position: ", objective_grid_position)
		var path : Array[Vector2i] = new_astar.calculate_path(start_position, objective_grid_position)
		
		reset_label_score()
		tiles.clear()
		for tile in new_astar.closedSet:
			#print(str(new_astar.grid[tile.x][tile.y].f))
			var g = str(new_astar.grid[tile.x][tile.y].g)
			var h = str(new_astar.grid[tile.x][tile.y].h)
			
			label_score[tile.x][tile.y].text = g + " " + h
			if tile in path:
				tiles.set_cell(0, tile, 1, Vector2i(0,0))
			else:
				tiles.set_cell(0, tile, 0, Vector2i(0,0))
		
		for tile in new_astar.openSet:
			var g = str(new_astar.grid[tile.x][tile.y].g)
			var h = str(new_astar.grid[tile.x][tile.y].h)
			
			label_score[tile.x][tile.y].text = g + " " + h
			if tile in path:
				tiles.set_cell(0, tile, 1, Vector2i(0,0))
			else:
				tiles.set_cell(0, tile, 0, Vector2i(0,0))

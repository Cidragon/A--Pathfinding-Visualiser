extends Node2D

@export var label_font_size : Theme

@onready var tiles: TileMap = %tiles

var label_score = []

var new_astar : Custom_Astar = Custom_Astar.new()

func _ready() -> void:
	
	new_astar.grid_size = Vector2i(30,20)
	new_astar.tile_size = Vector2(16,16)
	new_astar.start_grid()
	start_label_score()
	
		
	
	pass # Replace with function body.

func start_label_score() -> void:
	for col in range(new_astar.grid_size.x):
		label_score.push_back([])
		for row in range(new_astar.grid_size.y):
			var new_label : Label = Label.new()
			new_label.position = Vector2i(col,row) * new_astar.tile_size + Vector2i(2,7)
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

var start_position : Vector2i = Vector2i(0,0)
var end_position : Vector2i = Vector2i(0,0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("set_start_position"):
		var mouse_position : Vector2i = get_global_mouse_position()
		start_position = mouse_position / new_astar.tile_size
		print("start grid position: ", start_position)
		get_full_path()
	elif event.is_action_pressed("set_end_position"):
		print("set_end_position")
		var mouse_position : Vector2i = get_global_mouse_position()
		end_position = mouse_position / new_astar.tile_size
		print("end grid position: ", end_position)
		get_full_path()
	elif event.is_action_pressed("q"):
		print("Q pressed")
		var mouse_position : Vector2i = get_global_mouse_position()
		var objective_grid_position : Vector2i = mouse_position / new_astar.tile_size
		var start_position : Vector2i = Vector2i(0,0) / new_astar.tile_size
		var path : Array[Vector2i] = new_astar.calculate_path_next_step(start_position, objective_grid_position)
		
		print(new_astar.openSet)
		print(new_astar.closedSet)
		
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
		
		if not new_astar.found_path:
			var tile : Vector2i = path[0]
			tiles.set_cell(0, tile, 2, Vector2i(0,0))
		

func get_full_path() -> void:
	var path : Array[Vector2i] = new_astar.calculate_path(start_position, end_position)
		
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

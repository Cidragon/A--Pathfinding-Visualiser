extends Node
class_name Custom_Astar

var grid = []
var grid_size : Vector2i
var tile_size : Vector2i

var openSet : Dictionary = {}
var closedSet : Dictionary = {}

const STRAIGHT_COST : int = 10
const DIAGONAL_COST : int = 14

func _init() -> void:
	print("custom astar init")

func start_grid() -> void:
	grid = []
	for y in range(grid_size.x):
		grid.push_back([])
		for x in range(grid_size.y):
			grid[y].push_back(Cell.new(y,x))
	

func calculate_path(from : Vector2i, target : Vector2i) -> Array[Vector2i]:
	start_grid()
	#reset_cells()
	openSet = {}
	closedSet = {}
	
	openSet[Vector2i(from.x, from.y)] = grid[from.x][from.y]
	grid[from.x][from.y].g = 0
	grid[from.x][from.y].h = get_distance(from, target)
	#grid[from.x][from.y].h = manhattan_distance(from, target)
	#grid[from.x][from.y].h = euclidean_distance(from, target)
	print(get_distance(from, target))
	while openSet:
		var current : Cell = get_lowest_fscore()
		#print("openSet: ", openSet)
		#print("current cell: ", current)
		
		openSet.erase(Vector2i(current.x, current.y))
		closedSet[Vector2i(current.x, current.y)] = true
		
		if Vector2i(current.x, current.y) == target:
			print("FOUND PATH")
			#show_f_values()
			return reconstruct_path(current)
		
		for neighbor in get_neighbors(current):
			if closedSet.has(Vector2i(neighbor.x, neighbor.y)):
				continue
			
			var tentative_g : int = current.g + get_distance(Vector2(current.x, current.y), Vector2i(neighbor.x, neighbor.y))
			#var tentative_g : int = current.g + manhattan_distance(Vector2i(current.x,current.y), Vector2i(neighbor.x, neighbor.y))
			#var tentative_g : int = current.g + euclidean_distance(Vector2i(current.x,current.y), Vector2i(neighbor.x, neighbor.y))
			
			#print(neighbor.g)
			if tentative_g < neighbor.g:
				neighbor.g = tentative_g
				neighbor.h = get_distance(Vector2(neighbor.x, neighbor.y), target)
				neighbor.came_from = current
				
				#neighbor.h = manhattan_distance(Vector2(neighbor.x, neighbor.y), target)
				#neighbor.h = euclidean_distance(Vector2(neighbor.x, neighbor.y), target)
				
				
				if not openSet.has(Vector2i(neighbor.x, neighbor.y)):
					openSet[Vector2i(neighbor.x, neighbor.y)] = neighbor 
			pass
		
	
	print("NO PATH")
	return []

var found_path : bool = false
var start_path_next_step : bool = true
func calculate_path_next_step(from : Vector2i, target: Vector2i) -> Array[Vector2i]:
	if start_path_next_step:
		start_grid()
		openSet = {}
		closedSet = {}
		openSet[Vector2i(from.x, from.y)] = grid[from.x][from.y]
		grid[from.x][from.y].g = 0
		grid[from.x][from.y].h = get_distance(from, target)
		start_path_next_step = false
	
	if openSet and not found_path:
		var current : Cell = get_lowest_fscore()
		openSet.erase(Vector2i(current.x, current.y))
		closedSet[Vector2i(current.x, current.y)] = true
		
		if Vector2i(current.x, current.y) == target:
			print("FOUND PATH")
			found_path = true
			return reconstruct_path(current)
		
		for neighbor in get_neighbors(current):
			if closedSet.has(Vector2i(neighbor.x, neighbor.y)):
				continue
			
			var tentative_g : int = current.g + get_distance(Vector2(current.x, current.y), Vector2i(neighbor.x, neighbor.y))
			if tentative_g < neighbor.g:
				neighbor.g = tentative_g
				neighbor.h = get_distance(Vector2(neighbor.x, neighbor.y), target)
				neighbor.came_from = current
				
				#neighbor.h = manhattan_distance(Vector2(neighbor.x, neighbor.y), target)
				#neighbor.h = euclidean_distance(Vector2(neighbor.x, neighbor.y), target)
				
				
				if not openSet.has(Vector2i(neighbor.x, neighbor.y)):
					openSet[Vector2i(neighbor.x, neighbor.y)] = neighbor 
		
		return [Vector2i(current.x, current.y)]
		
	
	print("NO PATH")
	return []


func get_lowest_fscore() -> Cell:
	var lowest_f_cell : Cell
	#print(openSet)
	for key: Vector2i in openSet:
		var cell : Cell = openSet[key]
		if not lowest_f_cell:
			lowest_f_cell = cell
			continue
		
		if cell.get_f() < lowest_f_cell.get_f():
			lowest_f_cell = cell
	
	print("lowest f score: ", lowest_f_cell.get_f())
	print(lowest_f_cell)
	return lowest_f_cell

func reconstruct_path(cell : Cell) -> Array[Vector2i]:
	var path : Array[Vector2i]= []
	var current : Cell = cell
	while current:
		path.push_back(Vector2i(current.x, current.y))
		current = current.came_from
	
	path.reverse()
	print("final path: ", path)
	return path

func get_neighbors(cell : Cell) -> Array[Cell]:
	var neighbors : Array[Cell] = []
	if cell.x > 0:
		neighbors.push_back(grid[cell.x-1][cell.y])
	if cell.x < grid.size() - 1:
		neighbors.push_back(grid[cell.x+1][cell.y])
	if cell.y > 0:
		neighbors.push_back(grid[cell.x][cell.y-1])
	if cell.y < grid[0].size() - 1:
		neighbors.push_back(grid[cell.x][cell.y + 1])
	if cell.x > 0 and cell.y > 0:
		neighbors.push_back(grid[cell.x-1][cell.y-1])
	if cell.x < grid.size() - 1 and cell.y > 0:
		neighbors.push_back(grid[cell.x+1][cell.y-1])
	if cell.x > 0 and cell.y < grid[0].size() - 1:
		neighbors.push_back(grid[cell.x-1][cell.y+1])
	if cell.x < grid.size() - 1 and cell.y < grid[0].size() - 1:
		neighbors.push_back(grid[cell.x+1][cell.y+1])
	
	#print("neighbors: ", neighbors)
	return neighbors

func manhattan_distance(a : Vector2i, b : Vector2i) -> int:
	return abs(b.x - a.x) + abs(b.y - a.y)

func euclidean_distance(a : Vector2i, b : Vector2i) -> int:
	var dx = abs(b.x - a.x)
	var dy = abs(b.y - a.y)
	var remaining = abs(dx - dy)
	return sqrt(dx*dx + dy*dy)

func get_distance(a : Vector2i, b : Vector2i) -> int:
	var dx = abs(b.x - a.x)
	var dy = abs(b.y - a.y)
	if dx > dy:
		return 14*dy + 10*(dx - dy)
	return 14*dx + 10*(dy-dx)

func show_f_values() -> void:
	var output = ""
	for y in range(grid_size.x):
		for x in range(grid_size.y):
			var cell : Cell = grid[y][x]
			output += str(cell.f) + " "
		output += "\n"
	
	
	print("f values")
	print(output)

func reset_cells() -> void:
	for key in closedSet:
		var cell : Cell = grid[key.x][key.y]
		cell.clean()
	
	for key in openSet:
		var cell : Cell = grid[key.x][key.y]
		cell.clean()

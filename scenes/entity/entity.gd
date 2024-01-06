extends Sprite2D

var objective : Vector2i = Vector2i(-1,-1)
var is_walking : bool = false
var path : Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if objective != Vector2i(-1,-1):
		path = Pathfinding.astar_grid.get_id_path(get_grid_position(), objective)
		print(path)
	
	if path.size() >= 2 and not is_walking:
		is_walking = true
		move()
		return
	
	#objective = Vector2i(-1,-1)
	pass

func get_grid_position() -> Vector2i:
	var pos : Vector2i = position
	var cell_size : Vector2i = Pathfinding.astar_grid.cell_size
	print("position: " ,position)
	print("grid position: ", Vector2i(pos / cell_size))
	return Vector2i(pos / cell_size)
	pass

func move() -> void:
	print("moving")
	var tween := create_tween()
	var next_point : Vector2 = Vector2(path[1]) * Pathfinding.astar_grid.cell_size
	tween.tween_property(self, "position", next_point, 0.2)
	tween.finished.connect(move_finish)

func move_finish() -> void:
	path.pop_front()
	is_walking = false
	if path.size() < 2:
		objective = Vector2i(-1,-1)
	

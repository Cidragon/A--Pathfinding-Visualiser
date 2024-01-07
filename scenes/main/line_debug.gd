extends Control

func _draw() -> void:
	for y in range(40):
		draw_line(Vector2(0,16*y), Vector2(16*80,16*y),Color.WHITE,1)
		
	for x in range(80):
		draw_line(Vector2(16*x,0), Vector2(16*x,16*40),Color.WHITE,1)

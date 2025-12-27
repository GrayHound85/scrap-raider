extends Node
# Uses the Bowyer-Waston algorithm
class_name DelaunayTriangulation

class Triangle:
	var a: Vector2
	var b: Vector2
	var c: Vector2
	var circumcenter: Vector2
	var circumradius: float
	
	func _init(a: Vector2, b: Vector2, c: Vector2) -> void:
		self.a = a
		self.b = b
		self.c = c
		calc_circumcircle()
	
	func calc_circumcircle() -> void:
		pass

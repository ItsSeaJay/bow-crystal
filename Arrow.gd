extends Area2D

var move_speed = 4000
var velocity = Vector2()
var direction = Global.Direction.LEFT

func _ready():
	velocity.x = move_speed * direction
	connect("area_entered", self, "fuck")

func _process(delta):
	position += velocity * delta

func fuck(area):
	if area is Crystal:
		get_tree().change_scene("res://Ending.tscn")

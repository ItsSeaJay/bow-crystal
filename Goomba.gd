extends KinematicBody2D

export var move_speed = 100

var velocity = Vector2()
var direction = Global.Direction.LEFT if rand_range(0, 1) > 0.5 else Global.Direction.RIGHT

func _ready():
	velocity.x = move_speed * direction

func _physics_process(delta):
	if is_on_wall():
		direction = Global.Direction.LEFT if direction == Global.Direction.RIGHT else Global.Direction.RIGHT
	
	velocity.y += Global.GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)

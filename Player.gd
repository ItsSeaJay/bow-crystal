extends KinematicBody2D

enum MovementState {
	MOVEMENT_STATE_GROUNDED,
	MOVEMENT_STATE_AIRBORNE
}

enum BowState {
	BOW_STATE_NORMAL,
	BOW_STATE_DRAWN
}

export var move_speed = 100
export var jump_speed = 200

var state_movement = MovementState.MOVEMENT_STATE_GROUNDED
var state_bow = BowState.BOW_STATE_NORMAL
var velocity = Vector2()
var direction = Global.Direction.RIGHT

onready var arrow = preload("res://Arrow.tscn")

func _physics_process(delta):
	var input_direction = Vector2()
	
	match(state_movement):
		MovementState.MOVEMENT_STATE_GROUNDED:
			process_movement()
			process_jumping()
			
			if not is_on_floor():
				state_movement = MovementState.MOVEMENT_STATE_AIRBORNE
		MovementState.MOVEMENT_STATE_AIRBORNE:
			process_movement()
			
			if is_on_floor():
				state_movement = MovementState.MOVEMENT_STATE_GROUNDED
	
	match(state_bow):
		BowState.BOW_STATE_NORMAL:
			process_direction()
			
			if Input.is_action_pressed("shoot"):
				state_bow = BowState.BOW_STATE_DRAWN
		BowState.BOW_STATE_DRAWN:
			if not Input.is_action_pressed("shoot"):
				shoot()
				state_bow = BowState.BOW_STATE_NORMAL
	
	print(state_bow)
	
	velocity.y += Global.GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)

func process_movement():
	var input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
		input_direction.x += 1
	
	velocity.x = input_direction.x * move_speed

func process_jumping():
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed

func process_direction():
	if Input.is_action_just_pressed("ui_left"):
		direction = Global.Direction.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		direction = Global.Direction.RIGHT
	
	$AnimatedSprite.flip_h = true if direction == Global.Direction.LEFT else false

func shoot():
	var instance = arrow.instance()
	instance.global_position = global_position
	instance.direction = direction
	
	get_tree().root.add_child(instance)

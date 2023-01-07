extends "res://scripts/Entity.gd"

export var jump_strength = 500

const BRICK_MIN_X = 521
const BRICK_MAX_COUNT = 19
const BRICK_SPAWN_Y = -324
const BRICK_WIDTH = 16

var brick = load("res://scenes/Brick.tscn")
var prev_velocity = velocity

func _process(delta):
	if can_attack and is_on_floor():
		can_attack = false
		timer.start(cooldown)
		jump()

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if prev_velocity.y != 0 and velocity.y == 0:
		drop_bricks(5)
	prev_velocity = velocity

func jump():
	velocity.y -= jump_strength

func drop_brick():
	var i = randi() % BRICK_MAX_COUNT
	var inst = brick.instance()
	inst.position = Vector2(BRICK_MIN_X + BRICK_WIDTH * i, BRICK_SPAWN_Y)
	get_parent().add_child(inst)

func drop_bricks(amount):
	var positions = []
	for i in range(BRICK_MAX_COUNT):
		positions.append(BRICK_MIN_X + i * BRICK_WIDTH)
	
	for i in range(amount):
		var j = randi() % (BRICK_MAX_COUNT - i)
		var inst = brick.instance()
		inst.position = Vector2(positions[j], BRICK_SPAWN_Y)
		get_parent().add_child(inst)
		positions.remove(j)

extends KinematicBody2D

export var gravity = 2350
export var speed = 150
export var damage = 1
export var maximum_hp = 10
export var cooldown = 0.35
export var recoil = 250
export var reach = 35
export var friction = 2000
var velocity = Vector2.ZERO
var hp
var facing_direction = 1
var can_attack = false
var timer
var external_velocity = Vector2.ZERO

func _on_AttackCooldownTimer_timeout():
	can_attack = true

func _ready():
	hp = maximum_hp
	timer = $AttackCooldownTimer
	timer.connect("timeout", self, "_on_AttackCooldownTimer_timeout")
	timer.wait_time = cooldown

func _process(_delta):
	$AnimatedSprite.flip_h = facing_direction < 0

func _physics_process(delta):
	external_velocity = external_velocity.move_toward(Vector2.ZERO, friction * delta)

func in_reach(target):
	var d = position.distance_to(target.position)
	var s = sign(target.position.x - position.x)
	return d < reach and s == facing_direction

func attack(group):
	can_attack = false
	timer.start(cooldown)
	
	var targets = get_tree().get_nodes_in_group(group)
	for t in targets:
		if in_reach(t):
			t.get_attacked(self)

func get_attacked(attacker):
	hp -= attacker.damage
	if hp <= 0:
		die()
	
	external_velocity = Vector2(attacker.recoil * attacker.facing_direction, 0)

func die():
	print(self, " died")

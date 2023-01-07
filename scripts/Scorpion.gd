extends "res://scripts/Entity.gd"

export var jump_strength = 300
var player
var waiting_to_attack = false

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	$AnimatedSprite.play("idle")
	
func _process(_delta):
	if can_attack and in_reach(player) and not waiting_to_attack:
		waiting_to_attack = true
		$AttackWaitingTimer.start()
		$AttackCooldownTimer.stop()
	facing_direction = sign(player.position.x - position.x)

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if position.distance_to(player.position) > reach:
		velocity.x = facing_direction * speed
	
	velocity += external_velocity
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if player.position.y < position.y and is_on_floor():
		jump()

func _on_AttackWaitingTimer_timeout():
	attack("Player")
	waiting_to_attack = false
	$AnimatedSprite.play("attack")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack":
		$AnimatedSprite.play("idle")

func jump():
	velocity.y -= jump_strength

func get_attacked(attacker):
	.get_attacked(attacker)
	$ScorpionSoundPlayer.play()

func die():
	.die()
	queue_free()

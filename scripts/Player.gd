extends "res://scripts/Entity.gd"

signal hp_changed(new_hp)
signal changed_weapon(new_weapon)
signal changed_inventory(new_inventory)

export var jump_strength = 470
export var dashing_speed = 400

var jumped = false
var dashing = false
var can_dash = true
var move_direction = 0
var step = 0
var screen_size

const weapon_dependent_animations = ["attack", "dash", "idle", "jump", "walk"]
const Weapon = preload("Weapon.gd")

var weapon
var weapons = []

func _ready():
	screen_size = get_viewport_rect().size
	$Background.scale = Vector2(screen_size.x / 320, screen_size.y / 180)
	
	weapon = Weapon.new()
	weapon.name = "none"
	
	var claw = Weapon.new()
	claw.name = "claw"
	claw.damage = 1
	claw.recoil = 250
	claw.cooldown = 0.25
	claw.reach = 35
	claw.icon = load("res://art/weapons/claw.png")
	claw.description = "not too strong but faster"
	
	
	add_weapon(claw)

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		die()
	if Input.is_action_just_pressed("hit") and not dashing and can_attack and weapon.name != "none":
		get_node(weapon.name.capitalize() + "HitStreamPlayer").play()
		$AnimatedSprite.offset = Vector2(-5 if $AnimatedSprite.flip_h else 5, 0)
		try_playing_animation("attack")
		attack("Enemy")
	if Input.is_action_just_pressed("dash") and not dashing and can_dash:
		dashing = true
		can_dash = false
		velocity.y = 0
		$DashTimer.start()
		$DashStreamPlayer.play()
		try_playing_animation("dash")
	if Input.is_action_just_pressed("equipt_claw"):
		change_weapon("claw")
	if Input.is_action_just_pressed("equipt_stick"):
		change_weapon("stick")
	if Input.is_action_just_pressed("change_weapon"):
		change_weapon("stick" if weapon.name == "claw" else "claw")
	
	if not dashing:
		move_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if move_direction != 0:
		facing_direction = move_direction

func _physics_process(delta):
	if not dashing:
		velocity.x = move_direction * speed + external_velocity.x
	else:
		velocity.x = facing_direction * dashing_speed
	
	if not dashing:
		velocity.y += gravity * delta
	
	if is_on_floor():
		jumped = false
		can_dash = true
		if move_direction == 0:
			try_playing_animation("idle")
			if !$WalkAudioTimer.is_stopped():
				$WalkAudioTimer.stop()
		else:
			try_playing_animation("walk")
			if $WalkAudioTimer.is_stopped():
				step = 1
				$StepStreamPlayer2.play()
				$WalkAudioTimer.start()
		if Input.is_action_pressed("jump") and not dashing:
			try_playing_animation("jump")
			$JumpStreamPlayer.play()
			velocity.y -= jump_strength
			jumped = true
	else:
		if !$WalkAudioTimer.is_stopped():
				$WalkAudioTimer.stop()
	
	velocity = move_and_slide(velocity, Vector2.UP)

func get_weapon(name):
	for w in weapons:
		if w.name == name:
			return w

func change_weapon(name):
	var w = get_weapon(name)
	if (!w):
		return
	print(name)
	weapon = w
	damage = weapon.damage
	recoil = weapon.recoil
	cooldown = weapon.cooldown
	reach = weapon.reach
	
	emit_signal("changed_weapon", weapon)

func add_weapon(w):
	weapons.append(w)
	emit_signal("changed_inventory", weapons)

func get_attacked(attacker):
	.get_attacked(attacker)
	$HurtStreamPlayer.play()
	emit_signal("hp_changed", hp)

func die():
	.die()
	set_process(false)
	set_physics_process(false)
	try_playing_animation("death")

func try_playing_animation(anim):
	if "attack" in $AnimatedSprite.animation or "dash" in $AnimatedSprite.animation:
		return
	anim = add_suffix_to_animation(anim)
	$AnimatedSprite.play(anim)

func add_suffix_to_animation(anim):
	if anim in weapon_dependent_animations and weapon.name != "none":
		anim += "_" + weapon.name
	return anim

func _on_AnimatedSprite_animation_finished():
	if "attack" in $AnimatedSprite.animation:
		$AnimatedSprite.offset = Vector2.ZERO
		$AnimatedSprite.play(add_suffix_to_animation("idle"))
	elif $AnimatedSprite.animation == "death":
		get_tree().change_scene("res://scenes/Cutscene.tscn")

func _on_AnimatedSprite_frame_changed():
	if "attack" in $AnimatedSprite.animation:
		$AnimatedSprite.offset = Vector2(-5 if $AnimatedSprite.flip_h else 5, 0)

func _on_WalkAudioTimer_timeout():
	if step == 1:
		$StepStreamPlayer1.play()
	else:
		$StepStreamPlayer2.play()
	
	step += 1
	step %= 2

func _on_DashTimer_timeout():
	dashing = false
	$AnimatedSprite.play(add_suffix_to_animation("idle"))





# acceleration code (breaks slope physics)

#if move_direction == 0:
	#velocity.x = 0
#elif abs(velocity.x) < max_speed:
	#velocity.x += acceleration * delta * move_direction

extends Node

var screen_size

func load_main():
	get_tree().change_scene("res://scenes/Main.tscn")

func _ready():
	$AnimatedSprite.play("default")
	screen_size = get_viewport().size
	$AnimatedSprite.position = Vector2(screen_size.x / 2, screen_size.y / 2)
	#$AnimatedSprite.scale = Vector2(screen_size.x / 256, screen_size.y / 256)

func _process(_delta):
	if Input.is_action_just_pressed("skip_cutscene"):
		load_main()

func _on_AnimatedSprite_animation_finished():
	load_main()


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.frame == 3:
		$FallingSoundPlayer.play()
	elif $AnimatedSprite.frame == 8:
		$BluebirdSoundPlayer.play()

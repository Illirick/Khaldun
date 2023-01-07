extends Node

export var scroll_speed = 55

var screen_size
var pbg

func _ready():
	screen_size = get_viewport().size
	pbg = $CanvasLayer/ParallaxBackground
	$CanvasLayer/TextureRect.rect_position = Vector2(screen_size.x / 4, 0)


func _process(delta):
	$CanvasLayer/ParallaxBackground/ParallaxLayer/TextureRect.rect_scale = Vector2(screen_size.x / 320, screen_size.y / 180)
	$CanvasLayer/ParallaxBackground/ParallaxLayer/TextureRect2.rect_scale = Vector2(screen_size.x / 320, screen_size.y / 180)
	$CanvasLayer/ParallaxBackground/ParallaxLayer/TextureRect2.rect_position = Vector2(-screen_size.x, 0)
	pbg.offset.x += delta * scroll_speed
	if pbg.offset.x >= screen_size.x:
		pbg.offset.x = 0


func _on_TextureButton_pressed():
	get_tree().change_scene("res://scenes/Cutscene.tscn")

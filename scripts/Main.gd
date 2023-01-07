extends Node

const Weapon = preload("Weapon.gd")

onready var anubis = load("res://scenes/Anubis.tscn")
onready var tree_no_bird_texture = load("res://art//tree/tree1.png")

func _ready():
	randomize()

func trigger_anubis():
	var anubis_instance = anubis.instance()
	anubis_instance.position = Vector2(800, -220)
	add_child(anubis_instance)


func _on_Ghost_died():
	trigger_anubis()
	get_tree().call_group("Ghost", "queue_free")


func _on_Tree_body_entered(body):
	var stick = Weapon.new()
	stick.name = "stick"
	stick.damage = 2
	stick.recoil = 350
	stick.cooldown = 0.6
	stick.reach = 50
	stick.icon = load("res://art/weapons/stick.png")
	stick.description = "stronger and longer but slowe"
	$Player.add_weapon(stick)
	
	$Tree.disconnect("body_entered", self, "_on_Tree_body_entered")
	$Tree.get_node("Sprite").texture = tree_no_bird_texture

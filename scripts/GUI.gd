extends MarginContainer

export var max_hp = 5

var player

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	player.connect("changed_weapon", self, "_on_Player_changed_weapon")
	player.connect("changed_inventory", self, "_on_Player_changed_inventory")
	player.connect("hp_changed", self, "_on_Player_hp_changed")
	
	_on_Player_changed_inventory(player.weapons)

func _on_Player_hp_changed(new_hp):
	for i in range(max_hp):
		if i < new_hp:
			get_node("VBoxContainer/HBoxContainer/Healpoint" + (i as String)).show()
		else:
			get_node("VBoxContainer/HBoxContainer/Healpoint" + (i as String)).hide()


func _on_Player_changed_weapon(w):
	for t in $VBoxContainer/HBoxContainer2.get_children():
		if t.name == w.name.capitalize():
			t.rect_scale = Vector2.ONE
		else:
			t.rect_scale = Vector2.ONE * .75

func _on_Player_changed_inventory(inv):
	var hide
	for t in $VBoxContainer/HBoxContainer2.get_children():
		hide = true
		for item in inv:
			if t.name == item.name.capitalize():
				t.show()
				t.hint_tooltip = item.description
				hide = false
		if hide:
			t.hide()

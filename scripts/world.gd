extends Node2D


var grass_array = [1, 2, 3, 4, 5]
var grass_number_picked

func _on_player_player_in_grass():
	var grass_number_picked = randi_range(0, grass_array.size() - 1) 
	print(grass_number_picked)
	if grass_number_picked == 4:
		get_tree().change_scene_to_file("res://battle_scene.tscn")

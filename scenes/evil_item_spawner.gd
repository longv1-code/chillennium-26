extends Node2D

var possible_items = [
	preload("res://item_objects/collectable_item6.tscn"),
	preload("res://item_objects/collectable_item7.tscn"),
	preload("res://item_objects/collectable_item8.tscn"),
	preload("res://item_objects/collectable_item9.tscn"),
]



var max_items = 5
var safe_distance = 50.0 # The minimum pixel distance away from the player

func _process(_delta: float) -> void:
	# Constantly check how many items exist
	var current_item_count = get_tree().get_nodes_in_group("items").size()
	
	# If we drop below 5, instantly try to spawn one
	if current_item_count < max_items:
		spawn_random_item()

func spawn_random_item():
	# Find the player and all current items
	var player = get_tree().get_first_node_in_group("player")
	var existing_items = get_tree().get_nodes_in_group("items")
	
	var valid_locations = []
	
	for child in get_children():
		if child is Marker2D:
			
			# Test 1: Is it far enough from the player?
			var is_far_from_player = true
			if player and child.global_position.distance_to(player.global_position) < safe_distance:
				is_far_from_player = false
				
			# Test 2: Is the spot empty? (Check distance to all existing items)
			var is_empty = true
			for item in existing_items:
				# If an item is within 10 pixels of this marker, the spot is taken!
				if child.global_position.distance_to(item.global_position) < 100.0:
					is_empty = false
					break # Stop checking, we already know it's occupied
					
			# If it passed BOTH tests, it's a valid spawn point!
			if is_far_from_player and is_empty:
				valid_locations.append(child)
				
	# Safety check: If all markers are full or too close to player, cancel spawn
	if valid_locations.is_empty():
		return
		
	# Pick a random valid marker AND a random item
	var chosen_marker = valid_locations.pick_random()
	var random_scene = possible_items.pick_random()
	# Create the item
	var new_item = random_scene.instantiate()
	
	# CRUCIAL: Add it to the group AND the world FIRST
	new_item.add_to_group("items") 
	get_parent().add_child(new_item)
	
	# NOW set the global position (without the Vector offset!)
	new_item.global_position = chosen_marker.global_position
	
	print("item spawned at: ", new_item.global_position)

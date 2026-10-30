extends Node

var fighterDir = "res://src/fighters/"

#func _load_csv(Attack_Type: String) -> Array:
	#var file_path = "res://Player_Base/Frame_Data/"+ Attack_Type +".dat"
	#var file = FileAccess.open(file_path, FileAccess.READ)
	#
	#if !file:
		#return []
	#
	#var skipped_first_row = false
	#var hitboxes = []
	#
	#while file.get_position() < file.get_length()-1:
		#var csv_line = file.get_csv_line("\n")
		#match skipped_first_row:
			#true:
				#hitboxes.append(convert_to_hitbox_data(csv_line))
			#false:
				#skipped_first_row = true
	#file.close()
	#return hitboxes

func _save_csv(fighterName, attackType, hitBoxManager, hitboxStartFrames):
	# Open the file for writing
	var file_path = fighterDir + fighterName + "/hitboxes/" + attackType +".dat"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file:
		var child_count = 0
		# Write data to the file
		var data = ""
		for hitboxNode in hitBoxManager.get_children():
			data = str(hitboxStartFrames[child_count]) + ","
			data += str(hitboxNode.shape.extents.x) + ","
			data += str(hitboxNode.shape.extents.y) + ","
			data += str(hitboxNode.position.x) + ","
			data += str(hitboxNode.position.y) + ","
			data += str(hitboxNode.damage) + ","
			data += str(hitboxNode.framesActive) + ","
			data += str(hitboxNode.priority) + ","
			data += str(hitboxNode.angle) + ","
			data += str(hitboxNode.baseKnockback) + ","
			data += str(hitboxNode.hitStun) + ","
			data += str(hitboxNode.knockbackScale) + ","
			data += str(hitboxNode.hitLag) + ","
			data += str(hitboxNode.blockDamage) + ","
			data += str(hitboxNode.type) + ","
			data += str(hitboxNode.reversable)
			file.store_line(data)
			child_count += 1
		
		# You can write more lines as needed
		
		# Close the file
		file.close()
		print("Data saved to CSV file.")
	else:
		print("Failed to open the file for writing.")

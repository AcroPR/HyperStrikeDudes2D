extends Node

var fighterDir = "res://src/fighters/"

func convert_to_hitbox_data(csv_line: PackedStringArray) -> Array:
	var splitArray = csv_line[0].split(",")
	var newArray = []
	
	for i in splitArray.size():
		match i:
			11:
				newArray.append(float(splitArray[i])+0.0)
			15:
				newArray.append(bool(splitArray[i]=="true"))
			_:
				newArray.append(int(splitArray[i]))
	
	while newArray.size() < splitArray.size():
		newArray.append(0)
	return newArray

func _load_csv(fighterName: String, attackType: String) -> Array:
	var filePath = fighterDir + fighterName + "/hitboxes/" + attackType +".dat"
	var file = FileAccess.open(filePath, FileAccess.READ)
	
	if !file:
		return []
	
	var hitboxes = []
	
	while file.get_position() < file.get_length()-1:
		var csv_line = file.get_csv_line("\n")
		hitboxes.append(convert_to_hitbox_data(csv_line))
	file.close()
	return hitboxes

func _save_csv(fighterName, attackType, hitBoxManager, hitboxStartFrames):
	# Open the file for writing
	var filePath = fighterDir + fighterName + "/hitboxes/" + attackType +".dat"
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	
	if file:
		var childCount = 0
		# Write data to the file
		var data = ""
		for hitboxNode in hitBoxManager.get_children():
			data = str(hitboxStartFrames[childCount]) + ","
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
			childCount += 1
		
		# Close the file
		file.close()
		print("Data saved to CSV file.")
	else:
		print("Failed to open the file for writing.")

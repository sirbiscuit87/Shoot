extends Area2D

var nearby_objects_list = [] # Near enough objects should have interaction prompts appear
var hovered_object: Interactable = null 

func _ready():
	check_nearby_on_load()

func check_nearby_on_load(): #This method, eventually, needs to be called by a signal 
	var nearby_objects_array = get_overlapping_areas()
	for x in nearby_objects_array:
		var area_parent = x.get_parent()
		if area_parent is Interactable:
			nearby_objects_list.append(area_parent)
	
func _on_area_entered(area): #Instances interaction bubbles
	var area_parent = area.get_parent()
	if area_parent is Interactable:
		nearby_objects_list.append(area_parent)
		

func _on_area_exited(area):
	var area_parent = area.get_parent()
	if area_parent is Interactable:
		nearby_objects_list.erase(area_parent)


func _process(_delta):
	
	#Only use the raycast if there are indeed interactables near enough to warrant it
	if nearby_objects_list.size():
		var object = $"Facing Raycast".get_collider() #Intersected object
		if hovered_object == null: #An object was not already being hovered
			if object == null: # Nothing to nothing
				return
			else: # Nothing to something
				if object.get_parent() is Interactable:
					#Connect and call hovered signal
					hovered_object = object.get_parent()
					
					hovered_object._just_hovered()
					
					return
				else: #Hovering non-interactable item
					return
		else:	#An object was being hovered, must be notified that it's no longer hovered
			if object == null: # Something to nothing
				hovered_object._just_unhovered()
				hovered_object = null
				return
			if object.get_parent() == hovered_object: #Something to itself
				return	
			if object.get_parent() is Interactable: #Something to something else
					
					#Notify old object its unhovered
					hovered_object._just_unhovered()
					
					hovered_object = object.get_parent()
					hovered_object._just_hovered()
					# call the hovered_object's hovered method, if it has one.
					
					return
			else: #Hovering non-interactable item
				return
		

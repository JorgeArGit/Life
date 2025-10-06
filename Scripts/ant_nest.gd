extends Building
class_name AntNest

var settlers_to_create:int = 0
var total_food_consumption:float = 0.0
@export var settlers_food_cost: float = 10.0
@export var max_settlers: int = 4
@onready var total_settlers: Label = $UI/UIContainer/VBoxContainer/TotalSettlers
@onready var total_food: Label = $UI/UIContainer/VBoxContainer/HBoxContainer/TotalFood
@onready var spawn_container: Node = $SpawnContainer


func _on_plus_pressed() -> void:
	if settlers_to_create < max_settlers:
		settlers_to_create += 1
		if total_food_consumption <= (settlers_food_cost * max_settlers):
			total_food_consumption -= settlers_food_cost
		total_settlers.text = str(settlers_to_create) + " / " + str(max_settlers)
		total_food.text = "Total food: " + str(total_food_consumption)

func _on_minus_pressed() -> void:
	if settlers_to_create > 0:
		settlers_to_create -= 1
		if total_food_consumption >= (-settlers_food_cost * max_settlers):
			total_food_consumption += settlers_food_cost
		total_settlers.text = str(settlers_to_create) + " / " + str(max_settlers)
		total_food.text = "Total food: " + str(total_food_consumption)

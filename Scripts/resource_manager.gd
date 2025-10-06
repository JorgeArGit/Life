extends Node
class_name ResourceManager

var wood_amount: float = 0.0
var food_amount: float = 0.0

@onready var wood: Label = $"../UI/ResourceLabelsContainer/Wood"
@onready var food: Label = $"../UI/ResourceLabelsContainer/Food"
@export var time_manager: TimeManager
@export var settlers_container: SettlersContainer

func _ready() -> void:
	time_manager.new_day.connect(func() -> void:
		#var food_consumption: float = abs(settlers_container.get_food_consumption())
		#while food_amount < food_consumption:
			#settlers_container.free_random_settlers()
			#print(settlers_container.settlers_array)
			#food_consumption = abs(settlers_container.get_food_consumption())
			#print(food_consumption)
		#set_resource_amount(settlers_container.get_food_consumption(), MapResourceStats.Type.FOOD)
		pass
		)

func set_resource_amount(amount: float, type: int) -> void:
	match type:
		MapResourceStats.Type.WOOD:
			wood_amount += amount
			wood.text = "Wood: " + str(wood_amount)
		MapResourceStats.Type.FOOD:
			if (food_amount + amount) < 0.0:
				food_amount = 0
			else:
				food_amount += amount
			food.text = "Food: " + str(food_amount)

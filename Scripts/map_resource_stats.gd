extends Resource
class_name MapResourceStats

enum Type{
	WOOD,
	FOOD,
	EGG
}

@export var resource_amount: float
@export var amount_per_second: float
@export var type: Type 

func set_resource_amount(amount: float) -> void:
	resource_amount -= amount

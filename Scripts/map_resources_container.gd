extends TileMapLayer
class_name MapResourcesContainer

@onready var settlers_container: SettlersContainer = $"../SettlersContainer"
@onready var map_resources_array: Array
@onready var nav_layer: TileMapLayer = $"../NavLayer"

@onready var used_tiles: Array[Vector2i] = get_used_cells()
@export var resource_manager: ResourceManager

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	map_resources_array = self.get_children()
	connect_map_resources()
	check_navigation_layer()

func connect_map_resources() -> void:
	for resource: MapResource in get_children():
		resource.resource_selected.connect(func() -> void:
			var selected_settlers: Array = settlers_container.any_settler_selected()
			for settler: Settler in selected_settlers:
				
				settler.set_resource_focus(resource)
			)
		resource.resource_obtained.connect(func(amount: float, type: int) -> void:
			resource_manager.set_resource_amount(amount, type)
		)
		resource.resource_freed.connect(func() -> void:
			var coords: Vector2i = local_to_map(resource.global_position)
			erase_cell(coords)
			nav_layer.set_cell(coords, 0, Vector2i(1, 2))
			)
		
func check_navigation_layer() -> void:
	for tile: Vector2i in used_tiles:
		nav_layer.set_cell(tile, 0, Vector2i(1, 0))

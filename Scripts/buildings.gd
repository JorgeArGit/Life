extends TileMapLayer
class_name Buildings

@onready var nav_layer: TileMapLayer = $"../NavLayer"
@onready var time_manager: TimeManager = $"../TimeManager"
@onready var settlers_container: SettlersContainer = $"../SettlersContainer"
@onready var build_menu: BuildMenu = $"../UI/BuildMenu"
@onready var map_resources_container: MapResourcesContainer = $"../MapResourcesContainer"
@onready var warning: Warning = $"../UI/Warning"
@onready var resource_manager: ResourceManager = $"../ResourceManager"
@export var nest_cost: float = 0.0
@export var farm_cost: float = 0.0
@export var food_per_farm: float = 0.0
var total_nests: int = 0
var total_farms: int = 0


var to_build: Types = -1

enum Types{
	NEST,
	FARM
}

func _ready() -> void:
	#time_manager.new_day.connect(func() -> void:
		#for building: Building in get_children():
			#if building is AntNest:
				#for i: int in range(building.settlers_to_create):
					#var spawn_position: Vector2 = building.spawn_container.get_child(i).global_position
					#settlers_container.spawn_settlers(spawn_position, building.settlers_food_cost)
		#resource_manager.set_resource_amount(food_per_farm * total_farms, MapResourceStats.Type.FOOD)
		#)
	build_menu.build.connect(func(type: int) -> void:
		to_build = type
		)
	build_menu.stop.connect(func() -> void:
		to_build = -1
		)

func use_farms() -> void:
	for building: Building in get_children():
		if building is AntNest:
			for i: int in range(building.settlers_to_create):
				var spawn_position: Vector2 = building.spawn_container.get_child(i).global_position
				settlers_container.spawn_settlers(spawn_position, building.settlers_food_cost)
	resource_manager.set_resource_amount(food_per_farm * total_farms, MapResourceStats.Type.FOOD)
		
func connect_building() -> void:
	if get_children().size() != 0:
		for building: Building in get_children():
			building.building_placed.connect(func(size: Vector2) -> void:
				var coords: Vector2i = local_to_map(building.global_position)
				var og_coords: Vector2i = coords
				for i: int in range(size.x):
					for j: int in range(size.y):
						nav_layer.set_cell(coords, 0, Vector2i(1, 0))
						coords.y += 1
					coords.x += 1
					coords.y = og_coords.y
				)
			building.ui_showed.connect(func() -> void:
				for i: Building in get_children():
					if i != building:
						i.ui.visible = false
				)


func build() -> void:
	if Input.is_action_just_pressed("left_click") and to_build != -1 and build_menu.build_mode:
		var coords: Vector2i = local_to_map(get_global_mouse_position())
		match to_build:
			Types.NEST:
				if resource_manager.wood_amount < nest_cost:
					warning.show_warning("You don't have enough wood!")
					return
				var og_coords: Vector2i = coords
				for i: int in range(3):
					for j: int in range(5):
						if map_resources_container.get_cell_source_id(Vector2i(coords.x, coords.y)) != -1:
							warning.show_warning("You can't build on top of another object!")
							return
						if nav_layer.get_cell_atlas_coords(Vector2i(coords.x, coords.y)) == Vector2i(1, 0):
							warning.show_warning("You can't build on top of another object!")
							return
						if nav_layer.get_cell_atlas_coords(Vector2i(coords.x, coords.y)) == Vector2i(3, 0):
							warning.show_warning("You can't build outside map limits!")
							return
						coords.y += 1
					coords.x += 1
					coords.y = og_coords.y
				set_cell(og_coords, 0, Vector2i(0, 0), 1)
				resource_manager.set_resource_amount(-nest_cost, MapResourceStats.Type.WOOD)
				total_nests += 1
			Types.FARM:
				if resource_manager.wood_amount < farm_cost:
					warning.show_warning("You don't have enough wood!")
					return
				var og_coords: Vector2i = coords
				for i: int in range(6):
					for j: int in range(3):
						if map_resources_container.get_cell_source_id(Vector2i(coords.x, coords.y)) != -1:
							warning.show_warning("You can't build on top of another object!")
							return
						if nav_layer.get_cell_atlas_coords(Vector2i(coords.x, coords.y)) == Vector2i(1, 0):
							warning.show_warning("You can't build on top of another object!")
							return
						if nav_layer.get_cell_atlas_coords(Vector2i(coords.x, coords.y)) == Vector2i(3, 0):
							warning.show_warning("You can't build outside map limits!")
							return
						coords.y += 1
					coords.x += 1
					coords.y = og_coords.y
			
				set_cell(og_coords, 0, Vector2i(0, 0), 5)
				resource_manager.set_resource_amount(-farm_cost, MapResourceStats.Type.WOOD)
				total_farms += 1
		to_build = -1


func _input(event: InputEvent) -> void:
	build()

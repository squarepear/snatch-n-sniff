extends SpotLight3D

@onready var _base_color := light_color
@onready var _light_material :Material= $convention_light/Cylinder.mesh.surface_get_material(1)

func turn_red():
	light_color = Color.RED
	_light_material.albedo_color = light_color

func return_to_normal():
	light_color = _base_color
	_light_material.albedo_color = Color.WHITE
	

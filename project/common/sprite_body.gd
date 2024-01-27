class_name SpriteBody 
extends Sprite3D

func _ready():
	pixel_size = 0.0025
	billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	var body: StaticBody3D = preload("res://sniffable/sniffableBody.tscn").instantiate()
	var size := get_item_rect().size * pixel_size
	var cylinder: CylinderShape3D = body.get_child(0).shape
	add_child(body)
	cylinder.height = size.y
	cylinder.radius = size.x / 2
	global_position.y += size.y / 2

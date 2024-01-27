class_name Hands
extends TextureRect


func snatch(snatchable: Snatchable) -> void:
	texture = snatchable.get_parent().get_node("Sprite3D").texture
	
	snatchable.snatch()

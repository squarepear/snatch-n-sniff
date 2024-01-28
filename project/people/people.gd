extends CharacterBody3D

@export var sprite_texture : CompressedTexture2D:
	set(value):
		%Sprite.texture = value

@export var taking_aodio: AudioStream:
	set(value):
		%TakingAudioPlayer.stream = value
const SPEED = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var chase_target: Node3D

@onready var snatchback_detector = %SnatchbackDetector
@onready var snatched_alarm: SnatchedAlarm = get_parent().get_node("SnatchedAlarm")


func _ready():
	snatched_alarm.activated.connect(chase)
	snatched_alarm.deactivated.connect(stop_chase)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if chase_target:
		look_at(chase_target.global_position)
	else:
		rotate_y(0.02)

	var direction = (transform.basis * Vector3.FORWARD).normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()

	if chase_target:
		_detect_target()


func _detect_target() -> void:
	if not snatchback_detector.is_colliding():
		return

	var body: Node = snatchback_detector.get_collider(0)
	var hands := Hands.find(body)

	if not hands:
		return

	hands.drop()
	%TakingAudioPlayer.play()
	snatched_alarm.deactivate()


func chase(node: Node3D) -> void:
	chase_target = node


func stop_chase() -> void:
	chase_target = null

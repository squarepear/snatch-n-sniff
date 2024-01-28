class_name Person
extends CharacterBody3D

@export var sprite_texture : CompressedTexture2D:
	set(value):
		%Sprite.texture = value

@export var taking_audio: AudioStream

@export var snatch_attempt_audio: AudioStream

const SPEED = 1.0
const POI_STOP_DISTANCE := 2.0
const POI_STOP_TIME := 4.0
const POI_STOP_TIME_RANGE := 2.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var chase_target: Node3D
var current_poi: Node3D
var waiting := false

@onready var snatchback_detector = %SnatchbackDetector
@onready var snatched_alarm: SnatchedAlarm = get_parent().get_node("SnatchedAlarm")
@onready var points_of_interest = get_parent().get_node("PointsOfInterest").get_children() as Array[Node3D]


func _ready():
	snatched_alarm.activated.connect(chase)
	snatched_alarm.deactivated.connect(stop_chase)

	_pick_new_poi()


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta


	if waiting and not chase_target:
		return

	look_at(chase_target.global_position if chase_target else current_poi.global_position)
	rotation.x = 0
	rotation.z = 0

	var direction = (transform.basis * Vector3.FORWARD).normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()

	if chase_target:
		_detect_target()

	if global_position.distance_to(current_poi.global_position) <= POI_STOP_DISTANCE:
		waiting = true
		get_tree().create_timer(_calculate_stop_time()).timeout.connect(_pick_new_poi)


func _pick_new_poi() -> void:
	waiting = false
	current_poi = points_of_interest[randi() % points_of_interest.size()]


func _calculate_stop_time() -> float:
	return POI_STOP_TIME + (randf() * POI_STOP_TIME_RANGE) - (POI_STOP_TIME_RANGE / 2.0)

func get_snatch_attempt_audio() -> AudioStream:
	return snatch_attempt_audio


func _detect_target() -> void:
	if not snatchback_detector.is_colliding():
		return

	var body: Node = snatchback_detector.get_collider(0)
	var hands := Hands.find(body)

	if not hands:
		return

	hands.drop()
	hands.item_dropped.emit()
	Sfx.set_stream(taking_audio)
	Sfx.play()

	snatched_alarm.deactivate()


func chase(node: Node3D) -> void:
	chase_target = node


func stop_chase() -> void:
	chase_target = null
	_pick_new_poi()

class_name Player
extends CharacterBody3D

signal snatched_snatchable(snatchable: Snatchable)
signal sniffed

const SPEED := 5.0
const SNIFF_SPEED_MULTIPLIER := 0.25
const JUMP_VELOCITY := 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_sniffing := false
var has_sniffed := false:
	set(newValue):
		has_sniffed = newValue
		if has_sniffed:
			sniffed.emit()

@onready var sniff_timer := %SniffTimer
@onready var sniff_noises := %SniffNoises
@onready var hands := $Hands


func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	sniff_timer.timeout.connect(sniff_complete)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Handle movement.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * get_speed()
		velocity.z = direction.z * get_speed()
	else:
		velocity.x = move_toward(velocity.x, 0, get_speed())
		velocity.z = move_toward(velocity.z, 0, get_speed())
	
	if is_sniffing and not has_sniffed:
		hands.shake(10.0, delta)
	
	move_and_slide()


func sniff(sniffdex_entry: SniffdexEntry) -> void:
	if not sniffdex_entry:
		return
	hands.drop()
	sniffed.emit()


func start_sniffing() -> void:
	if is_sniffing or not hands.held_item:
		return
	sniff_timer.start(hands.held_item.sniff_time)
	is_sniffing = true
	sniff_noises.stream = hands.held_item.sniff_noise
	sniff_noises.play()


func sniff_complete() -> void:
	if not is_sniffing:
		return
	has_sniffed = true


func stop_sniffing() -> void:
	if not is_sniffing:
		return
	is_sniffing = false
	hands.reset_position()
	if not has_sniffed:
		sniff_timer.stop()
		sniff_noises.stop()
		return
	hands.drop()
	has_sniffed = false


func get_speed() -> float:
	return SPEED * (SNIFF_SPEED_MULTIPLIER if is_sniffing else 1.0)


func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() #im gamer
	if event.is_action_pressed("snatch"):
		hands.snatch()
	if event.is_action_pressed("sniff"):
		start_sniffing()
	elif event.is_action_released("sniff"):
		stop_sniffing()


func _on_hands_snatched_snatchable(snatchable:Snatchable):
	snatched_snatchable.emit(snatchable)

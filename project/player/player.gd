extends CharacterBody3D


signal snatched_snatchable(snatchable: Snatchable)

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var snatch_detector := $SnatchDetector


func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

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
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func snatch():
	if not snatch_detector.is_colliding():
		return

	var body: Node = snatch_detector.get_collider(0)
	var snatchable := Snatchable.find(body)

	if not snatchable:
		return

	snatched_snatchable.emit(snatchable)


func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() #im gamer
	if event.is_action_pressed("snatch"):
		snatch()

extends CharacterBody3D


const SPEED = 2.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var chase_target: Node3D

func _ready():
	var snatched_alarm: SnatchedAlarm = get_parent().get_node("SnatchedAlarm")
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


func chase(node: Node3D) -> void:
	chase_target = node


func stop_chase() -> void:
	chase_target = null

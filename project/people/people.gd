extends CharacterBody3D


const SPEED = 2.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = (transform.basis * Vector3.FORWARD).normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	rotate_y(0.02)

	move_and_slide()

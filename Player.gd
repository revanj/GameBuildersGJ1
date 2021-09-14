extends RigidBody2D

const ACCELERATION = 50
const GRAVITY = 10
const MAX_SPEED = 300

var velocity = Vector2()


func friction():
	velocity.x = lerp(velocity.x, 0.0, 0.1)

func move_right_left():
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)

func gravity():
	if (velocity.y < MAX_SPEED):
		velocity.y += GRAVITY

func _physics_process(delta):
	velocity = self.linear_velocity;
	gravity()
	friction()
	move_right_left()
	self.linear_velocity = velocity;

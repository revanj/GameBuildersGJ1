extends RigidBody2D

const ACCELERATION = 50
const GRAVITY = 10
const MAX_SPEED = 300

var velocity = Vector2()
var grapple_point

#func friction():
#	velocity.x = lerp(velocity.x, 0.0, 0.1)
#
#func move_right_left():
#	if Input.is_action_pressed("ui_right"):
#		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
#	elif Input.is_action_pressed("ui_left"):
#		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
#
#func gravity():
#	if (velocity.y < MAX_SPEED):
#		velocity.y += GRAVITY
#
#func _physics_process(delta):
#	velocity = self.linear_velocity;
#	gravity()
#	friction()
#	move_right_left()
#	self.linear_velocity = velocity;



# needs jumping functionality.
# first, detect whether player is on groud
# this is achieved with a short raycast pointing downwards from the player
# (because the player is always bouncing around, is_on_floor won't work properly)
# also we should lock the rigidbody's angular movement so that it doesn't spin randomly


func move_right_left():
	if Input.is_action_pressed("ui_right"):
		apply_central_impulse(Vector2(10, 0))
	elif Input.is_action_pressed("ui_left"):
		apply_central_impulse(Vector2(-10, 0))

func _physics_process(delta):
	move_right_left()

# grappling is achieved with a PinJoint2D, doc can be found
# https://docs.godotengine.org/en/stable/classes/class_pinjoint2d.html
# note that the PinJoint2D's node_a and node_b are NodePath
# see https://docs.godotengine.org/en/stable/classes/class_nodepath.html

# I created a GrapplePoint scene, it comes with a PinJoint2D and the
# node_a is already set to be the point itself.
# each time the player presses the button, find the nearest grapple point, then
# set its PinJoint2D node_b to the player.

# to change the length of the PinJoint, see the second answer in
# https://godotengine.org/qa/23760/how-to-change-the-rest-position-of-a-pinjoint2d

func find_grapple_point():
	# this function returns a list of all nodes labeled "grapple_point"
	# see https://docs.godotengine.org/en/latest/tutorials/scripting/groups.html
	get_tree().get_nodes_in_group("grapple_point")

# some basic tutorial can be found
# https://docs.godotengine.org/en/stable/getting_started/step_by_step/index.html

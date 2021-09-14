extends RigidBody2D

var speed = 10
var max_speed = 100
func _physics_process(delta):
	var xdir = 0
	if Input.is_action_pressed("ui_left"):
		xdir -= 1
	if Input.is_action_pressed("ui_right"):
		xdir += 1
		
	add_central_force(Vector2(xdir * speed, 0))
	
	
func _integrate_forces(state):
	if state.linear_velocity.length()>max_speed:
		state.linear_velocity=state.linear_velocity.normalized()*max_speed
		

extends RigidBody2D

const ACCELERATION = 10
const GRAVITY = 10
const MAX_SPEED = 300
const GRAPPLE_LENGTH = 500



func move_right_left():
	if Input.is_action_pressed("ui_right"):
		apply_central_impulse(Vector2(ACCELERATION, 0))
	elif Input.is_action_pressed("ui_left"):
		apply_central_impulse(Vector2(-ACCELERATION, 0))


func grapple():
	var mousepos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	
	var max_grapple_position = (mousepos - global_position)
	max_grapple_position = max_grapple_position/max_grapple_position.length()*GRAPPLE_LENGTH + global_position
	
	var result = space_state.intersect_ray(global_position, max_grapple_position, [self])
	
	if result:
		var world = get_node("/root/World")
		for i in world.get_children():
			if (i.name == "grapple point"):
				world.remove_child(i)
		
		var node = StaticBody2D.new()
		node.name = "grapple point"
		world.add_child(node)
		
		var grapple = PinJoint2D.new()
		node.add_child(grapple)
		
		node.position = result.position
		
		grapple.set_node_a(node.get_path())
		grapple.set_node_b(self.get_path())
		print("Grappled ")
		
func _input(event):
	if event is InputEventMouseButton:
		if (event.pressed):
			grapple()
	
func _physics_process(delta):
	move_right_left()
	

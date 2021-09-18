extends RigidBody2D

const ACCELERATION = 200
const GRAVITY = 10
const MAX_SPEED = 300
const GRAPPLE_LENGTH = 500

var rope = []

func move_right_left():
	if Input.is_action_pressed("ui_right"):
		apply_central_impulse(Vector2(ACCELERATION, 0))
	elif Input.is_action_pressed("ui_left"):
		apply_central_impulse(Vector2(-ACCELERATION, 0))

func add_section(previous_node, pos):
	var section = RigidBody2D.new()
	previous_node.add_child(section)
	rope.append(section)
	section.mass = 0.01
	section.weight = 5
	section.gravity_scale = 0
	section.angular_damp = 0
	section.linear_damp = 0
	for r in rope:
		section.add_collision_exception_with(r)
	
	var shape = CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	shape.shape.radius = 4
	section.add_child(shape)
	
	
	var grapple = PinJoint2D.new()
	section.add_child(grapple)
	
	section.global_position = pos
	
	grapple.set_node_a(previous_node.get_path())
	grapple.set_node_b(section.get_path())
	
	return section

func grapple():
	var mousepos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	
	var max_grapple_position = (mousepos - global_position)
	max_grapple_position = max_grapple_position/max_grapple_position.length()*GRAPPLE_LENGTH + global_position
	
	var result = space_state.intersect_ray(global_position, max_grapple_position, rope)
	
	if result:
		var world = get_node("/root/World")
		for i in world.get_children():
			if (i.name == "grapple point"):
				world.remove_child(i)
		
		var node = StaticBody2D.new()
		node.name = "grapple point"
		world.add_child(node)
		
		var currentpos = result.position
		var direction = self.global_position - result.position
		var long = direction.length()
		direction = direction / direction.length()
		var currentnode = node
		
		rope.append(node)
		rope.append(self)
		for i in range(long/4):
			currentnode = add_section(currentnode, currentpos)
			currentpos = currentpos + direction*4
		
		
		var grapple = PinJoint2D.new()
		currentnode.add_child(grapple)
		
		currentnode.global_position = currentpos
		
		grapple.set_node_a(currentnode.get_path())
		grapple.set_node_b(self.get_path())
		
		print("Grappled ")
		
func _input(event):
	if event is InputEventMouseButton:
		if (event.pressed):
			grapple()
	
func _physics_process(delta):
	move_right_left()
	

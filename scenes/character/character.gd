extends CharacterBody3D
class_name Character

# REFERENCES
@export_group("References")
@export var head : Node3D

# PUBLIC VARIABLES
@export_group("Variables")
@export_group("Camera")
@export var mouse_sensitivity : float
@export var max_look_down : float
@export var max_look_up : float

# PRIVATE VARIABLES
const GRAVITY : float = 9.8

var should_jump_on_land : bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func handle_looking_around(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * mouse_sensitivity / 4))
		head.rotate_x(-deg_to_rad(event.relative.y * mouse_sensitivity * get_tree().root.size.y/get_tree().root.size.x / 4))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-max_look_down), deg_to_rad(max_look_up))
		
func handle_gravity(delta : float) -> void:
	velocity.y -= GRAVITY * delta
		
func handle_air_movement(speed : float, acceleration : float, delta : float, cap : float, wish_direction : Vector3) -> void:
		
	var current_speed_in_wish_direction = self.velocity.dot(wish_direction)
	var capped_speed = min((speed * wish_direction).length(), cap)
	var add_speed_until_cap = capped_speed - current_speed_in_wish_direction
	
	if add_speed_until_cap > 0:
		var acceleration_speed = acceleration * speed * delta
		acceleration_speed = min(acceleration_speed, add_speed_until_cap)
		self.velocity += acceleration_speed * wish_direction
		
func handle_ground_movement(speed : float, acceleration : float, deceleration : float, delta : float, wish_direction : Vector3) -> void:
	if wish_direction:
		velocity.x = lerp(velocity.x, wish_direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, wish_direction.z * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, deceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, deceleration * delta)
		
func get_wish_direction(input_direction : Vector2) -> Vector3:
	var wish_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	return wish_direction
	
func get_input_direction() -> Vector2:
	var input_direction = Input.get_vector("left", "right", "forward", "backward")
	return input_direction
		
func call_move_and_slide() -> void:
	move_and_slide()

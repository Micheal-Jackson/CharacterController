extends State
class_name JumpingPlayerState

@export_group("References")
@export var state_machine : StateMachine

@export_group("Movement")
@export var cap : float
@export var speed : float
@export var acceleration : float
@export var jump_strenght : float

# PRIVATE VARIABLES
var auto_jump_duration : float = 0.5 # this is used to auto jump when the player presses the jump button in the air. It counts down from this until it reaches 0 and sets it back to false. look for should_jump_on_land in character script.
var time : float = 0.0

func input(event : InputEvent) -> void:
	state_machine.character.handle_looking_around(event)

func enter() -> void:
	state_machine.character.velocity.y = jump_strenght

func physics_update(delta : float) -> void:
	var input_direction : Vector2 = state_machine.character.get_input_direction()
	input_direction.y = 0
	var wish_direction : Vector3 = state_machine.character.get_wish_direction(input_direction)
	state_machine.character.handle_air_movement(speed, acceleration, delta, cap, wish_direction)
	state_machine.character.handle_gravity(delta)
	state_machine.character.call_move_and_slide()
	
func update(delta : float) -> void:
	if state_machine.character.is_on_floor():
		transition.emit("LandingPlayerState")
		
	elif state_machine.character.velocity.y < 0.0:
		transition.emit("InAirPlayerState")
		
	if state_machine.character.should_jump_on_land: # used to make the player auto jump when landing when pressing the jump button while still in air to avoid having to be very precise while bhopping.
		time += delta
		if time >= auto_jump_duration:
			state_machine.character.should_jump_on_land = false
			time = 0

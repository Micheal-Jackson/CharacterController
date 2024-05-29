extends State
class_name WalkingPlayerState

@export_group("References")
@export var state_machine : StateMachine

@export_group("Movement")
@export var speed : float
@export var acceleration : float
@export var deceleration : float

func input(event : InputEvent) -> void:
	state_machine.character.handle_looking_around(event)
	
	if event.is_action_pressed("jump"):
		transition.emit("JumpingPlayerState")
	
	elif event.is_action_pressed("crouch"):
		transition.emit("CrouchingPlayerState")

func physics_update(delta : float) -> void:
	var input_direction : Vector2 = state_machine.character.get_input_direction()
	var wish_direction : Vector3 = state_machine.character.get_wish_direction(input_direction)
	state_machine.character.handle_ground_movement(speed, acceleration, deceleration, delta, wish_direction)
	state_machine.character.call_move_and_slide()

func update(_delta : float) -> void:
	if state_machine.character.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
		
	elif Input.is_action_pressed("sprint"):
		transition.emit("SprintingPlayerState")
		
	elif !state_machine.character.is_on_floor():
		transition.emit("InAirPlayerState")

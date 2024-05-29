extends State
class_name CrouchingPlayerState

@export_group("References")
@export var state_machine : StateMachine

@export_group("Movement")
@export var speed : float
@export var acceleration : float
@export var deceleration : float
@export var crouch_anim_speed : float

func enter() -> void:
	state_machine.animation_player.play("crouch", -1, crouch_anim_speed, false)

func exit() -> void:
	state_machine.animation_player.play("crouch", -1, -crouch_anim_speed, true)
	
func input(event : InputEvent) -> void:
	state_machine.character.handle_looking_around(event)

	if event.is_action_pressed("crouch"):
		if !state_machine.crouch_check.is_colliding():
			transition.emit("IdlePlayerState")

func physics_update(delta : float) -> void:
	var input_direction : Vector2 = state_machine.character.get_input_direction()
	var wish_direction : Vector3 = state_machine.character.get_wish_direction(input_direction)
	state_machine.character.handle_ground_movement(speed, acceleration, deceleration, delta, wish_direction)
	state_machine.character.call_move_and_slide()
	
func update(_delta : float) -> void:
	if !state_machine.character.is_on_floor():
		transition.emit("InAirPlayerState")

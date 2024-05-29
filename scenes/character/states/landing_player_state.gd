extends State
class_name LandingPlayerState

@export_group("References")
@export var state_machine : StateMachine

func input(event : InputEvent) -> void:
	state_machine.character.handle_looking_around(event)

func update(_delta : float) -> void:
	if state_machine.character.should_jump_on_land:
		transition.emit("JumpingPlayerState")
		state_machine.character.should_jump_on_land = false
	else:
		transition.emit("IdlePlayerState")

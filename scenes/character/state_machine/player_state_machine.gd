extends Node
class_name StateMachine

@export var character : Character
@export var animation_player : AnimationPlayer
@export var crouch_check : ShapeCast3D
@export var current_state : State

var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains something which isnt a state.", child.name)
	current_state.enter()
	
func _process(delta) -> void:
	print(character.velocity.length())
	current_state.update(delta)
	
func _physics_process(delta) -> void:
	current_state.physics_update(delta)

func _input(event) -> void:
	current_state.input(event)

func on_child_transition(new_state_name : StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != current_state:
			current_state.exit()
			new_state.enter()
			current_state = new_state
			
	else:
		push_warning("State doesnt exist.")

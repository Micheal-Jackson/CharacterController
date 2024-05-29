extends Node
class_name State

signal transition(new_state_name : StringName)

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func update(_delta : float) -> void:
	pass
	
func physics_update(_delta : float) -> void:
	pass

func input(_event : InputEvent) -> void:
	pass

@icon("res://addons/enhanced_state_chart/icons/transitions/guards/guard.png")
extends Node
class_name EGuard

## Returns true if the guard is satisfied, false otherwise.
func is_satisfied(context_transition: ETransition, context_state: EState) -> bool:
	push_error("EGuard.is_satisfied() is not implemented. Did you forget to override it?")
	return false

func _get_configuration_warnings() -> PackedStringArray:
	return []
@tool
## A guard which is satisfied when the given guard is not satisfied.
class_name NotEGuard
extends EGuard

## The guard that should not be satisfied. When null, this guard is always satisfied.
@onready var guard: EGuard = get_guard_child()

func is_satisfied(context_transition: ETransition, context_state: EState) -> bool:
    if guard == null:
        return true

    return not guard.is_satisfied(context_transition, context_state)




func get_guard_child() -> EGuard:
    if get_child_count() == 0 or !get_child(0) is EGuard:
        return null

    return get_child(0) as EGuard

func _get_configuration_warnings() -> PackedStringArray:
    var warnings := super()

    if get_guard_child() == null:
        warnings.append("NotEGuard should have at least one child as EGuard.")
    
    return warnings


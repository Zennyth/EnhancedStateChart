@tool
## A composite guard that is satisfied when all of its guards are satisfied.
class_name AllOfEGuard
extends EGuard

## The guards that need to be satisified. When empty, returns true.
@onready var guards: Array[EGuard] = get_guard_children()

func is_satisfied(context_transition: ETransition, context_state: EState) -> bool:
    for guard in guards:
        if not guard.is_satisfied(context_transition, context_state):
            return false

    return true


func get_guard_children() -> Array[EGuard]:
    var guards: Array[EGuard] = []

    for child in get_children():
        if child is EGuard:
            guards.append(child)
    
    return guards

func _get_configuration_warnings() -> PackedStringArray:
    var warnings := super()

    if len(get_guard_children()) == 0:
        warnings.append("AllOfEGuard should have at least one child as EGuard.")
    
    return warnings
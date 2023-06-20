@tool
@icon("res://addons/enhanced_state_chart/icons/states/atomic_state.png")
extends EState
class_name EAtomicState


func _get_configuration_warnings() -> PackedStringArray:
    var warnings = super._get_configuration_warnings()

    for child in get_children():
        if child is EState:
            warnings.append("Atomic states cannot have child state nodes.")
            break

    return warnings
@tool
@icon("res://addons/enhanced_state_chart/icons/states/composites/parallel_state.png")
extends EState
class_name EParrallelState

var sub_states: Array[EState]:
    get = get_sub_states




func initialize() -> void:
    for sub_state in sub_states:
        sub_state.initialize()

    super()


func enter() -> void:
    super()
    
    for sub_state in sub_states:
        sub_state.enter()


func exit() -> void:
    for sub_state in sub_states:
        sub_state.exit()

    super()






func get_sub_states() -> Array[EState]:
    var _sub_states: Array[EState] = []

    for child in get_children():
        if not child is EState:
            continue
        
        _sub_states.append(child as EState)
    
    return _sub_states

func _get_configuration_warnings() -> PackedStringArray:
    var warnings = super._get_configuration_warnings()
    
    if get_child_count() == 0:
        warnings.append("Parallel states should have at least one child state.")
    
    return warnings
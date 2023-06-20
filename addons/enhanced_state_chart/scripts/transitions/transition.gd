@tool
@icon("res://addons/enhanced_state_chart/icons/transitions/transition.png")
extends Node
class_name ETransition

## The target state to which the transition should switch
@export_node_path("EState") var to_path :NodePath:
    set(value):
        to_path = value
        update_configuration_warnings()

var to: EState:
    get = get_to
func get_to() -> EState:
    return get_node_or_null(to_path) as EState


@export var guard: EGuard
@export var debug: bool = false


var transition_owner: EState

func initilialize_transition(_transition_owner: EState) -> void:
    transition_owner = _transition_owner
    transition_owner.entered.connect(_on_owner_entered)
    transition_owner.exited.connect(_on_owner_exited)
    

func _on_owner_entered() -> void:
    pass

func _on_owner_exited() -> void:
    pass   



func _on_event_triggered() -> void:
    if transition_owner == null or !transition_owner.is_active or to == null:
        return
    
    if guard != null and !guard.is_satisfied(self, transition_owner):
        return
    
    if debug:
        print("Transition [%s] triggered from [%s] to [%s]" % [name, transition_owner.name, to.name])

    transition_owner.handle_transition(self)

func is_equal_to(_other: ETransition) -> bool:
    return false


func get_first_compound_state(state: EState) -> ECompoundState:
    var parent = state.get_parent()

    if parent != null:
        if parent is ECompoundState:
            return parent
    
        if parent is EState:
            return get_first_compound_state(parent)
    
    return null

func _get_configuration_warnings():
    var warnings = []
    
    if to == null:
        warnings.append("The target state is not set")
    
    return warnings
    
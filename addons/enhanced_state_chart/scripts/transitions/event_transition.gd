@tool
@icon("res://addons/enhanced_state_chart/icons/transitions/events/event.png")
extends ETransition
class_name EEventTransition

@export_node_path("Node") var source_path: NodePath:
    set = set_source_path
@onready var source: Node = get_node_or_null(source_path)

@export var signal_name: String


func set_source_path(value) -> void:
    source_path = value
    source = get_node_or_null(source_path)



func _on_owner_entered() -> void:
    if source == null or !source.has_signal(signal_name):
        return
    
    if signal_name == "entered" and source == transition_owner:
        return _on_event_triggered()
    
    source.get(signal_name).connect(_on_signal_triggered)
    
func _on_owner_exited() -> void:
    if source == null or !source.has_signal(signal_name) or !source.get(signal_name).is_connected(_on_signal_triggered):
        return
    
    source.get(signal_name).disconnect(_on_signal_triggered)

func _on_signal_triggered(_arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null) -> void:
    _on_event_triggered()    




func is_equal_to(other: ETransition) -> bool:
    if not other is EEventTransition:
        return super(other)

    return source == other.source

func _get_configuration_warnings():
    var warnings = super()
    
    return warnings
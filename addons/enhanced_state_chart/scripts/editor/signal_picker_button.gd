@tool
extends Button

const SignalPicker = preload("res://addons/enhanced_state_chart/scenes/editor/SignalPicker.tscn")

var transition: ETransition
var signal_picker

func initialize(_transition: ETransition) -> void:
    transition = _transition
    pressed.connect(_on_pressed)


func _on_pressed() -> void:    
    signal_picker = SignalPicker.instantiate()
    signal_picker.initialize(transition.source)
    signal_picker.signal_picked.connect(_on_signal_picked)
    add_child(signal_picker)


func _on_signal_picked(signal_name: String, node: Node) -> void:
    transition.signal_name = signal_name 
    signal_picker.close()

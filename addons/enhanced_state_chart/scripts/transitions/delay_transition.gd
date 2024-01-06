@tool
@icon("res://addons/enhanced_state_chart/icons/transitions/delay_transition.png")
extends ETransition
class_name EDelayTransition

## Delay in seconds before the transition happens
@export var delay: float = 1
@onready var timer: Timer = Timer.new()

func _ready():
    add_child(timer)

func _on_owner_entered() -> void:
    timer.timeout.connect(_on_event_triggered)
    timer.start(delay)

func _on_owner_exited() -> void:
    timer.stop()

    if timer.timeout.is_connected(_on_event_triggered):
        timer.timeout.disconnect(_on_event_triggered)
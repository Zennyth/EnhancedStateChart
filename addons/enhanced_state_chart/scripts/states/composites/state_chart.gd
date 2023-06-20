@tool
@icon("res://addons/enhanced_state_chart/icons/states/composites/state_chart.png")
extends EParrallelState
class_name EStateChart

func _ready() -> void:
    if Engine.is_editor_hint():
        return

    initialize()
    enter()
@tool
extends EAction
class_name EStateAction

@onready var state: EState = get_parent()


func _ready() -> void:
	state.entered.connect(_on_state_entered)
	state.physics_processed.connect(_on_state_physics_processed)
	state.processed.connect(_on_state_processed)
	state.exited.connect(_on_state_exited)


func _on_state_entered() -> void:
	pass

func _on_state_physics_processed(_delta: float) -> void:
	pass

func _on_state_processed(_delta: float) -> void:
	pass

func _on_state_exited() -> void:
	pass


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = super()

	if not get_parent() is EState:
		warnings.append("State actions should have a State as a parent.")

	return warnings

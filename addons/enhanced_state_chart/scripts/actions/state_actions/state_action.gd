@tool
extends EAction
class_name EStateAction

enum Events {
	NONE,
	ENTER,
	PHYSICS_PROCESS,
	PROCESS,
	EXIT
}


@onready var state: EState = get_parent()

func _ready():
	_bind_action_events()

func _bind_action_events() -> void:
	state.entered.connect(_on_state_entered)
	state.physics_processed.connect(_on_state_physics_processed)
	state.processed.connect(_on_state_processed)
	state.unhandled_input.connect(_on_state_unhandled_input)
	state.exited.connect(_on_state_exited)

func _get_action_event(event: Events) -> Signal:
	match event:
		Events.ENTER:
			return state.entered
		Events.PHYSICS_PROCESS:
			return state.physics_processed
		Events.PROCESS:
			return state.processed
		Events.EXIT:
			return state.exited
		_, Events.NONE:
			return state.ready 

func _bind_action_event(event: Events, callback: Callable) -> void:
	if event == Events.NONE:
		return
	
	_get_action_event(event).connect(callback)

func _on_state_entered() -> void:
	pass

func _on_state_physics_processed(_delta: float) -> void:
	pass

func _on_state_processed(_delta: float) -> void:
	pass

func _on_state_unhandled_input(event: InputEvent) -> void:
	pass

func _on_state_exited() -> void:
	pass


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = super()

	if not get_parent() is EState:
		warnings.append("State actions should have a State as a parent.")

	return warnings

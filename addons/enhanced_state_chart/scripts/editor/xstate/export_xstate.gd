extends EditorInspectorPlugin

func _can_handle(object) -> bool:
	return object is EState

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide) -> bool:
	if name == "debug":
		var button: Button = Button.new()
		button.text = "Export StateChart"
		button.pressed.connect(_on_button_pressed.bind(object))
		add_custom_control(button)
	
	return false



func _on_button_pressed(state: EState) -> void:
	var xstate: Dictionary = _convert(state)
	var json_converter: JSON = JSON.new()

	var json: String = json_converter.stringify(xstate)
	DisplayServer.clipboard_set(json)

func _convert(state: EState) -> Dictionary:
	var xstate: Dictionary = _convert_state(state)
	xstate["id"] = state.name
	return xstate

func _convert_state(state: EState) -> Dictionary:
	var xstate: Dictionary = _convert_parallel_state(state)

	if xstate.is_empty():
		xstate = _convert_compound_state(state)
	
	if xstate.is_empty():
		xstate = _convert_atomic_state(state)
	
	xstate["on"] = _convert_transitions(state)
	
	return xstate

func _convert_parallel_state(state: EState) -> Dictionary:
	if not state is EParrallelState:
		return {}
	
	var xstate: Dictionary = {
		"type": "parallel"
	}

	xstate["states"] = {}
	for child in state.sub_states:
		xstate.states[child.name] = _convert_state(child)
	
	return xstate

func _convert_compound_state(state: EState) -> Dictionary:
	if not state is ECompoundState:
		return {}
	
	var xstate: Dictionary = {
		"type": "coumpound",
		"initial": state.initial_state.name
	}

	xstate["states"] = {}
	for child in NodeUtils.find_nodes(state, EState, EState):
		xstate.states[child.name] = _convert_state(child)
	
	return xstate

func _convert_atomic_state(state: EState) -> Dictionary:
	return {}


func _convert_transitions(state: EState) -> Dictionary:
	var transitions: Dictionary = {}

	for transition in NodeUtils.find_nodes(state, ETransition, EState):
		transitions[transition.name] = _convert_transition(transition)
	
	return transitions

func _convert_transition(transition: ETransition) -> Dictionary:
	var xtransition: Dictionary = {
		"target": transition.to.name
	}
	
	return xtransition

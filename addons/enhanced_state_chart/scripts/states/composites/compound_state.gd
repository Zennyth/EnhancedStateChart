@tool
@icon("res://addons/enhanced_state_chart/icons/states/composites/compound_state.png")
extends EState
class_name ECompoundState

@export_node_path("EState") var initial_state_path: NodePath:
	set(value):
		initial_state_path = value
		update_configuration_warnings()

var initial_state: EState:
	get = get_initial_state

var active_state: EState:
	set = set_active_state

func set_active_state(value) -> void:
	if value == self:
		return push_error("Coumpound state cannot be it's own active state !")

	if active_state != null:
		active_state.exit()
	
	active_state = value

	if active_state != null:
		active_state.enter()





func initialize() -> void:
	for child in get_children():
		if not child is EState:
			continue
		
		(child as EState).initialize()

	super()


func enter() -> void:
	if initial_state == null:
		return push_error("No initial state configured for compound state '" + name + "'.")
	
	# process children first so that transitions on entered doesn't break the enter flow
	active_state = initial_state
	super()

func handle_transition(transition: ETransition) -> void:
	if transition.transition_owner == self:
		for child_transition in get_all_transition_children():
			if transition.is_equal_to(child_transition):
				return

	if transition.to in get_children():
		active_state = transition.to
		return

	super(transition)

func exit() -> void:
	active_state = null
	super()


func get_all_transition_children(state: EState = self) -> Array:
	var res: Array = []

	for child in state.get_children():
		if child is EState and child.is_active:
			res += child.get_transitions()
			
			if child is ECompoundState or child is EParrallelState:
				res += get_all_transition_children(child)
	
	return res


func get_initial_state() -> EState:
	var _initial_state: EState = get_node_or_null(initial_state_path) 

	if _initial_state == null and get_child_count() == 1 and get_child(0) is EState:
		return get_child(0) as EState
	
	return _initial_state

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = super()

	if get_child_count() == 0:
		warnings.append("Compound states should have at least one child state.")
	
	if initial_state == null:
		warnings.append("Compound states should have their initial state configured or have only one child state.")

	return warnings

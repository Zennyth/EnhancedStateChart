@icon("res://addons/enhanced_state_chart/icons/states/state.png")
extends Node
class_name EState

signal initialized()
signal activated()
signal deactivated()

signal entered()
signal physics_processed(delta: float)
signal processed(delta: float)
signal unhandled_input(event: InputEvent)
signal exited()

@export var debug: bool = false


func _ready() -> void:
	if Engine.is_editor_hint() or get_parent() is EState:
		return

	initialize()
	enter()


var is_active: bool:
	set = set_is_active


func initialize() -> void:
	is_active = false
	initialized.emit()

	for transition in get_transitions():
		transition.initilialize_transition(self)

func enter() -> void:
	if debug: print("[%s] entered" % name)
	
	is_active = true
	entered.emit()

func _physics_process(delta: float) -> void:
	physics_processed.emit(delta)

func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return

	unhandled_input.emit(event)

func _process(delta: float) -> void:
	processed.emit(delta)

func exit() -> void:
	is_active = false
	exited.emit()
	
	if debug: print("[%s] exited" % name)

func handle_transition(transition: ETransition) -> bool:
	if not get_parent() is EState:
		return false

	return get_parent().handle_transition(transition)


func set_is_active(value) -> void:
	var was_active: bool = is_active
	is_active = value
	
	set_process(is_active)
	set_physics_process(is_active)
	
	if is_active == true and was_active == false:
		activated.emit()
	else:
		deactivated.emit()

func _get_configuration_warnings() -> PackedStringArray:
	return []

func get_transitions() -> Array[ETransition]:
	var transitions: Array[ETransition] = []

	for child in get_children():
		if not child is ETransition:
			continue
		
		transitions.append(child as ETransition)
	
	return transitions

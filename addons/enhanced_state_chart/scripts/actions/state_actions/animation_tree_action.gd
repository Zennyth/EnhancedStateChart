extends EStateAction
class_name EAnimationTreeStateAction

signal animation_finished

@export var animation_tree: AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@export var animation_name: String

@export_group("Blend Position")
const DirectionType = Controller2D.DirectionType
@export var action_event: Events = Events.NONE
@export var controller: Controller2D
@export var direction_type: DirectionType = DirectionType.MOVE 


func _on_state_entered() -> void:
	if !is_multiplayer_authority():
		return
	
	SignalUtils.connect_if_not_connected(animation_tree.animation_finished, _on_animation_finished)
	play.rpc()

@rpc("call_local")
func play() -> void:
	animation_state_machine.travel(_animation_name)

	if action_event == Events.ENTER:
		sync_blend_position()


func _on_state_physics_processed(_delta: float) -> void:
	if action_event != Events.PHYSICS_PROCESS:
		return

	sync_blend_position()
	
func _on_state_exited() -> void:
	SignalUtils.disconnect_if_connected(animation_tree.animation_finished, _on_animation_finished)

###
# CORE
###
var _animation_name: String:
	get: return animation_name if !StringUtils.is_null_or_empty(animation_name) else state.name

func sync_blend_position() -> void:
	animation_tree.set("parameters/StateMachine/" + _animation_name + "/blend_position", controller.get_direction(direction_type).normalized())

func _on_animation_finished(finished_animation_name: String) -> void:
	if animation_name != _animation_name or not state.is_active:
		return
	
	animation_finished.emit()
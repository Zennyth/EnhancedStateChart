extends EStateAction
class_name EAnimationTreeStateAction

signal animation_finished

@export var animation_tree: AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@export var animation_name: String

@export_group("Blend Position")
@export var sync_type: SyncType = SyncType.NONE
@export var sync_property: SyncProperty = SyncProperty.MOVE_DIRECTION
@export var controller: Controller2D


func _on_state_entered() -> void:
	if !is_multiplayer_authority():
		return
	
	SignalUtils.connect_if_not_connected(animation_tree.animation_finished, _on_animation_finished)
	play.rpc()

@rpc("call_local")
func play() -> void:
	animation_state_machine.travel(_animation_name)

	if sync_type == SyncType.ENTER:
		sync_blend_position()


enum SyncType {
	NONE,
	PHYSICS_PROCESS,
	ENTER
}
enum SyncProperty {
	MOVE_DIRECTION,
	WATCH_DIRECTION,
	AIM_DIRECTION,
}
func _on_state_physics_processed(_delta: float) -> void:
	if sync_type != SyncType.PHYSICS_PROCESS:
		return

	sync_blend_position()
	
func _on_state_exited() -> void:
	SignalUtils.disconnect_if_connected(animation_tree.animation_finished, _on_animation_finished)

###
# CORE
###
var _animation_name: String:
	get: return animation_name if !StringUtils.is_null_or_empty(animation_name) else state.name

func get_sync_property_value() -> Vector2:
	if sync_property == SyncProperty.MOVE_DIRECTION:
		return controller.move_direction
	if sync_property == SyncProperty.WATCH_DIRECTION:
		return controller.watching_direction
	return controller.aim_direction 

func sync_blend_position() -> void:
	animation_tree.set("parameters/StateMachine/" + _animation_name + "/blend_position", get_sync_property_value().normalized())

func _on_animation_finished(finished_animation_name: String) -> void:
	if animation_name != _animation_name or not state.is_active:
		return
	
	animation_finished.emit()
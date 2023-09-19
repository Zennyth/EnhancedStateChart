extends EStateAction
class_name EAnimationTreeStateAction

@export var animation_tree: AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

@export var animation_name: String


func _on_state_entered() -> void:
	if !is_multiplayer_authority():
		return
	
	play.rpc()

@rpc("call_local")
func play() -> void:
	animation_state_machine.start(animation_name if animation_name != null else state.name)

func _on_state_exited() -> void:
	pass

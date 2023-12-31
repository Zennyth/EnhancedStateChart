extends EStateAction
class_name EAnimationPlayerStateAction

@export var animation_player: AnimationPlayer
@export var animation_name: String


func _on_state_entered() -> void:
	if !is_multiplayer_authority():
		return
	
	play.rpc()

@rpc("call_local")
func play() -> void:
	animation_player.play(animation_name if !StringUtils.is_null_or_empty(animation_name) else state.name)

func _on_state_exited() -> void:
	pass
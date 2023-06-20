extends EStateAction

@export var animation_player: AnimationPlayer
@export var animation_name: String


func _on_state_entered() -> void:
    animation_player.play(animation_name if animation_name != null else state.name)

func _on_state_exited() -> void:
    pass
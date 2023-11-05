extends EStateAction
class_name EControllableStateAction

@export var controllable: RotationDirectionControllable2D
@export var mode: RotationDirectionControllable2D.Mode = RotationDirectionControllable2D.Mode.MOVE

func _on_state_entered() -> void:
	controllable.mode = mode
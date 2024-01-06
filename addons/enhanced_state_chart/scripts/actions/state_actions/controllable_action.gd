extends EStateAction
class_name EControllableStateAction

const DirectionType = RotationDirectionControllable2D.DirectionType

@export var controllable: RotationDirectionControllable2D
@export var direction_type: DirectionType = DirectionType.MOVE
@export var single_sync: bool = false

func _on_state_entered() -> void:
	controllable.direction_type = direction_type 
	controllable.single_sync = single_sync

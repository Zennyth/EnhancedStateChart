extends EStateAction
class_name EVisibleStateAction

@export var node: CanvasItem

func _on_state_entered() -> void:
	node.visible = true

func _on_state_exited() -> void:
	node.visible = false
@tool
extends EditorPlugin

const EventEditorInspector = preload("res://addons/enhanced_state_chart/scripts/editor/event_editor_inspector.gd")
var event_editor_inspector: EditorInspectorPlugin

func _enter_tree():
	event_editor_inspector = EventEditorInspector.new()
	add_inspector_plugin(event_editor_inspector)

func _exit_tree():
	remove_inspector_plugin(event_editor_inspector)

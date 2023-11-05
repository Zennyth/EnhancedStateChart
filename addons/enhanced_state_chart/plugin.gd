@tool
extends EditorPlugin

const EventEditorInspector = preload("res://addons/enhanced_state_chart/scripts/editor/event_editor_inspector.gd")
var event_editor_inspector: EditorInspectorPlugin

var xstate_import_plugin: EditorImportPlugin
const XStateEditorInspector = preload("res://addons/enhanced_state_chart/scripts/editor/xstate/export_xstate.gd")
var xstate_editor_inspector = XStateEditorInspector

func _enter_tree():
	event_editor_inspector = EventEditorInspector.new()
	add_inspector_plugin(event_editor_inspector)

	xstate_import_plugin = preload("res://addons/enhanced_state_chart/scripts/editor/xstate/import_xstate.gd").new()
	add_import_plugin(xstate_import_plugin)
	xstate_editor_inspector = XStateEditorInspector.new()
	add_inspector_plugin(xstate_editor_inspector)

func _exit_tree():
	remove_import_plugin(xstate_import_plugin)
	remove_inspector_plugin(event_editor_inspector)
	remove_inspector_plugin(xstate_editor_inspector)

@tool
extends Window

const ICON: Texture2D = preload("res://addons/enhanced_state_chart/icons/transitions/events/signal.png")

@export var generate: bool = false:
	set = set_generate

@onready var tree: Tree = $Panel/Tree
@onready var button: Button = $Panel/Button

var selected_node: Node

signal signal_picked(signal_name: String, node: Node)


func initialize(target: Node) -> void:
	selected_node = target



func set_generate(value) -> void:
	var main_item := tree.create_item()
	main_item.set_text(0, selected_node.name)

	for property in selected_node.get_signal_list():
		var item := tree.create_item(main_item)
		var args: Array = property.args.map(func(arg: Dictionary): return "%s: %s" % [arg["name"], arg["hint_string"]] if arg["hint_string"] != "" else arg["name"])
		var function_definition: String = "%s(%s)" % [property.name, ",".join(args)]

		item.set_text(0, function_definition)
		item.set_icon(0, ICON)
		item.set_meta("signal_name", property.name)


func _ready() -> void:
	tree.item_selected.connect(_on_item_selected)
	tree.empty_clicked.connect(_on_empty_clicked)
	generate = true
	button.disabled = true
	button.pressed.connect(_on_pressed)
	close_requested.connect(close)


func close() -> void:
	hide()


func _on_pressed() -> void:
	var selected_item := tree.get_selected()

	if !selected_item.has_meta("signal_name"):
		return 
	
	signal_picked.emit(selected_item.get_meta("signal_name"), selected_node)

func _on_empty_clicked() -> void:
	button.disabled = true

func _on_item_selected() -> void:
	var selected_item := tree.get_selected()
	button.disabled = !selected_item.has_meta("signal_name")

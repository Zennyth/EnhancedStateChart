@tool
extends EditorImportPlugin

enum Presets {
    DEFAULT
}

func _get_importer_name() -> String:
    return "xstate"

func _get_visible_name() -> String:
    return "xstate"

func _get_import_name() -> String:
    return "xstate"

func _get_recognized_extensions() -> PackedStringArray:
    return ["json"]

func _get_save_extension() -> String:
    return "tscn"

func _get_resource_type() -> String:
    return "PackedScene"

func _get_priority() -> float:
    return 1.0

func _get_preset_count() -> int: 
    return Presets.size()

func _get_preset_name(preset_index: int) -> String:
    match preset_index:
        Presets.DEFAULT:
            return "Default"
        _:
            return "Unknown"

func _get_import_options(path: String, preset_index: int) -> Array:
    match  preset_index:
        Presets.DEFAULT:
            return [{
                "name": "use_xstate",
                "default_value": false
            }]
        _:
            return []

func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> int:
    var file = FileAccess.open(source_file, FileAccess.READ)

    if file == null:
        return FileAccess.get_open_error()
    
    var content: String = file.get_as_text()
    var xstate_chart: Dictionary = _parse_json(content)
    
    var state_chart: EState = _convert(xstate_chart)
    for state in state_chart.get_children():
        _sync_ownership(state, state_chart)

    var filename: String = "%s.%s" % [save_path, _get_save_extension()]
    
    var scene: PackedScene = PackedScene.new()
    scene.pack(state_chart)
    return ResourceSaver.save(scene, filename) 





###
# PARSING
###
func _parse_json(content: String) -> Dictionary:
    var json = JSON.new()
    return json.parse_string(content)

###
# CONVERSION
### 
func _convert(xstate_chart: Dictionary) -> EState:
    var state_chart: EState = _convert_state(xstate_chart)

    if xstate_chart.has("id"):
        state_chart.name = xstate_chart.id
    
    _sync_transitions(state_chart)
    
    return state_chart 


func _convert_state(xstate: Dictionary) -> EState:
    var state: EState = _convert_parallel_state(xstate)

    if state == null:
        state = _convert_compound_state(xstate)
    
    if state == null:
        state = _convert_atomic_state(xstate)
    
    for transition in _convert_transitions(xstate):
        state.add_child(transition)
    
    return state

func _convert_parallel_state(xstate: Dictionary) -> EParrallelState:
    if not xstate.has("type") or xstate.type != "parallel" or not xstate.has("states"):
        return null
    
    var state: EParrallelState = EParrallelState.new()

    for child_name in xstate.states.keys():
        var child: Dictionary = xstate.states[child_name]
        var child_state: EState = _convert_state(child)
        child_state.name = child_name
        state.add_child(child_state)

    return state

func _convert_compound_state(xstate: Dictionary) -> ECompoundState:
    if not xstate.has("states") or not xstate.has("initial"):
        return null
    
    var state: ECompoundState = ECompoundState.new()

    for child_name in xstate.states.keys():
        var child: Dictionary = xstate.states[child_name]
        var child_state: EState = _convert_state(child)
        child_state.name = child_name
        state.add_child(child_state)

        if xstate.initial == child_name:
            state.initial_state_path = state.get_path_to(child_state)
    
    return state

func _convert_atomic_state(xstate: Dictionary) -> EAtomicState:
    var state: EAtomicState = EAtomicState.new()
    return state

###
# TRANSITIONS
###
func _convert_transitions(xstate: Dictionary) -> Array[ETransition]:
    if not xstate.has("on"):
        return []
    
    var transitions: Array[ETransition] = []

    for transition_name in xstate.on.keys():
        transitions.append_array(_convert_transition(transition_name, xstate.on[transition_name]))
    
    return transitions

func _convert_transition(transition_name: String, xtransition: Variant) -> Array[ETransition]:
    if xtransition is String:
        var transition: ETransition = ETransition.new()
        transition.name = transition_name
        transition.set_meta("target", xtransition)
        return [transition]
    
    if xtransition is Dictionary:
        var transition: ETransition = ETransition.new()
        transition.name = transition_name
        transition.set_meta("target", xtransition.target)
        return [transition]
    
    if xtransition is Array:
        var transitions: Array[ETransition] = []

        for _xtransition in xtransition:
            transitions.append_array(_convert_transition(str(len(transitions)), _xtransition))
        
        return transitions

    return []
    
func _sync_transitions(state_chart: EState) -> void:
    for transition in NodeUtils.find_nodes(state_chart, ETransition): 
        var target: EState = state_chart.find_child(transition.get_meta("target"), true, false)
        transition.to_path = transition.get_path_to(target)


###
# OWNERSHIP
###
func _sync_ownership(node: Node, owner: Node) -> void:
    node.owner = owner

    for child in node.get_children():
        _sync_ownership(child, owner)
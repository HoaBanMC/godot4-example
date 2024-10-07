extends Node

# callback from parent iframe game
var _postmessage_callback = JavaScriptBridge.create_callback(_on_postmessage_callback)

signal data_from_angular(data)

func _init() -> void:
	if check_is_web_platform():
		var window = JavaScriptBridge.get_interface("window")
		window.addEventListener("message", _postmessage_callback)

func _on_postmessage_callback(args) -> void:
	var data_angular = args[0].data.value
	if(data_angular):
		data_from_angular.emit(data_angular)

# postmessage to parent iframe
func _on_postmessage_to_angular(action) -> void:
	if check_is_web_platform():
		print(JSON.stringify(action))
		JavaScriptBridge.eval("window.parent.postMessage(%s, '*');" % JSON.stringify(action))

func check_is_web_platform() -> bool:
	if OS.has_feature("web") or OS.has_feature("web_ios") or OS.has_feature("web_android"):
		return true
		
	return false

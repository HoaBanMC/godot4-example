extends Node

@onready var tree_postion: Marker2D = $TreePos
@onready var tree_sprite: AnimatedSprite2D = $TreePos/TreeSprite
@onready var animation_player: AnimationPlayer = $TreePos/AnimationPlayer
@onready var texture_progress_bar: TextureProgressBar = $TreePos/Control/TextureProgressBar
@export var label_score_click: PackedScene

# for debugs
@onready var score_label: Label = $Debug/Text/ScoreLabel

# enum 
var data_web = {
	"value": 0, 
	"treeId": 1,
	"init": true
}

var list_trees = {
	1:'Tomato',
	2:'Bean',
	3:'Potato',
	4:'Pumpkin',
	5:'Strawberry',
	6:'Apple'
}

# variables
var score: int = 0
var current_tree_name = "Apple"
var current_tree
var can_change_value = true
var current_value = 0
var current_sound_effect = 0
var can_click_score = true

var left_selected = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	tree_postion.position = Vector2(viewport_size.x/2, viewport_size.y/2)
	
	$TreePos/TapArea.visible = true
	
	var _error_signal = Global.data_from_angular.connect(_on_passing_data_angular)
	var _error_has_up = tree_sprite.has_up.connect(_on_has_up)
	
	if Global.check_is_web_platform():
		print("web")
	else:
		print(OS.get_name())
	
	
func _on_has_up(_value):
	can_click_score = _value
	print(_value)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			left_selected = false


func _on_passing_data_angular(data):
	print(data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if Global.check_is_web_platform():
		var data = {
			"action": "openModal",
			"message": "open modal from Godot"
		}
		Global._on_postmessage_to_angular(data)
		
		
func change_value_score(_score) -> void:
	if !can_click_score or score >= 1000:
		return
		
	score += _score
	score_label.text = "Score: " + str(score)
	texture_progress_bar.value = score
	tree_sprite.on_play_anim(score)
		
		
func _on_up_button_pressed() -> void:
	change_value_score(10)


func _on_down_button_pressed() -> void:
	change_value_score(-10)


func _on_reset_button_pressed() -> void:
	score = 0.0
	score_label.text = "Score: " + str(score)
	
	tree_sprite.play_idle(score)
	change_value_score(0)
	

func _on_tap_area_input_event(_viewport: Node, _event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_click") and !left_selected and can_click_score:
		left_selected = true
		animation_player.play("tap_cycle")
		var _score_click = label_score_click.instantiate()
		_score_click.set_score(1)
		add_child(_score_click)
		_score_click.set_position(_event.position)
		change_value_score(1)

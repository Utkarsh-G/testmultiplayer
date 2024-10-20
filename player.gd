extends Node2D

@onready var player = $Sprite2D
var speed = 100

# @rpc("call_local","any_peer","unreliable")
func move_player(position: Vector2):
	player.position = position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('name of new player:'+name)
	$MultiplayerSynchronizer.set_multiplayer_authority(name.to_int())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		var input_vector = Vector2(
			Input.get_action_strength('ui_right') - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)
		if input_vector != Vector2.ZERO:
			var new_position = player.position + input_vector * speed * delta
			move_player(new_position)  # Broadcast to all peers

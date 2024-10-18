extends Node2D

@onready var player_scene = preload("res://player.tscn")
var server = ENetMultiplayerPeer.new()
	
# Yes, I do want this to only be issued by server, not clients.
# also issue to self, hence call_local
# and it needs to be reliable, hence TCP
@rpc("call_local","authority","reliable")
func spawn_player(peer_id: int):
	var player = player_scene.instantiate()
	print('peer id:' + str(peer_id))
	player.name = str(peer_id)
	print('player name set:' + player.name)
	add_child(player)
	if peer_id == 1:
		var sprite = player.get_node('Sprite2D')
		sprite.modulate = Color(1, 0.5, 0.5, 1)  # Light red tint
	print("Spawned player 1 for peer:", peer_id)
	print('num children:' + str(get_child_count()))
	#else:

	

func start_server():
	server.create_server(12345)  # Host authorityserver on port 12345
	multiplayer.multiplayer_peer = server
	print("Server started")
	print(multiplayer.get_peers())
	spawn_player(multiplayer.get_unique_id())

func connect_to_server():
	server.create_client("127.0.0.1", 12345)  # Connect to localhost
	multiplayer.multiplayer_peer = server
	print("Connected as client")
	print(multiplayer.get_peers())
	spawn_player(multiplayer.get_unique_id())

func _on_peer_connected(id):
	print("Peer connected:", id)
	spawn_player(id)

func _on_peer_disconnected(id):
	print("Peer disconnected:", id)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# How signals are connected via code.
	# For signal from a sub node, we'd
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print('Pressed Enter')
		start_server()  # Press Enter to start server
	elif Input.is_action_just_pressed("ui_cancel"):
		connect_to_server()

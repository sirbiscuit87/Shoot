extends Node
var Utils = load("res://Scripts/utils/Utils.gd")
var PlayerActor = load("res://Scripts/Multiplayer/PlayerActor.gd")

const SERVER_IP_ADDRESS = "127.0.0.1"
const PORT = 32169

var player_id
var players = {}

func _ready():
	var client = ENetMultiplayerPeer.new()
	client.create_client(SERVER_IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = client
	multiplayer.peer_connected.connect(_on_player_connected)
	print("Running.")

func _on_player_connected(id: int):
	player_id = multiplayer.get_unique_id()

func update_position(position: Vector2, head_rotation: float, body_rotation: float):
	if multiplayer.get_peers().has(1):
		rpc_id(1, "server_update_player_position", player_id, position, head_rotation, body_rotation)
	else:
		print("Client not connected yet")

@rpc
func client_update_player_position(player: Dictionary):
	var player_actor = PlayerActor.new()
	Utils.dict_to_obj(player_actor, player)
	players[player_actor.peer_id] = player_actor

# yes, you need to have the function defined in both the client and the server
# yes, i agree this is retarded
# just think of everything below this as being like a template for the server, akin to a C++ header file
@rpc
func server_update_player_position(_player_id: int, _position: Vector2, _rotation: float): pass
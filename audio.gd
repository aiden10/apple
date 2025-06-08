extends Node

const coin = preload("res://assets/coin.wav")

var audio_players: Array[AudioStreamPlayer] = []
var sound_level: float = 100.0
const POOL_SIZE = 4

func _ready() -> void:
	for i in POOL_SIZE:
		var player = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

	GameSignals.coin_pickup.connect(func(): play_sound(coin))
	
func set_master_volume() -> void:
	var normalized_volume = _get_normalized_volume(sound_level)
	for player in audio_players:
		player.volume_db = normalized_volume

func _get_normalized_volume(slider_value: float) -> float:
	var normalized = slider_value / 100.0
	var curved_volume = pow(normalized, 2)  # Quadratic curve    
	var volume_db = linear_to_db(curved_volume)
	return min(volume_db, 0.0)

func play_sound(sound: AudioStream, volume_adjustment: float = 0.0) -> void:
	var player = _get_available_player()
	if player:
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		player.stream = sound
		player.volume_db = _get_normalized_volume(sound_level + volume_adjustment)
		player.play()

func _get_available_player() -> AudioStreamPlayer:
	for player in audio_players:
		if not player.playing:
			return player
	return null
	

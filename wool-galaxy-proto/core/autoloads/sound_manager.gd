# sound_manager.gd

extends Node

#region Constants

const BGM_PATH: String = "res://assets/audio/bgm/%s.mp3"

const BGM_FADE_DURATION: float = 0.5
const BGM_VOLUME: float = 0.5

#endregion

#region Variables

var _bgm_player: AudioStreamPlayer
var _current_bgm: String = ""
var _bgm_tween: Tween
var _bgm_volume_db: float = linear_to_db(BGM_VOLUME)

#endregion

#region Lifecycle

func _ready() -> void:
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "Bgm"
	add_child(_bgm_player)

#endregion

#region Methods

func play_bgm(bgm_name: String, fade_in: bool = false) -> void:
	if _current_bgm == bgm_name and _bgm_player.playing:
		return

	_kill_bgm_tween()

	if _bgm_player.playing:
		_bgm_tween = create_tween()
		_bgm_tween.tween_property(_bgm_player, "volume_db", -80.0, BGM_FADE_DURATION)
		_bgm_tween.tween_callback(_bgm_player.stop)
		_bgm_tween.tween_callback(func(): _start_bgm(bgm_name, true))
		return

	_start_bgm(bgm_name, fade_in)

func stop_bgm(fade_out: bool = false) -> void:
	if not _bgm_player.playing:
		return

	_kill_bgm_tween()

	if fade_out:
		_bgm_tween = create_tween()
		_bgm_tween.tween_property(_bgm_player, "volume_db", -80.0, BGM_FADE_DURATION)
		_bgm_tween.tween_callback(_bgm_player.stop)
		_bgm_tween.tween_callback(func(): _current_bgm = "")
	else:
		_bgm_player.stop()
		_current_bgm = ""

	LogManager.info("stop_bgm", "SoundManager")

func _start_bgm(bgm_name: String, fade_in: bool) -> void:
	var path := BGM_PATH % bgm_name
	var stream := load(path) as AudioStream
	if stream == null:
		LogManager.error("BGM not found: %s" % path, "SoundManager")
		return

	_bgm_player.stream = stream
	_bgm_player.stream.loop = true
	_current_bgm = bgm_name

	if fade_in:
		_bgm_player.volume_db = -80.0
		_bgm_player.play()
		_bgm_tween = create_tween()
		_bgm_tween.tween_property(_bgm_player, "volume_db", _bgm_volume_db, BGM_FADE_DURATION)
	else:
		_bgm_player.volume_db = _bgm_volume_db
		_bgm_player.play()

	LogManager.info("play_bgm: %s" % bgm_name, "SoundManager")

func _kill_bgm_tween() -> void:
	if _bgm_tween and _bgm_tween.is_running():
		_bgm_tween.kill()
		_bgm_tween = null

#endregion
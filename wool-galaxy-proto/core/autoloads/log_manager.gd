# log_manager.gd
extends Node

#region Enums

enum LogLevel {
	DEBUG,
	INFO,
	WARNING,
	ERROR,
}

#endregion

#region Variables

var log_enabled := true
var min_log_level: LogLevel = LogLevel.DEBUG

#endregion

#region Lifecycle

func _ready() -> void:
	# 릴리즈 빌드에서는 로그 비활성화
	if OS.has_feature("release"):
		log_enabled = false

#endregion

#region Methods

func debug(message: String, context: String = "") -> void:
	_log(LogLevel.DEBUG, message, context)

func info(message: String, context: String = "") -> void:
	_log(LogLevel.INFO, message, context)

func warning(message: String, context: String = "") -> void:
	_log(LogLevel.WARNING, message, context)

func error(message: String, context: String = "") -> void:
	_log(LogLevel.ERROR, message, context)

func _log(level: LogLevel, message: String, context: String) -> void:
	if not log_enabled:
		return
	if level < min_log_level:
		return
	
	var level_str: String = LogLevel.keys()[level]
	var prefix := "[%s]" % level_str
	if context != "":
		prefix += "[%s]" % context
	
	print("%s %s" % [prefix, message])

#endregion

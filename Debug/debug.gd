## Global debug manager for registering sessions, handling outputs, and routing log messages.
##
## This script is intended to be added as an autoload (singleton) named [Debug].
## It acts as the central hub of the debugging system:
## [br]
## - Manages [DebugSession] instances for different systems or users.
## [br]
## - Routes messages to installed [IDebugOutput] implementations (e.g. [ConsoleDebugOutput]).
## [br]
## - Enforces logging policies and minimum priority thresholds via [DebugSettings].
## [br]
## Usage: [br]
## You should not normally call logging functions on [Debug] directly.
## Instead, create and use [DebugSession] objects.
## [br]
## Register a session (recommended):
## [codeblock]
## var session := Debug.register("PlayerSystem", "PLAYER")
## session.info("Player spawned")
## session.warning("Low health detected", ["combat"])
## [/codeblock]
##
## Global/system logs: [br]
## It is possible to call directly through [Debug], but this is not recommended.
##
## Autoload: [br]
## Add this script as a singleton named [Debug] for global access.
extends Node

## Reference to the debug settings resource.
var settings: DebugSettings

## All registered debug sessions.
var sessions: Dictionary[StringName, DebugSession] = {}

## All active outputs (e.g. console, file, etc.).
var outputs: Array[IDebugOutput] = []


## Logging priority levels.
enum Priority { DEBUG, INFO, SYSTEM_INFO, WARNING, ERROR, CRITICAL }

## Text representation of priorities.
var priority_texts: Dictionary[Priority, StringName] = {
    Priority.DEBUG: "DEBUG",
    Priority.INFO: "INFO",
    Priority.SYSTEM_INFO: "SYSTEM INFO",
    Priority.WARNING: "WARNING",
    Priority.ERROR: "ERROR",
    Priority.CRITICAL: "CRITICAL",
}

## Default colors for each priority level.
const priority_colors: Dictionary[Priority, StringName] = {
    Priority.DEBUG: "gray",
    Priority.INFO: "white",
    Priority.SYSTEM_INFO: "light_pink",
    Priority.WARNING: "yellow",
    Priority.ERROR: "orange",
    Priority.CRITICAL: "red",
}


## Registers a new [DebugSession] for a given user.
## [br] [br]
## [param _user_name] Unique identifier for the system or user (e.g. `"AI"`, `"UI"`). [br]
## [param _prefix] Short label used in logs to identify the session. [br]
## [param _default_color] Text color for the session’s user name (BBCode color string). [br]
## [br]
## returns A [DebugSession] instance. If already registered, returns the existing one.
func register(_user_name: StringName, _prefix: String, _default_color: String = "white") -> DebugSession:
    if _user_name in sessions:
        return sessions.get(_user_name)

    var session := DebugSession.new(_user_name, _prefix, _default_color)
    sessions[_user_name] = session
    return session


## Registers a new debug output channel.
## [br] [br]
## [param debug_output] An implementation of [IDebugOutput].
func register_output(debug_output: IDebugOutput) -> void:
    outputs.append(debug_output)


## Internal logging implementation. Not used directly — call helpers like [method debug] or [method warning].
## [br] [br]
## [param msg] The message to log. [br]
## [param tags] Optional tags for filtering or categorization. [br]
## [param debug_session] The originating session. [br]
## [param priority] The priority level (see [enum Priority]). [br]
func _log(msg: String, tags: Array[String] = [], debug_session: DebugSession = null, priority: Priority = Priority.DEBUG) -> void:
    if not debug_session or not settings or (settings and not settings.is_allowed_to_log(debug_session.user_name)):
        return
    if priority < settings.min_priority:
        return

    var priority_text : StringName = priority_texts.get(priority)
    var priority_color : StringName = priority_colors.get(priority)
    var date := Time.get_datetime_string_from_system()

    var tags_string: String = "" if tags.is_empty() else "[" + ", ".join(tags) + "]"

    # Fixed-width formatting for readability
    var date_field: String = date.rpad(20)
    var priority_field: String = priority_text.rpad(12)
    var user_field: String = debug_session.user_name.rpad(10)
    var prefix_field: String = debug_session.prefix.rpad(12)

    var msg_string := "[color=gray]%s[/color] [color=%s][%s][/color] [color=%s]%s[/color] (%s): %s %s" % [
        date_field,
        priority_color,
        priority_field,
        debug_session.default_color,
        user_field,
        prefix_field,
        msg,
        tags_string,
    ]

    for output in outputs:
        output.log(msg_string)


## Logs a DEBUG priority message.
func debug(msg: String, tags: Array[String] = [], debug_session: DebugSession = null) -> void:
    _log(msg, tags, debug_session, Priority.DEBUG)

## Logs an INFO priority message.
func info(msg: String, tags: Array[String] = [], debug_session: DebugSession = null) -> void:
    _log(msg, tags, debug_session, Priority.INFO)

## Logs a SYSTEM_INFO priority message.
func system_info(msg: String, tags: Array[String] = [], debug_session: DebugSession = null) -> void:
    _log(msg, tags, debug_session, Priority.SYSTEM_INFO)

## Logs a WARNING priority message.
func warning(msg: String, tags: Array[String] = [], debug_session: DebugSession = null) -> void:
    _log(msg, tags, debug_session, Priority.WARNING)

## Logs an ERROR priority message.
func error(msg: String, tags: Array[String] = [], debug_session: DebugSession = null) -> void:
    _log(msg, tags, debug_session, Priority.ERROR)

## Logs a CRITICAL priority message.
func critical(msg: String, tags: Array[String] = [], debug_session: DebugSession = null) -> void:
    _log(msg, tags, debug_session, Priority.CRITICAL)


## Initializes the debug system on startup.
## [br]
## Loads settings from [GameResources], and installs enabled outputs (e.g. console).
func _ready() -> void:
    if GameResources.has_resource("debug_settings"):
        settings = GameResources.get_resource("debug_settings")

    var output_alias: Dictionary = {
        # output_name -> output class
        "console": ConsoleDebugOutput,
    }

    for output_alias_name in output_alias:
        if not settings.is_output_installed(output_alias_name):
            continue

        var output : IDebugOutput = output_alias.get(output_alias_name).new()
        register_output(output)

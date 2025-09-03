class_name DebugSession
extends RefCounted

## Represents a logging session tied to a specific user or system.
## 
## A DebugSession acts as a facade to the [Debug] autoload, 
## allowing you to emit log messages with a consistent user name, 
## prefix, and default color.
## [br]
## Do not instantiate this class directly. 
## Instead, obtain an instance through [method Debug.register]  
## which ensures proper tracking.
## [br]
## Usage:
## [codeblock]
## var session := Debug.register("Inventory")
## session.info("Inventory system initialized.")
## session.warning("Low item stack detected.", ["items", "inventory"])
## [/codeblock]


## Name of the user or system that owns this session.
var user_name: StringName

## Text prefix added to each message emitted by this session.
var prefix: String

## Default color name for messages (e.g. "white", "red", "yellow").
var default_color: String


## Constructs a new DebugSession.
##
## @param _user_name Identifier for the session (e.g. "AI", "Inventory").
## @param _prefix Prefix string shown before every log message.
## @param _default_color Default text color for this session (defaults to "white").
func _init(_user_name: StringName, _prefix: String, _default_color: String = "white") -> void:
    user_name = _user_name
    prefix = _prefix
    default_color = _default_color


## Emits a debug-level message. For general development logs.
func debug(msg: String, tags: Array[String] = []) -> void:
    Debug.debug(msg, tags, self)

## Emits an informational message. Use for normal activity reports.
func info(msg: String, tags: Array[String] = []) -> void:
    Debug.info(msg, tags, self)

## Emits a system-level informational message.
## Useful for lifecycle or global state updates.
func system_info(msg: String, tags: Array[String] = []) -> void:
    Debug.system_info(msg, tags, self)

## Emits a warning message. Indicates a non-critical issue.
func warning(msg: String, tags: Array[String] = []) -> void:
    Debug.warning(msg, tags, self)

## Emits an error message. Indicates a failure in a feature or action.
func error(msg: String, tags: Array[String] = []) -> void:
    Debug.error(msg, tags, self)

## Emits a critical-level message. Use for unrecoverable failures.
func critical(msg: String, tags: Array[String] = []) -> void:
    Debug.critical(msg, tags, self)

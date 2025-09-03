## Configuration resource for the debugging system.
##
## This resource defines which sessions are allowed to log, the minimum priority
## level for messages, and which debug outputs are currently active.
## [br]
## It is typically loaded by the [Debug] autoload to enforce global settings.
## [br]
## Properties:
## [br]
## - [member min_priority]: The minimum priority level required for a message
##   to be logged. Messages below this priority are ignored.
## [br]
## - [member session_policy]: Dictionary that maps session names to booleans.
##   A value of `true` means the session is allowed to log, `false` means it is
##   silenced. If a session is not found, it defaults to `false`.
## [br]
## - [member outputs_installed]: List of output targets currently installed.
##   Each output is identified by its registered name (e.g. `"ConsoleOutput"`).
## [br]
## Usage:
## [codeblock]
## var settings := DebugSettings.new()
## settings.min_priority = Debug.Priority.WARNING
## settings.session_policy = {"Gameplay": true, "UI": false}
## settings.outputs_installed = ["ConsoleOutput", "FileOutput"]
## [/codeblock]
class_name DebugSettings
extends Resource

## The minimum priority a message must have to be logged.
@export var min_priority: Debug.Priority = Debug.Priority.DEBUG

## Dictionary of session names mapped to their logging permission.
## Example: {"Gameplay": true, "UI": false}.
@export var session_policy: Dictionary[StringName, bool]

## Names of installed output targets.
@export var outputs_installed: Array[StringName] = []


## Returns whether the given session is allowed to log messages.
##
## @param _session_name The name of the debug session.
## @return `true` if logging is permitted, `false` otherwise.
func is_allowed_to_log(_session_name: StringName) -> bool:
    return session_policy.get(_session_name, false)


## Returns whether the given output is currently installed.
##
## @param _output_name The name of the debug output target.
## @return `true` if installed, `false` otherwise.
func is_output_installed(_output_name: StringName) -> bool:
    return outputs_installed.has(_output_name)

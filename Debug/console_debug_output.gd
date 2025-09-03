## A debug output implementation that writes messages to the Godot console.
##
## This class extends [IDebugOutput] and provides a simple output channel
## that uses [method print_rich] to display formatted messages directly
## in the Godot editor or terminal output.
##
## Typically, this is one of the default outputs installed by the [Debug] autoload.
## [br]
## Usage:
## [codeblock]
## var output := ConsoleDebugOutput.new()
## output.log("[color=yellow]Warning:[/color] Something happened")
## [/codeblock]
##
## Output (in console):
## [br]
## [color=yellow]Warning:[/color] Something happened
class_name ConsoleDebugOutput
extends IDebugOutput

## Logs a message to the console.
##
## @param msg The formatted string to display. Can include BBCode-style
## rich text tags (e.g. `[color=red]Error[/color]`).
func log(msg: String) -> void:
    print_rich(msg)

## Interface for custom debug output targets.
##
## Implement this class to define how debug messages are displayed or stored.
## For example, you might write an implementation that prints to the console,
## writes to a file, or renders messages inside the game UI.
## [br]
## This class is not meant to be instantiated directly. Instead, extend it
## and override [method log] with your own output logic.
## [br]
## Usage:
## [codeblock]
## class_name FileDebugOutput
## extends IDebugOutput
##
## func log(_msg: String) -> void:
##     var file := FileAccess.open("user://debug.log", FileAccess.WRITE_READ)
##     file.store_line(_msg)
##     file.close()
## [/codeblock]
class_name IDebugOutput
extends RefCounted

## Called when a debug message should be output.
##
## @param _msg The formatted message string to be written or displayed.
func log(_msg: String) -> void:
    pass

# Flaregazer Games - Debug System

**Part of the Flaregazer Games Toolbox**

---

## Overview

The **Flaregazer Games Debug System** is a structured, session-based logging framework for Godot 4.x projects. It provides a centralized and extensible logging pipeline, enabling developers to track runtime events, monitor systems, and debug efficiently without losing clarity or context. 

Designed to improve on the limitations of Godot's built-in logging methods (`print()`, `push_warning()`, `push_error()`), this system is suitable for both solo developer projects and small studio workflows.

---

## Problems Addressed

In larger or more complex Godot projects, standard logging practices can introduce the following challenges:

1. **Inconsistent Message Formatting**  
   - Messages from different systems lack a standard format, making logs hard to read and parse.

2. **No Centralized Management**  
   - Each subsystem manages its own logging independently, requiring manual tagging, timestamping, and color-coding.

3. **Limited Output Flexibility**  
   - Native logging is restricted to the console and warning/error panels. Exporting logs to files, networks, or custom panels requires ad-hoc solutions.

4. **No Session Awareness**  
   - Logs cannot be easily grouped by subsystem or developer, which complicates debugging in multi-module projects.

5. **No Priority Filtering**  
   - Debug, info, warning, and critical messages are not distinguished natively, causing important logs to be lost in the noise.

6. **Manual Tagging**  
   - Categorization and filtering of messages must be done manually by embedding tags in strings.

---

## Scope

The **Debug System** provides:

- Structured, color-coded log messages with timestamps, session prefixes, and priority levels.
- Session management for subsystems or developer-specific logging.
- Priority-based filtering to prevent low-priority messages from cluttering output.
- Extensible output channels via the `IDebugOutput` interface (console, file, editor panels, etc.).
- Tagging support for better categorization and filtering.
- Centralized configuration through `DebugSettings`, controlling allowed sessions, outputs, and minimum priorities.

This system is designed primarily for:

- Medium-sized solo projects requiring organized logs.
- Small studios managing multiple developers and subsystems.
- Teams or individuals needing maintainable, readable, and extensible logging.

It is **not intended** for production telemetry or advanced analytics pipelines.

---

## How the System Solves the Problems

| Problem | Solution Provided by Debug System |
|---------|---------------------------------|
| Inconsistent Formatting | Automatic BBCode color-coding, timestamps, session prefixes, and aligned message fields. |
| No Centralized Management | Singleton `Debug` handles session registration, message routing, and output dispatching. |
| Limited Output Flexibility | Multiple outputs can be registered and extended through `IDebugOutput`. |
| No Session Awareness | `DebugSession` provides a facade per subsystem or developer with dedicated logging functions. |
| No Priority Filtering | Messages include six priority levels (`DEBUG`, `INFO`, `SYSTEM_INFO`, `WARNING`, `ERROR`, `CRITICAL`) with customizable minimum thresholds. |
| Manual Tagging | Messages can include arrays of tags, allowing filtering and organization programmatically. |

---

## Components

1. **DebugSession**  
   - Facade for a specific subsystem or developer session.  
   - Encapsulates `user_name`, `prefix`, and `default_color`.  
   - Provides logging functions: `debug`, `info`, `system_info`, `warning`, `error`, `critical`.  

2. **DebugSettings**  
   - Resource containing logging policies: allowed sessions, outputs, and minimum priority levels.  

3. **IDebugOutput**  
   - Interface for custom output channels.  
   - `ConsoleDebugOutput` included by default; additional outputs can be implemented as needed.  

4. **Debug Singleton**  
   - Central hub managing sessions, outputs, and routing of messages.  
   - Handles formatting, priority filtering, and tag handling.  
   - Sessions should be accessed via `Debug.register(_user_name, _prefix)`.

---

## Usage Examples

### Registering a Session
```gdscript
var player_session := Debug.register("PlayerSystem", "PLAYER", "light_blue")
player_session.info("Player spawned")
player_session.warning("Low health detected", ["combat"])

extends Node

func _ready():
    # Register multiple sessions
    var player := Debug.register("PlayerSystem", "PLAYER", "light_blue")
    var enemy := Debug.register("EnemySystem", "ENEMY", "orange")
    var ai := Debug.register("AISystem", "AI", "pink")
    
    var sessions := [player, enemy, ai]

    # Randomized logging loop
    for i in range(1, 20):
        for session in sessions:
            var n := randi() % 6
            match n:
                0:
                    session.debug("Debug message %d" % i, ["loop", session.user_name])
                1:
                    session.info("Info message %d" % i, ["loop"])
                2:
                    session.system_info("System info %d" % i)
                3:
                    session.warning("Warning triggered %d" % i, ["warning"])
                4:
                    session.error("Error encountered %d" % i, ["error", "loop"])
                5:
                    session.critical("Critical event %d" % i, ["critical", session.user_name])
    
    # Conditional test
    if player:
        player.debug("Testing conditional branch: player exists", ["conditional"])
        if enemy:
            player.info("Conditional branch: enemy exists", ["conditional"])
        else:
            player.warning("Conditional branch: enemy missing", ["conditional"])
    
    # Nested tags
    ai.debug("Nested tag example", ["AI", "loop", "nested"])
    
    # Test logging without session (direct Debug call)
    Debug.warning("Global warning, no session", ["global"])
    
    # Final message
    Debug.info("Stress test finished", ["system"])

##0: Comparison Commentary – Debug Facade vs Plain Logging

# 1. Structured Sessions
# Plain print: Each log message requires manual prefixing, coloring, or labeling. Easy to forget, inconsistent, prone to typos.
# Debug system: Each DebugSession has a user_name, prefix, and default color. Automatically formats messages with alignment, colors, and tags.

# 2. Logging Levels
# Plain print: No enforced logging levels. You have to manually prefix messages with "DEBUG", "INFO", "WARNING", etc., or use push_warning()/push_error().
# Debug system: Supports structured priority levels (DEBUG, INFO, SYSTEM_INFO, WARNING, ERROR, CRITICAL) with color coding and threshold filtering. Messages below min_priority are automatically skipped.

# 3. Output Flexibility
# Plain print: Messages go only to the console. push_warning/push_error show warnings/errors in Godot but cannot be redirected easily.
# Debug system: Supports multiple outputs via IDebugOutput (e.g., console, file, network), easily extendable without changing log calls.

# 4. Tagging & Filtering
# Plain print: Tags must be manually embedded in strings; no filtering mechanism exists.
# Debug system: Tags are formalized, can be used for filtering, searching, or categorization across sessions and outputs.

# 5. Consistency & Readability
# Plain print: Alignment, colors, and timestamps must be manually maintained. Messy output if multiple developers log in different styles.
# Debug system: Automatically formats timestamp, session name, prefix, and colors for readability. All logs maintain consistent width and style.

# 6. Conditional Logging
# Plain print: Must manually check conditions for each message.
# Debug system: Conditional logging integrated. Sessions respect the policy in DebugSettings; logs below min_priority or disallowed sessions are automatically ignored.

# 7. Maintenance & Scalability
# Plain print: Adding new systems requires copy-paste of prefixes/colors and manual update of every log.
# Debug system: Adding a new system is one call to Debug.register, and all logs inherit its formatting and policies. Centralized maintenance.

# Conclusion
# Your Debug system provides far superior readability, maintainability, and flexibility. It is safer, more scalable, and far easier to integrate into complex projects. Plain Godot logs are only sufficient for very small, single-developer tests.

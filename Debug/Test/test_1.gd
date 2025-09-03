extends Node

func _ready():
    # Define session "aliases" for color/label simulation
    var sessions := [
        {"user_name": "PlayerSystem", "prefix": "PLAYER", "color": "light_blue"},
        {"user_name": "EnemySystem", "prefix": "ENEMY", "color": "orange"},
        {"user_name": "AISystem", "prefix": "AI", "color": "pink"},
    ]

    # Randomized logging loop
    for i in range(1, 20):
        for session in sessions:
            var n := randi() % 6
            var prefix := "[%s]" % session.prefix
            var user_color = session.color
            match n:
                0:
                    print_rich("[color=%s]%s[/color] DEBUG: Debug message %d [loop, %s]" % [user_color, prefix, i, session.user_name])
                1:
                    print_rich("[color=%s]%s[/color] INFO: Info message %d [loop]" % [user_color, prefix, i])
                2:
                    print_rich("[color=%s]%s[/color] SYSTEM INFO: System info %d" % [user_color, prefix, i])
                3:
                    push_warning("%s WARNING: Warning triggered %d [warning]" % [prefix, i])
                4:
                    push_error("%s ERROR: Error encountered %d [error, loop]" % [prefix, i])
                5:
                    push_error("%s CRITICAL: Critical event %d [critical, %s]" % [prefix, i, session.user_name])

    # Conditional test
    var player = sessions[0]
    var enemy = sessions[1]
    if player:
        print_rich("[color=%s][%s][/color] DEBUG: Testing conditional branch: player exists [conditional]" % [player.color, player.prefix])
        if enemy:
            print_rich("[color=%s][%s][/color] INFO: Conditional branch: enemy exists [conditional]" % [player.color, player.prefix])
        else:
            push_warning("%s WARNING: Conditional branch: enemy missing [conditional]" % player.prefix)

    # Nested tags
    var ai = sessions[2]
    print_rich("[color=%s][%s][/color] DEBUG: Nested tag example [AI, loop, nested]" % [ai.color, ai.prefix])

    # Test global logging (no session)
    push_warning("Global WARNING: no session [global]")
    
    # Final message
    print("INFO: Stress test finished [system]")

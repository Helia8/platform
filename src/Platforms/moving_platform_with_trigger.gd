extends Node2D

@onready var path: Path2D = $PlatformPath
@onready var pathFollow: PathFollow2D = $PlatformPath/PlatformPathFollow
@export var speed: float = 500

@export var idle_time_midpath: float = 5.0
var moving: bool = false
var go_back: bool = false
var time_since_left: float = 0
var player_left = false
func _process(delta: float):
	time_since_left += delta
	if (player_left && time_since_left > idle_time_midpath && not go_back):
		go_back = true
		pass
	pass

func _physics_process(delta: float) -> void:
	if (moving):
		if (player_left and not go_back):
			return
		var direction = 1 if not go_back else -1
		var old_rota = pathFollow.rotation
		var res = speed / 100 * direction
		if pathFollow.progress_ratio + res > 1:
			pathFollow.progress_ratio = 1
		elif pathFollow.progress_ratio + res < 0 :
			pathFollow.progress_ratio = 0
		else :
			pathFollow.progress_ratio += res
		
		pathFollow.rotation = old_rota
	pass
	
func _on_trigger_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		go_back = false
		player_left = false
		moving = true
	pass # Replace with function body.


func _on_trigger_area_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		player_left = true
		time_since_left = 0
	pass # Replace with function body.

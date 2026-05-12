extends CharacterBody2D

@export var wander_time: float = 3.0
var wander_timer = 0
var dir = 1

func _on_ennemy_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		print("player hit ennemy")
		body.hit()
	pass # Replace with function body.

func _ready():
	velocity.x = 1
	
func patrol_wander():
	wander_timer = 0
	dir = (dir + 1) % 2
func random_wander():
		wander_timer = 0
		dir = randi() % 2
func _physics_process(delta: float) -> void:
	wander_timer += delta
	if (wander_timer > wander_time):
		patrol_wander()
	if (dir == 0):
		velocity.x = 100
	else:
		velocity.x = -100
	move_and_slide()
		
	
	

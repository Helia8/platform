extends CharacterBody2D

@export var wander_time: float = 3.0
var wander_timer = 0
var dir = 1
var is_dead = false
@onready var anim: AnimatedSprite2D = $EnnemyArea/EnemyAnim
@onready var hitbox: CollisionShape2D = $EnnemyArea/EnnemyHitbox
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
	
func _update_animation() -> void:
	if not is_dead:
		anim.play("walk")
	else :
		anim.play("death")
	
func random_wander():
	wander_timer = 0
	dir = randi() % 2
		
		
func _physics_process(delta: float) -> void:
	if is_dead:
		_update_animation()
		return
	wander_timer += delta
	if (wander_timer > wander_time):
		patrol_wander()
	if (dir == 0):
		velocity.x = 100
		anim.flip_h = true
	else:
		velocity.x = -100
		anim.flip_h = false
	move_and_slide()
	_update_animation()
		
func _process(delta: float) -> void:
	if is_dead && !anim.is_playing():
		queue_free()
	
	


func _on_ennemy_hurtbox_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		body.add_iseconds(1)
		is_dead = true
		body.make_bounce()
pass # Replace with function body.

extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Animator
var velocity : Vector2
export (int, 0, 200) var push = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	Animator = get_node("AnimationTree")
	Animator.set("parameters/Direction/blend_amount",0)
	Animator.set("parameters/NotIdle/blend_amount",0)

func right(speed = 50):
	Animator.set("parameters/NotIdle/blend_amount",lerp(Animator.get("parameters/NotIdle/blend_amount"),1,0.1))
	velocity.x = lerp(velocity.x,speed,0.1)
	get_node("RotationHandler").scale.x = 1

func left(speed = 50):
	Animator.set("parameters/NotIdle/blend_amount",lerp(Animator.get("parameters/NotIdle/blend_amount"),1,0.1))
	velocity.x = lerp(velocity.x,-speed,0.1)
	get_node("RotationHandler").scale.x = -1


func jump():
	if is_on_floor():
		#velocity.y = -60
		velocity.y = -60
		Animator.set("parameters/Jump/active",true)

func idle(friction = 0.25):
	Animator.set("parameters/NotIdle/blend_amount",0)
	if is_on_floor():
		velocity.x = lerp(velocity.x,0,friction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RotationHandler.rotation = $RayCast2D.get_collision_normal().angle() + PI/2
	velocity.y += 98 * delta
	velocity = move_and_slide(velocity, Vector2.UP,
					false, 4, PI/4, false)
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)

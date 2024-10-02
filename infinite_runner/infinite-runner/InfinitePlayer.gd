extends CharacterBody2D

var SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var jumpSound = get_node("../Sound Effects/Jump")
@onready var crashSound = get_node("../Sound Effects/Crash")

func _ready():
	$AnimatedSprite2D.play("run")

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumpSound.play()

	velocity.x = SPEED
	move_and_slide()

func hit():
	crashSound.play()
	$AnimatedSprite2D.play("crash")
	SPEED = 10
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("run")
	SPEED = 300

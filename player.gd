extends CharacterBody2D


const SPEED = 175.0
const JUMP_VELOCITY = -600.0

var jumps = 0
var isDoubleJump = false
@onready var point_light_2d = $PointLight2D
@onready var timer = $Timer

@onready var sprite_2d = $Sprite2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_just_pressed("jump") and jumps < 1:
			isDoubleJump = true
			velocity.y = JUMP_VELOCITY * 0.75
			jumps = jumps +1
		else:
#			sprite_2d.animation = "jump"
			velocity.y += gravity * delta	
				
	print(timer.time_left)
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumps = 0
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 100)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft	


func _input(event: InputEvent):
	if event.is_action_pressed("down") and is_on_floor():
			position.y +=1



func _on_area_2d_area_entered(area):
	point_light_2d.energy = 0
	timer.stop()
	print(area.get_groups())


func _on_area_2d_area_exited(area):
	point_light_2d.energy = 1
	timer.start()


func _on_timer_timeout():
	get_tree().reload_current_scene()

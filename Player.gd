extends CharacterBody2D
const MAX_SPEED = 1500
var top_speed = 600
const SPEED = 10.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D 

func _physics_process(delta):
	# Add the gravity.
	var current_anim = animated_sprite.animation
	if(velocity.x < 0):
		animated_sprite.flip_h = true
	elif(velocity.x > 0):
		animated_sprite.flip_h = false
	if not is_on_floor():
		velocity.y += gravity * delta
		
		if(velocity.y <= 0):
			if(current_anim != "Jump"):
				animated_sprite.play("Jump")
		else:
			if(current_anim != "Falling"):
				animated_sprite.play("Falling")
	else:
		if(velocity.x == 0):
			if(current_anim != "Idle" and current_anim != "Slide"):
				animated_sprite.play("Idle")
		else: 
			if(abs(velocity.x) > 500):
				top_speed += 10
				if(top_speed > MAX_SPEED):
					top_speed = MAX_SPEED
				if(current_anim != "Dash loop" and current_anim != "Slide"):
					animated_sprite.play("Dash loop")
			else:
				top_speed = 600
				if(current_anim != "Walking"):
					animated_sprite.play("Walking")

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("Down"):
		if current_anim != "Slide":
			animated_sprite.play("Slide")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		print(direction)
		if(abs(velocity.x) > top_speed):
			velocity.x = top_speed*direction
			
		else:
			velocity.x += direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

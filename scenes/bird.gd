extends CharacterBody2D

@export var gravity=9.81
@export var jumpforce=500

func _physics_process(delta):
	if($"..".hasGameStarted):
		velocity.y+=gravity*delta
		move_and_collide(velocity*delta)
	
func _input(event):
	if($"..".hasGameStarted and !$"..".isGameOver):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index==MOUSE_BUTTON_LEFT:
			flap()
	
func flap():
	velocity.y=-jumpforce
	$AnimatedSprite2D.play()
	$"../Fly Audio Stream".play();
	
func reset():
	$AnimatedSprite2D.stop()

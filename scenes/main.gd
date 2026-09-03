extends Node2D

@export var pipe : PackedScene
@export var screensize=Vector2i(864,936)
var groundheight = 0
var pipes : Array
@export var moveSpeed = 50
var isGameOver = false
var hasGameStarted = false
var score = 0

func _ready():
	$CanvasLayer/Panel.visible = false
	groundheight = $Ground.get_node("Sprite2D").texture.get_height()
	
func _process(delta):
	if(!isGameOver and hasGameStarted):
		for pipe in pipes:
			pipe.position.x -= moveSpeed * delta
			
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index==MOUSE_BUTTON_LEFT:
		if(!hasGameStarted):
			hasGameStarted = true;
			$Timer.start()

func _on_timer_timeout():
	var spawnedpipe=pipe.instantiate()
	spawnedpipe.position.x=screensize.x+50
	spawnedpipe.position.y=(screensize.y-groundheight)/2 + randi_range(-150, 150)
	add_child(spawnedpipe)
	spawnedpipe.hit.connect(onpipehit)
	spawnedpipe.scored.connect(onscored)
	pipes.append(spawnedpipe)
	
func onpipehit():
	if(!isGameOver):
		$CanvasLayer/Panel.visible = true
		isGameOver = true;
		$Timer.stop()
		$Bird.reset()
		$"Hit Audio Stream".play()
		$"Die Audio Stream".play()
	
func _on_ground_body_entered(body):
	if(!isGameOver):
		$CanvasLayer/Panel.visible = true
		isGameOver = true;
		$Timer.stop()
		$Bird.reset()
		$"Hit Audio Stream".play()
		$"Die Audio Stream".play()
	
func onscored():
	score+=1
	$"Point Audio Stream".play();
	$"CanvasLayer/SCORE lABEL".text = "Score: " + str(score)
	$CanvasLayer/Panel/score.text = "Score: " + str(score)


func _on_button_pressed():
	get_tree().reload_current_scene()

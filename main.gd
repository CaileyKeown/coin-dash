extends Node

@export var powerup_scene : PackedScene

#MAY NEED TO DELETE
@export var cactus_scene: PackedScene


@export var coin_scene : PackedScene
@export var playtime = 30
var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
	

func _process(delta):
	print(get_tree().get_nodes_in_group("coins").size())
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		
		#CAILEY REVISIT THIS; SHOULD BE ADDED?
		# Set a random wait time for the PowerupTimer
		$PowerupTimer.wait_time = randf_range(1.0, 2.0)
		#ADDED NEXT LINE FOR TESTINNG; DEL LATER
		print("Starting PowerupTimer with wait time:", $PowerupTimer.wait_time)
		$PowerupTimer.start()
		

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	spawn_multiple_cacti(5)

func spawn_coins():
	$LevelSound.play()
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x),
			randi_range(0, screensize.y))
			
			#MAY NEED TO DELETE
func spawn_multiple_cacti(count: int):
	for i in range(count):
		spawn_cactus()  # Call the function to spawn a single cactus

			
			
			
			#TESTINNG MAY NEED TO DELETE
func spawn_cactus():
	if cactus_scene:
		var cactus = cactus_scene.instantiate()
		add_child(cactus)
		cactus.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		print("Cactus spawned at: ", cactus.position)
	else:
		print("Cactus scene not assigned!")

			

func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()
		
func _on_player_hurt():
	game_over()
	

func _on_player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)
	
#func _on_player_pickup():
	#score += 1
	#$HUD.update_score(score)
	
	$CoinSound.play()
	
func game_over():
	
	$EndSound.play()
	
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$HUD.show_game_over()
	$Player.die()
	
func _on_hud_start_game():
	new_game()
	
	$HUD.update_score(score)
	$HUD.update_timer(time_left)


func _on_powerup_timer_timeout():
	#ADDED THE NEXT LINE FOR TESTINNG, REMOVE LATER
	print("Powerup spawned!")
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x),randi_range(0, screensize.y))

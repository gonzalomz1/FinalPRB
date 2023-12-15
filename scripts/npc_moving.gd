extends CharacterBody2D


enum {
	IDLE,
	NEW_DIR,
	MOVE
}
var current_state = IDLE

const SPEED = 25

var dir = Vector2.RIGHT
var start_pos
var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

@onready var up = $chat_detection_area/CollisionShape2D/up
@onready var down = $chat_detection_area/CollisionShape2D/down
@onready var right = $chat_detection_area/CollisionShape2D/right
@onready var left = $chat_detection_area/CollisionShape2D/left

func _ready():
	randomize()
	start_pos = position

func _process(delta):
	if current_state == 0 or current_state == 1 && $chat_detection_area/CollisionShape2D/down.is_colliding():
		$AnimationPlayer.play("idle_down")
	if current_state == 0 or current_state == 1 && $chat_detection_area/CollisionShape2D/up.is_colliding():
		$AnimationPlayer.play("idle_up")
	if current_state == 0 or current_state == 1 && $chat_detection_area/CollisionShape2D/left.is_colliding():
		$AnimationPlayer.play("idle_left")
	if current_state == 0 or current_state == 1 && $chat_detection_area/CollisionShape2D/right.is_colliding():
		$AnimationPlayer.play("idle_right")
	
	elif current_state == 2 and !is_chatting:
		if dir.x == -1:
			$AnimationPlayer.play("walk_left")
		if dir.x == 1:
			$AnimationPlayer.play("walk_right")
		if dir.y == -1:
			$AnimationPlayer.play("walk_up")
		if dir.y == 1:
			$AnimationPlayer.play("walk_down")
	
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
	
	if Input.is_action_just_pressed("action_button"):
		print("chatting with npc")
		$Dialogue.start()
		$Dialogue.visible = true
		is_roaming = false
		is_chatting = true

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += dir * SPEED * delta

func _on_chat_detection_area_body_entered(body):
	if body is Player:
		player = body
		player_in_chat_zone = true
		print(player_in_chat_zone)
	
	if up.is_colliding():
		print("up ray")
		$AnimationPlayer.play("idle_up")
	if down.is_colliding():
		print("down ray")
		$AnimationPlayer.play("idle_down")
	if right.is_colliding():
		print("right ray")
		$AnimationPlayer.play("idle_right")
	if left.is_colliding():
		print("left ray")
		$AnimationPlayer.play("idle_left")

func _on_chat_detection_area_body_exited(body):
	if body is Player:
		player_in_chat_zone = false
		print(player_in_chat_zone)
		$Dialogue.visible = false
		

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])


func _on_dialogue_dialogue_finished():
	$Dialogue.visible = false
	is_chatting = false
	is_roaming = true

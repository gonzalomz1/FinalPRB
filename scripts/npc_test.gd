extends CharacterBody2D

var starting_position: Vector2
@onready var anim_player = $AnimationPlayer

func _ready():
	starting_position = position
	anim_player.play("idle_down")

func _physics_process(delta):
	pass

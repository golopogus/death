extends Node2D

var player_load = preload("res://player.tscn")
var player
var player_death_load = preload("res://player_death.tscn")
var player_death
var dead_load = preload("res://dead_player.tscn")
var dead

func _ready() -> void:
	spawn_player()
	
func die(method):
	$Timer.start()
	spawn_death(method)
	
func spawn_death(method):
	
	## add dead body ##
	player_death = player_death_load.instantiate()
	add_child(player_death)
	player_death.start(player.velocity, player.position, method)
	
	## add ghost ##
	dead = dead_load.instantiate()
	add_child(dead)
	dead.start(player.position)
	
	## remove player ##
	remove_child(player)
	player.queue_free()
	
	
func spawn_player():
	player = player_load.instantiate()
	add_child(player)
	player.start()


func _on_boundary_body_entered(body: Node2D) -> void:
	if body.name == 'player':
		die('')


func _on_timer_timeout() -> void:
	$Timer.stop()
	spawn_player()
	
func remove_ghost(name):
	remove_child(name)
	name.queue_free()
	
	

extends Node

var apple_position: Vector3
var rot_position: Vector3
var player_position: Vector3
var player_velocity: Vector3
var dash_time: float = 0
var dash_speed: int = 300
var rot_speed: float = 0.03
var coins: int = 0

## Stat increments
var speed_inc: float = 0.1
var jump_inc: float = 0.1
var knockback_inc: float = 0.1
var spear_cooldown_inc: float = 0.1
var dash_cooldown_inc: float = 0.1
var dash_dist_inc: float = 0.4
var apple_roll_inc: float = 0.1

## Stats
var speed_stat: int = 0
var jump_stat: int = 0
var knockback_stat: int = 0
var spear_cooldown_stat: int = 0
var dash_cooldown_stat: int = 0
var dash_distance_stat: int = 0
var apple_roll_stat: int = 0

extends Node

var can_climb = false
var are_assembled = false
var ecrous = 0
var isArmsPlayerOnCeiling					# action de se suspendre au plafond
var isLegsPlayerJumping
var directionX								# -1 = à gauche, 1 = à droite
const ARMSPLAYER_OFFSET = Vector2(-4, -18)
const LEGSPLAYER_OFFSET = Vector2(-4, -27)

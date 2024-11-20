extends Node

var can_climb = false
var can_hang = false
var are_assembled = false
var can_change_assembly_state = true
var ecrous
var isArmsPlayerOnCeiling					# action de se suspendre au plafond
var isLegsPlayerJumping
var directionX								# -1 = à gauche, 1 = à droite
var dialogues = JSON.parse_string(FileAccess.get_file_as_string("res://Game/Assets/Dialogue/dialogues.json"))
const ARMSPLAYER_OFFSET = Vector2(-4, -18)
const LEGSPLAYER_OFFSET = Vector2(-4, -27)

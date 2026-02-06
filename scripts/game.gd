extends Node2D

var on_cooldown = false

var playershot = false
var playershield = false
var playerreload = false
var bulletsplayer = 2
var playerHP = 25
#ai vars
var ai_shot = false
var ai_shield = false
var ai_reload = false
var ai_bullets = 2
var AIhp = 25

func _ready() -> void:
	print("I AM RUNNING ON: ", self)
	


func _on_shoot_pressed() -> void:
	if bulletsplayer != 0:
		$AnimatedSprite2D.play("shoot")
		playershot = true
		playershield = false
		playerreload = false
		bulletsplayer -= 1    # FIXED
		print(bulletsplayer)
		ai_choose_action()
		resolve_round()
		start_cooldown()
	else:
		print("no bullets!")

func _on_sheild_pressed() -> void:
	$AnimatedSprite2D.play("shield")
	playershot = false
	playershield = true
	playerreload = false
	ai_choose_action()
	resolve_round()
	start_cooldown()

func _on_reload_pressed() -> void:
	$AnimatedSprite2D.play("reload2")
	playershot = false
	playershield = false
	playerreload = true
	if bulletsplayer < 2:
		bulletsplayer += 1    # FIXED
		ai_choose_action()
		resolve_round()
		start_cooldown()
	else:
		print("max bullets")
	print(bulletsplayer)
# ============================================================
# AI LOGIC (reacts instantly when player chooses)
# ============================================================

func ai_choose_action() -> void:
	var choices = []

	if ai_bullets > 0:
		choices.append("shoot")

	choices.append("shield")

	if ai_bullets < 2:
		choices.append("reload")

	choices.shuffle() # randomize order

	var action = choices[0]
	print("AI chooses:", action)

	match action:
		"shoot":
			ai_shoot()
		"shield":
			ai_shield_action()
		"reload":
			ai_reload_action()

func ai_shoot() -> void:
	$AI/AnimatedSprite2D.play("shoot")
	ai_shot = true
	ai_shield = false
	ai_reload = false
	ai_bullets -= 1
	print("AI bullets:", ai_bullets)

func ai_shield_action() -> void:
	$AI/AnimatedSprite2D.play("shield")
	ai_shot = false
	ai_shield = true
	ai_reload = false

func ai_reload_action() -> void:
	$AI/AnimatedSprite2D.play("reload2")
	ai_shot = false
	ai_shield = false
	ai_reload = true
	if ai_bullets < 2:
		ai_bullets += 1
	print("AI bullets:", ai_bullets)
func resolve_round():
	# Player shoots AI
	if playershot and not ai_shield:
		AIhp -= 5
		print("AI takes 5 damage! HP:", AIhp)

	# AI shoots Player
	if ai_shot and not playershield:
		playerHP -= 5
		print("Player takes 5 damage! HP:", playerHP)

	# Update progress bars
	$PlayerHPA.value = playerHP
	$AIAHP.value = AIhp

	# Reset round states
	playershot = false
	playershield = false
	playerreload = false

	ai_shot = false
	ai_shield = false
	ai_reload = false

	# Check for game over
	if playerHP <= 0:
		print("PLAYER LOSES!")
	if AIhp <= 0:
		print("AI LOSES!")
func start_cooldown():
	on_cooldown = true
	await get_tree().create_timer(3.0).timeout
	on_cooldown = false

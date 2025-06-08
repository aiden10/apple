extends Control

var sprites: Array = []
var time: float = 0.0
var original_positions: Array = []

const SPEED_PRICE: int = 3 
const JUMP_PRICE: int = 3 
const KNOCKBACK_PRICE: int = 3 
const SPEAR_COOLDOWN_PRICE: int = 3 
const DASH_COOLDOWN_PRICE: int = 3 
const DASH_DISTANCE_PRICE: int = 3 
const APPLE_ROLL_COST: int = 3

const GOLD_APPLE_PRICE: int = 10
const GHOST_APPLE_PRICE: int = 10
const ANTIGRAV_APPLE_PRICE: int = 10
const RECURRING_APPLE_PRICE: int = 10

@onready var coin_label: Label = $CoinContainer/HBoxContainer/CoinLabel

func _ready() -> void:
	sprites = $BackgroundContainer.get_children()
	
	for sprite in sprites:
		sprite.modulate.a = 0.85
		original_positions.append(sprite.position)
	
	$Upgrades/Speed/HBoxContainer/SpeedCost.text = str(SPEED_PRICE)
	$Upgrades/Jump/HBoxContainer/JumpCost.text = str(JUMP_PRICE)
	$Upgrades/Knockback/HBoxContainer/KnockbackCost.text = str(KNOCKBACK_PRICE)
	$Upgrades/SpearCooldown/HBoxContainer/SpearCooldownCost.text = str(SPEAR_COOLDOWN_PRICE)
	$Upgrades/DashCooldown/HBoxContainer/DashCooldownCost.text = str(DASH_COOLDOWN_PRICE)
	$Upgrades/DashDistance/HBoxContainer/DashDistCost.text = str(DASH_DISTANCE_PRICE)
	$Upgrades/AppleRoll/HBoxContainer/AppleRollCost.text = str(APPLE_ROLL_COST)
	
	$Apples/Antigrav/HBoxContainer/AntigravCost.text = str(ANTIGRAV_APPLE_PRICE)
	$Apples/Recurring/HBoxContainer/RecurringCost.text = str(RECURRING_APPLE_PRICE)
	$Apples/Ghost/HBoxContainer/GhostCost.text = str(GHOST_APPLE_PRICE)
	$Apples/Gold/HBoxContainer/GoldCost.text = str(GOLD_APPLE_PRICE)
	
	coin_label.text = str(GameState.coins)
	GameSignals.purchase.connect(func(): coin_label.text = str(GameState.coins))
	
	$Upgrades/Speed.gui_input.connect(buy_speed)
	$Upgrades/Jump.gui_input.connect(buy_jump)
	$Upgrades/Knockback.gui_input.connect(buy_knockback)
	$Upgrades/SpearCooldown.gui_input.connect(buy_spear_cooldown)
	$Upgrades/DashCooldown.gui_input.connect(buy_dash_cooldown)
	$Upgrades/DashDistance.gui_input.connect(buy_dash_distance)
	$Upgrades/AppleRoll.gui_input.connect(buy_apple_roll)
	
	$Apples/Antigrav.gui_input.connect(buy_antigrav)
	$Apples/Recurring.gui_input.connect(buy_recurring)
	$Apples/Ghost.gui_input.connect(buy_ghost)
	$Apples/Gold.gui_input.connect(buy_gold)
	
	$MarginContainer/BackButton.pressed.connect(exit_shop)
	$PanelContainer/VBoxContainer/EscapeButton.pressed.connect(escape)
	
func exit_shop() -> void:
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func escape() -> void:
	if GameState.coins >= 100:
		get_tree().paused = false
		visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().change_scene_to_file("res://ending.tscn")
	else:
		invalid_purchase()

func buy_antigrav(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= ANTIGRAV_APPLE_PRICE:
			GameState.apple_variety = "antigrav"
			GameState.coins -= ANTIGRAV_APPLE_PRICE
			GameSignals.purchase.emit()
			GameSignals.antigrav_purchase.emit()
		else:
			invalid_purchase()

func buy_recurring(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= RECURRING_APPLE_PRICE:
			GameState.apple_variety = "recurring"
			GameState.coins -= RECURRING_APPLE_PRICE
			GameSignals.purchase.emit()
			GameSignals.recurring_purchase.emit()
		else:
			invalid_purchase()

func buy_ghost(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= GHOST_APPLE_PRICE:
			GameState.apple_variety = "ghost"
			GameState.coins -= GHOST_APPLE_PRICE
			GameSignals.purchase.emit()
			GameSignals.ghost_purchase.emit()
		else:
			invalid_purchase()

func buy_gold(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= GOLD_APPLE_PRICE:
			GameState.apple_variety = "gold"
			GameState.coins -= GOLD_APPLE_PRICE
			GameSignals.purchase.emit()
			GameSignals.gold_purchase.emit()
		else:
			invalid_purchase()

func buy_speed(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= SPEED_PRICE:
			GameState.speed_stat += 1
			GameState.coins -= SPEED_PRICE
			GameSignals.purchase.emit()
		else:
			invalid_purchase()

func buy_jump(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= JUMP_PRICE:
			GameState.jump_stat += 1
			GameState.coins -= JUMP_PRICE
			GameSignals.purchase.emit()
		else:
			invalid_purchase()

func buy_knockback(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= KNOCKBACK_PRICE:
			GameState.knockback_stat += 1
			GameState.coins -= KNOCKBACK_PRICE
			GameSignals.purchase.emit()
		else:
			invalid_purchase()

func buy_spear_cooldown(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= SPEAR_COOLDOWN_PRICE:
			GameState.spear_cooldown_stat += 1
			GameState.coins -= SPEAR_COOLDOWN_PRICE
			GameSignals.purchase.emit()
		else:
			invalid_purchase()

func buy_dash_cooldown(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= DASH_COOLDOWN_PRICE:
			GameState.dash_cooldown_stat += 1
			GameState.coins -= DASH_COOLDOWN_PRICE
			GameSignals.purchase.emit()
		else:
			invalid_purchase()

func buy_dash_distance(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= DASH_DISTANCE_PRICE:
			GameState.dash_distance_stat += 1
			GameState.coins -= DASH_DISTANCE_PRICE
			GameSignals.purchase.emit()
		else:
			invalid_purchase()

func buy_apple_roll(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.coins >= APPLE_ROLL_COST:
			GameState.coins -= APPLE_ROLL_COST
			GameState.apple_roll_stat += 1
			GameSignals.purchase.emit()
		else:
			invalid_purchase()

func invalid_purchase() -> void:
	var tween = create_tween()
	tween.tween_property(coin_label, "modulate", Color(1, 0, 0, 1), 1)
	tween.tween_property(coin_label, "modulate", Color(1, 1, 1, 1), 0.5)
	
func _physics_process(delta: float) -> void:
	time += delta
	
	for i in range(sprites.size()):
		var sprite = sprites[i]
		var original_pos = original_positions[i]
		
		var frequency = 1.0 + (i * 0.01)
		var amplitude = 20.0 + (i * 2.5)
		var phase_offset = i * 0.5
		
		var bob_offset = sin(time * frequency + phase_offset) * amplitude
		sprite.position.y = original_pos.y + bob_offset
		sprite.position.x = original_pos.x + bob_offset / 2

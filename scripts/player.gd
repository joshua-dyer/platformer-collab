extends CharacterBody2D

@onready var debug_label: Label = $DebugLabel
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var player_sprite: AnimatedSprite2D = $playerSprite

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@export var _jump_available: bool = true
@export var _coyote_time: float = 0.75

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	update_Debug_Label()

	handle_buffer_jump(delta) ## Working on this one now
	handle_coyote_jump(delta)



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x < 0:
			flip_me(true)
		if velocity.x > 0:
			flip_me(false)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# End of Physics Process 




func flip_me(flip: bool) -> void: 
	player_sprite.flip_h = flip

func handle_buffer_jump(delta) -> void:
	pass

	# If not on floor, apply gravity, and
	# start Coyote Timer
	# If on floor, reset _jump_available and
	# stop Coyote Timer
func handle_coyote_jump(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		if coyote_timer.is_stopped():
			coyote_timer.start(_coyote_time)
	else:  # if IS on floor
		_jump_available = true
		coyote_timer.stop()
		
	if Input.is_action_just_pressed("jump") and _jump_available:
		velocity.y = JUMP_VELOCITY
		_jump_available = false
		

func _on_coyote_timer_timeout() -> void:
	_jump_available = false

func update_Debug_Label() -> void:
	debug_label.text = "JumpAvail: %s\nIsOnFl: %s" % [str(_jump_available), str(is_on_floor())]

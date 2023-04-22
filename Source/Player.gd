class_name Player extends CharacterBody2D

signal died


const PLAYER_ACCEL: float = SIZE * 20
const PLAYER_AIR_ACCEL: float = SIZE * 10
const PLAYER_DECEL: float = SIZE * 10
const SIZE: float = 32
const GRAVITY: float = SIZE * 25
const MOVE_SPEED: float = SIZE * 6
const JUMP_SPEED: float = SIZE * 6
const JUMP_MAX_FRAMES: int = 10
const GRAPPLE_LENGTH: float = SIZE * 8
const RETRACT_SPEED_I: float = 0
const RETRACT_SPEED_F: float = SIZE * 12
const GRAPPLED_SPEED: float = SIZE * 9
const RETRACT_ACCEL: float = SIZE * 50

var jumping: bool = false
var jump_frames: int = 0
var grappled: bool = false
var grapple_point: Vector2
var grapple_target: Node2D
var retracting: bool = false
var controller: bool = false
var is_aiming: bool = false
@onready var ray: RayCast2D = $RayCast2D

func _ready() -> void:
	pass

func _draw() -> void:
	if is_aiming or !controller or grappled:
		var c := Color(1, 0, 0, 0.25)
		var p := ray.target_position
		if grappled:
			c = Color.RED
			p = to_local(grapple_point)
		elif ray.is_colliding():
			c = Color.DARK_RED
			p = to_local(ray.get_collision_point())
		draw_line(Vector2.ZERO, p, c)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("switch_controls"):
		controller = !controller
	queue_redraw()

func _physics_process(delta: float) -> void:
	is_aiming = false
	if(!controller):
		ray.target_position = to_local(get_global_mouse_position()).normalized() * GRAPPLE_LENGTH
	else:
		var direction := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		if !direction.is_zero_approx():
			is_aiming = true
			ray.target_position = direction.normalized() * GRAPPLE_LENGTH
			
	
	
	
	
	
	
	var retracted: bool = Input.is_action_pressed("grapple")
	var axis: float = Input.get_axis("left", "right")
	
	
	if grappled:
		if not retracted:
			grappled = false
	
	elif retracted and ray.is_colliding():
		grappled = true
		grapple_point = ray.get_collision_point()
		grapple_target = ray.get_collider()
	
	if grappled:
		velocity += (grapple_point - position).normalized() * RETRACT_ACCEL * delta
		velocity.limit_length(RETRACT_SPEED_F)
#		if velocity.length() > RETRACT_SPEED_F:
#			velocity = velocity.normalized() * RETRACT_SPEED_F
#		move_and_slide()
#		return
	
	if !is_on_floor():
		velocity.x = clamp(velocity.x + PLAYER_AIR_ACCEL * delta * axis, -RETRACT_SPEED_F, RETRACT_SPEED_F)
	else:
		velocity.x = clamp(velocity.x + PLAYER_ACCEL * delta * axis, -MOVE_SPEED, MOVE_SPEED)
		
	if is_zero_approx(axis):
		velocity.x = move_toward(velocity.x, 0, delta * PLAYER_DECEL)
		
	if Input.is_action_pressed("jump"):
		if jump_frames > 0:
			jump_frames += 1
			if (jump_frames > JUMP_MAX_FRAMES):
				jump_frames = 0
			else:
				velocity.y = -JUMP_SPEED
		else:
			if is_on_floor():
				jump_frames += 1
				velocity.y = -JUMP_SPEED
			else:
				velocity.y += GRAVITY * delta
	else:
		jump_frames = 0
		if !grappled:
			velocity.y += GRAVITY * delta
	
	move_and_slide()
	


func _on_area_2d_body_entered(body):
	died.emit()

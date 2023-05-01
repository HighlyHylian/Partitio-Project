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
const WALLJUMP_SPEED:int = 150

var coyote_frames: int = 0
var jumping: bool = false
var jump_frames: int = 0
@export var grappled: bool = false
var grapple_point: Vector2
var grapple_target: Node2D
@export var retracting: bool = false
var retracted: bool = false
@export var controller: bool = false
var is_aiming: bool = false
var can_slide: bool = true
@onready var ray: RayCast2D = $RayCast2D

func _ready() -> void:
	Engine.physics_jitter_fix = 0

func _draw() -> void:
	if is_aiming or !controller or grappled:
		var c := Color(1, 0, 0, .25)
		var p := ray.target_position
		if grappled:
			c = Color.GREEN
			p = to_local(grapple_point)
		elif ray.is_colliding():
			c = Color.DARK_GREEN
			p = to_local(ray.get_collision_point())
		draw_line(Vector2.ZERO, p, c)

func _process(_delta: float) -> void:
	$Camera2D.position.x = int($Camera2D.position.x)
	$Camera2D.position.y = int($Camera2D.position.y)
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
			
	
	
	
	
	
	
	retracted = Input.is_action_pressed("grapple")
	var axis: float = Input.get_axis("left", "right")
	
	
	if grappled:
		if not retracted:
			grappled = false
	
	elif retracted and ray.is_colliding():
		$Click.play()
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

	coyote_frames = coyote_frames - 1
	
	if !is_on_floor():
		velocity.x = clamp(velocity.x + PLAYER_AIR_ACCEL * delta * axis, -RETRACT_SPEED_F, RETRACT_SPEED_F)
	else:
		coyote_frames = 10
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
			if coyote_frames > 0 or is_on_wall() and !is_zero_approx(axis):
				if is_on_wall() and !is_zero_approx(axis):
					if(get_wall_normal().x>0):
						velocity.x=WALLJUMP_SPEED
					elif(get_wall_normal().x<0):
						velocity.x=-WALLJUMP_SPEED
					$GPUParticles2D.emitting = true
				jump_frames += 1
				velocity.y = -2 * JUMP_SPEED
			else:
				$GPUParticles2D.emitting = false
				velocity.y += GRAVITY * delta
	else:
		jump_frames = 0
		if !grappled:
			if is_on_wall() and !is_zero_approx(axis):
				coyote_frames = 10
				$GPUParticles2D.emitting = true
				if(get_wall_normal().x>0 and axis<-.1 or get_wall_normal().x<0 and axis>.1):
					velocity.y = GRAVITY * delta
			else:
				$GPUParticles2D.emitting = false
				velocity.y += GRAVITY * delta
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or is_on_wall() and !is_zero_approx(axis) and !grappled or coyote_frames > 0:
			$Jump.play()
	move_and_slide()
	


@warning_ignore("unused_parameter")
func _on_area_2d_body_entered(body):
	emit_signal("died")
	retracting = false
	grappled = false
	retracted = false
	velocity = Vector2.ZERO


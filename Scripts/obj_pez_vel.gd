extends KinematicBody2D

# Variables
export(int) var velosidad : int = 150
export(float) var v_rot : float = 2.5
export(float) var friccion : float = 5

var dir : int = 0
var mov : int = 0
var aceleracion : int = 0
var velosidad_reciduo : int = velosidad
var movimiento : Vector2 = Vector2()
const UP : Vector2 = Vector2(0,-1)

# Funcion main (loop)
func _physics_process(delta):
	
	# Detectar que tecla se pulso y asignarle un valor
	mov = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	
	# Rotar
	if Input.is_action_pressed("ui_up"):
		self.rotate(-v_rot * dir * delta)
	if Input.is_action_pressed("ui_down"):
		self.rotate(v_rot * dir * delta)
	
	# Limites de la rotacion
	if self.rotation < -1 : self.rotation = -1
	if self.rotation > 1 : self.rotation = 1
	
	# Girar sprite
	if mov == -1:
		if dir != -1:
			self.rotation *= -1
		dir = -1
		$sprite.flip_h = false
	elif mov == 1:
		if dir != 1:
			self.rotation *= -1
		dir = 1
		$sprite.flip_h = true
	
	# Animacion
	if mov == 0:
		$AnimationPlayer.play("anim_quieto")
	else:
		$AnimationPlayer.play("anim_nadando")
	
	# Friccion
	if mov != 0:
		aceleracion = (mov * velosidad) * velosidad * delta
		velosidad_reciduo = velosidad
	else:
		aceleracion = (dir * velosidad_reciduo) * velosidad_reciduo * delta
		if (velosidad_reciduo > 0):
			velosidad_reciduo -= friccion
		elif (velosidad_reciduo < 0):
			velosidad_reciduo = 0
	
	# Mover
	movimiento = Vector2(aceleracion, 0).rotated(self.rotation)
	move_and_slide(movimiento, UP)
	


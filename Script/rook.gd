extends Sprite2D

var dragging = false
var click_radius = 100


func _ready():
	pass

func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.position).length() < click_radius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			if global_position.x <= 300:
				self.position.x = 0
				self.position.y = 0
			else:
				self.position.x = 300
				self.position.y = 0
			dragging = false

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position

#	var mouse_pos = get_local_mouse_position()
#	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
#		if mouse_pos.x >= 0 and mouse_pos.x <= texture.get_width()\
#		and mouse_pos.y >= 0 and mouse_pos.y <= texture.get_height():
#			if event.is_pressed():
#				global_position.x = get_global_mouse_position().x
#				global_position.y = get_global_mouse_position().y
#				print(MOUSE_BUTTON_LEFT)
#				print("click")

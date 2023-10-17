extends Sprite2D

var dragging = false
var click_radius = 100

var drag_offset = Vector2()

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
				drag_offset = event.position - self.position
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			for i in range (0,8):
				print("Retour boucle", i)
				if global_position.x >= i*100 and global_position.x <= (i*100)+100:
					print("case visé", i)
					self.position.x = (i*100) + 50
					self.position.y = 50
					break
				elif global_position.x >= 800:
					print("Case de départ")
					self.position.x = 50
					self.position.y = 50
			dragging = false

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position

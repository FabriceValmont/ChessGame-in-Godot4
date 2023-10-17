extends Sprite2D

var dragging = false
var click_radius = 100
var drag_offset = Vector2()
var new_position = {"x": self.position.x, "y": self.position.y }
var move_case = VariableGlobal.one_move_case

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
				if global_position.x >= i*move_case and global_position.x <= (i*move_case)+move_case \
				and global_position.y >= new_position.y - 50 and global_position.y <= new_position.y + 50:
					self.position = Vector2((i*move_case) + 50, new_position.y)
					new_position = {"x": self.position.x, "y": self.position.y }
					break
				elif global_position.x >= new_position.x - 50 and global_position.x <= new_position.x + 50 \
				and global_position.y >= i*move_case and global_position.y <= (i*move_case)+move_case:
					self.position = Vector2(new_position.x, (i*move_case) + 50)
					new_position = {"x": self.position.x, "y": self.position.y }
					break
			self.position = Vector2(new_position.x, new_position.y)
			dragging = false

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position

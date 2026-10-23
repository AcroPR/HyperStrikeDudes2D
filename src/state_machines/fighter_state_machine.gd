extends StateMachine

# Sets state params if the node is a state
# Does recursion if not
#func set_states(_node: Node, parent: Player, model: Node2D, inputComponent: InputComponent):
func set_states(_node: Node, parent: Node, model: Node2D, inputComponent: Node):
	if _node is State:
		_node.parent = parent
		_node.model = model
		_node.inputComponent = inputComponent
	else:
		for child in _node.get_children():
			set_states(child, parent, model, inputComponent)

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default startingState.
#func init(parent: Player, model: Node2D, inputComponent: InputComponent) -> void:
func init(parent: Node, model: Node2D, inputComponent: Node) -> void:
	for child in get_children():
		set_states(child, parent, model, inputComponent)

	# Initialize to the default state
	change_state(startingState)

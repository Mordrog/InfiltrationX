extends "../IStateMachine.gd"

func _ready():
	states_map = {
		"Patrol": $Patrol,
		"TrackPlayer": $TrackPlayer
	}

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	if not _active:
		return
	if state_name in ["Patrol", "TrackPlayer"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)

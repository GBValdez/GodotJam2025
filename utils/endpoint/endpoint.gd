extends Area2D
@export var myKey:String=""

	

func enter_endpoint(body: Node2D) -> void:
	if not body.is_in_group("playerPro"):
		return
	saveEndpoint()
	print("hola")

func saveEndpoint():
	var endpoint:endpointDto=endpointDto.new()
	endpoint.pos=$pos.global_position
	var sect:zone= get_parent()
	endpoint.key= sect.key
	endpoint.myKey=myKey
	General.currentEndpont=endpoint
	General.dataGame.endpoint= myKey +"|"+sect.key +"|"+str(endpoint.pos)
	General.saveData()

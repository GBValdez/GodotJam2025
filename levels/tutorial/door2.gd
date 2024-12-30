extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func pressBtn(body: Node2D) -> void:
	enabled=false


func delease(body: Node2D) -> void:
	enabled=true

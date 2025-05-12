class_name bufferPlayer
var keyBufferList:Array[bufferPlayerKey]=[]
var timerBuffer:float=0.25

func addKey(key:String):
	var current:bufferPlayerKey= bufferPlayerKey.new()
	current.keyCode=key
	keyBufferList.push_back(current)

func validFirst(key:String) -> bool:
	for current in keyBufferList:
		if current.keyCode == key:
			return true
	return false
		
func update(delta:float):
	var listTemp:Array[bufferPlayerKey]=[]
	for current in keyBufferList:
		current.time+=delta
		if current.time<=timerBuffer:
			listTemp.push_back(current)
	keyBufferList=listTemp

func eraseKey(key:String):
	for i in range(keyBufferList.size()):
		if keyBufferList[i].keyCode == key:
			keyBufferList.remove_at(i)  
			break

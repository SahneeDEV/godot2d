class_name Save

var name = "user://savegame.save"
var data = {
	"levels": []
}

func load_data():
	var save_game = File.new()
	if save_game.file_exists(name):
		save_game.open(name, File.READ)
		data = parse_json(save_game.get_line())
		save_game.close()
	return data
	
func save_data():
	var save_game = File.new()
	save_game.open(name, File.WRITE)
	save_game.store_line(to_json(data))
	save_game.close()
	
func add_level(level):
	data.levels.push_back(level)

extends Node
# Word manager handles the loading and random selection of words from a list.
# Currently all words are loaded into memory upon loading the game up.

var words_by_length: Dictionary = {}

func load_words():
	var file = FileAccess.open("assets/words.txt", FileAccess.READ)
	if not file:
		push_error("Failed to open words.txt")
		return
		
	while file.get_position() < file.get_length():
		var word = file.get_line().strip_edges()
		# Remvoe quotes from words
		# Could eventually be removed once we have a clean word list with no quotes
		word = word.trim_prefix('"').trim_suffix('"')
		if word.length() > 0:
			if not words_by_length.has(word.length()):
				words_by_length[word.length()] = []
			words_by_length[word.length()].append(word)
	
	for length in words_by_length:
		words_by_length[length].sort()
	
	file.close()
	print("Loaded words: ", words_by_length.keys())

func get_random_word(length: int) -> String:
	if not words_by_length.has(length):
		push_error("No words of length %d" % length)
		return ""
		
	return words_by_length[length][randi() % words_by_length[length].size()]

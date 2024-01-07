extends MarginContainer


@onready var available = $VBox/Cards/Available
@onready var discharged = $VBox/Cards/Discharged
@onready var broken = $VBox/Cards/Broken
@onready var hand = $VBox/Cards/Hand

var gambler = null


func set_attributes(input_: Dictionary) -> void:
	gambler = input_.gambler
	input_.gameboard = self
	
	init_starter_kit_cards()
	available.set_attributes(input_)
	discharged.set_attributes(input_)
	broken.set_attributes(input_)
	hand.set_attributes(input_)
	
	next_turn()


func init_starter_kit_cards() -> void:
	for suit in Global.arr.suit:
		for rank in Global.arr.rank:
			for _i in Global.dict.card.count:
				var input = {}
				input.gameboard = self
				input.rank = rank
				input.suit = suit
			
				var card = Global.scene.card.instantiate()
				available.cards.add_child(card)
				card.set_attributes(input)
				card.gameboard = self
				card.area = available
				#print([card.get_index(), suit, rank])
	
	#print("___")
	#reshuffle_available()


func reshuffle_available() -> void:
	var cards = []
	
	while available.cards.get_child_count() > 0:
		var card = pull_random_card()
		cards.append(card)
	
	cards.shuffle()
	
	for card in cards:
		available.cards.add_child(card)


func pull_random_card() -> Variant:
	var cards = available.cards
	
	if cards.get_child_count() > 0:
		var card = cards.get_children().pick_random()
		cards.remove_child(card)
		return card
	
	print("error: empty available")
	return null


func pull_indexed_card(index_: int) -> Variant:
	var cards = available.cards
	
	if cards.get_child_count() > 0:
		for card in cards.get_children():
			#print(card.get_index_number(), " ", index_)
			if card.get_index_number() == index_:
				cards.remove_child(card)
				return card
	else:
		print("error: empty available")
	
		
	print("error: no card with index: ", index_)
	return null


func next_turn() -> void:
	hand.refill()

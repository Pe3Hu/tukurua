extends MarginContainer


@onready var cards = $Cards

var capacity = {}
var gameboard = null
var ranks = {}
var suits = {}


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	
	capacity.current = 6
	capacity.limit = 10


func refill() -> void:
	gameboard.reshuffle_available()
	
	while cards.get_child_count() < capacity.current and gameboard.available.cards.get_child_count() > 0:
		var card = gameboard.pull_random_card()
		add_card(card)


func add_card(card_: MarginContainer) -> void:
	cards.add_child(card_)
	var suit = card_.suit.subtype
	var rank = card_.rank.get_number()
	#print([suit, rank])
	
	if !suits.has(suit):
		suits[suit] = 0
	
	if !ranks.has(rank):
		ranks[rank] = 0
	
	suits[suit] += 1
	ranks[rank] += 1


func refill_based_on_card_indexs(indexs_: Array) -> void:
	for index in indexs_:
		draw_indexed_card(index)


func draw_indexed_card(index_: int) -> void:
	var card = gameboard.pull_indexed_card(index_)
	add_card(card)


func discard() -> void:
	while cards.get_child_count() > 0:
		var card = cards.get_child(0)
		discard_card(card)
	
	#print(gameboard.available.cards.get_child_count())


func discard_card(card_: MarginContainer) -> void:
	cards.remove_child(card_)
	#card_.charge.current -= 1
	var suit = card_.get_suit()
	var rank = card_.get_rank()
	suits[suit] -= 1
	ranks[rank] -= 1
	
	if suits[suit] == 0:
		suits.erase(suit)
	
	if ranks[rank] == 0:
		ranks.erase(rank)
	
	if card_.charge.current > 0:
		gameboard.available.cards.add_child(card_)
	else:
		gameboard.discharged.cards.add_child(card_)
		card_.area = gameboard.discharged


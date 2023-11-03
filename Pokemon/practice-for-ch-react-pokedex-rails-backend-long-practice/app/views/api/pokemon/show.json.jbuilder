# #show returns:
#
# {
#   "imageUrl": "/images/pokemon_snaps/1.svg",
#   "id": 1,
#   "number": 1,
#   "attack": 49,
#   "defense": 49,
#   "name": "Bulbasaur",
#   "type": "grass",
#   "moves": [
#     "tackle",
#     "vine whip"
#   ],
#   "captured": true,
#   "createdAt": "2020-12-16T01:17:24.119Z",
#   "updatedAt": "2020-12-16T01:17:24.119Z"
# }

json.partial! 'api/pokemon/pokemon_brief', pokemon: @pokemon
json.extract! @pokemon, :attack, :defense, :created_at, :updated_at
json.type @pokemon.poke_type
json.moves @pokemon.moves.map(&:name)

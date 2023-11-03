# #index returns:
#
# [
#   {
#     "id": 1,
#     "number": 1,
#     "name": "Bulbasaur",
#     "imageUrl": "/images/pokemon_snaps/1.svg",
#     "captured": true
#   },
#   // ...
# ]

json.array! @pokemon do |poke|
  json.partial! 'api/pokemon/pokemon_brief', pokemon: poke
end

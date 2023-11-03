# #index returns:
#
# [
#   {
#     "id": 1,
#     "happiness": 86,
#     "imageUrl": "/images/pokemon_potion.svg",
#     "name": "Awesome Plastic Pizza",
#     "price": 27,
#     "pokemonId": 1
#   },
#   // ...
# ]

json.array! @items do |item|
  json.partial! 'api/items/item', item: item
end

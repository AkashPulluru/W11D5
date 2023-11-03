json.extract! pokemon, :id, :number, :name, :captured
json.image_url (pokemon.captured ? pokemon.image_url : "/images/unknown.png")

# == Schema Information
#
# Table name: pokemons
#
#  id         :bigint           not null, primary key
#  number     :integer          not null
#  name       :string           not null
#  attack     :integer          not null
#  defense    :integer          not null
#  poke_type  :string           not null
#  image_url  :string           not null
#  captured   :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Pokemon < ApplicationRecord
  TYPES = [
    'fire',
    'electric',
    'normal',
    'ghost',
    'psychic',
    'water',
    'bug',
    'dragon',
    'grass',
    'fighting',
    'ice',
    'flying',
    'poison',
    'ground',
    'rock',
    'steel'
  ].sort.freeze

  alias_attribute :type, :poke_type

  validates :image_url, presence: true
  validates :captured, inclusion: { in: [true, false], message: "must be true or false" }
  validates :name, length: { in: 3..255 }, uniqueness: { message: "'%{value}' is already in use" }
  validates :attack, :defense, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :number, uniqueness: { message: "'%{value}' is already in use" }, numericality: { greater_than: 0 }
  validates :poke_type, inclusion: { in: TYPES, message: "'%{value}' is not a valid Pokemon type" }
  
  has_many :items, dependent: :destroy
  has_many :poke_moves, dependent: :destroy
  has_many :moves, through: :poke_moves

  def save_moves!(move_names)
    transaction do
      self.moves = move_names.map { |name| Move.find_or_create_by!(name: name) } 
    end
  rescue ActiveRecord::RecordInvalid => e
      errors.add(:moves, e.record.errors.messages.values[0])
      raise
  end

  def error_messages
    errors.messages.transform_keys({
      poke_type: :type,
      image_url: :imageUrl
    }, &:itself)
  end
end

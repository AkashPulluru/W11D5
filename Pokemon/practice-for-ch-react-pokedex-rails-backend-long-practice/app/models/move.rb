# == Schema Information
#
# Table name: moves
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Move < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { message: "'%{value}' is already in use" }

  has_many :poke_moves, dependent: :destroy
  has_many :pokemon, through: :poke_moves
end

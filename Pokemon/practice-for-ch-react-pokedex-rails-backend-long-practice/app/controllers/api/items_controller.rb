class Api::ItemsController < ApplicationController
  wrap_parameters include: Item.attribute_names + ['imageUrl', 'pokemonId']

  def index
    @items = Item.where(pokemon_id: params[:pokemon_id])
  end

  def create
    @item = Item.new(item_params)
    @item.pokemon_id = params[:pokemon_id]
    @item.image_url ||= "/images/#{%w(pokemon_berry.svg pokemon_egg.svg pokemon_potion.svg pokemon_super_potion.svg).sample}"
    if @item.save
      render :show
    else
      render json: @item.errors.messages, status: :unprocessable_entity
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      render :show
    else
      render json: @item.errors.messages, status: :unprocessable_entity
    end
  end

  def destroy
    id = params[:id]
    Item.destroy(id)
    render json: { id: id.to_i }
  end

  private
  def item_params
    params.require(:item).permit(:happiness, :name, :price, :image_url, :pokemon_id)
  end
end

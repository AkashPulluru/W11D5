class Api::PokemonController < ApplicationController
  wrap_parameters include: Pokemon.attribute_names + ['imageUrl', 'type']
  
  def types
    render json: Pokemon::TYPES
  end

  def index
    @pokemon = Pokemon.all 
    render :index
  end

  def show
    @pokemon = Pokemon.find_by(id: params[:id])

    if @pokemon
      render :show
    else 
      render json: "Pokemon not found", status: :not_found
    end
  end
  
  def create
    @pokemon = Pokemon.new(pokemon_params)

    @pokemon.transaction do
      @pokemon.save!
      @pokemon.save_moves!(params[:moves])
      render :show
    end
  rescue
    render json: { errors: @pokemon.error_messages }, status: :unprocessable_entity
  end

  def update
    @pokemon = Pokemon.find(params[:id])

    @pokemon.transaction do
      @pokemon.update!(pokemon_params)
      @pokemon.save_moves!(params[:moves])
      render :show
    end
  rescue
    render json: { errors: @pokemon.error_messages }, status: :unprocessable_entity
  end

  private
  def pokemon_params
    params.require(:pokemon).permit(:number, :attack, :defense, :image_url, :name, :type, :captured)
  end

end

class Api::V1::CitiesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  def index
    cities = City.all
    render json: {cities: cities, message: "All Cities", status: :Ok}
  end

  def show
    city = City.friendly.find(params[:id])
    render json: {city: city, status: :Ok}
  end

  def new
    city = City.new
  end

  def edit
  end

  def create
    city = City.new(city_params)
    if city.save
      render json: { message: 'City was successfully created.', status: :Ok }
    else
      render json: { errors: city.errors, status: :unprocessable_entity }
    end
  end

  def update
    if city.update(city_params)
      render json: { message: 'City was successfully updated.', status: :Ok }
    else
      render json: { errors: city.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    city.destroy
    render json: { notice: 'City was successfully destroyed.', status: :Ok }
  end

  private

  def set_city
    city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit(:name)
  end

end
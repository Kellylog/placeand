class PlacesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :destroy]

	def index
    @places = Place.all
		# @places = Place.order(:name).page(params[:page]).per(6)
	end

	def show
    @place = Place.find(params[:id])   
    @comment = Comment.new
    @photo = Photo.new
  end

  def new
    @place = Place.new
  end


def create
  @place = current_user.places.create(place_params)
  if @place.valid?
    redirect_to places_path
  else
    render :new, status: :unprocessable_entity
  end
end

def destroy
    @place = Place.find(params[:id])
    if @place.user != current_user
    return render text: 'Not Allowed', status: :forbidden
  end
    @place.destroy
    redirect_to root_path

  end


  private

  def place_params
    params.require(:place).permit(:name, :address, :description)
  end

end

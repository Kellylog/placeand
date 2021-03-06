class PlacesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]



	def index
    @places = Place.all
    
    #@places = Place.order(:name).page(params[:page]).per(6) 
    if params[:search]
      @places = Place.search(params[:search]).order("name")
    else
      @places = Place.order("name")		 
    end  

    if params[:category]    
      @category_id = Category.find_by(name: params[:category]).id
      @places = Place.where(category_id: @category_id)
    end
    
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

def edit
  @place = Place.find(params[:id])
  if @place.user != current_user
    return render text: 'Not Allowed', status: :forbidden
  end 
end

def update
    @place = Place.find(params[:id])
    if @place.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end

    @place.update_attributes(place_params)
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
    params.require(:place).permit(:name, :address, :description, :category_id)
  end


end

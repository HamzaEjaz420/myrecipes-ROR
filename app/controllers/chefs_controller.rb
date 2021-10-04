class ChefsController < ApplicationController
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    # @chef = Chef.all
    @chefs = Chef.paginate(page: params[:page], per_page: 5)
  end 

  def new
    @chef = Chef.new 
  end 

  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      session[:chef_id] = @chef_id
      flash[:success] = "Welcome #{@chef.chefname} to MyRecipes App!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end 
  
  def show 
    @chef = Chef.find(params[:id])
    @chef_recipes = @chef.recipes.paginate(page: params[:page], per_page: 5)
  end

  def edit
    @chef = Chef.find(params[:id])
  end
  
  def update
    @chef = Chef.find(params[:id])
    if @chef.update(chef_params)
      flash[:success] = "Your account was updated successfully"
      redirect_to @chef
    else
      render 'edit'
    end  
  end

  def destroy
    @chef = Chef.find(params[:id])
    @chef.destroy
    flash[:danger] = "Chef and all associated recipes have been deleted"
    redirect_to chefs_path
  end

  private
  
  def chef_params
    params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
  end

  def require_same_user
    if current_chef != @chef
      flash[:danger] = "You can only edit or delete your own account"
      redirect_to chefs_path
    end
  end


end
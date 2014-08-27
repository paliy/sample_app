class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index, :edit, :update]
	before_action :correct_user,   only: [:edit, :update]


	def index
		@users = User.paginate(page: params[:page])
	end


	def edit
    	# @user = User.find(params[:id])
    end


	def new
		@user = User.new
	end


	def show
    	@user = User.find(params[:id])
      @microposts = @user.microposts.paginate(page: params[:page])
	end


	def create
    	@user = User.new(user_params)    # Not the final implementation!
    	if @user.save
      		flash[:success] = "Welcome to the Sample App!"	
      		redirect_to @user
    	else
      		render 'new'
    	end
    end


   def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
   end


   def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private

    def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end


end

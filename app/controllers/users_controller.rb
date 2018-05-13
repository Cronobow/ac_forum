class UsersController < ApplicationController
  before_action :set_user

  def show
    @posts = @user.posts.published
  end

  def edit
    unless @user == current_user
      flash[:alert] = '沒有權限'
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Successfully updated"
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence if @user.errors.any?
      render :edit
    end
  end

  def show_comment
    @comments = @user.replies
    render :show
  end

  def show_collect
    if @user == current_user
      @collects = @user.collect_posts
      render :show
    else
      flash[:alert] = '沒有權限'
      redirect_back(fallback_location: root_path)
    end
  end

  def show_draft
    if @user == current_user
      @drafts = @user.posts.draft
      render :show
    else
      flash[:alert] = '沒有觀看權限'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :description, :avatar)
  end
end
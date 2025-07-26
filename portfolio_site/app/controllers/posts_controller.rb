class PostsController < ApplicationController
  # Only logged in users can create/edit/delete posts
  before_action :require_login, except: [:index, :show]
  # Find the post for show/edit/update/destroy actions
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # Ensure the current user owns the post before editing/updating/deleting
  before_action :authorize_post, only: [:edit, :update, :destroy]

  def index
    # Show newest posts first
    @posts = Post.order(created_at: :desc)
  end

  def show
    # @post is loaded in set_post
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @post is loaded and authorized in before actions
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  # Strong parameters for posts
  def post_params
    params.require(:post).permit(:title, :body, :published_at)
  end

  # Find the post by id
  def set_post
    @post = Post.find(params[:id])
  end

  # Ensure only the post owner can edit/update/destroy
  def authorize_post
    unless @post.user == current_user
      redirect_to posts_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
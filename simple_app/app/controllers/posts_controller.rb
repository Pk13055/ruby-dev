class PostsController < ApplicationController
	# this method will display all the values
	def index 
		@posts = Post.all
	end

	def show
		@post = Post.find(params[:id])
	end

	def new

	end

	def create
		# render plain: params[:post].inspect
		@post = Post.new(post_params)
		@post.save
		redirect_to @post
		# redirect_to action: "show", params: @post
	end

	private def post_params
		params.require(:post).permit(:title, :body)
	end


end

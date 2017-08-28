class PostsController < ApplicationController
	# this method will display all the values
	def index 
		@posts = Post.all
	end

	def show
		@post = Post.find(params[:id])
	end

	def new
		@post = Post.new
	end

	def create
		# render plain: params[:post].inspect
		@post = Post.new(post_params)
		if(@post.save)
			redirect_to @post
		else
			@message = "Post not saved"
			render 'new'
		end

		# redirect_to action: "show", params: @post
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
		if(@post.update(post_params))
			redirect_to @post
		else
			@message = "Post not saved"
			render 'edit'
		end

	end

	def destroy
		@post = Post.find(params[:id])
		if(@post.destroy)
			redirect_to posts_path
		else
			@message = "Post not deleted"
			render 'show'
		end
	end
	
	private def post_params
		params.require(:post).permit(:title, :body)
	end


end

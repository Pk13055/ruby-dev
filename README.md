# Ruby Web Application Development

This will cover making a basic web app. Ruby `syntax` is covered in the [ruby notebook](./Ruby.ipynb)

- All the important files are located in the _app_ folder.
- The **application_controller** is the core controller which every other user defined controller will extend.
- The _erb_ extension is the ruby html+ruby ext.
- The [application.html+ruby.erb](./simple_app/app/views/layouts/application.html+ruby.erb) will be the main super view, of sorts. All other views will "yield" to the body so that the _head_ and other boilerplate html+ruby need not be repeated.
- You can add various CDN links and stylesheets to this main view template, by simply.
```ruby
<%= stylesheet_link_tag    'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css' %>
<%= javascript_include_tag 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js' %>
```
- All the routes are located in the [config](./simple_app/config/routes.rb) folder.


## Creating a Controller

- To create a controller, you have to run `rails generate/g controller <controller_name>`
- Your output will be something like this.
```rails
       create  app/controllers/<controller_name>.rb
      invoke  erb
      create    app/views/posts
      invoke  test_unit
      create    test/controllers/<controller_name>_test.rb
      invoke  helper
      create    app/helpers/posts_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/posts.coffee
      invoke    scss
      create      app/assets/stylesheets/posts.scss
```
- The command basically creates a controller, a views folder, for the views associated with the controller, and a helper file for non-related functions and defs.

- The created post controller extends (using _<_) the Application controller
- Now we need to create a method for the controller which will point to a route

```ruby 
class PostController < ApplicationController
	def index

	end
end
```
- After creating the method, we have to add an associated view [index.html+ruby.erb](./simple_app/app/views/posts/index.html+ruby.erb)

- After creating of the files, now we have to make a route which will point to the specific page.
- In the `routes.erb`, we can change the root to point to the func which will render the homepage.
```ruby
root '<controller_name>#<func_name>'
get 'route_name' => 'controller_name#func_name'
# Example of regular route:
get 'about' => 'pages#about'
```

## Working with views

- Views can be routed as shown above.
- To add dynamic values that can be passed from the function to the html+ruby page, we can do the following.
- To our controller function add
```ruby
class PostsController < ApplicationController
	def index
		@title = "Posts Page"
	end
end
```
- Now, to use `title` in our view, we can simply, 
```html+ruby
<h1><%= @title %></h1>
```

## Routes

- Routes can be manually added as shown above, but sometimes that can be a bit tedious. We can simply add a basic CRUD interface to a particular controller by declaring it as a _resource_ in the `routes.rb`
- In routes.rb
```ruby
resources: 'posts'
```

## Forms

A form can be added as [follows](./simple_app/app/views/posts/new.html+ruby.erb)
Once that is added, the `posts_path` will submit to the matching method in the `PostsController`.
- Once the form is ready, we can submit it to the given url and that will route to the `create` method of our posts controller (CRUD). Here, to render the passed data, for now, we can
```ruby
def create
	render plain: params[:post].inspect
end
```

## Models

To save the posts we have to create a model, to store and communicate with data.
- We can do this using the same `rails g` command:
- It is good practice to use _plural_ for the controller and _singular_ for the model.
`rails g model Post <title:string> <body:text> <other_fields:filed_type>`
- Now running this command doesn't actually generate the table or model, it generates a migration. This is done so that multiple migrations can be applied at the same time, and the database isn't updated piece by piece but rather in bulk.
- **To apply all your migrations, you have to run `rake db:migrate`** 
- Once your migrations are applied and the table is created, you can add the various other methods and calls to the db for CRUD operations.

## Wiring Everything Together

### Adding record to the Database

To declare a new instance of the Post model, we have to do the following
```ruby
@post = Post.new(params[:post]);
```
However, this will not work (_forbidden attributes_). We have to add a verifier method that will permit 
creation of a model object. (this will be done in the same posts controller)
```ruby 
private def post_params
	params.require(:post).permit(:title, :body)
end
```
This _requires_ post objects to _permit_ title and body fields. Also, as the post object is created, you have to
_save_ the object to the database
After adding this, our PostsController should look something like this.
```ruby
def create
		# render plain: params[:post].inspect
		@post = Post.new(post_params)
		@post.save
		redirect_to @post
	end
	private def post_params
		params.require(:post).permit(:title, :body)
	end
```
### Frontend to display

Now, the *redirect_to* method will redirect to our show handler, which hasn't been defined yet. We are passing the post object as the parameter (_params_), so we grab it as follows

```ruby
def show
	@post = Post.find(params[:id])
	# capital Post refers to the model Post
end
```
After this is done, we have to define the view for show.html+ruby.erb in the posts folder.
```html+ruby
<h1><%= @post.id %></h1>
<h4><%= @post.title %></h4>
<h5><%= @post.body %></h5>
```
- Note that the html+ruby render for erb (_embedded ruby_) is handled in a similar way as say _jinja_. The `<%= %>` sytanx comes into play when a variable is to be rendered (similar to `{{ variable here }}` in jinja). For running loops and other commands we use `<% %>` (similar to `{% for ... %}` in jinja)
Thus our index template will look something like this
```html+ruby 
<h3>All the posts</h3>
<ul>
	<% @posts.each do |post| %>
	<li>
		post.id
		<ul>
			<li>post.title</li>
			<li>post.body</li>
		</ul>
	</li>
	<% end %>
</ul>
```
- To add links to our pages, instead of using the `a` tag, we can make _ruby_ do all the routing for us.
```html+ruby
<div><%= link_to "Name_to_display", path_to_link %></div>
```
- In this particular case, we have to config the route, path_to_link. It is of the form `<blah blah>_path`. Going to the routes.rb, we can configure root as 
```ruby
root 'posts#index', as: 'home'

# Example of regular route:
get 'about' => 'pages#about', as: 'about'

``` 
- Now, when the controllers are CRUD-ed as resources, the path variables can be represented as `new/delete/upadte_controller_path`.

### Form control and class additions

- To make a form or any other _ruby-rendered_ element look different, you can pass a class to it as follows
```html+ruby
<%= f.text_field( :title, {:class => 'form-control' }) %>
```
# Ruby Web Application Development

This will cover making a basic web app. Ruby `syntax` is covered in the [ruby notebook](./Ruby.ipynb)

- All the important files are located in the _app_ folder.
- The **application_controller** is the core controller which every other user defined controller will extend.
- The _erb_ extension is the ruby HTML ext.
- The [application.html.erb](./simple_app/app/views/layouts/application.html.erb) will be the main super view, of sorts. All other views will "yield" to the body so that the _head_ and other boilerplate HTML need not be repeated.

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
- After creating the method, we have to add an associated view [index.html.erb](./simple_app/app/views/posts/index.html.erb)

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
- To add dynamic values that can be passed from the function to the html page, we can do the following.
- To our controller function add
```ruby
class PostsController < ApplicationController
	def index
		@title = "Posts Page"
	end
end
```
- Now, to use `title` in our view, we can simply, 
```html
<h1><%= @title %></h1>
```

## Routes

- Routes can be manually added as shown above, but sometimes that can be a bit tedious. We can simply add a basic CRUD interface to a particular controller by declaring it as a _resource_ in the `routes.rb`
- In routes.rb
```ruby
resources: 'posts'
```

## Forms

A form can be added as [follows](./simple_app/app/views/posts/new.html.erb)
Once that is added, the `posts_path` will submit to the matching method in the `PostsController`.
- Once the form is ready, we can submit it to the given url and that will route to the `create` method of our posts controller (CRUD). Here, to render the passed data, for now, we can
```ruby
def create
	render plain: params[:post].inspect
end
```

## Models



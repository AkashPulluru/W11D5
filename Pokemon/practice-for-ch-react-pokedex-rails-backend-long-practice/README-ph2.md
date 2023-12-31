# Pokedex Backend, Phase 2: Routes, Controllers, And Jbuilder

In this phase, you will set up the routes that will enable your new Rails API
backend to communicate with the React frontend you will build in Part 2 (i.e.,
Pokedex Thunk).

## The API

To know what your Rails server needs to do, look at the __Pokedex-API.md__ file
in the repo linked to the `Download Project` button below. Assume that this
document represents an established API. It tells a frontend which routes to
call, how those routes change the database, and what those routes return.

A frontend does not care how that API gets implemented under the hood. You are
building a Rails server, but you could just as easily implement the API using an
Express server to receive requests, interact with the database, and send up the
information. You just need to make sure that the API remains the same. To put it
another way: you don't want a frontend app that has been using this API to have
to change anything for it to work with your new Rails backend.

## Routes

Start by identifying the nine routes in the README that your backend will
require. As you think about how to define these routes, the first thing to note
is that they all begin with `/api/`. You can achieve that effect by nesting all
of your routes inside an `api` namespace. (Remember that _namespaces_ provide a
way of encapsulating items--of grouping them together--primarily to prevent name
collisions.)

To set up an `api` namespace for your routes, include the following in your
__config/routes.rb__:

```ruby
# config/routes.rb
namespace :api, defaults: { format: :json } do
  # define routes here to include them in the api namespace
end
```

The `defaults: { format: :json }` option tells Rails to look first for a
JSON-based file extension such as `.json.jbuilder` rather than an `html.erb`
file when rendering views for routes in this namespace. For more on namespaces,
see the [Rails Guide to Routing][namespaces].

Now that you have set up your `api` namespace, define the nine routes you need
inside the namespace `do`-block. Remember that `resources` makes it easy to
define RESTful routes; just make sure that you `only` create the RESTful routes
that you actually need. (Creating PATCH routes in addition to PUT routes is
fine.) You will also need to define at least one custom route. Finally, note
that the API requires you to nest a couple of routes.

(For help nesting routes, see the [Rails Guide][nested-routes]. In particular,
check out the section on ["Shallow Nesting"][shallow-nesting]; while you are not
required to use the `:shallow` option here, this would be a good opportunity to
see how it works.)

When you have finished defining the routes, test your work by running `rails
routes`. You should see the following routes matching those specified in
__Pokedex-API.md__:

```sh
           Prefix Verb   URI Pattern                              Controller#Action
api_pokemon_types GET    /api/pokemon/types(.:format)             api/pokemon#types {:format=>:json}
api_pokemon_items GET    /api/pokemon/:pokemon_id/items(.:format) api/items#index {:format=>:json}
                  POST   /api/pokemon/:pokemon_id/items(.:format) api/items#create {:format=>:json}
         api_item PATCH  /api/items/:id(.:format)                 api/items#update {:format=>:json}
                  PUT    /api/items/:id(.:format)                 api/items#update {:format=>:json}
                  DELETE /api/items/:id(.:format)                 api/items#destroy {:format=>:json}
api_pokemon_index GET    /api/pokemon(.:format)                   api/pokemon#index {:format=>:json}
                  POST   /api/pokemon(.:format)                   api/pokemon#create {:format=>:json}
      api_pokemon GET    /api/pokemon/:id(.:format)               api/pokemon#show {:format=>:json}
                  PATCH  /api/pokemon/:id(.:format)               api/pokemon#update {:format=>:json}
                  PUT    /api/pokemon/:id(.:format)               api/pokemon#update {:format=>:json}
```

Once your nine routes (plus 2 PATCH routes) match, move on to the controllers!

## Controllers

Now that the routes are ready, you need to create two controllers, one for
`Pokemon` and one for `Items`. Set up your `Pokemon` controller with

```sh
rails g controller api::pokemon
```

Make sure to preface your controller's name with the namespace (`api::`)! This
will create an __api__ directory inside __app/controllers/__ and add a
__pokemon_controller.rb__ file to it. Go ahead and create your `Items`
controller too.

### Pokemon `types`, `index`, and `show`

Open __pokemon_controller.rb__. It should contain a basic skeleton for the
`Api::PokemonController` class. **Note that the namespace (`Api::`) precedes the
basic class name.**

Begin by defining a custom `types` action inside your `Api::PokemonController`
class. Look at the README from Pokedex Thunk again to see what this route should
return. Since this action returns static data, there is no need for any Jbuilder
views. Simply grab the data, put it into the expected format, and return it as
JSON directly from the controller using this format:

```rb
render json: <data_to_return>
```

That's it! To test your action, start up your server. Have your Rails
server listen on port 5000 rather than the default port 3000. You could
specify the port on the command line when starting the Rails server with the
`-p` flag, like this:

```sh
rails s -p 5000
```

Always having to specify the port can be a pain, however. Instead, go ahead and
change the default port in __config/puma.rb__. Look for the line `port
ENV.fetch("PORT") { 3000 }` (around line 18). This line specifies that the port
should be set to whatever is stored under the `PORT` environment variable. If
that variable is not set (such as during development), then fall back to the
port specified in the `{}`s, here `3000`. Just change `3000` to `5000`:

```rb
# config/puma.rb
# ...
# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port ENV.fetch("PORT") { 5000 }
# ...
```

Voilà! No more need for `-p 5000` on the command line.

After starting your server (`rails s`), pull up Postman and send a `GET` request
to `localhost:5000/api/pokemon/types`. Make sure that the response matches the
form specified by __Pokemon-API__.

Once you have verified that your backend is correctly returning the types, go
back to __pokemon_controller.rb__ and add `index` and `show` actions to your
`Api::PokemonController` class. Remember that all these actions need to do is
find the requested Pokemon--all Pokemon in the case of `index`, the specified
single Pokemon in the case of `show`--save it in an instance variable, and then
render the appropriate view. (How do you know which Pokemon you want to find in
`show`? **Hint:** Think about your routes.) If something goes wrong, render an
appropriate error message and a status code of `:not_found` (i.e., 404) instead.

To complete the `index` and `show` requests, you now need to define views that
will return the requested data in JSON format. It's time for Jbuilder!

## Jbuilder views

Because __config/routes.rb__ specifies that the `api` namespace defaults to
JSON-formatted responses (see above), Rails will look for an
__<action>.json.jbuilder__ template in a corresponding folder under
__app/views__ when rendering. Of course, since you selected an `api`, `minimal`
build, there is no __views__ folder under __app__. Create one now, then add an
__api__ folder to __app/views__ with additional folders for __pokemon__ and
__items__ inside. In the __pokemon__ folder, add files for each action you want
to render: currently, __index.json.jbuilder__ and __show.json.jbuilder__. Your
file structure should now look like this:

```text
app
└── views
    └── api
        ├── items
        └── pokemon
            ├── index.json.jbuilder
            └── show.json.jbuilder
```

Look at the API doc again to see what the `index` route should return. Once you
find the return value, copy it into the top of __index.json.jbuilder__ and
comment it out so you have an easily accessible record of what you need to
return.

The API shows that it should return an array of abbreviated Pokemon objects.
This is exactly what the `array!` command does in Jbuilder: create a top-level
array of objects. You can simply specify which attributes to extract from each
Pokemon in `@pokemon`:

```ruby
json.array! @pokemon, :id, :number, :name, :image_url, :captured
```

Copy that line into __index.json.jbuilder__ and send a Postman request for the
Pokemon index. (Look at the API description if you forget how to do this.) You
should see the names and characteristics of the various Pokemon in the response.
A frontend receiving this response likely would not be able to show any
associated images. Can you figure out why?

You have several tools to help you see and debug your Jbuilder results:

* Postman
* the server console (to see which templates are being called and when)
* `debugger`s in your Jbuilder code

(Once you build your frontend, you will also have access to the logger in the
frontend console and Redux DevTools.)

Some tools are better at catching certain errors than others, and you will
probably end up using all of these options at some point, so try to keep them
all in mind when you run into trouble.

For now, go to the response in Postman. Inspect the first `pokemon` and compare
it to the commented-out return value at the top of your Jbuilder file. Before
continuing, find the key that is different. The `pokemon` in your Postman
response probably looks similar to this:

```ruby
{
    "id": 1,
    "number": 1,
    "name": "Bulbasaur",
    "image_url": "/images/pokemon_snaps/1.svg"
    "captured": true,
}
```

Did you find the incorrect key? According to the API, the `image_url` key should
be camelCase--`imageUrl`--not the snake_case that your Rails database uses.
Address this issue programmatically by having Jbuilder always convert snake_case
keys to camelCase. To do this, add the following line to the end of
__config/environment.rb__:

```ruby
Jbuilder.key_format camelize: :lower
```

You've changed an environment setting, so you will need to restart your Rails
server for the change to take effect. Now when you try your Postman request
again, you should see the `image_url` key magically transformed into `imageUrl`.
Great!

The API provides a bit more information about this route, however. According to
__Pokedex-API.md__, the index route should serve up images only for captured
pokemon; pokemon still in the wild should have only a giant `?` for an image.
Jbuilder makes it easy to add this feature. Instead of automatically extracting
`image_url` with the other attributes, first check to see if the Pokemon is
captured. If it is, go ahead and return `image_url`. If not, have the template
return an `image_url` of `"/images/unknown.png"`. (You can use standard Ruby
`if`-clauses inside Jbuilder.)

Next, open __app/views/api/pokemon/show.json.jbuilder__ and copy in a
commented-out version of the API return value you need to create. You don't need
a top-level array this time, so just extract the values from `@pokemon` that you
want included in the Jbuilder object. Don't forget to return the `unknown` image
if the Pokemon is not captured!

Remember, too, that your Rails database does not have columns named `createdAt`
and `updatedAt`. How can you access that information? (**Hint:** Think about
`imageUrl`, and be glad that you made a programmatic change!) Also, note that
your previous programmatic change will **not** help you with `poke_type`; you
will need to address that attribute by explicitly setting the expected key and
assigning it the desired value.

Finally, you need to attach an array of `name`s to the key of `moves`. You can
access `@pokemon`'s `moves` through the `has_many` association that you set up
in your model: `@pokemon.moves`. This will return an array of `Moves`. Now you
want to iterate over that collection and create an array of the `name`s nested
under a key of `moves`. Remember that you can use normal Ruby functions in
Jbuilder and that you can always refer to the [Jbuilder docs][jbuilder] for help
if you get stuck.

That's it! When you have finished setting up your Jbuilder `show` file, go back
to Postman and test it out. The response should now include all the basic
details for that Pokemon. If it does, yea, you're ready to move on to `Items`!
If it does not, go back and debug.

## Items

You have defined the following routes for `Items`:

```sh
api_pokemon_items GET    /api/pokemon/:pokemon_id/items(.:format)   api/items#index {:format=>:json}
                  POST   /api/pokemon/:pokemon_id/items(.:format)   api/items#create {:format=>:json}
         api_item PATCH  /api/items/:id(.:format)                   api/items#update {:format=>:json}
                  PUT    /api/items/:id(.:format)                   api/items#update {:format=>:json}
                  DELETE /api/items/:id(.:format)                   api/items#destroy {:format=>:json}
```

Now you will write the controller actions and Jbuilder views for these routes.

First, set up your files. Open __app/controllers/api/items_controller.rb__ and
add skeletons to the `Api::ItemsController` class for the four controller
actions you will need. Next, under __views/api__, add a new folder __items__
containing Jbuilder files for `index` and `show`. (`create` and `update` will
both render `show`; `destroy` will not require Jbuilder.) Copy in and comment
out the appropriate API return values for each Jbuilder view.

Begin by implementing the controller action and Jbuilder view for `index`.
Their basic format will be very similar to the `Pokemon` `index` controller
action and view that you just wrote. If you get stuck, you can refer to the
`Pokemon` versions for help, but try to write these actions and views without
looking back. Once you have them implemented, test the API with Postman.

Next, implement `destroy`. All this action needs to do is call `Item.destroy`
with the `id` of the item to delete. As the API notes, you should return a JSON
object with the `id` of the deleted item. No need for Jbuilder here! Just
`render` the `json` return value directly. (If you don't remember how to do
this, look at `Api::PokemonController#types`.) Test your `destroy` action from
Postman to make sure that it works.

For `create` and `update`, set up strong params by defining a private
`item_params` method in `Api::ItemsController`
(__app/controllers/api/items_controller.rb__) that `require`s the item attribute
parameters to be nested under a key of `item` and `permit`s only legitimate
attribute parameters to come through. Then write `update`. It should render the
updated item's `show` view on success. If the update fails, render
`@item.errors.messages` under the `json` key and `:unprocessable_entity` under
`status`.

Now you need to write the Jbuilder `show` view in
__app/views/api/items/show.json.jbuilder__. Note that the return value for
`show` is the same as it is for an individual item in `index`. Let's keep your
code DRY by writing a partial!

Create a new file, __app/views/api/items/_item.json.jbuilder__, and copy in the
code for a single item from the `index` Jbuilder file. To call this partial,
just invoke `json.partial!` followed by the partial's path within the __views__
folder (omit the underscore before `_item`). A second argument is a hash
specifying the values of any arguments to be passed (here, `item`). For
instance, replace the copied code in __index.json.jbuilder__ with the following
partial call:

```rb
json.partial! 'api/items/item', item: item
```

That one line--appropriately modified--is all you need to include in
__show.json.jbuilder__.

Test your work by editing an item in Postman. First verify that your `update`
action correctly updates `name`, `happiness`, and `price` by sending updated
values in the body; that should be relatively straightforward. Next test that
you can update an item's image file and associated Pokemon. Here you will likely
run into difficulty: the image and associated Pokemon will not change.

To find out what is wrong, return to __app/controllers/api/items_controller.rb__
and insert a `debugger` inside `item_params`. Try submitting your previous edit
again. When you hit your `debugger` in the server console, type `params`. You
should see something like this (likely with different values for most of the
keys):

```rb
<ActionController::Parameters {"id"=>"17", "happiness"=>15, "name"=>"Super Happy Fun Ball", "price"=>30, "pokemonId"=>1, "imageUrl"=>"pokemon_berry.svg", "format"=>:json, "controller"=>"api/items", "action"=>"update", "item"=>{"id"=>17, "name"=>"Super Happy Fun Ball", "price"=>30, "happiness"=>15}} permitted: false>
```

As you hopefully noticed, the `id`, `name`, `price`, and `happiness` parameters
all appear both 1) at the top level and 2) nested under `items`. Now look back
at your Postman request. Where does your request nest **anything** under
`items`? It doesn't. So where does the `item` parameter with its hash of nested
attributes come from???

The answer, of course, is Rails magic. By default, when Rails receives a request
in **JSON format**, it figures out the likely model from the controller name and
then wraps parameters that correspond to that model's attributes under the model
name (here, `item`). (This is why `item_params` can require `item` even if the
frontend doesn't nest its JSON arguments under that key.) In other words, when
Rails gets the request from your frontend, it recognizes that `id`, `name`,
`price`, and `happiness` are all `Item` attributes and accordingly copies them
under a key of `item`, thereby enabling `item_params` to draw them forth.

Why doesn't Rails grab `imageUrl` and `pokemonId` too? It leaves those
parameters alone because they don't correspond to columns in the `Items` table:
the table's columns are `image_url` and `pokemon_id`. Just as you needed to
convert snake_case to camelCase when sending data back to the frontend, so you
need to convert camelCase to snake_case when receiving requests.

To perform this conversion programmatically, open
__app/controllers/application_controller.rb__. Add a private method to
convert params to snake_case and have it run before `create` and `update`:

```rb
# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  before_action :snake_case_params, only: [:create, :update]

  private
  def snake_case_params
    params.deep_transform_keys!(&:underscore)
  end
end
```

(Putting this code in `ApplicationController` will make it accessible to both
`Api::ItemsController` and `Api::PokemonController`.)

Type `c` (or `continue`) in your server console so that the server is once again
ready for requests, then submit your item edit request again. This time when you
look at the `params` in the server console, you should see something similar to
this:

```ruby
<ActionController::Parameters {"id"=>"17", "happiness"=>15, "name"=>"Super Happy Fun Ball", "price"=>30, "pokemon_id"=>1, "image_url"=>"pokemon_berry.svg", "format"=>:json, "controller"=>"api/items", "action"=>"update", "item"=>{"id"=>17, "name"=>"Super Happy Fun Ball", "price"=>30, "happiness"=>15}} permitted: false>
```

Hmmmm... that's still not quite what you wanted. Everything is now snake_case
(Yea!), but `image_url` and `pokemon_id` are still not nested under `item`. Can
you guess why?

The answer is that Rails wraps the parameters **before** your snake_case
conversion happens. A robust fix would accordingly involve setting up an
initializer to go through and transform everything to snake_case before the
wrapping occurs, but that's a little outside the scope of this project. Instead,
simply tell Rails to include `imageUrl` and `pokemonId` as parameters to nest by
adding the following line to `Api::ItemsController`:

```rb
# app/controllers/api/items_controller.rb
class Api::ItemsController < ApplicationController
  wrap_parameters include: Item.attribute_names + ['imageUrl', 'pokemonId']
  # ...
end
```

Now when you submit your edit form, `params` should look correct:

```rb
<ActionController::Parameters {"id"=>"17", "happiness"=>15, "name"=>"Super Happy Fun Ball", "price"=>30, "pokemon_id"=>1, "image_url"=>"pokemon_berry.svg", "format"=>:json, "controller"=>"api/items", "action"=>"update", "item"=>{"id"=>17, "name"=>"Super Happy Fun Ball", "price"=>30, "happiness"=>15, "image_url"=>"pokemon_berry.svg", "pokemon_id"=>1}} permitted: false>
```

Note the order in which things happen. When the JSON request comes in, Rails
grabs the parameters to wrap (now including `imageUrl` and `pokemonId`) and
duplicates them under the `item` key. Then, before `update` runs, Rails runs
`snake_case_params`, which converts all the parameters--even those that are
nested!--to snake_case. Finally, `update` runs and calls `item_params`.

Allow the request to finish processing. The response should now show a correctly
edited item. Success!

Now finish your item controller by writing the `create` action. According to
the API, an image_url will be supplied if `image_url` is not provided.
Accordingly, add this line **after** you have created the new `Item`:

```rb
@item.image_url ||= %w(pokemon_berry.svg pokemon_egg.svg pokemon_potion.svg pokemon_super_potion.svg).sample
```

As with `update`, render the `show` view on successful creation and
`@item.errors.messages` with an appropriate error `status` on failure. Once you
have finished, test your action from Postman to make sure it works.

## Pokemon `create` and `update`

Finish the project by filling out `create` and `update` for
`Api::PokemonController`. Try to do it without looking at your items controller,
although you can look back if you get stuck. Remember that you will need to add
a `wrap_parameters` line at the top of the class definition to include the one
camelCase parameter. You will also need to add `type` to the list of parameters
to wrap because it is not a `Pokemon` column name.

In fact, `type` requires a little more attention. Since `type` is a reserved
word in Rails, you had to name your `Pokemon` table column `poke_type`, but the
API lists `type` as the appropriate key. The simplest fix for this discrepancy
is to add an alias in the `Pokemon` model that will map any attribute named
`type` onto `poke_type`:

```rb
# app/models/pokemon.rb
class Pokemon < ApplicationRecord
  # ...
  alias_attribute :type, :poke_type
  # ...
end
```

Note that you also need to save/update `moves` separately: `moves` is not a
column in the `pokemons` table, so `Pokemon.new` will not create any `moves`. (A
corollary: you do not need to include `moves` as a permitted attribute in
`pokemon_params`. If you added it, go ahead and remove it.) Here are a few
things to keep in mind as you think about how to save/update the Pokemon's
`moves`:

* You can access the `moves` passed from Postman / a frontend through `params`.
* You can use assignment (`=`) with an association and Rails will automatically
  perform the necessary adjustments--both additions and deletions--on the
  intervening join table.
* You might find the [`find_or_create_by`] Active Record Relation method
  helpful.
* If saving/updating the `moves` fails, the whole create/update should fail
  without persisting anything to the database. To handle this possibility, wrap
  all of your related database operations in a [`transaction`].  

You've already written a Jbuilder `show` template for a Pokemon, so nothing more
is required to render a newly created/updated Pokemon. Now that you know how to
do partials in Jbuilder, however, go ahead and refactor your code so that the
elements common to the `index` and `show` templates reside in a partial. Once
you've finished, test your work in Postman to make sure everything still renders
correctly.

The only thing left to do is render the errors and an `unprocessable_entity`
status if `create` or `update` fails. You have relative freedom on the error
format. Just remember that the frontend will likely want to relay the error
message to the user, so you want them to be informative. Try to make it easy for
the frontend to render an error message like "Number: '1' is already in use" or
"Moves: can't be blank".

Things to consider:

* Should you use `errors.messages` or `errors.full_messages`? (What is the
  difference?)
* Should you use `new`/`save`, or `create`, or the `!` versions of those
  methods? (Again, what are the differences?)
* How will you handle error keys that do not correspond exactly to the keys
  expected by the frontend?

As you test, try to trigger validation errors for every field at least once.

This last task can be quite challenging, so don't worry if you find it
difficult. Well-deserved kudos, though, if you are able to get everything
working!

## What you've learned

In today's project, you built a Rails API backend server from scratch,
investigated how Rails handles parameters, and experienced some of the
challenges that arise when trying to make your code interface with a
pre-existing app. This enabled you to refresh your Ruby/Rails skills while also
practicing new syntactic sugar and patterns like Jbuilder that will serve you
well in your upcoming Full Stack Project.

[namespaces]: https://guides.rubyonrails.org/routing.html#controller-namespaces-and-routing
[nested-routes]: https://guides.rubyonrails.org/routing.html#nested-resources
[shallow-nesting]: https://guides.rubyonrails.org/routing.html#shallow-nesting
[jbuilder]: https://github.com/rails/jbuilder
[`find_or_create_by`]: https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Relation.html#method-i-find_or_create_by
[`transaction`]: https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Transactions/ClassMethods.html

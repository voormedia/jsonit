**NOTE: Jsonit is no longer maintained. We recommend you use
[Jbuilder](https://github.com/rails/jbuilder) instead. It offers similar
functionality.**

# Jsonit

Jsonit provides a way to quickly construct handcrafted json documents.
Jsonit requires objects to respond to `#to_json`.
It will attempt to load the json gem if this is not the case.

## Installation

`gem install jsonit`

## Usage


``` ruby
require 'json'    # Jsonit expects a #to_json method on object.
require 'jsonit'

# a simple object
Jsonit::Builder.new do |json|
  json.foo "bar"
end.to_json #=> {"foo":"bar"}

# nested object
Jsonit::Builder.new do |json|
  json.foo do
    json.bar "baz"
  end

  json.alpha do
    json.bravo do
      json.charlie "delta"
    end
  end
end.to_json #=> {"foo":{"bar":"baz"},"alpha":{"bravo":{"charlie":"delta"}}}

# arrays
Jsonit::Builder.new do |json|
  json.first [1, 2, 3]

  json.second [1, 2, 3] do |itm|
    json.value itm
  end
end.to_json #=> {"first":[1, 2, 3],"second":[{"value":1},{"value":2},{"value":3}]}

```

## Rails 3

Jsonit can be used with rails 3.

In `app/helpers/photos_helper.rb`

``` ruby
class PhotosHelper
  def photos
    Photo.all
  end
end
```

In `app/controllers/photos_controller.rb`

``` ruby
class PhotosController < ApplicationController
  respond_to :json
end

```

In `app/views/photos/index.json.jsonit`

``` ruby
json.ok true
json.data photos do |photo|
  photo.title    photo.title
  photo.location url_for(photo)
end
```

Result will be something like:

``` json
{
  "ok": true,
  "data": [
        {
          "title": "My First Photo",
          "location": "http://www.example.com/photos/1.json"
        }
  ]
}

```

## Sinatra

Jsonit can be used with Sinatra.

In your Gemfile:

``` ruby
gem 'json'
gem 'jsonit'
```

In `views/index.jsonit`:

``` ruby
json.foo "bar"
```

In your app:

``` ruby
class App < Sinatra::Base
  get "/" do
    jsonit :index
  end
end
```


## Padrino

Jsonit can be used with Padrino.

In your Gemfile:

``` ruby
gem 'json'
gem 'jsonit'
```

In `app/views/photos/index.json.jsonit`:

``` ruby
json.photos photos do |photo|
  json.title    photo.title
  json.location url_for(:photos, :show, :photo_id => photo.id)
end
```

In your controller:

``` ruby
MyApp.controllers :photos do
  helpers do
    def photos
      Photos.all
    end
  end

  get :index, :provides => :json do
    render :'photos/index'
  end

  get :show, :with => :photo_id, :provides => :json do
    render :'photos/show'
  end
end
```


## Project status

Jsonit is currently under active development.

## LICENSE

Json is Copyright (c) 2011 Voormedia B.V. and distributed under the MIT license. See the LICENSE file for more info.



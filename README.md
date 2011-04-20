# Jsonit

Jsonit provides a way to quickly construct json documents.  

## Usage

``` ruby
require 'json'
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

``` ruby
class PhotosController < ApplicationController
  respond_to :json

  private
  def photos
    Photo.all
  end
  helper_method :photos
end

```

`app/views/photos/index.json.jsonit`

``` ruby
json.ok true
json.data photos do |photo|
  photo.title photo.title
  photo.location url_for(photo)
end
```

result:

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

## Project status

Jsonit is currently under active development and not yet released as gem.


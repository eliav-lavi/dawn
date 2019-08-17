# Dawn
`Dawn` is a simple and intuitive instances container for Ruby. It was born out of the need to reference existing application instances in Rails controllers, without having to re-initialize them upon each controller call or using the singleton pattern; however, while `Dawn` can be used in a Rails app, it may fit any Ruby application that is built with dependency injection in mind.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dawn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dawn

## Usage

`Dawn` allows you to build a container of namespaces which are registered with instances. Upon the booting stages of your application, you might want to initialize instances of classes which serve different purposes (e.g. `ChargeCreationService` for handling the complexity of creating a new charge in your system), accross different business domains. That way you can reference those instances later, when requests start arriving at your application, without having re-initialize those instances each time. This idea also allows you to build your app as a hierarchical tree of dependnecies, as will be demonstrated later.

You can build a `Dawn` container with multiple namespaces, each namespace having a unique name and containing several instances:

```ruby
# Assuming instance_a and instance_b were just initialized:
foo_namespace_request = Dawn::Namespace::Request.new(name: :foo) do |namespace|
    namespace
        .set(key: :instance_a, instance: instance_a)
        .set(key: :instance_b, instance: instance_b)
end

CONTAINER = Dawn::Container.build([foo_namespace_request])
```

Later, you may fetch instances from the container:
```ruby
CONTAINER.fetch(namespace: foo, key: :instance_a)
```
![](https://i.imgur.com/GFEKDlh.png)

### Dependency Injection Based Applications
Since `Dawn` was created to support the development of dependency injection based application, I will briefly discuss this topic in this section. Usage in Rails will be clearer hence.

Crafting your application as such that is based on a nested tree of injected dependencies has many benefits that has been described in many writings before. That is, in contrary to an opposing design choice, which is fairly common in the Ruby eco-system, in which dependencies are hard coded. The following example demonstrates this in a nutshell.

Assuming some `FooService` class:

```ruby
class FooService
    def call
        # Return some value / do something
    end
end
```

We can use it as a dependency in another class, `BarService` in two ways. Either directly, as an hard-coded dependency:
```ruby
class BarService
    def call
        FooService.new.call
    end
end
```

Or as injected dependency:
```ruby
class BarService
    def self.build
        foo_service = FooService.new
        new(foo_service: foo_service)
    end

    def initialize(foo_service:)
        @foo_service = foo_service
    end
    def call
        @foo_service.call
    end
end
```

This is just a single level of dependency, real-life application are often much more nested.
Notice that I did mentioned `FooService` in an hard-coded fashion, in my `.build` method, but that is just a helper method to get the common usage of `BarService` instances and its not on the instant scope, but on the class scope. I can pass anything I want to `BarService#initialize`.

I urge you to read more about dependency injection, but the advantages of the latter approach are numerous! From testing to code reusability, dependency injection is a real thing, and it doesn't have to be complex or scary at all.

### Usage In Rails
One problem that sometimes  emerges is that we don't have control of everything in our application, and the most prominent example is if we are building our application on top of Rails. When Rails receives a request to a certain route, it will find the controller which is registered with this route **and will initialize a new instance of that controller with the parameters of the request as the instance variable `@param`**. This pattern is the complete opposite of dependency injection based design, but we have nothing to do about it (other than not using Rails, which is not always a choice we can make).
While we cannot change this behaviour of Rails - a new controller instance will be created upon each request - we can choose to stop this pattern right there, and use pre-initialized instances from there on. This is where `Dawn` becomes really helpful.

For example, let's assume some `ChargesController`, whose `#create` method needs to pass request's data to some `ChargeCreationService`. Usually, the implementation would look like this:
```ruby
    class ChargesController < ApplicationController
        def create
            ChargeCreationService.new.call(params[:charge])
            
            # Note: In this manner, ChargeCreationService instances have no members / instance variables.
            # Some people also do the following, which might feel slicker at first:
            # ChargeCreationService.new(params[:charge]).call
            # Honestly, assuming ChargeCreationService has dependencies of it's own, both feel wrong to me.
        end
    end
```

With `Dawn` we can do this:
```ruby
    class ChargesController < ApplicationController
        def create
            # Assuming we initialized a proper Dawn container in the initialization stages of our application, and assigned it the the global const CONTAINER:

            service = CONTAINER.fetch(namespace: :charges, key: :creation_service)
            service.call(params[:charge])
        end
    end
```

Rails offers the `after_initialize` hook that you can use in `application.rb` - this is a proper place to initialize your `Dawn::Container`. In the previous example, I have referenced it from the top level contsant `CONTAINER`, which could be assigned there. See [here](https://guides.rubyonrails.org/configuring.html#rails-general-configuration) for more info on `after_initialize`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Feature Requests

Dawn is open for changes and requests!
If you have an idea, a question or some need, feel free to contact me here or at eliavlavi@gmail.com.

## Contributing

1. Fork it ( https://github.com/eliav-lavi/dawn/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

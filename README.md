# Korolev

Minimalistic gem

Korolev allows you to have multiple constructors in Ruby with just one
simple declaration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'korolev'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install korolev

## Usage

Constructors defined with Korolev work the same way as real Ruby 
construtors in all senses.
 
konstructor call implies private, i.e. all constructors will be private methods even if they
are declared as public.

You can place call to konstructor with names anywhere. It works similar to private, 
public calls, you can use it with symbol or without.
When used without, it will affect only the next method. When used with name, 
it can be used before and after method definition. Named and nameless declarations can be mixed.

Passing of blocks also works.

Using reserved method names 'new' and 'initialize' for custom constructor definition will raise an error.

### Inheritance

Since konstructor is a instance method, you can override it in subclass and call super as usual. Once method is
a marked constructor in hierarchy, it is always a constructor.

Inherited methods can't be to constructor in subclass, you should define a new constructor in subclass
and reuse inherited method.

### Defining konstructors in Modules

Use ActiveSupport::Concern and define constructor in your ClassMethods or write on inlcuded hook manually.

### Reserved names
Reserved konstructor names are `new` and `initialize`, since they are used by default constructor.

### is_konstrutor?

You can always check if certain instnace method name is a constructor. It will return true for `initialize` and
all additional constructors. It will return true even if there is not such konstructor has been defined yet.

### Conflicts with other gems

Korolev written way that avoid any conflict with other gem. If you find a gem that Korolev conflicts with, please
open an issue and give an example code.

Korolev works with gems that use the same metaprogramming approach, such as rake, thor, contracts, etc.

When you include Korolev only one method `konstructor` is defined. 
Until method `konstructor` is called in class, the class is not affected any other way.
  
There are not 
  
### Getting rid of includes
  
This is totally safe, there is no perfomance penalty, no conflicts. Just add to gemfile
```ruby
gem 'korolev', require: 'korolev/core_ext'
```
And you will have `konstructor` method in all your classes. Until you
call `konstructor` in your class, it is not affected in any other way. 

## Details

In Ruby constructors are actually factories and it is a pair of class and instance methods. For motivation 
behind such approach and an step by step explanation of how gem works you can read this article.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/snovity/korolev. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


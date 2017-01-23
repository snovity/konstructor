[![Gem Version](http://img.shields.io/gem/v/konstructor.svg)][gem]
[![Build Status](http://img.shields.io/travis/snovity/konstructor.svg)][travis]
[![Coverage Status](http://img.shields.io/coveralls/snovity/konstructor.svg)][coveralls]

[gem]: https://rubygems.org/gems/konstructor
[travis]: http://travis-ci.org/snovity/konstructor
[coveralls]: https://coveralls.io/r/snovity/konstructor

# Konstructor

Konstructor is a small gem that gives you multiple
constructors in Ruby.

Use `konstructor` keyword to define constructors additional to the defaul one:
```ruby
class SomeClass
  konstructor
  def create(val)
    @val = val
  end 
  
  attr_reader :val
end

obj0 = SomeClass.new
obj0.val # nil

obj1 = SomeClass.create(3)
obj1.val # 3
```
It's similar to having overloaded constructors in other languages.

## Installation

Via Gemfile:

```ruby
gem 'konstructor' 
```

and then execute `bundle`. 

You can also install it without Bundler:

    $ gem install konstructor

If you are a gem author or just wish to manually include Konstructor 
in your classes only when you need it, see 
[Manual include](https://github.com/snovity/konstructor/wiki/Manual-include) page.
   
## Usage

In its simplest form `konstructor` creates a 
constructor from the next method.

 ```ruby
  konstructor
  def create
  end
 
  konstructor
  def recreate
  end
 ```
 
When method names are given, it creates constructors from 
those methods without affecting the next method.
 
 ```ruby
  konstructor :create, :recreate
 
  def not_constructor
  end
 
  def create
  end
 
  def recreate
  end
 ```
 
 Call with method names can be placed anywhere in class definition.
 
 ```ruby
  def create
  end
  konstructor :create
  
  konstructor
  def recreate
  end
 ```
 
 In all above cases the class will have the default constructor 
 and two additional ones.
 
 ```ruby
 obj0 = SomeClass.new
 obj1 = SomeClass.create
 obj2 = SomeClass.recreate
 ```
 
#### Same as default constructor
 
Additional constructors work exactly the same way as 
built-in Ruby constructor. 

You can pass blocks to them. 

```ruby
  konstructor
  def create(val)
    @val = yield val
  end
  #...

obj = SomeClass.create(3) { |v| v*3 }
obj.val # 9
```

You can override them in subclasses and call `super`.
```ruby
class SomeClass
  konstructor
  def create(val)
    @val = val
  end
  
  attr_reader :val
end

class SomeSubclass < SomeClass
  def create(val1, val2)
    super(val1 * val2)
  end
end

obj = SomeSubclass.create(2, 3)
obj.val # 6
``` 
Once method is a marked as konstructor in hierarchy, 
it is always a konstructor.

There are certain of what can be marked `konstructor`, see
[Limitations page](https://github.com/snovity/konstructor/wiki/Limitations)
for details

#### Declaring in Modules

Modules can't have konstructors. Use `ActiveSupport::Concern` and 
declare konstructor in `included` block.

```ruby
module SomeModule
  extend ActiveSupport::Concern
    
  included do      
    konstructor :create
  end
    
  def create
  end
end        
```

#### Removing default constructor

If you decide to remove the defaul Ruby constructor for some reason,
you can effectively do it by marking it as private using built-in Ruby 
method:
```ruby
class SomeClass
  private_class_method :new
end   
```

#### Using with other gems

Konstructor doesn't affect other gems, including those
that depend on metaprogramming, such as 
[rake](https://github.com/ruby/rake),
[thor](https://github.com/erikhuda/thor), 
[contracts](https://github.com/egonSchiele/contracts.ruby), etc.

For instnace, this is how Konstructor works with contracts:
```ruby
class SomeClass
  konstructor
  Contract Num => SomeClass
  def create(some_number)
    @number = some_number
  end
end    
```
  
If you stumble upon a metaprogramming gem that 
conflicts with Konstructor, please 
[open an issue](https://github.com/snovity/konstructor/issues/new).
  
## Details

Ruby constructor is a pair consisting of public factory method defined
on a class and a private instance method. Therefore, to achieve 
its goal `konstructor` marks instance method as private and defines a 
corresponding public class method with the same name.

#### Performance
 
Konstructor does all its work when class is being defined. Once class
has been defined, it's just standard Ruby instance creation.
Therefore, there is no runtime performance penalty. 

Konstructor doesn't depend on other gems.
  
#### Thread safety
  
Konstructor is thread safe.

## Contributing

Bug reports and pull requests are welcome on GitHub at 
https://github.com/snovity/konstructor. This project is intended to be
a safe, welcoming space for collaboration, and contributors are 
expected to adhere to the 
[Contributor Covenant](http://contributor-covenant.org) 
code of conduct.

## License

The gem is available as open source under the terms of the 
[MIT License](http://opensource.org/licenses/MIT).


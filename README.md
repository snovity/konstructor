[![Gem Version](http://img.shields.io/gem/v/konstructor.svg)][gem]

[gem]: https://rubygems.org/gems/konstructor

# Konstructor

Konstructor is a small gem that gives you multiple
constructors in Ruby.

To define custom constructors use `konstructor` keyword:
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
gem 'konstructor' #, require: 'konstructor/core_ext' 
```

and then execute `bundle`. 

Uncomment require option to skip adding 
`include Konstructor` every time you want to use `konstructor` keyword. 

You can also install it without Bundler:

    $ gem install konstructor

## Usage

When no names are given `konstructor` just affects the next method:

 ```ruby
 konstructor
 def create
 end
 
 konstructor
 def recreate
 end
 ```
 
 When names are given, it makes those methods konstructors:
 
 ```ruby
 konstructor :create, :recreate
 
 def create
 end
 
 def recreate
 end
 ```
 
 Call with names can be placed anywhere in class definition:
 
 ```ruby
  def create
  end
  konstructor :create
  
  konstructor
  def recreate
  end
 ```
 
 In all above cases the class will have the default constructor 
 and two custom ones:
 
 ```ruby
 obj0 = SomeClass.new
 obj1 = SomeClass.create
 obj2 = SomeClass.recreate
 ```
 
### Same as default constructor
 
Konstructors work exactly the same way as built-in Ruby constructor.
You can pass blocks to them: 

```ruby
konstructor
def create(val)
  @val = yield val
end

obj = SomeClass.create(3) { |v| v*3 }
obj.val # 9
```

You can override konstructors in subclasses and call `super`. 
Once method is a marked as konstructor in hierarchy, 
it is always a konstructor.
                                   
Methods inherited from superclasses can't become konstructors in 
subclasses. To achieve the effect, define a new method, 
mark it as konstructor and call the inherited one. 

### Reserved names

Using reserved method names `new` and `initialize` for custom 
constructor definition will raise an error:
```ruby
konstructor
def initialize # raises Konstructor::ReservedNameError
end
```
or
```ruby
konstructor
def new # raises Konstructor::ReservedNameError
end
```

### Defining konstructors in Modules

Modules can't have konstructors. Use `ActiveSupport::Concern` and 
define konstructor in `included` block.

### Using with other gems

Konstructor doesn't affect other gems, including those
that depend on metaprogramming, such as rake, thor, contracts, etc.

For instnace, Konstructor works with contracts gem:
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
conflicts with Konstructor, please open an issue.

### Removing default constructor

You can effectively remove default Ruby construtor
by marking it as private:
```ruby
class SomeClass
  private_class_method :new
end   
```
 
## Performance
 
Konstructor does all its work when class is being defined. Once class
has been defined, it's just standard Ruby instance creation.
Therefore, it's as fast as standard Ruby constructor. 

If there is a slowdown during startup, it should be comparable 
to the one of `attr_accessor` or `ActiveSupport::Concern`. 
  
## Thread safety
  
Konstructor is thread safe.
  
## Details

Ruby constructor is a pair consisting of public factory method defined
on a class and a private instance method. Therefore, 
`konstructor` marks instance method as private and defines a 
corresponding public class method with the same name.

You can check if certain instance method name has been declared as 
constructor or is a default constructor by running.
```ruby
Konstructor.is?(SomeClass, :initialize) # true
Konstructor.is?(SomeClass, :create) # true
Konstructor.is?(SomeClass, :recreate) # true
Konstructor.is?(SomeClass, :something_else) # false
``` 
 
It will return true even if there is not such constructor has 
been defined yet. Like:
```ruby
class SomeClass
  konstructor :create
end
```
Konstructor body may be supplied in subclasses.

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


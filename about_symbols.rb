require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutSymbols < EdgeCase::Koan
  def test_symbols_are_symbols
    symbol = :ruby
    assert_equal true, symbol.is_a?(Symbol)
  end

  def test_symbols_can_be_compared
    symbol1 = :a_symbol
    symbol2 = :a_symbol
    symbol3 = :something_else

    assert_equal true, symbol1 == symbol2
    assert_equal false, symbol1 == symbol3
  end

  # A Ruby symbol is a constant, unique name, but its contens can't be changed
  
  def test_identical_symbols_are_a_single_internal_object
    symbol1 = :a_symbol
    symbol2 = :a_symbol

    assert_equal true, symbol1           == symbol2
    assert_equal true, symbol1.object_id == symbol2.object_id
  end
  
  # Unlike strings, symbols of the same name are initialized and exist in memory 
  # only once during a session of ruby. Symbols are most obviously useful when 
  # youÕre going to be reusing strings representing something else.
  
  # even if the symbol was used as a key in two different hashes they are still the 
  # same object so for example, patient1 and patient2 :ruby keys would be the same object
  
  # patient1 = { :ruby => "red" }
  # patient2 = { :ruby => "testing" }
  # patient1.each_key {|key| puts key.object_id.to_s]
  # patient2.each_key {|key| puts key.object_id.to_s}
  # both result in 3918094 so its the same object
  
  # Two symbols with the same name are always the same underlying object:
  # so "open".object_id != "open".object_id 
  # but :open.object_id == :open.object_id
  
  def test_method_names_become_symbols
    symbols_as_strings = Symbol.all_symbols.map { |x| x.to_s }
    assert_equal true, symbols_as_strings.include?("test_method_names_become_symbols")
  end

  # THINK ABOUT IT:
  #
  # Why do we convert the list of symbols to strings and then compare
  # against the string value rather than against symbols?

  # Because Symbols aren't Strings so we have to convert them to strings to do a 
  # string compare on the values. A later test shows that using .eql? doesn't work
  
  # Great tips on how to think between the two:
  # (1) If the contents (i.e. the sequence of characters) of the object is important, use a String.
  # (2) If the identity of the object is important, use a Symbol.
  
  in_ruby_version("mri") do
    RubyConstant = "What is the sound of one hand clapping?"
    def test_constants_become_symbols
      all_symbols = Symbol.all_symbols

      assert_equal false, all_symbols.include?(RubyConstant)
    end
  end

  def test_symbols_can_be_made_from_strings
    string = "catsAndDogs"
    assert_equal :catsAndDogs, string.to_sym
  end

  def test_symbols_with_spaces_can_be_built
    symbol = :"cats and dogs"

    assert_equal symbol, :"cats and dogs".to_sym
  end

  def test_symbols_with_interpolation_can_be_built
    value = "and"
    symbol = :"cats #{value} dogs"

    assert_equal symbol, :"cats and dogs".to_sym
  end

  def test_to_s_is_called_on_interpolated_symbols
    symbol = :cats
    string = "It is raining #{symbol} and dogs."

    assert_equal "It is raining cats and dogs.", string
  end

  def test_symbols_are_not_strings
    symbol = :ruby
    assert_equal false, symbol.is_a?(String)
    assert_equal false, symbol.eql?("ruby") # even if ":ruby" result is false
  end
  
  # Symbols are not Strings but they can be converted using .to_s and vice versa, 
  # where Strings can be converted to Symbols using .to_sym
  
  def test_symbols_do_not_have_string_methods
    symbol = :not_a_string
    assert_equal false, symbol.respond_to?(:each_char)
    assert_equal false, symbol.respond_to?(:reverse)
  end

  # It's important to realize that symbols are not "immutable
  # strings", though they are immutable. None of the
  # interesting string operations are available on symbols.

  def test_symbols_cannot_be_concatenated
    # Exceptions will be pondered further father down the path
    assert_raise(NoMethodError) do
      :cats + :dogs
    end
  end
  
  # while symbols can't be concatenated you can convert each to a string, concatenate 
  # the strings and them convert to a symbol, for example:
  #
  # puts (:test1.to_s + " " + :test2.to_s).to_sym
  # puts :"test1 test2".is_a?(Symbol)
  
  def test_symbols_can_be_dynamically_created
    assert_equal :catsdogs, ("cats" + "dogs").to_sym
  end

  # THINK ABOUT IT:
  #
  # Why is it not a good idea to dynamically create a lot of symbols?
  
  # Creating a lot of symbols dynamically allocates a lot of memory that can't be 
  # freed until the program ends. Ruby Symbols are put into memory only once so they 
  # are very efficient for things like hash keys.
end
require File.expand_path(File.dirname(__FILE__) + '/edgecase')

def my_global_method(a,b)
  a + b
end

class AboutMethods < EdgeCase::Koan

  def test_calling_global_methods
    assert_equal 5, my_global_method(2,3)
  end

  def test_calling_global_methods_without_parentheses
    result = my_global_method 2, 3
    assert_equal 5, result
  end

  # (NOTE: We are Using eval below because the example code is
  # considered to be syntactically invalid).
  # Easy fix, can either wrap everything in parenthesis to be clear 
  # or on the inner most method.
  def test_sometimes_missing_parentheses_are_ambiguous
    eval "assert_equal(5, my_global_method(2, 3))" # ENABLE CHECK
    #
    # Ruby doesn't know if you mean:
    #
    #   assert_equal(5, my_global_method(2), 3)
    # or
    #   assert_equal(5, my_global_method(2, 3))
    #
    # Rewrite the eval string to continue.
    #
  end

  # NOTE: wrong number of argument is not a SYNTAX error, but a
  # runtime error.
  def test_calling_global_methods_with_wrong_number_of_arguments
    exception = assert_raise(ArgumentError) do
      my_global_method
    end
    assert_match(/wrong number/, exception.message)

    exception = assert_raise(ArgumentError) do
      my_global_method(1,2,3)
    end
    assert_match(/wrong number/, exception.message)
  end

  # ------------------------------------------------------------------

  def method_with_defaults(a, b=:default_value)
    [a, b]
  end

  def test_calling_with_default_values
    assert_equal [1, :default_value], method_with_defaults(1)
    assert_equal [1, 2], method_with_defaults(1, 2)
  end

  # ------------------------------------------------------------------

  def method_with_var_args(*args)
    args
  end
  
  # Fairly straightforward, very much just like ..rest in AS3, the 
  # rest parameter is an array. If passing no arguments then the 
  # answer for the first assertion is actually an empty array. Would 
  # have expected nil here (in comparison to AS3 I'm not sure if 
  # ..rest defaults to an empty array but I think it does).
  def test_calling_with_variable_arguments
    assert_equal [], method_with_var_args
    assert_equal [:one], method_with_var_args(:one)
    assert_equal [:one, :two], method_with_var_args(:one, :two)
  end

  # ------------------------------------------------------------------

  # Whatever is last in the method is by default the return value but 
  # since we have an explicit return statement that will be the value 
  # used instead.
  def method_with_explicit_return
    :a_non_return_value
    return :return_value
    :another_non_return_value
  end

  def test_method_with_explicit_return
    assert_equal :return_value, method_with_explicit_return
  end

  # ------------------------------------------------------------------

  # Whatever is last in the method is by default the return value.
  def method_without_explicit_return
    :a_non_return_value
    :return_value
  end

  def test_method_without_explicit_return
    assert_equal :return_value, method_without_explicit_return
  end

  # ------------------------------------------------------------------

  def my_same_class_method(a, b)
    a * b
  end

  def test_calling_methods_in_same_class
    assert_equal 12, my_same_class_method(3,4)
  end
  
  # I don't think this would be different than using the "this" 
  # keyword in AS3 or JS to call the method. Need a refresher.
  def test_calling_methods_in_same_class_with_explicit_receiver
    assert_equal 12, self.my_same_class_method(3,4)
  end

  # ------------------------------------------------------------------

  def my_private_method
    "a secret"
  end
  private :my_private_method

  def test_calling_private_methods_without_receiver
    assert_equal "a secret", my_private_method
  end

  # Exception message also reports the word "private" so its aware 
  # that it is rather than just stating it doesn't exist.
  def test_calling_private_methods_with_an_explicit_receiver
    exception = assert_raise(NoMethodError) do
      self.my_private_method
    end
    assert_match /method/, exception.message
  end

  # ------------------------------------------------------------------

  class Dog
    def name
      "Fido"
    end

    private

    def tail
      "tail"
    end
  end

  def test_calling_methods_in_other_objects_require_explicit_receiver
    rover = Dog.new
    assert_equal "Fido", rover.name
  end

  def test_calling_private_methods_in_other_objects
    rover = Dog.new
    assert_raise(NoMethodError) do
      rover.tail
    end
  end
  
end
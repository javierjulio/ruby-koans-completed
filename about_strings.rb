require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutStrings < EdgeCase::Koan
  def test_double_quoted_strings_are_strings
    string = "Hello, World"
    assert_equal true, string.is_a?(String)
  end

  def test_single_quoted_strings_are_also_strings
    string = 'Goodbye, World'
    assert_equal true, string.is_a?(String)
  end

  def test_use_single_quotes_to_create_string_with_double_quotes
    string = 'He said, "Go Away."'
    assert_equal "He said, \"Go Away.\"", string
  end

  def test_use_double_quotes_to_create_strings_with_single_quotes
    string = "Don't"
    assert_equal 'Don\'t', string
  end

  def test_use_backslash_for_those_hard_cases
    a = "He said, \"Don't\""
    b = 'He said, "Don\'t"'
    assert_equal true, a == b
  end

  def test_use_flexible_quoting_to_handle_really_hard_cases
    a = %(flexible quotes can handle both ' and " characters)
    b = %!flexible quotes can handle both ' and " characters!
    c = %{flexible quotes can handle both ' and " characters}
    assert_equal true, a == b
    assert_equal true, a == c
  end

  def test_flexible_quotes_can_handle_multiple_lines
    long_string = %{
It was the best of times,
It was the worst of times.
}
    assert_equal 54, long_string.size
  end

  # puts %{It was the best of times, It was the worst of times.}.size
  # that gives an output of 52, but since we should be expecting 54, that means 
  # the 2 line breaks are counted in the size
  
  def test_here_documents_can_also_handle_multiple_lines
    long_string = <<EOS
It was the best of times,
It was the worst of times.
EOS
    assert_equal 53, long_string.size
  end
  
  # hmm, based on the previous notes I don't understand why this is 53?
  
  def test_plus_will_concatenate_two_strings
    string = "Hello, " + "World"
    assert_equal "Hello, " + "World", string
  end

  def test_plus_concatenation_will_leave_the_original_strings_unmodified
    hi = "Hello, "
    there = "World"
    string = hi + there
    assert_equal "Hello, ", hi
    assert_equal "World", there
  end

  def test_plus_equals_will_concatenate_to_the_end_of_a_string
    hi = "Hello, "
    there = "World"
    hi += there
    assert_equal "Hello, World", hi
  end

  def test_plus_equals_also_will_leave_the_original_string_unmodified
    original_string = "Hello, "
    hi = original_string
    there = "World"
    hi += there
    assert_equal "Hello, ", original_string
  end
  
  # using += doesn't change the original string object, note that since "hi" was 
  # set to "original_string" when appending values to "hi" using +=, the "original_string" 
  # remains unmodified, this is an important difference as when using the << operator 
  # it would modify the original
          
  def test_the_shovel_operator_will_also_append_content_to_a_string
    hi = "Hello, "
    there = "World"
    hi << there
    assert_equal "Hello, World", hi
    assert_equal "World", there
  end

  def test_the_shovel_operator_modifies_the_original_string
    original_string = "Hello, "
    hi = original_string
    there = "World"
    hi << there
    assert_equal "Hello, World", original_string

    # THINK ABOUT IT:
    #
    # Ruby programmers tend to favor the shovel operator (<<) over the
    # plus equals operator (+=) when building up strings.  Why?
  end

  # hi = original_string
  #
  # this means we are assigning a reference (a place in memory that points to the referenced 
  # value). Its a place the holds the memory address of the referenced value of the string 
  # "original_string" to the variable "hi" and when working with the variable "hi" it means 
  # we are working on its referenced object "original_string"
  # 
  # when using << we are changing the object on the left hand side so since "hi" 
  # was set to a reference of the variable "original_string" thus "original_string"s 
  # value now changes to contain whatever was being appended
  
  def test_double_quoted_string_interpret_escape_characters
    string = "\n"
    assert_equal 1, string.size
  end

  def test_single_quoted_string_do_not_interpret_escape_characters
    string = '\n'
    assert_equal 2, string.size
  end

  # interesting, when using single quotes this has a length of 2, otherwise its 1
  
  def test_single_quotes_sometimes_interpret_escape_characters
    string = '\\\''
    assert_equal 2, string.size
    assert_equal "\\'", string
  end
  
  # first test result is 2 because \\ cancel out and then the outer single qoutes define 
  # the string so that just leaves us with \' so we have a size of 2
  # not sure why on the second test result

  def test_double_quoted_strings_interpolate_variables
    value = 123
    string = "The value is #{value}"
    assert_equal "The value is 123", string
  end

  # placeholders, simple string substitution, the variable name goes within #{} and 
  # whenever that style syntax exists in a double quoted string it is replaced
  # note: requires double quotes!!
  
  def test_single_quoted_strings_do_not_interpolate
    value = 123
    string = 'The value is #{value}'
    assert_equal 'The value is #{value}', string
  end

  def test_any_ruby_expression_may_be_interpolated
    string = "The square root of 5 is #{Math.sqrt(5)}"
    assert_equal "The square root of 5 is 2.23606797749979", string
  end

  def test_you_can_get_a_substring_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal "let", string[7,3]
    assert_equal "let", string[7..9]
  end
  
  # substring is 0 based
  # the first param is the start index, second is the length
  # with ranges the first param is the start index and the second is the end index
  
  def test_you_can_get_a_single_character_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal 97, string[1]

    # Surprised?
    # Yes!
  end

  in_ruby_version("1.8") do
    def test_in_ruby_1_8_single_characters_are_represented_by_integers
      assert_equal 97, ?a
      assert_equal true, ?a == 97
      assert_equal true, ?b == (?a + 1)
    end
  end

  in_ruby_version("1.9") do
    # NOT TESTED, running Ruby 1.8.7
    def test_in_ruby_1_9_single_characters_are_represented_by_strings
      assert_equal "a", ?a
      assert_equal "a", ?a == 97
    end
  end

  def test_strings_can_be_split
    string = "Sausage Egg Cheese"
    words = string.split
    assert_equal ["Sausage", "Egg", "Cheese"], words
  end

  def test_strings_can_be_split_with_different_patterns
    string = "the:rain:in:spain"
    words = string.split(/:/)
    assert_equal ["the", "rain", "in", "spain"], words

    # NOTE: Patterns are formed from Regular Expressions.  Ruby has a
    # very powerful Regular Expression library.  We will become
    # enlightened about them soon.
  end

  def test_strings_can_be_joined
    words = ["Now", "is", "the", "time"]
    assert_equal "Now is the time", words.join(" ")
  end

  # split and join work very much the same way as in AS3/JS
  
  def test_strings_are_not_unique_objects
    a = "a string"
    b = "a string"
    
    assert_equal true, a == b
    assert_equal false, a.object_id == b.object_id
  end
  
  # strandard stuff, strings match in value so first is true but second will 
  # be false since they are unique instances
  
end
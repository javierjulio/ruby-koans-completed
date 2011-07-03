require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutIteration < EdgeCase::Koan

  def test_each_is_a_method_on_arrays
    assert_equal true, [].methods.include?("each")
  end

  def test_iterating_with_each
    array = [1, 2, 3]
    sum = 0
    array.each do |item|
      sum += item
    end
    assert_equal 6, sum
  end

  def test_each_can_use_curly_brace_blocks_too
    array = [1, 2, 3]
    sum = 0
    array.each { |item|
      sum += item
    }
    assert_equal 6, sum
  end

  def test_break_works_with_each_style_iterations
    array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    sum = 0
    array.each { |item|
      break if item > 3
      sum += item
    }
    assert_equal 6, sum
  end

  def test_collect_transforms_elements_of_an_array
    array = [1, 2, 3]
    new_array = array.collect { |item| item + 10 }
    assert_equal [11, 12, 13], new_array

    # NOTE: 'map' is another name for the 'collect' operation
    another_array = array.map { |item| item + 10 }
    assert_equal [11, 12, 13], another_array
  end

  def test_select_selects_certain_items_from_an_array
    array = [1, 2, 3, 4, 5, 6]

    even_numbers = array.select { |item| (item % 2) == 0 }
    assert_equal [2, 4, 6], even_numbers

    # NOTE: 'find_all' is another name for the 'select' operation
    more_even_numbers = array.find_all { |item| (item % 2) == 0 }
    assert_equal [2, 4, 6], more_even_numbers
  end

  # Read this wrong at first, its not size equals 4 but greater than
  def test_find_locates_the_first_element_matching_a_criteria
    array = ["Jim", "Bill", "Clarence", "Doug", "Eli"]
    
    assert_equal "Clarence", array.find { |item| item.size > 4 }
  end

  def test_inject_will_blow_your_mind
    result = [2, 3, 4].inject(0) { |sum, item| sum + item }
    assert_equal 9, result

    result2 = [2, 3, 4].inject(1) { |sum, item| sum * item }
    assert_equal 24, result2

    # Extra Credit:
    # Describe in your own words what inject does.
    # 
    # The inject method takes a block that will be executed for every element 
    # in the object we called the inject method on. So since its an array of 3
    # elements, the block will execute for each of the 3 elements.
    # 
    # The first argument of the block is the argument given to the inject 
    # method. This will be the result once its all done so think of it as 
    # creating a counter variable outside a loop that within a loop you are 
    # changing. 
    # 
    # The second parameter is the first element from the object inject was 
    # called on. So in the array example above that would be 2. The next 
    # time the block runs the second parameter is 3, then 4, etc.
  end
  
  # The map method always returns an array but can workon other collections 
  # as well. A key point here to remember is that Ruby will use the value 
  # from the last line as a return value, so that's a handy way to remember 
  # that seeing item + 10 will return that as a value within the result array.
  def test_all_iteration_methods_work_on_any_collection_not_just_arrays
    # Ranges act like a collection
    result = (1..3).map { |item| item + 10 }
    assert_equal [11, 12, 13], result

    # Files act like a collection of lines
    File.open("example_file.txt") do |file|
      upcase_lines = file.map { |line| line.strip.upcase }
      assert_equal ["THIS", "IS", "A", "TEST"], upcase_lines
    end

    # NOTE: You can create your own collections that work with each,
    # map, select, etc.
  end

  # Bonus Question:  In the previous koan, we saw the construct:
  #
  #   File.open(filename) do |file|
  #     # code to read 'file'
  #   end
  #
  # Why did we do it that way instead of the following?
  #
  #   file = File.open(filename)
  #   # code to read 'file'
  #
  # When you get to the "AboutSandwichCode" koan, recheck your answer.
  # 
  # I still don't understand this one.

end

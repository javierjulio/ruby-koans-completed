require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutArrayAssignment < EdgeCase::Koan
  def test_non_parallel_assignment
    names = ["John", "Smith"]
    assert_equal ["John", "Smith"], names
  end

  def test_parallel_assignments
    first_name, last_name = ["John", "Smith"]
    assert_equal "John", first_name
    assert_equal "Smith", last_name
  end
  
  # nice, comma delimited assignment matches the related indices on the right, 
  # in this case an array but can work with normal values too, for example if 
  # we had variables a and b that are integers it would be written as:
  # 
  # a, b = b, a
  # 
  # very handy and simple way to swap values that would have required a temporary 
  # variable in another language, so we would have to do something like: 
  # 
  # var a = 1;
  # var b = 2;
  # var temp = a;
  # a = b;
  # b = temp;
  # 
  # Parallel assignment FTW!
  
  def test_parallel_assignments_with_extra_values
    first_name, last_name = ["John", "Smith", "III"]
    assert_equal "John", first_name
    assert_equal "Smith", last_name
  end
  
  # if it was first_name, last_name, other_name, then other_name would be "III"
  
  def test_parallel_assignments_with_splat_operator
    first_name, *last_name = ["John", "Smith", "III"]
    assert_equal "John", first_name
    assert_equal ["Smith","III"], last_name
  end
  
  # when I learned about methods, the * was for unlimited values so 
  # figured here it means from the matching index onwards to the end, 
  # and that was right
  
  def test_parallel_assignments_with_too_few_variables
    first_name, last_name = ["Cher"]
    assert_equal "Cher", first_name
    assert_equal nil, last_name
  end
  
  # no matching second element in the array so makes sense its nil
  
  def test_parallel_assignments_with_subarrays
    first_name, last_name = [["Willie", "Rae"], "Johnson"]
    assert_equal ["Willie", "Rae"], first_name
    assert_equal "Johnson", last_name
  end
  
  # remember the assignment order defined on the left matches the array 
  # on the right
  
  def test_parallel_assignment_with_one_variable
    first_name, = ["John", "Smith"]
    assert_equal "John", first_name
  end

  def test_swapping_with_parallel_assignment
    first_name = "Roy"
    last_name = "Rob"
    first_name, last_name = last_name, first_name
    assert_equal "Rob", first_name
    assert_equal "Roy", last_name
  end
end

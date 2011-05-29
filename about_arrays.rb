require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutArrays < EdgeCase::Koan
  def test_creating_arrays
    empty_array = Array.new
    assert_equal Array, empty_array.class
    assert_equal 0, empty_array.size
  end
  
  # array.size is an alias for .length, both work the same
  
  def test_array_literals
    array = Array.new
    assert_equal [], array

    array[0] = 1
    assert_equal [1], array

    array[1] = 2
    assert_equal [1, 2], array

    array << 333 # appends an element to the array
    assert_equal [1, 2, 333], array
  end
  
  # can use << as a neat way to append an element to an array
  
  def test_accessing_array_elements
    array = [:peanut, :butter, :and, :jelly]

    assert_equal :peanut, array[0]
    assert_equal :peanut, array.first
    assert_equal :jelly, array[3]
    assert_equal :jelly, array.last
    assert_equal :jelly, array[-1]
    assert_equal :butter, array[-3]
  end
  
  # accessing with negative numbers go in reverse from the end, so 
  # -1 gets you the last item, -2 the second to last, etc.
  
  def test_slicing_arrays
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut], array[0,1]
    assert_equal [:peanut,:butter], array[0,2]
    assert_equal [:and,:jelly], array[2,2]
    assert_equal [:and,:jelly], array[2,20]
    # don't understand why empty array here and from 5 on its nil
    # arrays are 0 based so its 0-3 for the example given... 
    # well [4] returns nil, with a second param [4,x] it returns an empty array, interesting
    assert_equal [], array[4,0]
    assert_equal [], array[4,100]
    assert_equal nil, array[5,0]
  end
  
  # http://stackoverflow.com/questions/3219229/why-does-array-slice-behave-differently-for-length-n
  # a[a.length] returns nil. Good.
  # a[a.length, x] returns []. Good.
  # a[a.length+x, y] returns nil. Inconsistent with 2.
  # It may help to think of the slice points as being between the elements, rather than the elements themselves.
  
  def test_arrays_and_ranges
    assert_equal Range, (1..5).class
    assert_not_equal [1,2,3,4,5], (1..5)
    assert_equal [1,2,3,4,5], (1..5).to_a
    assert_equal [1,2,3,4], (1...5).to_a
  end
  
  # Range with .. means inclusive so 1..4 means 1,2,3,4
  # whereas ... includes all except the last item, so 1...4 means 1,2,3
  
  def test_slicing_with_ranges
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut, :butter, :and], array[0..2]
    assert_equal [:peanut, :butter], array[0...2]
    assert_equal [:and, :jelly], array[2..-1]
  end
  
  # Looks like a range with -1 means any limit?
  
  def test_pushing_and_popping_arrays
    array = [1,2]
    array.push(:last)

    assert_equal [1,2,:last], array

    popped_value = array.pop
    assert_equal :last, popped_value
    assert_equal [1,2], array
  end
  
  # Don't use very often so tend to forget which one is first or last:
  # pop method removes the last item, shift removes the first
  
  def test_shifting_arrays
    array = [1,2]
    array.unshift(:first)
    
    assert_equal [:first,1,2], array
    
    shifted_value = array.shift
    assert_equal :first, shifted_value
    assert_equal [1,2], array
  end
  
  # unshift method adds an element to the beginning of the array 
  # interesting, unlike AS3/JS it only supports 1 arg
end

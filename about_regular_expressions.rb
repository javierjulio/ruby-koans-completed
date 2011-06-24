# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutRegularExpressions < EdgeCase::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal "match", "some matching content"[/match/]
  end

  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/something/]
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional
    assert_equal "ab", "abbcccddddeeeee"[/ab?/]
    assert_equal "a", "abbcccddddeeeee"[/az?/]
  end

  def test_plus_means_one_or_more
    assert_equal "bccc", "abbcccddddeeeee"[/bc+/]
  end

  def test_asterisk_means_zero_or_more
    assert_equal "abb", "abbcccddddeeeee"[/ab*/]
    assert_equal "a", "abbcccddddeeeee"[/az*/]
    assert_equal "", "abbcccddddeeeee"[/z*/]

    # THINK ABOUT IT:
    #
    # When would * fail to match?
  end
  
  # I'm not really sure * would ever fail to match if that means its valid to return an 
  # empty string and assuming nil is a failure. I couldn't really determine a final answer
  # http://stackoverflow.com/questions/5084141/getting-the-star-regex-operator-to-fail
  
  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?
  
  # The * is used to match and return as many possible characters from the input. Have 
  # to be careful when using this as since it'll grab as much data as it can you might 
  # end up with more than what you want. Performs a lot of backtracking to get result.
  
  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    assert_equal "a", "abbccc az"[/az*/]
  end

  # ------------------------------------------------------------------

  # I don't understand this one. If I take out the "a" in " a[/" the answer is the same 
  # value as the animals array (all 4 values), but if I leave it as is, its just the first 
  # 3 values of the array that match. Why?
  # 
  # Ok I think I get it now. The select method acts like a loop and the |a| is each 
  # array element since I remember you can use array notation with regex against a String 
  # object and that's what |a| is. The regex then looks for a starting character of either 
  # just c, b, or r so that's why it just returns an array of the first 3.
  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
    assert_equal ["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] }
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal "42", "the number is 42"[/[0123456789]+/]
    assert_equal "42", "the number is 42"[/\d+/]
  end

  def test_character_classes_can_include_ranges
    assert_equal "42", "the number is 42"[/[0-9]+/]
  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal "variable_1", "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal "variable_1", "variable_1 = 42"[/\w+/]
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal "abc", "abc\n123"[/a.+/]
  end

  def test_a_character_class_can_be_negated
    assert_equal "the number is ", "the number is 42"[/[^0-9]+/]
  end
  
  # Careful, when using capital letters the opposite occurs, so for \d you get 
  # all digits but \D will get you anything but digits.
  def test_shortcut_character_classes_are_negated_with_capitals
    assert_equal "the number is ", "the number is 42"[/\D+/]
    assert_equal "space:", "space: \t\n"[/\S+/]
    assert_equal " = ", "variable_1 = 42"[/\W+/]
  end

  # ------------------------------------------------------------------
  
  # If no match is found, nil is returned, not an empty string.
  
  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal "start", "start end"[/\Astart/]
    assert_equal nil, "start end"[/\Aend/]
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal "end", "start end"[/end\z/]
    assert_equal nil, "start end"[/start\z/]
  end
  
  # If we were to change this to be "89num 42\n2 lines" then then answer would be 
  # "89" since its a match at the first line that has it
  
  def test_caret_anchors_to_the_start_of_lines
    assert_equal "2", "num 42\n2 lines"[/^\d+/]
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal "42", "2 lines\nnum 42"[/\d+$/]
  end

  def test_slash_b_anchors_to_a_word_boundary
    assert_equal "vines", "bovine vines"[/\bvine./]
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
    assert_equal "hahaha", "ahahaha"[/(ha)+/]
  end

  # ------------------------------------------------------------------

  # IMPORTANT: Those commas don't separate array elements, they are actual characters 
  # used in the regular expression! This threw me off for awhile but now it makes sense. 
  # I was only seeing examples with a single regular expression and then a second parameter 
  # but I wasn't reading this carefully so I thought the 1 or 2 number given was as a 
  # third parameter.
  def test_parentheses_also_capture_matched_content_by_number
    assert_equal "Gray", "Gray, James"[/(\w+), (\w+)/, 1]
    assert_equal "James", "Gray, James"[/(\w+), (\w+)/, 2]
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal "Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/]
    assert_equal "Gray", $1
    assert_equal "James", $2
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    grays = /(James|Dana|Summer) Gray/
    assert_equal "James Gray", "James Gray"[grays]
    assert_equal "Summer", "Summer Gray"[grays, 1]
    assert_equal nil, "Jim Gray"[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).

  # ------------------------------------------------------------------
  
  # The String.scan method always returns an Array if only a pattern is given. If it 
  # has a block then a String is returned. This seems to be common behavior amongst 
  # other similar methods too.
  def test_scan_is_like_find_all
    assert_equal ["one", "two", "three"], "one two-three".scan(/\w+/)
  end

  def test_sub_is_like_find_and_replace
    assert_equal "one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] }
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal "one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
  end
end

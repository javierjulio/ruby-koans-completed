require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutHashes < EdgeCase::Koan
  def test_creating_hashes
    empty_hash = Hash.new
    assert_equal Hash, empty_hash.class
    assert_equal({}, empty_hash)
    assert_equal 0, empty_hash.size
  end

  # nice, just like AS3/JS you can create hashes using the {} shorthand
  
  def test_hash_literals
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.size
  end

  def test_accessing_hashes
    hash = { :one => "uno", :two => "dos" }
    assert_equal "uno", hash[:one]
    assert_equal "dos", hash[:two]
    assert_equal nil, hash[:doesnt_exist]
  end

  # seems like most things won't throw an error but rather return nil, much easier 
  # to test for nill then have to handle elaborate errors
  
  def test_changing_hashes
    hash = { :one => "uno", :two => "dos" }
    hash[:one] = "eins"

    expected = { :one => "eins", :two => "dos" }
    assert_equal true, expected == hash

    # Bonus Question: Why was "expected" broken out into a variable
    # rather than used as a literal?
  end

  # they are equal since they contain the same number of keys, the keys match 
  # in name and so do the values, as far as breaking it out into its own variable 
  # that's because if not expected would be a reference to hash no? unless I 
  # misunderstand here what they mean by literal
  
  def test_hash_is_unordered
    hash1 = { :one => "uno", :two => "dos" }
    hash2 = { :two => "dos", :one => "uno" }

    assert_equal true, hash1 == hash2
  end

  # hash order doesn't matter as long as both contain the same keys they are equal
  
  def test_hash_keys
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.keys.size
    assert_equal true, hash.keys.include?(:one)
    assert_equal true, hash.keys.include?(:two)
    assert_equal Array, hash.keys.class
  end

  # handy to use .keys on a Hash instance to get an array of all keys
  # note that .include? is an alias as the same can be written using other 
  # methods like: .has_key?, .key? or .member?
  
  def test_hash_values
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.values.size
    assert_equal true, hash.values.include?("uno")
    assert_equal true, hash.values.include?("dos")
    assert_equal Array, hash.values.class
  end

  # handy to use .values on a Hash instance to get an array of all values
  
  def test_combining_hashes
    hash = { "jim" => 53, "amy" => 20, "dan" => 23 }
    new_hash = hash.merge({ "jim" => 54, "jenny" => 26 }) #careful here, new key being added!
    
    # can use either .merge or .update
    
    assert_equal true, hash != new_hash # they are different because on merge we add a new key "jenny"

    expected = { "jim" => 54, "amy" => 20, "dan" => 23, "jenny" => 26 }
    assert_equal true, expected == new_hash
  end
  
  # the merge shook me off at first since the key "jenny" was at the end thus 
  # making the new hash different from the original by one key, other than that 
  # though its straightforward, if the keys match in name and value and if key 
  # or value is a string its a case sensitive match, they are equal
end

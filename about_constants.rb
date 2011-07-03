require File.expand_path(File.dirname(__FILE__) + '/edgecase')

C = "top level"

class AboutConstants < EdgeCase::Koan

  C = "nested"

  def test_nested_constants_may_also_be_referenced_with_relative_paths
    assert_equal "nested", C
  end
  
  # Careful this fooled me at first but the top level C constant is 
  # defined outside the class but in this file, its still global.
  def test_top_level_constants_are_referenced_by_double_colons
    assert_equal "top level", ::C
  end
  
  # Regarding the previous comment I was expecting this to be "top 
  # level" but that's a global constant, here we are referencing the 
  # C constant within the class. I missed that distinction at first.
  def test_nested_constants_are_referenced_by_their_complete_path
    assert_equal "nested", AboutConstants::C
    assert_equal "nested", ::AboutConstants::C
  end

  # ------------------------------------------------------------------

  class Animal
    LEGS = 4
    def legs_in_animal
      LEGS
    end

    class NestedAnimal
      def legs_in_nested_animal
        LEGS
      end
    end
  end

  def test_nested_classes_inherit_constants_from_enclosing_classes
    assert_equal 4, Animal::NestedAnimal.new.legs_in_nested_animal
  end

  # ------------------------------------------------------------------

  class Reptile < Animal
    def legs_in_reptile
      LEGS
    end
  end

  def test_subclasses_inherit_constants_from_parent_classes
    assert_equal 4, Reptile.new.legs_in_reptile
  end

  # ------------------------------------------------------------------

  class MyAnimals
    LEGS = 2

    class Bird < Animal
      def legs_in_bird
        LEGS
      end
    end
  end

  def test_who_wins_with_both_nested_and_inherited_constants
    assert_equal 2, MyAnimals::Bird.new.legs_in_bird
  end

  # QUESTION: Which has precedence: The constant in the lexical scope,
  # or the constant from the inheritance heirarachy?
  # 
  # The lexical scope.

  # ------------------------------------------------------------------

  class MyAnimals::Oyster < Animal
    def legs_in_oyster
      LEGS
    end
  end

  def test_who_wins_with_explicit_scoping_on_class_definition
    assert_equal 4, MyAnimals::Oyster.new.legs_in_oyster
  end

  # QUESTION: Now Which has precedence: The constant in the lexical
  # scope, or the constant from the inheritance heirarachy?  Why is it
  # different than the previous answer?
  # 
  # The inheritance heirarachy. While the class is named the same 
  # it is scoped but I'm not sure if Ruby really treats this as a 
  # separate class, if it did there wouldn't be question about scope 
  # since LEGS wouldn't be accessible.
  # 
  # I'm probably off here on my understanding of this. Need to look 
  # more into it.
  # 
  # Research online lead to some great explanations on StackOverflow
  # http://stackoverflow.com/questions/5464811/ruby-koans-explicit-scoping-on-a-class-definition-part-2
  # http://www.eggheadcafe.com/software/aspnet/36217729/ruby-constant-lookup-for-classes-in-modules.aspx
end
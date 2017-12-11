require File.expand_path(File.dirname(__FILE__) + '/neo')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

def build_dice_map(dice)
    die_map = {}

    set_index = 0

    dice.each do |die|
        # Somewhat counterintuitive, but returns true if fetch doesn't retrieve a
        # matching index
        if die_map.fetch(die, false) == false
            # initiate an array at an index that matches the die value
            die_map[die] = [[]]
            # push the die value into the new array
            die_map[die][0].push(die)
        else
            puts die_map.to_s
            # Load another matching value
            die_map[die][set_index].push(die)

            if die_map[die][set_index].length > 2
                set_index += 1
                # push a new empty array
                die_map[die].push([])
            end
        end
    end
    die_map
end

def set_is_all(set, num)
    set.uniq == [num]
end

def set_is_all_ones(set)
    set_is_all(set, 1)
end

def set_is_all_fives(set)
    set_is_all(set, 5)
end

def set_is_all_same(set)
    set_is_all(set, set[0])
end

def score_set(set)
    score = 0
    set.each do |v|
        if v == 1
            score = score + 100
        elsif v == 5
            score = score + 50
        end
    end
    score
end

def score(dice)
    score = 0
    die_map = build_dice_map(dice)

    die_map.each do |idx, die_roll_sets|
        die_roll_sets.each do |die_roll_set|
            if die_roll_set.length == 3
                if set_is_all_ones(die_roll_set)
                    score = score + 1000
                elsif set_is_all_fives(die_roll_set)
                    score = score + 500
                elsif set_is_all_same(die_roll_set)
                    score = score + die_roll_set[0] * 100
                end
            else
                score = score + score_set(die_roll_set)
            end
        end
    end
    score
end

class AboutScoringProject < Neo::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2,2,2])
    assert_equal 300, score([3,3,3])
    assert_equal 400, score([4,4,4])
    assert_equal 500, score([5,5,5])
    assert_equal 600, score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2,5,2,2,3])
    assert_equal 550, score([5,5,5,5])
    assert_equal 1100, score([1,1,1,1])
    assert_equal 1200, score([1,1,1,1,1])
    assert_equal 1150, score([1,1,1,5,1])
  end

end

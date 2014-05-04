# -*- coding: utf-8 -*-
require 'spec_helper'
require 'cs_refresh'


NUMBERS = [9, 12, 19, 8, 23, 62, 91, 52]

SORTED_NUMBERS = [8, 9, 12, 19, 23, 52, 62, 91]

OTHER_NUMBERS = [234234, 29, 1, 23423, 523, 28, 5]


def insert_test_values(tree)
  NUMBERS.each do |num|
    tree.insert_value(num)
  end
end

def test_finding_recursive(tree)
  NUMBERS.each do |num|
    it "Should be able to find value #{num} recursively" do
      expect(tree.value?(num)).to be true
    end
  end
end

def test_not_finding_recursive(tree)
  OTHER_NUMBERS.each do |num|
    it "Should not find value #{num} recursively" do
      expect(tree.value?(num)).to be false
    end
  end
end

def test_finding_iterative(tree)
  NUMBERS.each do |num|
    it "Should be able to find value #{num} iteratively" do
      expect(tree.value_iterative?(num)).to be true
    end
  end
end

def test_not_finding_iterative(tree)
  OTHER_NUMBERS.each do |num|
    it "Should not find value #{num} iteratively" do
      expect(tree.value_iterative?(num)).to be false
    end
  end
end

def test_sorted(tree)
  it "Should return a sorted list" do
    expect(tree.sorted_list).to eq(SORTED_NUMBERS)
  end
end

def test(binary_search_tree_class)
  describe binary_search_tree_class do
    my_tree = binary_search_tree_class.new
    insert_test_values(my_tree)
    test_finding_recursive(my_tree)
    test_not_finding_recursive(my_tree)
    test_finding_iterative(my_tree)
    test_not_finding_iterative(my_tree)
    test_sorted(my_tree)
  end
end

# NEXT: Array-based tree storage?
[CsRefresh::BinarySearchTree].each do |binary_search_tree_class|
  test(binary_search_tree_class)
end

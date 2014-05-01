# -*- coding: utf-8 -*-
require 'spec_helper'
require 'cs_refresh'

def test(sorter)
  describe sorter.class do
    cases = {
      [1, 2, 3, 4, 5, 7, 8, 6, 9, 10] => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    }
    cases.each do |unsorted, sorted|
      it "Should sort #{unsorted} into #{sorted}" do
        expect(sorter.sort(unsorted)).to eq sorted
      end
    end
  end
end


[CsRefresh::SystemSorter.new,
 CsRefresh::MergeSorter.new(CsRefresh::SystemMinHeap.new),
 CsRefresh::MergeSorter.new(CsRefresh::VinceMinHeap.new),
].each do |sorter|
  test(sorter)
end

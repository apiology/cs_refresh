# -*- coding: utf-8 -*-
require 'spec_helper'
require 'cs_refresh'

describe CsRefresh::Sorter do
  cases = {
    [1, 2, 3, 4, 5, 7, 8, 6, 9, 10] => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  }
  cases.each do |unsorted, sorted|
    it "Should sort #{unsorted} into #{sorted}" do
      expect(CsRefresh::Sorter.new.sort(unsorted)).to eq sorted
    end
  end
end

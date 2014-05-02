# -*- coding: utf-8 -*-
require 'spec_helper'
require 'cs_refresh'

def test(map)
  describe map.class do
    cases = [{ 1 => 5, 7 => 9, 23 => 21, "593" => 2 }]
    cases.each do |test_case|
      test_case.each do |key, value|
        map[key] = value
      end
      test_case.each do |key, value|
        it "Should store #{key} as #{value}" do
          map[key] = value
          expect(map[key]).to eq value
        end
      end
    end
  end
end


[CsRefresh::SystemMap.new,
 CsRefresh::HashTable.new(30),
].each do |sorter|
  test(sorter)
end

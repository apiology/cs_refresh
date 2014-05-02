require 'algorithms'

# Code to refresh my memory of algorithms and data structures
module CsRefresh
  SystemMap = Hash

  # My implementation of a hash table with separate chaining
  class HashTable
    def initialize(size)
      @arr = Array.new(size)
      @size = size
    end

    def bucket(key)
      key.hash % @size
    end

    def []=(key, value)
      @arr[bucket(key)] ||= []
      @arr[bucket(key)] << [key, value]
    end

    def [](desired_key)
      @arr[bucket(desired_key)].each do |key, value|
        return value if key == desired_key
      end
      nil
    end
  end
end

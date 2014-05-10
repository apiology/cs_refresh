# Indicates an assert failed
class AssertionError < RuntimeError
end

def assert
  fail AssertionError unless yield
end

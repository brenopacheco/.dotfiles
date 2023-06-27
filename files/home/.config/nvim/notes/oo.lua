--[[
Class functions:
  - Defining a class function has two equivalent syntaxes
    Class:func(...args)         // callable via =instance:func(...args)=
    Class.func(self, ...args)   // callable via =instance.func(instance, ...args)=
  - The one that is registered in the table is with "self" variant

Prototypes
- __index will make a will lookup in b for any property it does not have
- there are 2 ways of doing classes:
  1. using the class table as the metatable
    setmetatable(o, self)
    self.__index = self
    -> { <metatable> = <1>{ __index = <table 1>, foo = ... } }

  2. adding __index to point to the class table
    setmetatable(o, {__index = self})
    -> { <metatable> = { __index = { foo = ... } } }

Inheritance
  - create a new instace of the Class and add new methods
    A = {...}
    function A:new() ... end
    B = A:new()
    function B:bar() ... end
    b = B:new()

--]]

---@class A
A = { foo = 1 }

---@return A
function A:new()
  o = {}
  setmetatable(o, {__index = self})
  -- setmetatable(o, self)
  -- self.__index = self
  return o
end

---@class B : A
B = A:new()

---@return number
function B:bar()
  return self.foo + 1
end

b = B:new()

--- This is for inference
---@return B
function B:new() return self.new() end



P(b:bar())



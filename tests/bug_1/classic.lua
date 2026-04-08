--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--

-- not even i know how this works - bloctans

local Object = {}
Object.__index = Object


function Object:new()
end


function Object:extend()
  local cls = {}

  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  
  local proxy = {}

  setmetatable(proxy, {
    __index = function(t, k)
      return cls[k]
    end,
    __newindex = function(t, k, v)
      print(k,v)

      --[[if cls.Changed then
        cls.Changed.Invoke(k, cls[k], v)
      end]]

      cls[k] = v
    end,
  })

  return proxy
end


function Object:implement(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end


function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end


function Object:__tostring()
  return "Object"
end


function Object:__call(...)
  local obj = setmetatable({}, self)
  
  ---@diagnostic disable-next-line: redundant-parameter
  obj:new(...)
  return obj
end


return Object
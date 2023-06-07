-- helpers and controls
local gui = require("gui")
local module = {}
-- Multiscreen: hide multiple screens behind switch
local Multiscreen = gui.Screen:new()

function Multiscreen:new(o)
  o = o or {
		current_screen = nil,
    screens = {},
    monitor = self.monitor
	};
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function Multiscreen:newScreen(name)
  local screen = gui.Screen:new{monitor=self.monitor}
  self.screens = self.screens or {}
  self.screens[name] = screen
  return screen
end
function Multiscreen:render()
	self.current_screen:render()
end;
function Multiscreen:handleInput()
	self.current_screen:handleInput()
end;
function Multiscreen:switchScreen(name)
  self.current_screen = self.screens[name]
end
function Multiscreen:addElement(element) -- can't add it here
end;
-- Button: simplified way to click shit
Button = {}

function Button:new(o)
  o = o or {
    x = 1,
    y = 1,
    bc = colors.white,
    fc = colors.black,
    text = "Button",
    on_click = function(mon) end
  }
  setmetatable(o, self);
	self.__index = self;
  return o
end

function Button:render(mon)
  mon.setCursorPos(self.x, self.y)
  mon.setBackgroundColor(self.bc)
  mon.setTextColor(self.fc)
  mon.write(self.text)
end

function Button:handleInput(mon, event)
  local name = event[1]
  if (name == "mouse_click" or name == "monitor_touch") then
    local name, button, x, y = table.unpack(event)
    if x > self.x and x < self.x + string.len(text) and y > self.y and y < self.y + 1 then
      self.on_click(mon)
    end
  end
end

module.Multiscreen = Multiscreen
module.Button = Button
return module
-- helpers and controls
local gui = require("gui")
local module = {}
-- Multiscreen: hide multiple screens behind switch
local Multiscreen = {}

function Multiscreen:new(o)
  o = o or {
		current_screen = nil,
    screens = {},
    monitor = term
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
function Multiscreen:loop()
  parallel.waitForAny(function()
		while true do
			self.current_screen:render();
		end;
	end, function()
		while true do
			self.current_screen:handleInput();
		end;
	end);
end
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
  return {render = function(mon)
    mon.setCursorPos(o.x, o.y)
    mon.setBackgroundColor(o.bc)
    mon.setTextColor(o.fc)
    mon.write(o.text)
  end, handleInput = function(mon, event)
    name = event[1]
    if name == "monitor_touch" or name == "mouse_click" then
      name, button, x, y = table.unpack(event)
      if x > o.x and x < o.x + string.len(o.text) and y > o.y and y < o.y + 1 then
        on_click(mon)
      end
    end
  end}
end

module.Multiscreen = Multiscreen
module.Button = Button
return module
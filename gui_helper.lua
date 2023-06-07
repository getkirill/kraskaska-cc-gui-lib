-- helpers and controls
local gui = require("gui")
Multiscreen = gui.Screen:new()

function Multiscreen:new(o)
  o = o or {
		current_screen = nil,
    screens = {}
	};
	setmetatable(o, self);
	self.__index = self;
	return o;
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
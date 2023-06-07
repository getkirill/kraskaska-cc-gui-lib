Screen = {};
function Screen:new(o)
	o = o or {
		monitor = term,
		elements = {}
	};
	setmetatable(o, self);
	self.__index = self;
	o.monitor.setBackgroundColor(colors.black);
	o.monitor.setTextColor(colors.white);
	o:clear();
	return o;
end;
function Screen:clear()
	self.monitor.clear();
	self.monitor.setCursorPos(1, 1);
end;
function Screen:addElement(element)
	self.elements = self.elements or {};
	table.insert(self.elements, element);
end;
function Screen:render()
	local handlers = {};
	for _, elem in pairs(self.elements) do
		if elem.render ~= nil then
			table.insert(handlers, function()
				elem.render(self.monitor);
			end);
		end;
	end;
	parallel.waitForAll(table.unpack(handlers));
	os.sleep(0);
end;
function Screen:handleInput()
	local event = table.pack(os.pullEvent());
	local handlers = {};
	for _, elem in pairs(self.elements) do
		if elem.handleInput ~= nil then
			table.insert(handlers, function()
				elem.handleInput(self.monitor, event);
			end);
		end;
	end;
	parallel.waitForAll(table.unpack(handlers));
end;
function Screen:loop()
	parallel.waitForAny(function()
		while true do
			self:render();
		end;
	end, function()
		while true do
			self:handleInput();
		end;
	end);
end;
return {Screen}
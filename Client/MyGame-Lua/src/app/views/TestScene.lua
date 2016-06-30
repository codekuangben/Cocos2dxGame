local TestScene = class("MainScene", cc.load("mvc").ViewBase)

function TestScene:onCreate()
    -- add background image
	--[[
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)
		:rotate(30);

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self);
	]]	
		
	self:loadTestUI();
end

-- 测试加载 UI
function TestScene:loadTestUI()
	local ui_Test = require "UITest";
	local uiNode = ui_Test.create(nil);
	local resNode = uiNode.root;
	self:addChild(resNode);
end

return TestScene;
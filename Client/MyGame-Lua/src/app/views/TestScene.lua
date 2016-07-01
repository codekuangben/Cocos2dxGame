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
		
	--self:testLoadUI();
	self:testPlayAni();
end

-- 测试加载 UI
function TestScene:testLoadUI()
	local ui_Test = require "UITest";
	local uiNode = ui_Test.create(nil);
	local resNode = uiNode.root;
	self:addChild(resNode);
end

-- 测试播放动画
function TestScene:testPlayAni()
	local ui_Test = require "UITest";
	local uiNode = ui_Test.create(nil);
	local resNode = uiNode.root;
	self:addChild(resNode);
	
	local  btnAni = uiNode.animation;
	btnAni:retain();
	
	resNode:runAction(btnAni); -- 这个接口必须调用，否则动画不会播放，好像 runAction 一定要是编辑器中的 root Node，但是项目中没有使用 root Node，而是使用了 Parent Node
	
	btnAni:play("Ani_Btn", true);
end

-- 测试帧动画
function TestScene:testFrameAni()
	
end

return TestScene;
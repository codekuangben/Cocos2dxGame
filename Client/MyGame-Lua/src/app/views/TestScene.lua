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
	--self:testPlayAni();
	--self:testFrameAni();
	self:addEventHandle();
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
	-- 通过plist文件把每一帧加载到精灵帧缓存.
	local frameCache = cc.SpriteFrameCache:getInstance();
	-- C++ 中 addSpriteFramesWithFile 接口绑定到 Lua 中 addSpriteFrames 
	frameCache:addSpriteFrames("Test.plist");
	
	-- 生成动画
	local frameAnimation = nil;
	local animationCache = cc.AnimationCache:getInstance();
	frameAnimation = animationCache:getAnimation("dance_1");
	
	if(frameAnimation == nil) then
		-- C++ addAnimationsWithFile 绑定到 Lua 是 addAnimations 接口
		cc.AnimationCache:getInstance():addAnimations("Anim.plist");
		frameAnimation = cc.AnimationCache:getInstance():getAnimation("dance_1");
	end
	
	-- frameAnimation:setDelayUnits(0.1);
	-- frameAnimation:setRestoreOriginalFrame(true);
	
	--精灵执行动画
	local animate = cc.Animate:create(frameAnimation);
	local effectSprite = cc.Sprite:create();
	
	-- Lua 中 getSpriteFrameByName 过时，使用 getSpriteFrame
	local frame = frameCache:getSpriteFrame("bai01_000.tga");
	
	-- C++ 中 setDisplayFrame 过时，使用 setSpriteFrame 代替
	effectSprite:setSpriteFrame(frame);
	
	self:addChild(effectSprite);
	
	effectSprite:stopAllActions();
	effectSprite:runAction(cc.RepeatForever:create(animate));
end

function TestScene:testLoadImage()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("aaa.plist");
	
	local ui_Test = require "UITest";
	local uiNode = ui_Test.create(nil);
	local resNode = uiNode.root;
	self:addChild(resNode);
	
	uiNode.Button_1:loadTexturePressed("aaa", 1);
	uiNode.Button_1:loadTextureNormal("aaa", 1);
end

function TestScene:addEventHandle()
	--local button_close=mianye:getChildByTag(4);
	
	local ui_Test = require "UITest";
	local uiNode = ui_Test.create(nil);
	local resNode = uiNode.root;
	self:addChild(resNode);
	
	uiNode.Button_1:addTouchEventListener(
		function(sender, state)
			self:menuZhuCeCallback(sender, state);
		end
	);
end

function TestScene:menuZhuCeCallback(sender,eventType)
	print(sender:getTag());
	if eventType == ccui.TouchEventType.began then
		print("按下按钮");
	elseif eventType == ccui.TouchEventType.moved then
		print("按下按钮移动");
	elseif eventType == ccui.TouchEventType.ended then
		print("放开按钮");
		self:testFrameAni();
	elseif eventType == ccui.TouchEventType.canceled then
		print("取消点击");
	end
end

return TestScene;
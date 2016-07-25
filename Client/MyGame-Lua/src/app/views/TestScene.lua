local TestScene = class("TestScene", cc.load("mvc").ViewBase)

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
	--self:addEventHandle();
	--self:testClip();
	--self:testParticle();
	--self:testParticle1();
	--self:testTick();
	self:testLoadFormUI();
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
	local animation = nil;
	local animationCache = cc.AnimationCache:getInstance();
	animation = animationCache:getAnimation("dance_1");
	
	if(frameAnimation == nil) then
		-- C++ addAnimationsWithFile 绑定到 Lua 是 addAnimations 接口
		cc.AnimationCache:getInstance():addAnimations("Anim.plist");
		animation = cc.AnimationCache:getInstance():getAnimation("dance_1");
	end
	
	-- animation:setDelayUnits(0.1);
	-- animation:setRestoreOriginalFrame(true);
	
	--精灵执行动画
	local animate = cc.Animate:create(animation);
	local effectSprite = cc.Sprite:create();
	
	-- Lua 中 getSpriteFrameByName 过时，使用 getSpriteFrame
	local spriteFrame = frameCache:getSpriteFrame("bai01_000.tga");
	
	-- C++ 中 setDisplayFrame 过时，使用 setSpriteFrame 代替
	effectSprite:setSpriteFrame(spriteFrame);
	
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

--利用ClippingNode实现遮罩，但是在实际的项目中，可以用widget的setEnable的
function TestScene:testClip()
	local size = cc.Director:getInstance():getVisibleSize();
    local orign = cc.Director:getInstance():getVisibleOrigin();
   
    --设置两个控件
    local menuitemImage = cc.MenuItemFont:create("HelloWorld");
    local menu = cc.Menu:create(menuitemImage);
   
    menu:setPosition(cc.p(size.width/2, size.height-20));
    self:addChild(menu);
   
    menuitemImage:registerScriptTapHandler(
		function()  
			print("menuitemImage click");
		end
	);

    local sprite = cc.Sprite:create("Hello.png");
    self:addChild(sprite);
    sprite:setPosition(cc.p(orign.x + size.width/2, orign.y + size.height/2+30));
    sprite:setScale(0.3);
   
    --创建一个button，为了不相应它前面的控件
    local btn = ccui.Button:create();
    btn:setContentSize(size);
    btn:setPosition(cc.p(size.width/2,size.height/2));
    btn:setScale9Enabled(true);
    self:addChild(btn);
    btn:setSwallowTouches(true);
   
    btn:addTouchEventListener(
		function(ref, type)
			if ref == btn and type == ccui.TouchEventType.ended then
				print("btn click");
			end
		end
	);
   
    --创建ClippingNode(底板)
    local laycolor = cc.LayerColor:create(cc.c4b(0,0,0,120));
    local clipNode = cc.ClippingNode:create();
    clipNode:setInverted(true);
    clipNode:setAlphaThreshold(0);
    self:addChild(clipNode);
    clipNode:addChild(laycolor);

    --模板，其实就是模板这个控件正常显示，其他的控件加上了color这层
    local image = cc.MenuItemImage:create("CloseNormal.png","CloseSelected.png");
    image:setPosition(cc.p(size.width/2, 100));
    menu = cc.Menu:create(image);
    menu:setPosition(cc.p(0,0));
    self:addChild(menu);
    image:registerScriptTapHandler(
		function()
			print("image click");
		end
	);
    clipNode:setStencil(menu);
end

function TestScene:testParticle()
	local director = cc.Director:getInstance();
	local visibleSize = director:getVisibleSize();
	local particleSystem = cc.ParticleSystemQuad:create("ParticleTest.plist");
	particleSystem:setDuration(20);
	particleSystem:setPosition(cc.p(visibleSize.width/2, visibleSize.height/2));
	self:addChild(particleSystem);
	
	-- 一定要加这一行，默认是暂停的
	particleSystem:resumeEmissions();
end

function TestScene:testParticle1()
	local director = cc.Director:getInstance();
	local visibleSize = director:getVisibleSize();
	local particleSystem = cc.ParticleSystemQuad:create("ParticleTest.plist");
	particleSystem:setPosition(cc.p(visibleSize.width/2, visibleSize.height/2));
	particleSystem:retain();
	local batch = cc.ParticleBatchNode:createWithTexture(particleSystem:getTexture());
	batch:addChild(particleSystem);
	self:addChild(batch);
	particleSystem:release();
	-- 一定要加这一行，默认是暂停的
	particleSystem:resumeEmissions();
end

function TestScene:testTick()
	--self:onUpdate(TestScene.testOnTick);
	self:onUpdate(handler(self, self.onTick));
end

function TestScene.testOnTick(delta)
	
end

--每一帧都回调的函数
function TestScene:onTick(delta)
	local aaa = delta;
	
	self:stopTick();
end

function TestScene:stopTick()
	self:unscheduleUpdate();
end

function TestScene:testLoadFormUI()
	require "MyLua.UI.UITestTableView.UITestTableView";
	local form = GlobalNS.new(GlobalNS.TestTableViewNS.UITestTableView);
	form:onInit();
	form:onReady();
	form:onShow();
	form:addToStage(self);
end

return TestScene;
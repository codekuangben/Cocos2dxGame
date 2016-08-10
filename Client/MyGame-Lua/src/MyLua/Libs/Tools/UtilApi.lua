local M = GlobalNS.StaticClass();
local this = M;
M.clsName = "UtilApi";
GlobalNS[M.clsName] = M;

local director = cc.Director:getInstance()

function M.getStageVisibleSize()
	return director:getVisibleSize();
end

function M.getStageVisibleOrigin()
	return director:getVisibleOrigin();
end

function M.getChildByName(parentNode, name)
	local childNode = parentNode:getChildByName(name);
	return childNode;
end

function M.findChildByPath(parentNode, path)
	return parentNode:enumerateChildren(path);
end

function M.addChild(parent, child)
	if(parent ~= nil and child ~= nil) then
		parent:addChild(child);
	end
end

function M.addEventHandle(uiWidget, handle)
	uiWidget:setTouchEnabled(true);
	uiWidget:onTouch(handle);
end

function M.captureScreen()
	cc.utils:captureScreen();
end

function M.createTableViewCell()
	return cc.TableViewCell:new();
end

--添加事件监听器
function M.addEventListener(node)
	if(nil ~= node) then
		local eventDispatcher = node:getEventDispatcher();
		local listener = cc.EventListenerTouchOneByOne:create();
		eventDispatcher:addEventListenerWithSceneGraphPriority(listener);
		return listener;
	end
	
	return nil;
end

function M.addTouchBeganHandle(listener, functor)
	if(nil ~= listener and nil ~= functor) then
		listener:registerScriptHandle(functor, cc.Handler.EVENT_TOUCH_BEGAN);
	end
end

function M.addTouchMoveHandle(listener, functor)
	if(nil ~= listener and nil ~= functor) then
		listener:registerScriptHandle(functor, cc.Handler.EVENT_TOUCH_MOVED);
	end
end

function M.addTouchEndHandle(listener, functor)
	if(nil ~= listener and nil ~= functor) then
		listener:registerScriptHandle(functor, cc.Handler.EVENT_TOUCH_ENDED);
	end
end

--没有从 EventDispatcher 中获取一个 Node 的 Listener 的接口，只能是谁使用谁添加，谁保存
function M.addEventListenerAndHandle(node, beginFunctor, moveFunctor, endFunctor)
	if(nil ~= node) then
		local eventDispatcher = node:getEventDispatcher();
		local listener = cc.EventListenerTouchOneByOne:create();
		eventDispatcher:addEventListenerWithSceneGraphPriority(listener);
		
		if(nil ~= beginFunctor) then
			listener:registerScriptHandle(beginFunctor, cc.Handler.EVENT_TOUCH_BEGAN);
		end
		
		if(nil ~= moveFunctor) then
			listener:registerScriptHandle(moveFunctor, cc.Handler.EVENT_TOUCH_MOVED);
		end
		
		if(nil ~= endFunctor) then
			listener:registerScriptHandle(endFunctor, cc.Handler.EVENT_TOUCH_ENDED);
		end
		
		return listener;
	end
	
	return nil;
end

function M.getAndLoadLua(path)
	local uiModule = GlobalNS.ClassLoader.loadClass(path);
	local uiNode = uiModule.create();
	return uiNode;
end

function M.getAndLoadLuaRoot(path)
	local uiModule = GlobalNS.ClassLoader.loadClass(path);
	local uiNode = uiModule.create();
	return uiNode.root;
end

function M.min(a, b)
	return math.min(a, b);
end

function M.max(a, b)
	return math.max(a, b);
end

--创建闭包函数
function M.createClosureFunctor(obj, method)
    return function(...)
        return method(obj, ...);
    end
end

function M.isTouchInNode(node, touch)
	local touchLocation = touch:getLocation();
	touchLocation = node:getParent():convertToNodeSpace(touchLocation);
	local bBox = node:getBoundingBox(); 	--getBoundingBox 获取的位置是相对于 Parent Node 的位置信息
	local ret = false;
	
	--获取的信息一定是左下是最小点，右上是最大点
	if(bBox.x <= touchLocation.x and
	   bBox.y <= touchLocation.y and
	   touchLocation.x <= bBox.x + bBox.width and
	   touchLocation.x <= bBox.x + bBox.height) then
		ret = true;
	end
	
	return ret;
end

function M.isTouchInRect(node, rect, touch)
	local touchLocation = =nil;
	if(nil ~= nil) then
		touchLocation = node:convertToNodeSpace(touch:getLocation()); 	--转换到节点空间
	else
		touchLocation = touch:getLocation();
	end
	if(nil ~= rect) then
		return cc.rectContainsPoint(rect, touchLocation);
	else
		local orig = node:getAnchorPointInPoints();
		local size = node:getContentSize();
		rect = cc.rect(orig, size);
		return cc.rectContainsPoint(rect, touchLocation);
	end
	
	return false;
end

function M.setTextColor4b(label, color)
	label:setTextColor(color);
end

function M.setTextColorRGBA(label, r, g, b, a)
	local c4b = cc.c4b(r, g, b, a);
	label:setTextColor(c4b);
end

return M;
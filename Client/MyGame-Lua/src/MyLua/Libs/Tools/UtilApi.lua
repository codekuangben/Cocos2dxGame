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

function M.addEventDispatcher(node)
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

--创建闭包函数对象
function M.createClosureFunctor(obj, method)
    return function(...)
        return method(obj, ...);
    end
end

return M;
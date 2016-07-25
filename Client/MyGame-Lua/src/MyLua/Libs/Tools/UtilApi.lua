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

function M.addChild(parent, child)
	if(parent ~= nil and child ~= nil) then
		parent:addChild(child);
	end
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

return M;
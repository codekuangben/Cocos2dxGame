require "MyLua.Libs.Core.GlobalNS"
require "MyLua.Libs.Core.Class"
require "MyLua.Libs.Core.GObject"

--[[
    @brief 基本的渲染器，所有与显示有关的接口都在这里
]]

local M = GlobalNS.Class(GlobalNS.GObject);
M.clsName = "EntityRenderBase";
GlobalNS[M.clsName] = M;

function M:ctor(entity_)
    self.m_entity = entity_;
end

function M:setClientDispose()

end

function M:getClientDispose()
    return self.m_entity:getClientDispose();
end

function M:gameObject()
    return nil;
end

function M:setGameObject(rhv)

end

function M:transform()
    return nil;
end

function M:onTick(delta)
    
end

function M:show()

end

function M:hide()

end

function M:IsVisible()
    return true;
end

function M:dispose()

end

function M:setPnt(pntGO_)

end

function M:getPnt()
    return nil;
end

function M:checkRender()
    return false;
end
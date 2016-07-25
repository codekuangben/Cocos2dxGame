--[[
    @brief 事件分发器
]]

require "MyLua.Libs.Core.GlobalNS"
require "MyLua.Libs.Core.Class"
require "MyLua.Libs.DataStruct.MList"
require "MyLua.Libs.DelayHandle.DelayHandleMgrBase"
require "MyLua.Libs.EventHandle.EventDispatchFunctionObject"

local M = GlobalNS.Class(GlobalNS.DelayHandleMgrBase);
M.clsName = "EventDispatch";
GlobalNS[M.clsName] = M;

function M:ctor(eventId_)
    self.m_eventId = eventId_;
    self.m_handleList = GlobalNS.new(GlobalNS.MList);
    self.m_uniqueId = 0;       -- 唯一 Id ，调试使用
end

function M:dtor()

end

function M:getHandleList()
    return self.m_handleList;
end

function M:getUniqueId()
    return self.m_uniqueId;
end

function M:setUniqueId(value)
    self.m_uniqueId = value;
    --self.m_handleList.uniqueId = m_uniqueId;
end

function M:addEventHandle(pThis, handle)
    if (nil ~= handle) then
        local funcObject = GlobalNS.new(GlobalNS.EventDispatchFunctionObject);
        funcObject:setFuncObject(pThis, handle);
        self:addObject(funcObject);
    else
        -- 日志
    end
end

function M:addObject(delayObject, priority)
    if (self:bInDepth()) then
        M.super.addObject(self, delayObject, priority); -- super 使用需要自己填充 Self 参数
    else
        -- 这个判断说明相同的函数只能加一次，但是如果不同资源使用相同的回调函数就会有问题，但是这个判断可以保证只添加一次函数，值得，因此不同资源需要不同回调函数
        self.m_handleList:Add(delayObject);
    end
end

function M:removeEventHandle(handle, pThis)
    local idx = 0;
    for idx = 0, self.m_handleList:Count() - 1, 1 do
        if (self.m_handleList:at(idx):isEqual(handle, pThis)) then
            break;
        end
    end
    if (idx < self.m_handleList:Count()) then
        self:removeObject(self.m_handleList[idx]);
    else
        -- 日志
    end
end

function M:removeObject(delayObject)
    if (self:bInDepth()) then
        M.super.removeObject(self, delayObject);
    else
        if (self.m_handleList:Remove(delayObject) == false) then
            -- 日志
        end
    end
end

function M:dispatchEvent(dispatchObject)
    self:incDepth();

    for _, handle in ipairs(self.m_handleList:list()) do
        if (handle.m_bClientDispose == false) then
            handle:call(dispatchObject);
        end
    end

    self:decDepth();
end

function M:clearEventHandle()
    if (self:bInDepth()) then
        for _, item in ipairs(self.m_handleList:list()) do
            self:removeObject(item);
        end
    else
        self.m_handleList:Clear();
    end
end

-- 这个判断说明相同的函数只能加一次，但是如果不同资源使用相同的回调函数就会有问题，但是这个判断可以保证只添加一次函数，值得，因此不同资源需要不同回调函数
function M:existEventHandle(pThis, handle)
    local bFinded = false;
    for _, item in ipairs(self.m_handleList:list()) do
        if (item:isEqual(pThis, handle)) then
            bFinded = true;
            break;
        end
    end

    return bFinded;
end

function M:copyFrom(rhv)
    for _, handle in ipairs(rhv.handleList:list()) do
        self.m_handleList:Add(handle);
    end
end

return M;
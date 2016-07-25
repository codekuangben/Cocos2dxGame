require "MyLua.Libs.Core.GlobalNS"
require "MyLua.Libs.Core.Class"
require "MyLua.Libs.DataStruct.MList"
require "MyLua.Libs.DelayHandle.DelayHandleMgrBase"

local M = GlobalNS.Class(GlobalNS.DelayHandleMgrBase);
M.clsName = "TimerMgr";
GlobalNS[M.clsName] = M;

function M:ctor()
    self.m_timerList = GlobalNS.new(GlobalNS.MList);     -- 当前所有的定时器列表
end

function M:getCount()
    return self.m_timerList:Count();
end

function M:addObject(delayObject, priority)
    if(nil == priority) then
        priority = 0;
    end
    
    -- 检查当前是否已经在队列中
    if (self.m_timerList:IndexOf(delayObject) == -1) then
        if (self:bInDepth()) then
            M.super.addObject(self, delayObject, priority);
        else
            self.m_timerList:Add(delayObject);
        end
    end
    
    GCtx.m_processSys:refreshUpdateFlag();
end

function M:removeObject(delayObject)
    -- 检查当前是否在队列中
    if (self.m_timerList:IndexOf(delayObject) ~= -1) then
        delayObject.m_disposed = true;
        if (self:bInDepth()) then
            M.super.removeObject(self, delayObject);
        else
            for key, item in ipairs(self.m_timerList:list()) do
                if (item == delayObject) then
                    self.m_timerList:Remove(item);
                    break;
                end
            end
        end
    end
    
    if(self.m_timerList:Count() == 0) then
        GCtx.m_processSys:refreshUpdateFlag();
    end
end

function M:addTimer(delayObject, priority)
    self:addObject(delayObject, priority);
end

function M:Advance(delta)
    self:incDepth();

    for key, timerItem in ipairs(self.m_timerList:list()) do
        if (not timerItem:getClientDispose()) then
            timerItem:OnTimer(delta);
        end

        if (timerItem.m_disposed) then       -- 如果已经结束
            self:removeObject(timerItem);
        end
    end

    self:decDepth();
end

return M;
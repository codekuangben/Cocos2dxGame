require "MyLua.Libs.Core.GlobalNS"
require "MyLua.Libs.Core.Class"
require "MyLua.Libs.Core.GObject"

--�հ��������󣬾���ͨ�� __call metamethod ʹ�ö���ʵ�ֺ�������
local M = GlobalNS.Class(GlobalNS.CallFuncObjectBase);
M.clsName = "ClosureFuncObject";
GlobalNS[M.clsName] = M;

function M:setPThisAndHandle(pThis, handle, param)
	self.m_pThis = pThis;
	self.m_handle = handle;
	self.m_param = param;
end

function M.__call(...)
	if(nil ~= self.m_pThis and nil ~= self.m_handle) then
        return self.m_handle(self.m_pThis, self.m_param);
    elseif nil ~= self.m_handle then
        return self.m_handle(self.m_param);
    else
        return 0
    end
end

return M;
require "MyLua.Libs.Core.GlobalNS"
require "MyLua.Libs.Core.Class"
require "MyLua.Libs.Core.GObject"

--闭包函数对象，就是通过 __call metamethod 使用对象实现函数调用
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
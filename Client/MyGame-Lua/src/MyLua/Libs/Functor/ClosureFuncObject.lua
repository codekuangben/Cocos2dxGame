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
	local params = {...};
	local this = params[1];
	local event = params[2];
	if(nil ~= this.m_pThis and nil ~= this.m_handle) then
        return this.m_handle(this.m_pThis, event);
    elseif nil ~= this.m_handle then
        return this.m_handle(event);
    else
        return 0
    end
end

return M;
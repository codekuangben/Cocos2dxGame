require "MyLua.Libs.Core.GlobalNS"
require "MyLua.Libs.Core.Class"
require "MyLua.Libs.Core.GObject"

--深度管理器，主要是 UI 之间切换前后顺序使用的
local M = GlobalNS.Class(GlobalNS.GObject);
M.clsName = "DepthMgr";
GlobalNS[M.clsName] = M;

function M:ctor()
	
end

function M:dtor()
	
end

--同一个父节点中放到最高
function M:bringToTop()
	
end

--同一个父节点中，放到最低
function M:bringToBottom()
	
end

return M;
require "MyLua.Libs.Core.GlobalNS"
require "MyLua.Libs.Core.Class"
require "MyLua.Libs.Core.GObject"
require "MyLua.Libs.AuxComponent.AuxComponent"

local M = GlobalNS.Class(GlobalNS.AuxComponent);
M.clsName = "AuxWindow";
GlobalNS[M.clsName] = M;

function M:ctor()
    self:init();
end

function M:dtor()
    self:dispose();
end

function M:init()

end

function M:dispose()
	
end

return M;
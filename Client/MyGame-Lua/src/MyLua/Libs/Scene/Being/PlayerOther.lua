require "MyLua.Libs.Core.GlobalNS"
require "MyLua.Libs.Core.Class"
require "MyLua.Libs.Core.GObject"

--[[
    @brief 其它玩家
]]

local M = GlobalNS.Class(GlobalNS.Player);
M.clsName = "PlayerOther";
GlobalNS[M.clsName] = M;

function M:ctor()

end
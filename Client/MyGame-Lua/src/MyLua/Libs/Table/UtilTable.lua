require "MyLua.Libs.Core.GlobalNS"
require "MyLua.Libs.Core.Class"
require "MyLua.Libs.Core.GObject"

local M = GlobalNS.StaticClass();
local this = M;
M.clsName = "UtilTable";
GlobalNS[M.clsName] = M;

function M.ctor()
    this.m_prePos = 0;        -- 记录之前的位置
    this.m_sCnt = 0;
end

function M.readString(bytes, tmpStr)
    bytes:readUnsignedInt16(this.m_sCnt);
    bytes:readMultiByte(tmpStr, this.m_sCnt, GkEncode.UTF8);
end

M.ctor();        -- 构造

return M;
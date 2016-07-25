-- 各种需要的 ByteBuffer

package.path = string.format("%s;%s/?.lua", package.path, "E:/Self/Self/unity/unitygame/Client/Assets/Prefabs/Resources")

require "DataStruct.ByteBuffer"
 
NetMsgData = ByteBuffer.new()
--NetMsgData = {}

--ByteBuffer:setSysEndian(23)
-- 输出测试
function NetMsgData:TestOut()
    self:log("TestOut")
    self:setPos(0)
    --self:clear()
    --local _int16 = self:readInt16()
    self:dumpAllBytes()
end

--NetMsgData:TestOut()

-- 给 C# 提供接口，因为 C# 中通过堆栈获取 Lua 函数，如果这个函数是通过元表指定的，是获取不到的，必须自己手工添加到表中的才能获取到
function NetMsgData:writeInt8FromCS(oneByte)
    self:writeInt8(oneByte)
end

function NetMsgData:writeMultiByteFromCS(bytes)
    self:writeMultiByte(bytes)
end

function NetMsgData:readInt8FromCS()
    return self:readInt8()
end

function NetMsgData:readInt16FromCS()
    return self:readInt16()
end

function NetMsgData:readInt32FromCS()
    return self:readInt32()
end

function NetMsgData:readMultiByteFromCS()
    self:log("readMultiByteFromCS")
    local len_ = 16
    return self:readMultiByte(len_)
end

function NetMsgData:clearFromCS(oneByte)
    self:clear()
end

-- 测试字符串
--[[
NetMsgData:writeMultiByte("asdfasdf")
NetMsgData:setPos(0)
local bbbb = NetMsgData:readMultiByte(8)
local sssss = 10
]]

--[[
-- 测试 double
NetMsgData:writeDouble(1245698.89)
NetMsgData:setPos(0)
local double_ = NetMsgData:readDouble()
local asdf = 10
]]

-- 测试 int32
--[[
NetMsgData:writeInt32(1289)
NetMsgData:setPos(0)
local int32_ = NetMsgData:readInt32()

local aaa = 10
]]

-- 测试 byte 
local tbl = {}
tbl[0] = 12345
local bt = string.byte(tbl[0])
local aaa = 145
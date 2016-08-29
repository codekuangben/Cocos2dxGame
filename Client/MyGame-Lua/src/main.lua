
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")	-- src 查找目录
cc.FileUtils:getInstance():addSearchPath("res/") 	-- res 查找目录
cc.FileUtils:getInstance():addSearchPath("res/UI") 	-- res/UI 查找目录
--cc.FileUtils:getInstance():addSearchPath("res/Effect")
--cc.FileUtils:getInstance():addSearchPath("res/Particle")

require("mobdebug").start()

local initconnection = require("debugger")
--initconnection("127.0.0.1", 10001, "luaidekey")
initconnection("127.0.0.1", 10001, "luaidekey", nil, nil, "E:/Self/Self/Cocos2dxGame-git/Cocos2dxGame/Client/MyGame-Lua/src")

require "MyLua.Libs.Core.Prequisites"

require "config"
require "cocos.init"

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end

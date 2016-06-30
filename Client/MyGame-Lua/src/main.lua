
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")	-- src 查找目录
cc.FileUtils:getInstance():addSearchPath("res/") 	-- res 查找目录


require("mobdebug").start()

--cc.FileUtils:getInstance():addSearchPath("res/UI") 	-- res/UI 查找目录

require "config"
require "cocos.init"

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end

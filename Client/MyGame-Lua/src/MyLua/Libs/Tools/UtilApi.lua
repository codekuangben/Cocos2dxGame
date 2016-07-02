local director = cc.Director:getInstance()

local M = {};

function M:getStageVisibleSize()
	return director:getVisibleSize();
end

function M:getStageVisibleOrigin()
	return director:getVisibleOrigin();
end

return M;
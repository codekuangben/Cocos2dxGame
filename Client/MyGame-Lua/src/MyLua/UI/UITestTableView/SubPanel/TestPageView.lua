local M = GlobalNS.Class(GlobalNS.AuxPageView);
M.clsName = "TestPageView";
GlobalNS[M.clsName] = M;

function M:ctor()
	self.mPageViewX = 0;
	self.mPageViewY = 0;
	
	self.mPageViewWidth = 500;
	self.mPageViewHeight = 500;
	
	--self.mDirection = cc.SCROLLVIEW_DIRECTION_HORIZONTAL
	self.mDirection = ccui.ScrollViewDir.horizontal;
end

function M:dtor()
	
end

function M:onPageViewTurn()
	
end

return M;
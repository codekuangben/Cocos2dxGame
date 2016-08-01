local M = GlobalNS.Class(GlobalNS.AuxWindow);
M.clsName = "AuxScrollView";
GlobalNS[M.clsName] = M;

function M:ctor()
	self.mScrollViewX = 0;
	self.mScrollViewY = 0;
	
	self.mScrollViewWidth = 500;
	self.mScrollViewHeight = 500;
	
	self.mScrollViewInnerWidth = 500;
	self.mScrollViewInnerHeight = 1000;	
	
	--ccui.ScrollViewDir.vertical
	self.mDirection = cc.SCROLLVIEW_DIRECTION_VERTICAL;
	
	self.mScrollView = nil;
end

function M:dtor()
	
end


function M:init()
	self:createTableView();
end

function M:createTableView()
	self.mScrollView = ccui.ScrollView:create();
	self.mScrollView:setSwallowTouches(true);
	self.mScrollView:setEnabled(true);
	self.mScrollView:setPosition(cc.p(self.mScrollViewX, self.mScrollViewY));
	self.mScrollView:setContentSize(cc.size(self.mScrollViewWidth, self.mScrollViewHeight));
	self.mScrollView:setDirection(self.mDirection);
	self.mScrollView:setScrollBarEnabled(false);
	self.mScrollView:setInnerContainerSize(cc.size(self.mScrollViewInnerWidth, self.mScrollViewInnerHeight));
	self.mScrollView.pThis = self;
	
	local cf = nil;
	local cf = GlobalNS.new(GlobalNS.ClosureFuncObject);
	cf:setPThisAndHandle(self, M.onTouchEvent);
	self.mScrollView:onEvent(cf);
end

function M:onTouchEvent(event)
	
end

return M;
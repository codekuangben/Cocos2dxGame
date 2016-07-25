local M = GlobalNS.Class(GlobalNS.AuxWindow);
M.clsName = "AuxTableViewCreateParam";
GlobalNS[M.clsName] = M;

function M:ctor()
	self.mTableViewX = 0;
	self.mTableViewY = 0;
	
	self.mTableViewWidth = 100;
	self.mTableViewHeight = 100;
	
	self.mDirection = cc.SCROLLVIEW_DIRECTION_VERTICAL;
	self.mVordering = cc.TABLEVIEW_FILL_TOPDOWN;
	
	self.onScrollViewDidScroll = nil;
	self.onScrollViewDidZoom = nil;
	self.onTableCellTouched = nil;
	self.onCellSizeForTable = nil;
	self.onTableCellAtIndex = nil;
	self.onNumberOfCellsInTableView = nil;
	
	self.mPThis = nil;
end

function M:dtor()
	
end

return M;
local M = GlobalNS.Class(GlobalNS.AuxTableView);
M.clsName = "TestTableView";
GlobalNS[M.clsName] = M;

function M:ctor()
	self.mTableViewX = 0;
	self.mTableViewY = 0;
	
	self.mTableViewWidth = 500;
	self.mTableViewHeight = 500;
	
	self.mDirection = cc.SCROLLVIEW_DIRECTION_VERTICAL;
	self.mVordering = cc.TABLEVIEW_FILL_TOPDOWN;
	
	self.mCellItemPath = "UI.UITestTableViewItem";
end

function M:dtor()
	
end

function M:onScrollViewDidScroll(tableView)
	
end

function M:onScrollViewDidZoom(tableView)
	
end

function M:onTableCellTouched(tableView, cell)
	
end

function M:onCellSizeForTable(tableView, cellIdx)
	return 500, 100;
end

function M:onTableCellAtIndex(tableView, cellIdx)
	local cell = self:getOrCreateCell(tableView);
	local listCell = self:getOrCreateCellItem(cell);
	
	return cell;
end

function M:onNumberOfCellsInTableView(tableView)
	return 10;
end

return M;
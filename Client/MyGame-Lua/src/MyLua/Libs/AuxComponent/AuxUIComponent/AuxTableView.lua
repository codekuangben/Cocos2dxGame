local M = GlobalNS.Class(GlobalNS.AuxWindow);
M.clsName = "AuxTableView";
GlobalNS[M.clsName] = M;

function M:ctor()
	self.mTableViewX = 0;
	self.mTableViewY = 0;
	
	self.mTableViewWidth = 100;
	self.mTableViewHeight = 100;
	
	self.mDirection = cc.SCROLLVIEW_DIRECTION_VERTICAL;
	self.mVordering = cc.TABLEVIEW_FILL_TOPDOWN;
	
	self.mCellItemTag = 1000;
	self.mcellItemPath = "";
end

function M:dtor()
	
end

function M:init()
	self:createTableView();
end

function M:getNativeTableView()
	return self.mTableView;
end

function M:createTableView()
	self.mTableView = cc.TableView:create(cc.size(self.mTableViewWidth, self.mTableViewHeight));
	self.mTableView:setDirection(self.mDirection);
	self.mTableView:setPosition(cc.p(self.mTableViewX, self.mTableViewY));
	self.mTableView:setDelegate();
	self.mTableView:setVerticalFillOrder(self.mVordering);
	
	--[[
	self.mTableView:registerScriptHandler(M.onGlobalScrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL);
	self.mTableView:registerScriptHandler(M.onGlobalScrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM);
	self.mTableView:registerScriptHandler(M.onGlobalTableCellTouched, cc.TABLECELL_TOUCHED);
	self.mTableView:registerScriptHandler(M.onGlobalCellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX);
	self.mTableView:registerScriptHandler(M.onGlobalTableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX);
	self.mTableView:registerScriptHandler(M.onGlobalNumberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW);
	]]
	
	local functor = nil;
	functor = handler(self, M.onScrollViewDidScroll);
	self.mTableView:registerScriptHandler(functor, cc.SCROLLVIEW_SCRIPT_SCROLL);
	
	functor = handler(self, M.onScrollViewDidZoom);
	self.mTableView:registerScriptHandler(functor, cc.SCROLLVIEW_SCRIPT_ZOOM);
	
	functor = handler(self, M.onTableCellTouched);
	self.mTableView:registerScriptHandler(functor, cc.TABLECELL_TOUCHED);
	
	functor = handler(self, M.onCellSizeForTable);
	self.mTableView:registerScriptHandler(functor, cc.TABLECELL_SIZE_FOR_INDEX);
	
	functor = handler(self, M.onTableCellAtIndex);
	self.mTableView:registerScriptHandler(functor, cc.TABLECELL_SIZE_AT_INDEX);
	
	functor = handler(self, M.onNumberOfCellsInTableView);
	self.mTableView:registerScriptHandler(functor, cc.NUMBER_OF_CELLS_IN_TABLEVIEW);
end

--Self 接口
function M:onScrollViewDidScroll(tableView)
	
end

function M:onScrollViewDidZoom(tableView)
	
end

function M:onTableCellTouched(tableView, cell)
	
end

function M:onCellSizeForTable(tableView, cellIdx)
	return 100, 100;
end

function M:onTableCellAtIndex(tableView, cellIdx)
	return nil;
end

function M:onNumberOfCellsInTableView(tableView)
	return 0;
end

--[[
--非 Self 接口
function M.onGlobalScrollViewDidScroll(tableView)
	
end

function M.onGlobalScrollViewDidZoom(tableView)
	
end

function M.onGlobalTableCellTouched(tableView, cell)
	
end

function M.onGlobalCellSizeForTable(tableView, idx)
	return 100, 100;
end

function M.onGlobalTableCellAtIndex(tableView, idx)
	return nil;
end

function M.onGlobalNumberOfCellsInTableView(tableView)
	return 0;
end
]]

function M:reloadData()
	if(self.mTableView ~= nil) then
		self.mTableView:reloadData();
	end
end

function M:setPosition(posX, posY)
	if(nil ~= self.mTableView) then
		self.mTableViewX = posX;
		self.mTableViewY = posY;
		self.mTableView:setPosition(cc.p(self.mTableViewX, self.mTableViewY));
	end
end

function M:getOrCreateCell(tableView)
	local cell = tableView:dequeueCell();
	if(nil == cell) then
		cell = GlobalNS.UtilApi.createTableViewCell();
	end
	
	return cell;
end

function M:getOrCreateCellItem(cell)
	local cellItem = cell:getChildByTag(1000);
	if(nil == cellItem) then
		cellItem = GlobalNS.UtilApi.getAndLoadLuaRoot(self.mcellItemPath);
		cellItem:setTag(self.mCellItemTag);
		GlobalNS.UtilApi.addChild(cell, cellItem);
	end
	
	return cellItem;
end

return M;
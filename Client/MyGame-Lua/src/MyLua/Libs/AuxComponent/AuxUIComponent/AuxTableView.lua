local M = GlobalNS.Class(GlobalNS.AuxWindow);
M.clsName = "AuxTableView";
GlobalNS[M.clsName] = M;

function M.create(params)
	local tableView = GlobalNS.new(GlobalNS.AuxTableView);
	tableView:init(params);
	return tableView;
end

function M:ctor()
	
end

function M:dtor()
	
end

function M:init(params)
    self.mParams = params;
	self:createTableView();
end

function M:getNativeTableView()
	return self.mTableView;
end

function M:createTableView()
	self.mTableView = cc.TableView:create(cc.size(self.mParams.mTableViewWidth, self.mParams.mTableViewHeight));
	self.mTableView:setDirection(self.mParams.mDirection);
	self.mTableView:setPosition(cc.p(self.mParams.mTableViewX, self.mParams.mTableViewY));
	self.mTableView:setDelegate();
	self.mTableView:setVerticalFillOrder(self.mParams.mVordering);
	
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

function M:reloadData()
	if(self.mTableView ~= nil) then
		self.mTableView:reloadData();
	end
end

--Self 接口
function M:onScrollViewDidScroll(tableView)
	if(self.mParams.onScrollViewDidScroll ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onScrollViewDidScroll(self.mParams.mPThis, tableView);
	elseif (self.mParams.onScrollViewDidScroll ~= nil) then
		self.mParams.onScrollViewDidScroll(tableView);
	end
end

function M:onScrollViewDidZoom(tableView)
	if(self.mParams.onScrollViewDidZoom ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onScrollViewDidZoom(self.mParams.mPThis, tableView);
	elseif (self.mParams.onScrollViewDidZoom ~= nil) then
		self.mParams.onScrollViewDidZoom(tableView);
	end
end

function M:onTableCellTouched(tableView, cell)
	if(self.mParams.onTableCellTouched ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onTableCellTouched(self.mParams.mPThis, tableView);
	elseif (self.mParams.onTableCellTouched ~= nil) then
		self.mParams.onTableCellTouched(tableView);
	end
end

function M:onCellSizeForTable(tableView, cellIdx)
	if(self.mParams.onCellSizeForTable ~= nil and self.mParams.mPThis ~= nil) then
		return self.mParams.onCellSizeForTable(self.mParams.mPThis, tableView);
	elseif (self.mParams.onCellSizeForTable ~= nil) then
		return self.mParams.onCellSizeForTable(tableView);
	end
	
	return 100, 100;
end

function M:onTableCellAtIndex(tableView, cellIdx)
	if(self.mParams.onTableCellAtIndex ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onTableCellAtIndex(self.mParams.mPThis, tableView);
	elseif (self.mParams.onTableCellAtIndex ~= nil) then
		self.mParams.onTableCellAtIndex(tableView);
	end
end

function M:onNumberOfCellsInTableView(tableView)
	if(self.mParams.onNumberOfCellsInTableView ~= nil and self.mParams.mPThis ~= nil) then
		return self.mParams.onNumberOfCellsInTableView(self.mParams.mPThis, tableView);
	elseif (self.mParams.onNumberOfCellsInTableView ~= nil) then
		return self.mParams.onNumberOfCellsInTableView(tableView);
	end
	
	return 0;
end

--非 Self 接口
function M.onGlobalScrollViewDidScroll(tableView)
	if(self.mParams.onScrollViewDidScroll ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onScrollViewDidScroll(self.mParams.mPThis, tableView);
	elseif (self.mParams.onScrollViewDidScroll ~= nil) then
		self.mParams.onScrollViewDidScroll(tableView);
	end
end

function M.onGlobalScrollViewDidZoom(tableView)
	if(self.mParams.onScrollViewDidZoom ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onScrollViewDidZoom(self.mParams.mPThis, tableView);
	elseif (self.mParams.onScrollViewDidZoom ~= nil) then
		self.mParams.onScrollViewDidZoom(tableView);
	end
end

function M.onGlobalTableCellTouched(tableView, cell)
	if(self.mParams.onTableCellTouched ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onTableCellTouched(self.mParams.mPThis, tableView);
	elseif (self.mParams.onTableCellTouched ~= nil) then
		self.mParams.onTableCellTouched(tableView);
	end
end

function M.onGlobalCellSizeForTable(tableView, idx)
	if(self.mParams.onCellSizeForTable ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onCellSizeForTable(self.mParams.mPThis, tableView);
	elseif (self.mParams.onCellSizeForTable ~= nil) then
		self.mParams.onCellSizeForTable(tableView);
	end
end

function M.onGlobalTableCellAtIndex(tableView, idx)
	if(self.mParams.onTableCellAtIndex ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onTableCellAtIndex(self.mParams.mPThis, tableView);
	elseif (self.mParams.onTableCellAtIndex ~= nil) then
		self.mParams.onTableCellAtIndex(tableView);
	end
end

function M.onGlobalNumberOfCellsInTableView(tableView)
	if(self.mParams.onNumberOfCellsInTableView ~= nil and self.mParams.mPThis ~= nil) then
		self.mParams.onNumberOfCellsInTableView(self.mParams.mPThis, tableView);
	elseif (self.mParams.onNumberOfCellsInTableView ~= nil) then
		self.mParams.onNumberOfCellsInTableView(tableView);
	end
end

return M;
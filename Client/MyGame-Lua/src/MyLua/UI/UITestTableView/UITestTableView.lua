require "MyLua.UI.UITestTableView.TestTableViewNS"
require "MyLua.UI.UITestTableView.TestTableViewData"

local M = GlobalNS.Class(GlobalNS.Form);
M.clsName = "UITestTableView";
GlobalNS.TestTableViewNS[M.clsName] = M;

function M:ctor()
	self.mData = GlobalNS.new(GlobalNS.TestTableViewNS.TestTableViewData);
	self.mModuleFullPath = "UI.UITestTableView";
end

function M:dtor()
	
end

function M:onInit()
    M.super.onInit(self);
	
	self.mTableViewWidth = 100;
	self.mTableViewHeight = 100;
	
	self.mTableViewX = 0;
	self.mTableViewY = 0;
end

function M:onReady()
    M.super.onReady(self);

	self:testVerticleTableView();
end

function M:onShow()
    M.super.onShow(self);
end

function M:onHide()
    M.super.onHide(self);
end

function M:onExit()
    M.super.onExit(self);
end

function M:onBtnClk()
	self:testEnumLoginMsg();
end

function M:testVerticleTableView()
	local params = GlobalNS.new(GlobalNS.AuxTableViewCreateParam);
	params.mTableViewX = 0;
	params.mTableViewY = 0;
	
	params.mTableViewWidth = 500;
	params.mTableViewHeight = 500;
	
	params.onScrollViewDidScroll = M.onScrollViewDidScroll;
	params.onScrollViewDidZoom = M.onScrollViewDidZoom;
	params.onTableCellTouched = M.onTableCellTouched;
	params.onCellSizeForTable = M.onCellSizeForTable;
	params.onTableCellAtIndex = M.onTableCellAtIndex;
	params.onNumberOfCellsInTableView = M.onNumberOfCellsInTableView;
	
	params.mPThis = self;
	
	self.mTableView = GlobalNS.AuxTableView.create(params);
	GlobalNS.UtilApi.addChild(self:getRootLayer(), self.mTableView:getNativeTableView());
	self.mTableView:reloadData();
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
	local cell = tableView:dequeueCell();
	if(nil == cell) then
		cell = GlobalNS.UtilApi.createTableViewCell();
	end
	
	local listCell = cell:getChildByTag(1000);
	if(nil == listCell) then
		local uiModule = require "UI.UITestTableViewItem";
		local uiNode = uiModule.create();
		listCell = uiNode.root;
		listCell:setTag(1000);
		GlobalNS.UtilApi.addChild(cell, listCell);
	end
end

function M:onNumberOfCellsInTableView(tableView)
	return 5;
end

return M;
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
	self.mTableView = GlobalNS.new(GlobalNS.AuxTableView);
	self.mTableView:init();
	GlobalNS.UtilApi.addChild(self:getRootLayer(), self.mTableView:getNativeTableView());
	self.mTableView:reloadData();
end

return M;
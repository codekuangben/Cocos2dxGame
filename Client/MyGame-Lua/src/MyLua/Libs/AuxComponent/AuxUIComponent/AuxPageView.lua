local M = GlobalNS.Class(GlobalNS.AuxWindow);
M.clsName = "AuxPageView";
GlobalNS[M.clsName] = M;

function M:ctor()
	self.mPageView = nil
end

function M:dtor()
	
end

function M:init()
	self:createPageView();
end

function M:createPageView()
	
end

function M:addEventHandle()
	local pageView = panel_main:getChildByName("PageView_1")  
	self.mPageView.pThis = self;
	self.mPageView:addEventListener(onPageViewEvent) 
end

function M.onPageViewEvent(sender, eventType)  
	if(eventType == ccui.PageViewEventType.turning) then  
		local pageView = sender;
		local this = self.mPageView.pThis;
		local pageNum = pageView:getCurPageIndex() + 1; 
	end  
end

return M;
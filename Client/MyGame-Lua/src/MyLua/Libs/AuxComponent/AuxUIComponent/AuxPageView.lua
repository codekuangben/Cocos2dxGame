local M = GlobalNS.Class(GlobalNS.AuxWindow);
M.clsName = "AuxPageView";
GlobalNS[M.clsName] = M;

function M:ctor()
	self.mPageViewX = 0;
	self.mPageViewY = 0;
	
	self.mPageViewWidth = 500;
	self.mPageViewHeight = 500;
	self.mCellItemTag = 1000;
	
	self.mDirection = ccui.ScrollViewDir.horizontal;
	--self.mDirection = cc.SCROLLVIEW_DIRECTION_HORIZONTAL
	self.mPageView = nil;
end

function M:dtor()
	
end

--��ʼ��
function M:init(pageView)
	self.mPageView = pageView;
	self:createPageView();
	self:findWidget();
	self:addEventHandle();
end

function M:getNativePageView()
	return self.mPageView;
end

--��������
function M:createPageView()
	if(nil == self.mPageView) then
		--������ ccui.PageView, ���� cc.PageView
		self.mPageView = ccui.PageView:create();
		self.mPageView:setDirection(self.mDirection);
		--cc.size ���� cc.Size 
		self.mPageView:setContentSize(cc.size(self.mPageViewWidth, self.mPageViewHeight));
		self.mPageView:setPosition(cc.size(self.mPageViewX, self.mPageViewY));
		self.mPageView:removeAllItems();
		self.mPageView:setIndicatorEnabled(false);
	end
	
	self.mPageView.pThis = self;
end

--���Ҵ���
function M:findWidget()
	
end

--����¼�������
function M:addEventHandle()
	--self.mPageView:onEvent(M.onPageViewEvent);
	local cf = GlobalNS.new(GlobalNS.ClosureFuncObject);
	
end

function M.onPageViewEvent(event)  
	if("TURNING" == event.name) then
		local this = event.target.pThis;
		this:onPageViewTurn();
	end  
end

function M:onPageViewTurn()
	local pageNum = sender:getCurPageIndex() + 1; 
end

function M:removeItem(index)
	if(nil ~= self.mPageView) then
		self.mPageView:removeItem(index);
	end
end

--void ListView::insertCustomItem(Widget* item, ssize_t index) ����ӿڵ�һ������������һ�� Widget ���У���� CocosStudio ֱ�������� UI�������� Lua �ļ� Root ���� Widget ����˲���ֱ����ӵ� PageView ����, Layout �� Widget ���࣬ TableView ���� Widget ������
function M:insertCustomItem(item, index)
	if(nil ~= self.mPageView) then
		item:setTag(self.mCellItemTag);
		local layout = ccui.Layout:create();
		layout:setContentSize(cc.size(self.mPageViewWidth, self.mPageViewHeight));
		layout:addChild(item);
		self.mPageView:insertCustomItem(layout, index);
	end
end

function M:scrollToItem(itemIndex)
	if(nil ~= self.mPageView) then
		self.mPageView:scrollToItem(itemIndex);
	end
end

return M;
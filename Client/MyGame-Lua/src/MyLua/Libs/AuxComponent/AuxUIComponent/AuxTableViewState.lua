local M = GlobalNS.Class(GlobalNS.GObject);
M.clsName = "AuxTableViewState";
GlobalNS[M.clsName] = M;

function M:ctor(tableView)
	self:init(tableView);
end

function M:dtor()
	self:dispose();
end

function M:init(tableView)
    self.mTableView = tableView;
    self.mDirection = self.mTableView:getDirection();
    
	self.mOffsetBeforeReload = nil;
	self.mContentSizeBeforeReload = nil;
	self.mViewSize = nil;
	
	self.mOffsetAfterReload = nil;
    self.mContentSizeAfterReload = nil;
end

function M:dispose()
    self.mTableView = nil;
    self.mDirection = nil;
    
    self.mOffsetBeforeReload = nil;
    self.mContentSizeBeforeReload = nil;
    self.mViewSize = nil;
    
    self.mOffsetAfterReload = nil;
    self.mContentSizeAfterReload = nil;
end

function M:setTableView(tableView)
    self.mTableView = tableView;
    self.mDirection = self.mTableView:getDirection();
end

function M:beforeReload()
    self.mOffsetBeforeReload = self.mTableView:getContentOffset();
    self.mContentSizeBeforeReload = self.mTableView:getContentSize();
    self.mViewSize = self.mTableView:getViewSize();
end

function M:afterReload()
    self.mOffsetAfterReload = self.mTableView:getContentOffset();
    self.mContentSizeAfterReload = self.mTableView:getContentOffset();
    local offset = nil;
    local delta = 0;
    
    if(self.mDirection == cc.SCROLLVIEW_DIRECTION_VERTICAL) then
        if(self.mViewSize.height < self.mContentSizeAfterReload.height) then
            offset = {x = 0, y = 0};
            if(not self.mOffsetBeforeReload.height == self.mContentSizeAfterReload.height) then
                delta = self.mContentSizeAfterReload.height - self.mContentSizeBeforeReload.height;
                offset.y = self.mOffsetBeforeReload.y - delta;
            end
            
            offset.x = self.mOffsetBeforeReload.x;
            self.mTableView:setContentOffset(offset);
        end
    elseif(self.mDirection == cc.SCROLLVIEW_DIRECTION_HORIZONTAL) then
        if(self.mViewSize.width < self.mContentSizeAfterReload.width) then
            offset = {x = 0, y = 0};
            if(not self.mOffsetBeforeReload.width == self.mContentSizeAfterReload.width) then
                delta = self.mContentSizeAfterReload.width - self.mContentSizeBeforeReload.width;
                offset.x = self.mOffsetBeforeReload.x - delta;
            end
            
            offset.y = self.mOffsetBeforeReload.y;
            self.mTableView:setContentOffset(offset);
        end
    end
end

return M;
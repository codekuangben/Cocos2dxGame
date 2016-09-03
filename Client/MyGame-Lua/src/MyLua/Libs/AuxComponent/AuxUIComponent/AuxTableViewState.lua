local M = GlobalNS.Class(GlobalNS.GObject);
M.clsName = "AuxTableViewState";
GlobalNS[M.clsName] = M;

function M:ctor(tableView, direction)
	self:init(tableView, direction);
end

function M:dtor()
	self:dispose();
end

function M:init(tableView, direction)
    self.mTableView = tableView;
    self.mDirection = direction;
    
	self.mOffsetBeforeReload = nil;
	self.mContentSizeBeforeReload = nil;
	self.mViewSize = nil;
	
	self.mOffsetAfterReload = nil;
    self.mContentSizeAfterReload = nil;
end

function M:dispose()

end

function M:setTableView(tableView, direction)
    self.mTableView = tableView;
    self.mDirection = direction;
end

function M:beforeReload()
    self.mOffsetBeforeReload = self.mTableView:getContentOffset();
    self.mContentSizeBeforeReload = self.mTableView:getContentSize();
    self.mViewSize = self.mTableView:getViewSize();
end

function M:afterReload()
    self.mOffsetAfterReload = self.mTableView:getContentOffset();
    self.mContentSizeAfterReload = self.mTableView:getContentOffset();
    
    if(self.mDirection == cc.SCROLLVIEW_DIRECTION_VERTICAL) then
        if(self.mViewSize.height < self.mContentSizeAfterReload.height) then
            if(self.mOffsetBeforeReload.height == self.mContentSizeAfterReload.height) then
                self.mTableView:setContentOffset(self.mOffsetBeforeReload);
            else
                local distY = self.mContentSizeAfterReload.height - self.mContentSizeBeforeReload.height;
                self.mOffsetBeforeReload.y = self.mOffsetBeforeReload.y - distY;
                self.mTableView:setContentOffset(self.mOffsetBeforeReload);
            end
        end
    elseif(self.mDirection == cc.SCROLLVIEW_DIRECTION_HORIZONTAL) then
        if(self.mViewSize.width < self.mContentSizeAfterReload.width) then
            if(self.mOffsetBeforeReload.width == self.mContentSizeAfterReload.width) then
                self.mTableView:setContentOffset(self.mOffsetBeforeReload);
            else
                local distX = self.mContentSizeAfterReload.width - self.mContentSizeBeforeReload.width;
                self.mOffsetBeforeReload.x = self.mOffsetBeforeReload.x - distX;
                self.mTableView:setContentOffset(self.mOffsetBeforeReload);
            end
        end
    end
end

return M;
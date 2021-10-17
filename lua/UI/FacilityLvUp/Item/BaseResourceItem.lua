require("UI.UIBaseCtrl")

BaseResourceItem = class("BaseResourceItem", UIBaseCtrl);
BaseResourceItem.__index = BaseResourceItem
--@@ GF Auto Gen Block Begin
BaseResourceItem.mText_ResName = nil;
BaseResourceItem.mText_ResNum = nil;

function BaseResourceItem:__InitCtrl()

	self.mText_ResName = self:GetText("Text_ResName");
	self.mText_ResNum = self:GetText("Text_ResNum");
end

--@@ GF Auto Gen Block End

function BaseResourceItem:InitCtrl(root)

    local obj=instantiate(UIUtils.GetGizmosPrefab("Facility/BaseResourceItem.prefab",self));

    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);

    self:__InitCtrl();

end

--
function BaseResourceItem:SetData(cmdData)

    if cmdData ~=nil then



    end

end
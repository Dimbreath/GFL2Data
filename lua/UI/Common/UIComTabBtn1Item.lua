require("UI.UIBaseCtrl")

UIComTabBtn1Item = class("UIComTabBtn1Item", UIBaseCtrl);
UIComTabBtn1Item.__index = UIComTabBtn1Item
--@@ GF Auto Gen Block Begin


function UIComTabBtn1Item:__InitCtrl()
    self.mText_Name = self:GetText("Root/GrpText/Text_Name");
    self.mBtn_Item = self:GetSelfButton();
    self.mTrans_Lock = self:GetRectTransform("Root/GrpLock");
end

--@@ GF Auto Gen Block End
UIComTabBtn1Item.mData = nil;

function UIComTabBtn1Item:InitCtrl(root)


    local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComTabBtn1ItemV2.prefab",self));

    self:SetRoot(obj.transform);
    obj.transform:SetParent(root,false);
    obj.transform.localScale=vectorone;

	self:__InitCtrl();

end


function UIComTabBtn1Item:SetData(data)
    self.mData = data
    self.mText_Name.text = data.name;
    self:UpdateLock();
end

function UIComTabBtn1Item:UpdateLock()
    if(self:IsLocked()) then
        setactive(self.mTrans_Lock,true)
    else
        setactive(self.mTrans_Lock,false)
    end
end

function UIComTabBtn1Item:IsLocked()
    if(self.mData.id > 1 and not NetCmdQuestData:CheckNewbiePhaseIsReceived(self.mData.id-1)) then
        return true
    end

    return false
end

function UIComTabBtn1Item:SetSelect(isSelected)
    self.mBtn_Item.interactable = not isSelected;
end



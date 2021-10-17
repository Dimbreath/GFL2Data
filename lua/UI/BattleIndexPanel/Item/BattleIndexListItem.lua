require("UI.UIBaseCtrl")

BattleIndexListItem = class("BattleIndexListItem", UIBaseCtrl);
BattleIndexListItem.__index = BattleIndexListItem
--@@ GF Auto Gen Block Begin


function BattleIndexListItem:__InitCtrl()
    self.mText_Name = self:GetText("GrpText/Text_Name");
    self.mText_EnName = self:GetText("GrpText/Text_ENName");
    self.mText_Num = self:GetText("GrpText/Text_Num");
    self.mTrans_RedPoint = self:GetRectTransform("Trans_RedPoint");
    self:InstanceUIPrefab("UICommonFramework/ComRedPointItemV2.prefab", self.mTrans_RedPoint, true)

    self.mTrans_Lock = self:GetRectTransform("Trans_GrpLock");
    self.mBtn_Self = self:GetSelfButton();
end

function BattleIndexListItem:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("BattleIndex/BattleIndexListItemV2.prefab",self));
	CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject)
	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function BattleIndexListItem:SetData(name,enname,num,islock)
    self.mText_Name.text = name;
    self.mText_EnName.text = enname;
    self.mText_Num.text = num;
    setactive(self.mTrans_RedPoint, NetCmdDungeonData:UpdateChatperIndexRedPoint(self.mData.id) > 0)
    self:SetLock(islock);
    --NetCmdSimulateBattleData:CheckTeachingRewardRedPoint() or NetCmdSimulateBattleData:CheckTeachingUnlockRedPoint()
end

BattleIndexListItem.bIsSim = false;

function BattleIndexListItem:UpdateRedPoint()
    if(self.mIsLock) then
        setactive(self.mTrans_RedPoint, false);
        return
    end

    local b = NetCmdSimulateBattleData:CheckTeachingRewardRedPoint() or NetCmdSimulateBattleData:CheckTeachingUnlockRedPoint()
    setactive(self.mTrans_RedPoint, b)
    self.bIsSim = true;
end


function BattleIndexListItem:SetSelected(isSelect)
    self.mBtn_Self.interactable =  (not isSelect);
    if(bIsSim == false) then 
        setactive(self.mTrans_RedPoint, not isSelect and NetCmdDungeonData:UpdateChatperIndexRedPoint(self.mData.id) > 0)
    end
end

function BattleIndexListItem:SetLock(isLock)
    setactive(self.mTrans_Lock,isLock);
    self.mIsLock = isLock;

    if(self.mIsLock) then
        setactive(self.mTrans_RedPoint, false);
        return
    end
end
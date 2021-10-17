--region *.lua
--Date

require("UI.UIBaseCtrl")

UIFormationMemberItem = class("UIFormationMemberItem", UIBaseCtrl);
UIFormationMemberItem.__index = UIFormationMemberItem;

UIFormationMemberItem.mObj_Locked = nil;
UIFormationMemberItem.mObj_NoneMember = nil;
UIFormationMemberItem.mObj_HaveMember = nil;

UIFormationMemberItem.mButton_HaveMember = nil;
UIFormationMemberItem.mButton_NoneMember = nil;

UIFormationMemberItem.mText_GunName = nil;

--����
function UIFormationMemberItem:ctor()
    UIFormationMemberItem.super.ctor(self);
end

--��ʼ��
function UIFormationMemberItem:InitCtrl(root)

    self:SetRoot(root);

    self.mObj_Locked = self:FindChild("BG/Locked");
    self.mObj_NoneMember = self:FindChild("BG/MemberNone");
    self.mObj_HaveMember = self:FindChild("BG/MemberHave");

    self.mText_GunName = self:GetText("BG/MemberHave/Name/BG/Text");
    self.mButton_HaveMember = self:GetButton("BG/MemberHave");
    self.mButton_NoneMember = self:GetButton("BG/MemberNone");
end

function UIFormationMemberItem:SetData(gunData)
    local gunData = TableData.listGunDatas:GetDataById(gunData.stc_gun_id);
    self.mText_GunName.text = gunData.name;
end

function UIFormationMemberItem:ShowLocked()
    setactive(self.mObj_Locked, true);
    setactive(self.mObj_NoneMember, false);
    setactive(self.mObj_HaveMember, false);
end

function UIFormationMemberItem:ShowNoneMember()
    setactive(self.mObj_Locked, false);
    setactive(self.mObj_NoneMember, true);
    setactive(self.mObj_HaveMember, false);
end

function UIFormationMemberItem:ShowHaveMember()
    setactive(self.mObj_Locked, false);
    setactive(self.mObj_NoneMember, false);
    setactive(self.mObj_HaveMember, true);
end
--endregion

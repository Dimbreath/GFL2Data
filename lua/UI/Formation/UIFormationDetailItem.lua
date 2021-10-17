--region *.lua
--Date

require("UI.UIBaseCtrl")

UIFormationDetailItem = class("UIFormationDetailItem", UIBaseCtrl);
UIFormationDetailItem.__index = UIFormationDetailItem;

UIFormationDetailItem.mButton_OpenDetail = nil;
UIFormationDetailItem.mText_TeamNum = nil;

UIFormationDetailItem.mObj_HaveMember = nil;
UIFormationDetailItem.mObj_NoneMember = nil;

UIFormationDetailItem.mImage_AType = nil;
UIFormationDetailItem.mImage_DType = nil;


--构造
function UIFormationDetailItem:ctor()
    UIFormationDetailItem.super.ctor(self);
end

--初始化
function UIFormationDetailItem:InitCtrl(root)

    self:SetRoot(root);

    self.mButton_OpenDetail = self:GetButton("BG/HaveMember/OpenDetail");
    self.mText_TeamNum = self:GetText("BG/TeamName/Text");

    self.mObj_HaveMember = self:FindChild("BG/HaveMember");
    self.mObj_NoneMember = self:FindChild("BG/NonMember");
    
    self.mImage_AType = self:GetImage("BG/HaveMember/TeamType/A_Pic");
    self.mImage_DType = self:GetImage("BG/HaveMember/TeamType/D_Pic");
end

function UIFormationDetailItem:ShowHaveMember()
    setactive(self.mObj_HaveMember, true);
    setactive(self.mObj_NoneMember, false);
end

function UIFormationDetailItem:ShowNoneMember()
    setactive(self.mObj_HaveMember, false);
    setactive(self.mObj_NoneMember, true);
end

function UIFormationDetailItem:SetData(data)
    local carrier = TableData.GetCarrierBaseBodyData(data.stc_carrier_id);
    if carrier.type == CS.TableEnumDefine.ECarrierType.eAttack then
        setactive(self.mImage_AType, true);
        setactive(self.mImage_DType, false);
    else 
        if carrier.type == CS.TableEnumDefine.ECarrierType.eDefense then
            setactive(self.mImage_AType, false);
            setactive(self.mImage_DType, true);
        end
    end
end


--endregion

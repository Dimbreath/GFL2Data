--region *.lua
--Date

require("UI.UIBaseCtrl")

UIFormationSelectItem = class("UIFormationSelectItem", UIBaseCtrl);
UIFormationSelectItem.__index = UIFormationSelectItem;

UIFormationSelectItem.mButton_Select = nil;
UIFormationSelectItem.mImage_Select = nil;
UIFormationSelectItem.mText_TeamNum = nil;

UIFormationSelectItem.mImage_AType = nil;
UIFormationSelectItem.mImage_DType = nil;

UIFormationSelectItem.mData = nil;

--构造
function UIFormationSelectItem:ctor()
    UIFormationSelectItem.super.ctor(self);
end

--初始化
function UIFormationSelectItem:InitCtrl(root)

    self:SetRoot(root);

    self.mButton_Select = self:GetButton("Select");
    self.mImage_Select = self:GetImage("Sel");
    self.mText_TeamNum = self:GetText("TeamName/Text");

    self.mImage_AType = self:GetImage("TeamType/A-Pic");
    self.mImage_DType = self:GetImage("TeamType/D-Pic");
end

function UIFormationSelectItem:SetUIData(carrier)
   self.mData = carrier;
   local cdata = TableData.GetCarrierBaseBodyData(carrier.stc_carrier_id);
   if cdata == nil then
       return
   end
       
   self.mText_TeamNum.text = "编队"..carrier.team_id;

   if cdata.type == CS.TableEnumDefine.ECarrierType.eAttack then
       setactive(self.mImage_AType, true);
       setactive(self.mImage_DType, false);
   else 
       if cdata.type == CS.TableEnumDefine.ECarrierType.eDefense then
           setactive(self.mImage_AType, false);
           setactive(self.mImage_DType, true);
       end
   end
end

function UIFormationSelectItem:SetSelectEnable(selected)
    setactive(self.mImage_Select, selected);
end


--endregion

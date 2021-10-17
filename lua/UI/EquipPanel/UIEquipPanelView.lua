 require("UI.UIBaseView")

UIEquipPanelView = class("UIEquipPanelView", UIBaseView)
UIEquipPanelView.__index = UIEquipPanelView

function UIEquipPanelView:ctor()
    self.equipSetList = {}
end

function UIEquipPanelView:__InitCtrl()
    self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
    self.mBtn_CommandCenter =  UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))

    self.mTrans_TabParent = self:GetRectTransform("Root/GrpLeft/GrpDetailsList/Content")

    self.mTrans_Info = self:GetRectTransform("Root/GrpRight/Trans_GrpDetails")
    self.mTrans_Enhance = self:GetRectTransform("Root/GrpRight/Trans_GrpPowerUp")
    self.mTrans_Equipped = self:GetRectTransform("Root/GrpLeft/GrpEquipedChr")

    self.mImage_GunIcon = self:GetImage("Root/GrpLeft/GrpEquipedChr/GrpHead/GrpHead/Img_ChrHead")

    self.mImage_RankBg = self:GetImage("Root/GrpEquipIcon/Img_BgFrame")
    self.mImage_EquipIcon = self:GetImage("Root/GrpEquipIcon/Img_Icon")

    self.mImage_Index = self:GetImage("Root/GrpRight/Trans_GrpDetails/GrpEquipPosition/Img_Icon")
    self.mText_EquipName = self:GetText("Root/GrpRight/Trans_GrpDetails/GrpWeaponInfo/Text_Name")
    self.mText_Lv = self:GetText("Root/GrpRight/Trans_GrpDetails/GrpEquipLevel/GrpText/Text_Level")
    self.mText_MainPropName = self:GetText("Root/GrpRight/Trans_GrpDetails/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/GrpList/Text_Name")
    self.mText_MainPropValue = self:GetText("Root/GrpRight/Trans_GrpDetails/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/Text_Num")
    self.mTrans_SubPropList = self:GetRectTransform("Root/GrpRight/Trans_GrpDetails/GrpAttributeList/Viewport/Content/GrpAttribute")
    self.mImage_Grade = self:GetImage("Root/GrpRight/Trans_GrpDetails/GrpLine/Img_Line")

    UIEquipPanelView.mTrans_EquipListPanel = self:GetRectTransform("Root/GrpEquipList")

    self:InitEquipSetList()
    self:InitLockItem()
end

function UIEquipPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end

 function UIEquipPanelView:InitLockItem()
     local parent = self:GetRectTransform("Root/GrpRight/Trans_GrpDetails/BtnLock")
     local obj = self:InstanceUIPrefab("UICommonFramework/ComLockItemV2.prefab", parent, true)
     self.mBtn_Lock = UIUtils.GetButton(obj)
     self.mTrans_Lock = UIUtils.GetRectTransform(obj, "ImgLocked")
     self.mTrans_UnLock = UIUtils.GetRectTransform(obj, "ImgUnLocked")
 end

 function UIEquipPanelView:InitEquipSetList()
     for i = 1, 2 do
         local parent = self:GetRectTransform("Root/GrpRight/Trans_GrpDetails/GrpAttributeList/Viewport/Content/GrpSkill")
         local item = self:InitEquipSet(parent)
         table.insert(self.equipSetList, item)
     end
 end

 function UIEquipPanelView:InitEquipSet(parent)
     local equipSet = UIEquipSetItem.New()
     equipSet:InitCtrl(parent)

     return equipSet
 end
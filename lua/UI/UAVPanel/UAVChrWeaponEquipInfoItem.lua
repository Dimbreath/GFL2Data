require("UI.UIBaseCtrl")

UAVChrWeaponEquipInfoItem = class("UAVPartsItem", UIBaseCtrl);
UAVChrWeaponEquipInfoItem.__index = UAVChrWeaponEquipInfoItem

function UAVChrWeaponEquipInfoItem:__InitCtrl(view)

    self.mBtn_Unique=self:GetSelfButton()
    self.mTrans_Set=self:GetRectTransform("GrpSel")
    self.mTrans_SkillIcon=self:GetRectTransform("Trans_GrpItem")
    self.mTrans_Add=self:GetRectTransform("Trans_GrpAdd")
    self.mTrans_Lock=self:GetRectTransform("Trans_GrpLock")
    self.mTrans_RedPoint=self:GetRectTransform("Trans_RedPoint")
    self.mImage_LeftUpIcon=self:GetImage("Trans_GrpItem/GrpTacticSkill2DIcon/Img_Icon")
    self.mImage_SkillIcon=self:GetImage("Trans_GrpItem/Grp3DModel/Img_3DModelIcon")
    self.mText_CostNum=self:GetText("Trans_GrpItem/GrpCost/Text_Num")
    self.mText_SkillLevelNum=self:GetText("Trans_GrpItem/GrpLevel/Text_Num")
    self.mText_UnLockLevelNum=self:GetText("Trans_GrpLock/GrpLevel/Text_Num")
    self.mUavView=view
    self.armtabledata=TableData.GetUavArmsData()
    self.uavarmdic=NetCmdUavData:GetUavArmData()
    self.armequipstate=NetCmdUavData:GetArmEquipState()


end

--@@ GF Auto Gen Block End

function UAVChrWeaponEquipInfoItem:InitCtrl(root,view)

	self:SetRoot(root)

	self:__InitCtrl(view)

end

function UAVChrWeaponEquipInfoItem:InitData(data,State,callback,index)
    
end

function UAVChrWeaponEquipInfoItem.OnClickBtn(armid,UavView,pos)
    
end



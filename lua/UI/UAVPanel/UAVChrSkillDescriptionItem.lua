require("UI.UIBaseCtrl")

UAVChrSkillDescriptionItem = class("UAVChrSkillDescriptionItem", UIBaseCtrl);
UAVChrSkillDescriptionItem.__index = UAVChrSkillDescriptionItem


function UAVChrSkillDescriptionItem:__InitCtrl()

    self.mText_LevelNum=self:GetText("GrpLevel/Text_Num")
    self.mText_LevelDes=self:GetText("Text_Description")
    self.mImage_level=self:GetImage("GrpLevel/Img_Bg")

end


function UAVChrSkillDescriptionItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UAVChrSkillDescriptionItem:InitData(skilllevelid,armlevel,index)
    --self=UAVChrSkillDescriptionItem
    local armskilltabledata=TableData.GetUarArmRevelantData(skilllevelid)
    self.mText_LevelNum.text=string.sub(tostring(skilllevelid),4,4)
    self.mText_LevelDes.text=armskilltabledata.UpgradeDescription
    if index==armlevel then
        self.mImage_level.color=ColorUtils.OrangeColor
        self.mText_LevelDes.color=ColorUtils.OrangeColor
    elseif index<armlevel then
        self.mImage_level.color=ColorUtils.WhiteColor
        self.mText_LevelDes.color=ColorUtils.WhiteColor
    elseif index>armlevel then
        self.mImage_level.color=ColorUtils.GrayColor
        self.mText_LevelDes.color=ColorUtils.GrayColor
    end
end


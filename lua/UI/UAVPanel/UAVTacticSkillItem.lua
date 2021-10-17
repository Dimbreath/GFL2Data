require("UI.UIBaseCtrl")

UAVTacticSkillItem = class("UAVTacticSkillItem", UIBaseCtrl);
UAVTacticSkillItem.__index = UAVTacticSkillItem
UAVTacticSkillItem.mImage_Icon=nil
UAVTacticSkillItem.mText_OilCost=nil
UAVTacticSkillItem.mBtn_SKill=nil
UAVTacticSkillItem.tabledata=nil
UAVTacticSkillItem.uavview=nil
function UAVTacticSkillItem:__InitCtrl()
    self.mImage_Icon=self:GetImage("GrpIcon/ImgIcon")
    self.mText_OilCost=self:GetText("GrpText/Text_Num")
    self.mBtn_SKill=self:GetSelfButton()
    self.mAnimator=getcomponent(self.mBtn_SKill.transform, typeof(CS.UnityEngine.Animator))
    self.mAnimator:SetLayerWeight(1,0)
    self.tabledata=TableData.GetUavArmsData()
end

function UAVTacticSkillItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UAVTacticSkillItem:InitData(armid,uavview)
    if armid==0 then
        return
    end
    self.uavview=uavview
    
	for i = 0, self.tabledata.Count-1 do
        if armid==self.tabledata[armid].Id then
            local smallicondata=TableData.GetUarArmRevelantData(tonumber(self.tabledata[armid].SkillSet))
            self.mImage_Icon.sprite=UIUtils.GetIconSprite("Icon/Skill",smallicondata.Icon);
            self.mText_OilCost.text=smallicondata.TeCost
            UIUtils.GetButtonListener(self.mBtn_SKill.gameObject).onClick=function() self:OnClickIcon(armid) end
            break
        end
    end
end
function UAVTacticSkillItem:OnClickIcon(armid)
    
    self.SkillInfoPanel = UAVSkillInfoDialogContent.New()
    self.SkillInfoPanel:InitCtrl(self.uavview.Canvas)
    self.SkillInfoPanel:SetData(nil,self.uavview.Canvas,armid)
end

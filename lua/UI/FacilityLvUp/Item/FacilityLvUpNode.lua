require("UI.UIBaseCtrl")

FacilityLvUpNode = class("FacilityLvUpNode", UIBaseCtrl);
FacilityLvUpNode.__index = FacilityLvUpNode
--@@ GF Auto Gen Block Begin
FacilityLvUpNode.mImage_Icon = nil;
FacilityLvUpNode.mImage_Fill = nil;
FacilityLvUpNode.mText_Name = nil;
FacilityLvUpNode.mText_Lv = nil;
FacilityLvUpNode.mText_UpgradePercent = nil;
FacilityLvUpNode.mText_msg = nil;
FacilityLvUpNode.mTrans_UpgradingMask = nil;
FacilityLvUpNode.mTrans_locked = nil;
FacilityLvUpNode.mTrans_NextLv = nil;
FacilityLvUpNode.mTrans_ReqNotMsg = nil;
FacilityLvUpNode.mTrans_highlight = nil;

function FacilityLvUpNode:__InitCtrl()

	self.mImage_Icon = self:GetImage("Image_Icon");
	self.mImage_Fill = self:GetImage("Trans_UpgradingMask/FillBak/Image_Lvup_Fill");
	self.mText_Name = self:GetText("Text_Name");
	self.mText_Lv = self:GetText("Text_Lv");
	self.mText_UpgradePercent = self:GetText("Trans_UpgradingMask/Text_UpgradePercent");
	self.mText_msg = self:GetText("Trans_ReqNotMsg/Text_msg");
	self.mTrans_UpgradingMask = self:GetRectTransform("Trans_UpgradingMask");
	self.mTrans_locked = self:GetRectTransform("Trans_locked");
	self.mTrans_NextLv = self:GetRectTransform("Trans_NextLv");
	self.mTrans_ReqNotMsg = self:GetRectTransform("Trans_ReqNotMsg");
	self.mTrans_highlight = self:GetRectTransform("Trans_highlight");
end

--@@ GF Auto Gen Block End

function FacilityLvUpNode:InitCtrl(root)

    self:SetRoot(root);

    self:__InitCtrl();

end


--配置表数据
function FacilityLvUpNode:SetData(facData)

    --名字
    self.mText_Name.text=facData.name;

    --gfdebug(facData.name);


    local facCmdData = NetCmdFacilityData:GetFacilityCmdDataById(facData.id)

    local propData=TableData.GetFacilityPropertyData(facData.id,facCmdData.level);

    if facCmdData~=nil then
        --等级 Lv.
        self.mText_Lv.text=facCmdData.level;
    end

    --升级中 升级条 百分比
    if facCmdData.up_end_time ~=0 then
        setactive(self.mTrans_UpgradingMask.gameObject,true);
        local cur= propData.lvup_time-(facCmdData.up_end_time-CGameTime:GetTimestamp());
        self.mText_UpgradePercent.text=CS.UIUtils.GetPercentageString(cur,propData.lvup_time);

        self.mImage_Fill.fillAmount=cur/propData.lvup_time;

    else
        setactive(self.mTrans_UpgradingMask.gameObject,false);
    end


end


function FacilityLvUpNode:SetHighLight(isactive)

    setactive(self.mTrans_highlight,isactive);

end
















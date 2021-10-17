require("UI.UIBaseCtrl")

UAVContrastDialog = class("UAVContrastDialog", UIBaseCtrl);
UAVContrastDialog.__index = UAVContrastDialog
UAVContrastDialog.mTrans_GrpAction=nil
UAVContrastDialog.mTrans_UAV=nil
UAVContrastDialog.mImage_LeftUpIcon=nil
UAVContrastDialog.mImage_SkillIcon=niil
UAVContrastDialog.mText_CostNum=nil
UAVContrastDialog.mText_SkllName=nil
UAVContrastDialog.mText_RangeName=nil
UAVContrastDialog.mText_SkillLevel=nil
UAVContrastDialog.mText_SkillDes=nil
UAVContrastDialog.mToggle_Range=nil
UAVContrastDialog.mTrans_UAV=nil
UAVContrastDialog.mTrans_Attriibute=nil
UAVContrastDialog.mTrans_SkillRange=nil
UAVContrastDialog.mTrans_layout1=nil
UAVContrastDialog.mTrans_layout2=nil
UAVContrastDialog.mTrans_layout3=nil
UAVContrastDialog.mBtn_Close=nil
function UAVContrastDialog:__InitCtrl(view)

    self.mImage_LeftUpIcon=self:GetImage("GrpContent/Trans_GrpUAV/GrpUAVInfo/GrpUAVIcon/GrpTacticSkill2DIcon/Img_Icon")
    self.mImage_SkillIcon=self:GetImage("GrpContent/Trans_GrpUAV/GrpUAVInfo/GrpUAVIcon/Grp3DModel/Img_3DModelIcon")
    self.mText_SkllName=self:GetText("GrpContent/Trans_GrpUAV/GrpUAVInfo/GrpName/Text_Name")
    self.mText_CostNum=self:GetText("GrpContent/Trans_GrpUAV/GrpUAVInfo/GrpUAVIcon/GrpCost/Text_Num")
    self.mText_SkillLevel=self:GetText("GrpContent/Trans_GrpUAV/GrpUAVInfo/GrpLevel/GrpText/Text_Level")
    self.mToggle_Range=self:GetToggle("GrpContent/Trans_GrpUAV/GrpUAVInfo/GrpRange/Btn_Range")
    self.mTrans_Attriibute=self:GetRectTransform("GrpContent/Trans_GrpUAV/GrpUAVDetails/GrpAttribute")
    self.mText_RangeName=self:GetText("GrpContent/Trans_GrpUAV/GrpUAVInfo/GrpRange/Btn_Range/Content/GrpName/TextName")
    self.mText_SkillDes=self:GetText("GrpContent/Trans_GrpUAV/GrpUAVDetails/GrpSkillInfo/Viewport/Content/Text_Describe")
    self.mTrans_SkillRange=self:GetRectTransform("GrpContent/Trans_GrpUAV/GrpUAVDetails/Trans_GrpSkillRange")
    self.mTrans_UAV=self:GetRectTransform("GrpContent/Trans_GrpUAV")
    self.mBtn_Close=self:GetButton("GrpContent/Trans_GrpUAV/GrpUAVDetails/Trans_GrpSkillRange/Btn_Close")
    self.mTrans_Weapon=self:GetRectTransform("GrpContent/Trans_GrpWeapon")
    setactive(self.mTrans_Weapon,false)
    self.mLayoutlist={}
    self.mTrans_layout1=self:GetRectTransform("GrpContent/Trans_GrpUAV/GrpUAVDetails/Trans_GrpSkillRange/GrpAllSkillDescription/GrpSkillDiagram/Img_SkillDiagram_9x9")
    self.mTrans_layout2=self:GetRectTransform("GrpContent/Trans_GrpUAV/GrpUAVDetails/Trans_GrpSkillRange/GrpAllSkillDescription/GrpSkillDiagram/Img_SkillDiagram_17x17")
    self.mTrans_layout3=self:GetRectTransform("GrpContent/Trans_GrpUAV/GrpUAVDetails/Trans_GrpSkillRange/GrpAllSkillDescription/GrpSkillDiagram/Img_SkillDiagram_21x21")
    table.insert(self.mLayoutlist,getcomponent(self.mTrans_layout1,typeof(CS.GridLayout)))
    table.insert(self.mLayoutlist,getcomponent(self.mTrans_layout2,typeof(CS.GridLayout)))
    table.insert(self.mLayoutlist,getcomponent(self.mTrans_layout3,typeof(CS.GridLayout)))
end

--@@ GF Auto Gen Block End

function UAVContrastDialog:InitCtrl(root,view)

	self:SetRoot(root)

	self:__InitCtrl(view)

end

function UAVContrastDialog:InitData(data)
    setactive(self.mTrans_UAV,true)
    --TODO chenliang
    local nowarmid=UAVUtility.NowRealBottomArmId
    local armtabledata=TableData.GetUavArmsData()
    local armequiped=NetCmdUavData:GetArmEquipState()
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local subid=string.sub(armtabledata[nowarmid].SkillSet,1,3)
    local battleskilldata=nil
    if uavarmdic:ContainsKey(nowarmid)==false then
        battleskilldata=TableData.GetUarArmRevelantData(subid..1)
    else
        battleskilldata=TableData.GetUarArmRevelantData(subid..uavarmdic[nowarmid].Level)
    end
    self.mText_CostNum.text=armtabledata[UAVUtility.NowRealBottomArmId].Cost
    self.mText_SkllName.text=armtabledata[nowarmid].Name
    self.mText_SkillLevel.text="LV."..uavarmdic[nowarmid].Level
    self.mText_RangeName.text=TableData.GetHintById(105013)
    local script=self.mTrans_Attriibute:GetComponent(typeof(CS.ScrollListChild))
    local itemobj1=instantiate(script.childItem.gameObject,self.mTrans_Attriibute)
    itemobj1.transform:Find("GrpList/Text_Name"):GetComponent(typeof(CS.UnityEngine.UI.Text)).text=
    TableData.GetHintById(105011)
    itemobj1.transform:Find("Text_Num"):GetComponent(typeof(CS.UnityEngine.UI.Text)).text=
    battleskilldata.TeCost
    local itemobj2=instantiate(script.childItem.gameObject,self.mTrans_Attriibute)
    itemobj2.transform:Find("GrpList/Text_Name"):GetComponent(typeof(CS.UnityEngine.UI.Text)).text=
    TableData.GetHintById(105012)
    itemobj2.transform:Find("Text_Num"):GetComponent(typeof(CS.UnityEngine.UI.Text)).text=
    battleskilldata.Stock
    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick=function() setactive(self.mTrans_SkillRange,false) 
        self.mToggle_Range.isOn=false end
    self.mToggle_Range.onValueChanged:AddListener(
    function(ison)
    if ison then
        setactive(self.mTrans_SkillRange,true)
        --TODO chenliang
        --local nowarmid=UAVUtility.NowRealBottomArmId
        local nowarmid=UAVUtility.NowFakeBottomArmId
        local armtabledata=TableData.GetUavArmsData()
        local armequiped=NetCmdUavData:GetArmEquipState()
        local uavarmdic=NetCmdUavData:GetUavArmData()
        local subid=string.sub(armtabledata[nowarmid].SkillSet,1,3)
        local battleskilldata=TableData.GetUarArmRevelantData(subid..uavarmdic[nowarmid].Level)
        local skillrangedata=TableData.GetSkillData(battleskilldata.SkillList[0])
        CS.SkillRangeUIHelper.SetSkillRange(self.mLayoutlist,1,skillrangedata)
    else
        setactive(self.mTrans_SkillRange,false)
    end
    end
    )
    self.mText_SkillDes.text=battleskilldata.Detail
    self.mImage_LeftUpIcon.sprite=UIUtils.GetIconSprite("Icon/Skill",battleskilldata.Icon)
    self.mImage_SkillIcon.sprite=UIUtils.GetIconSprite("Icon/UAV3DModelIcon","Icon_UAV3DModelIcon_"..armtabledata[nowarmid].ResCode)
end

function UAVContrastDialog.OnClickBtn()
    
end



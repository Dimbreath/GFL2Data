require("UI.UIBaseCtrl")

UAVPartsListItem = class("UAVPartsListItem", UIBaseCtrl);
UAVPartsListItem.__index = UAVPartsListItem
UAVPartsListItem.mBtn_Unique=nil
UAVPartsListItem.mTrans_Equiped=nil
UAVPartsListItem.mTrans_Set=nil
UAVPartsListItem.mImage_LeftIcon=nil
UAVPartsListItem.mText_CostNum=nil
UAVPartsListItem.mTrans_Lock=nil
UAVPartsListItem.mText_SkillName=nil
UAVPartsListItem.mText_SkillLevelNum=nil
UAVPartsListItem.mImage_RightIcon=nil
UAVPartsListItem.mText_CostOilNum=nil
UAVPartsListItem.mTrans_RedPointParent=nil
UAVPartsListItem.callback=nil

UAVPartsListItem.tabledata=nil
function UAVPartsListItem:__InitCtrl()
    self.mBtn_Unique=self:GetSelfButton()
    self.mTrans_Equiped=self:GetRectTransform("Trans_GrpNowEquiped")
    self.mTrans_Set=self:GetRectTransform("GrpSel")
    self.mImage_LeftIcon=self:GetImage("GrpNor/GrpUAVInfo/Grp3DModel/Img_3DModelIcon")
    self.mText_CostNum=self:GetText("GrpNor/GrpUAVInfo/GrpCost/Text_Num")
    self.mTrans_Lock=self:GetRectTransform("GrpNor/GrpUAVInfo/Trans_GrpLock")
    self.mText_SkillName=self:GetText("GrpNor/GrpName/Text_Name")
    self.mText_SkillLevelNum=self:GetText("GrpNor/GrpLevel/Text_Level")
    self.mImage_RightIcon=self:GetImage("GrpNor/GrpTacticSkillIcon/GrpIcon/ImgIcon")
    self.mText_CostOilNum=self:GetText("GrpNor/GrpTacticSkillIcon/GrpText/Text_Num")
    self.mTrans_RedPointParent=self:GetRectTransform("GrpNor/Trans_RedPoint")
    --右上角小图标E
    self.mTrans_RightUpEquiped=self:GetRectTransform("GrpNor/Trans_GrpNowEquiped")
    
    self.uavarmdic=NetCmdUavData:GetUavArmData()
    self.arminstall=NetCmdUavData:GetArmEquipState()

end

--@@ GF Auto Gen Block End

function UAVPartsListItem:InitCtrl(root)

	self:SetRoot(root);
	self:__InitCtrl();

end

function UAVPartsListItem:InitData(tablearmid,armid,IsShowRedPoint)

    self.tabledata=TableData.GetUavArmsData()
    for i = 0, self.arminstall.Count-1 do
        if tablearmid==self.arminstall[i] then
            setactive(self.mTrans_Equiped.gameObject,true)
            setactive(self.mTrans_RightUpEquiped,true)
            break
        end
    end 
    if tablearmid==armid then
        --self.mBtn_Unique.interactable=false
        --self.mTrans_Set
        setactive(self.mTrans_Set,true)
    else
        --self.mBtn_Unique.interactable=true
        setactive(self.mTrans_Set,false)
    end
    if IsShowRedPoint then
        setactive(self.mTrans_RedPointParent,true)
        local script=self.mTrans_RedPointParent:GetComponent(typeof(CS.ScrollListChild))
        local itemobj=instantiate(script.childItem.gameObject,self.mTrans_RedPointParent)
    end
    self.mImage_LeftIcon.sprite=UIUtils.GetIconSprite("Icon/UAV3DModelIcon","Icon_UAV3DModelIcon_"..self.tabledata[tablearmid].ResCode)
    self.mText_SkillName.text=self.tabledata[tablearmid].Name
    if self.uavarmdic:ContainsKey(tablearmid) then

        self.mText_SkillLevelNum.text="Lv."..self.uavarmdic[tablearmid].Level
    else
        setactive(self.mTrans_Lock.gameObject,true)
        --self.mBtn_Unique.interactable=false;
        self.mText_SkillLevelNum.text="Lv.1"
    end
    local smallicondata=TableData.GetUarArmRevelantData(tonumber(self.tabledata[tablearmid].SkillSet))
    local armtabledata=TableData.GetUavArmsData()
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local subid=string.sub(armtabledata[tablearmid].SkillSet,1,3)
    local battleskilldata=nil
    if uavarmdic:ContainsKey(tablearmid)==false then
        battleskilldata=TableData.GetUarArmRevelantData(subid..1)
    else
        battleskilldata=TableData.GetUarArmRevelantData(subid..uavarmdic[tablearmid].Level)
    end
    self.mText_CostNum.text=armtabledata[tablearmid].Cost
    self.mImage_RightIcon.sprite=UIUtils.GetIconSprite("Icon/Skill",smallicondata.Icon)
    self.mText_CostOilNum.text=battleskilldata.TeCost
    UIUtils.GetButtonListener(self.mBtn_Unique.gameObject).onClick= function() 
    self.OnClickBtn(armid,tablearmid)
    end
end

function UAVPartsListItem.OnClickBtn(armid,tablearmid)
    self=UAVPartsListItem
    --UIUAVPanel.UpOrDown(false)
    local hasunlockarmdata=NetCmdUavData:GetUavArmData()
    
    UAVUtility.NowArmId=tablearmid
    UAVUtility.AniState=1
    UIUAVPanel.SetAnim()
    if CS.LuaUtils.IsNullOrDestroyed(UIUAVPanel.contrastdialog)==false  then
		gfdestroy(UIUAVPanel.contrastdialog)
        UIUAVPanel.mView.mToggle_Contrast.isOn=false
	end
    setactive(UIUAVPanel.mView.mTrans_SkillRange,false)
    UIUAVPanel.mView.mToggle_Range.isOn=false
    UIUAVPanel.UpdateRightAreaInfo()
    UIUAVPanel.UpdateLeftAreaInfo()
    UIUAVPanel.UpdateRightBtnState()
    UIUAVPanel.UpdateBottomSkillState(true)
    --if hasunlockarmdata:ContainsKey(tablearmid) then
    --   UIUAVPanel.UpdateBottomSkillState(true)
    --end
    UAVUtility.IsClickUninstall=false
    
end


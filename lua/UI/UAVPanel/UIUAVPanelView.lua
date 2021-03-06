require("UI.UIBaseView")
UIUAVPanelView = class("UIUAVPanelView", UIBaseView);
UIUAVPanelView.__index = UIUAVPanelView

function UIUAVPanelView.ctor()
    UIUAVPanelView.super.ctor(self)
end

function UIUAVPanelView:__InitCtrl()

    --Root/Trans_GrpUAVInfo/GrpUAVInfo/AttributeList/Viewport/Content
    self.mAnimator=self:GetRectTransform("Root")
    self.mAnimator=getcomponent(self.mAnimator,typeof(CS.UnityEngine.Animator))
    self.mAnimator:SetInteger("UAVInfo",0)
    self.mAnimator:SetInteger("List",3)
    self.mTrans_UAVInfo=self:GetRectTransform("Root/Trans_GrpUAVInfo")
    self.mTrans_UAVPartsInfo=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo")
    self.mTrans_GrpPartsInfo=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo")
    self.mTrans_GrpSKill=self:GetRectTransform("Root/GrpSkill")
    self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
    self.mBtn_CommandCenter = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
    self.mBtn_Fuel=self:GetButton("Root/Trans_GrpUAVInfo/BtnFuel/Btn_Fuel")
    self.mImage_FuelProgress=self:GetImage("Root/Trans_GrpUAVInfo/BtnFuel/Btn_Fuel/GrpProgress/Img_Progress")
    self.mText_FuelName=self:GetText("Root/Trans_GrpUAVInfo/BtnFuel/Btn_Fuel/GrpText/Text")
    self.mText_NowFuelNum=self:GetText("Root/Trans_GrpUAVInfo/BtnFuel/Btn_Fuel/GrpText/Text_NowNum")
    self.mText_TotalFuelNum=self:GetText("Root/Trans_GrpUAVInfo/BtnFuel/Btn_Fuel/GrpText/Text_TotalNum")
    --位于主界面下的无人机升级突破按钮
    self.mTrans_LevelUp=self:GetRectTransform("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpAction/Trans_BtnLevelUp")
    self.mTrans_Break=self:GetRectTransform("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpAction/Trans_BtnBreak")
    -- self.mBtn_LevelUp=UIUtils.GetTempBtn(self:GetRectTransform("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpAction/Trans_BtnLevelUp"))
    -- self.mBtn_Break=UIUtils.GetTempBtn(self:GetRectTransform("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpAction/Trans_BtnBreak"))
    self.mTrans_MaxLevel=self:GetRectTransform("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpAction/Trans_MaxLevel")
    self.mTrans_Skill=self:GetRectTransform("Root/GrpSkill/GrpEquipInfo/GrpTacticSkill")
    self.mTrans_Cost=self:GetRectTransform("Root/GrpSkill/GrpEquipInfo/GrpCostAll/GrpIndicator")
    self.mText_CostName=self:GetText("Root/GrpSkill/GrpEquipInfo/GrpCostAll/GrpBg/Text")
    self.mTrans_RightSkillContent=self:GetRectTransform("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpTacticSkill/Trans_Content")
    self.mText_UAVName=self:GetText("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpTextName/Text_Name")
    self.mText_UAVLevel=self:GetText("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpUAVLevel/Text_Level")
    self.mTrans_AttributeList=self:GetRectTransform("Root/Trans_GrpUAVInfo/GrpUAVInfo/AttributeList/Viewport/Content")
    self.mText_HPName=self:GetText("Root/Trans_GrpUAVInfo/GrpUAVInfo/AttributeList/Viewport/Content/GrpHP/GrpText/TextName")
    self.mText_HPNum=self:GetText("Root/Trans_GrpUAVInfo/GrpUAVInfo/AttributeList/Viewport/Content/GrpHP/Text_Num")
    self.mText_ATKName=self:GetText("Root/Trans_GrpUAVInfo/GrpUAVInfo/AttributeList/Viewport/Content/GrpATK/GrpText/TextName")
    self.mText_ATKNum=self:GetText("Root/Trans_GrpUAVInfo/GrpUAVInfo/AttributeList/Viewport/Content/GrpATK/Text_Num")
    self.mText_DEFName=self:GetText("Root/Trans_GrpUAVInfo/GrpUAVInfo/AttributeList/Viewport/Content/GrpDEF/GrpText/TextName")
    self.mText_DEFNum=self:GetText("Root/Trans_GrpUAVInfo/GrpUAVInfo/AttributeList/Viewport/Content/GrpDEF/Text_Num")
    self.mText_HasEquipedSkill=self:GetText("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpText/GrpTittle/TextTittle")
    self.mText_ContrastName=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpContrast/Btn_Contrast/GrpText/Text")
    self.mToggle_Contrast=self:GetToggle("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpContrast/Btn_Contrast")
    self.mText_SkllName=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpTextName/Text_Name")
    self.mText_SkillLevel=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpPartsLevel/Text_Level")
    self.mText_RangeName=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/BtnRange/Btn_Range/Content/GrpName/TextName")
    self.mToggle_Range=self:GetToggle("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/BtnRange/Btn_Range")
    self.mText_OilCost=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/AttributeList/Viewport/Content/GrpCost/GrpText/Text_Name")
    self.mText_OilCostNum=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/AttributeList/Viewport/Content/GrpCost/Text_Num")
    self.mText_UseTimesDes=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/AttributeList/Viewport/Content/GrpTime/GrpText/Text_Name")
    self.mText_UseTimesNum=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/AttributeList/Viewport/Content/GrpTime/Text_Num")
    self.mText_SkillDes=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpSkillInfoItem/GrpSkillInfo/Viewport/Content/Text_Describe")
    self.mTrans_BtnReplace=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpAction/Trans_BtnReplace")
    self.mTrans_BtnUnistall=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpAction/Trans_BtnUnistall")
    self.mTrans_BtnEquip=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpAction/Trans_BtnEquip")
    self.mTrans_BtnPowerUp=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpAction/Trans_BtnPowerUp")
    self.mTrans_BtnUnLock=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpAction/Trans_BtnUnlock")
    self.mTrans_ArmMaxLevel=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpAction/Trans_MaxLevel")
    self.mText_MaxLevelName=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpAction/Trans_MaxLevel/Text_Name")
    self.mTrans_LeftSkillList=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsList")
    self.mCanvas_ScrollBar=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsList/GrpPartsList/Scrollbar")
    self.mCanvas_ScrollBar=self.mCanvas_ScrollBar:GetComponent("CanvasGroup")
    self.mTrans_LeftSkillListContent=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsList/GrpPartsList/Viewport/Content")
    self.mTrans_NoEquip=self:GetRectTransform("Root/Trans_GrpUAVInfo/GrpUAVInfo/GrpTacticSkill/Trans_GrpEmpty")
    self.mTrans_RightSKiillInfo=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo")
    self.mTrans_ArmLock=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpUAVIcon/Trans_GrpLock")
    self.mImage_RightLeftUpIcon=self:GetImage("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpUAVIcon/GrpTacticSkill2DIcon/Img_Icon")
    self.mImage_RightSkillIcon=self:GetImage("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpUAVIcon/Grp3DModel/Img_3DModelIcon")
    self.mText_RightCostNum=self:GetText("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpUAVIcon/GrpCost/Text_Num")
    self.mTrans_UnlockItem=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/GrpSkillInfoItem/Trans_GrpUnlockItem")
    self.mTrans_GrpSkill=self:GetRectTransform("Root/GrpSkill")
    self.mTrans_BtnSave=self:GetButton("Root/GrpSkill/Trans_BtnSave/Btn_Save")
    self.mAnim=self.mTrans_GrpSkill:GetComponent("Animator")
    self.mTrans_ScrollContent=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsList/GrpPartsList/Viewport/Content")
  
    self.mTrans_LevelUpContentParent=self:GetRectTransform("Root")

    self.mTrans_SkillRange=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/Trans_GrpSkillRange")
    self.mBtn_CloseRange=self:GetButton("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/Trans_GrpSkillRange/Btn_Close")
    self.mTrans_ContrastDialogParent=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/Trans_GrpUAVInfo")
    self.mLayoutlist={}
    self.mTrans_layout1=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/Trans_GrpSkillRange/GrpAllSkillDescription/GrpSkillDiagram/Img_SkillDiagram_9x9")
    self.mTrans_layout2=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/Trans_GrpSkillRange/GrpAllSkillDescription/GrpSkillDiagram/Img_SkillDiagram_17x17")
    self.mTrans_layout3=self:GetRectTransform("Root/Trans_GrpUAVPartsInfo/GrpPartsInfo/Trans_GrpSkillRange/GrpAllSkillDescription/GrpSkillDiagram/Img_SkillDiagram_21x21")
    table.insert(self.mLayoutlist,getcomponent(self.mTrans_layout1,typeof(CS.GridLayout)))
    table.insert(self.mLayoutlist,getcomponent(self.mTrans_layout2,typeof(CS.GridLayout)))
    table.insert(self.mLayoutlist,getcomponent(self.mTrans_layout3,typeof(CS.GridLayout)))
    --self.Canvas=GameObject.Find("Canvas").transform
    self.Canvas=UISystem.rootCanvasTrans
end

function UIUAVPanelView:InitCtrl(root)
    self:SetRoot(root);
    self:__InitCtrl();
end
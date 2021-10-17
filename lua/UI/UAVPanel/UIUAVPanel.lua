require("UI.UIBasePanel")

UIUAVPanel = class("UIUAVPanel", UIBasePanel)
UIUAVPanel.__index = UIUAVPanel

UIUAVPanel.mView = nil
UIUAVPanel.levelUpPanel=nil
UIUAVPanel.Const=
{
    MaxLevel=60,
    MAXArmLevel=6
}
--  1代表卸载,2代表替换
UIUAVPanel.SaveType=0

UIUAVPanel.UnInstallPos=-1
UIUAVPanel.ReplacePos=-1
UIUAVPanel.IsClickSave=false
UIUAVPanel.uavMaxLevel=0
UIUAVPanel.uavlimitlevel=0
UIUAVPanel.realmaxLevel=0
UIUAVPanel.fuelpanel=nil
UIUAVPanel.contrastdialog=nil
UIUAVPanel.OnlyRefreshOnce=false

UIUAVPanel.fakearmequiplist=List:New()
function UIUAVPanel:ctor()
    UIUAVPanel.super.ctor(self)
end

function UIUAVPanel.Init(root, data)
    UIUAVPanel.super.SetRoot(UIUAVPanel, root)
    self=UIUAVPanel
    self.mView=UIUAVPanelView.New()
    self.mView:InitCtrl(root)
    self:Show(true)
end

function UIUAVPanel.OnInit()
    UAVUtility:InitData()
    self=UIUAVPanel
    local armequipStateList=NetCmdUavData:GetArmEquipState()
    self.Const.MaxLevel=TableData.GetUavLevelData().Count
    for k,v in pairs(TableData.GetUavArmsData()) do
        self.Const.MAXArmLevel=v.UpgradeCost.Count+1
        break
    end
    self.InitInfo()
    self.AddListener()
    self.UpdateRightSkillState(armequipStateList)
    self.UpdateBottomSkillState()
    self.UpdateUavMainViewInfo()
    

    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick=function ()
        UIManager.JumpToMainPanel()
    end
    
    UIUtils.GetButtonListener(self.mView.mBtn_Fuel.gameObject).onClick=function() self.OnClickFuel() end
   
    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick=function() self.OnClickClose() end
    
    --self.UpdateLeftAreaInfo()
end

function UIUAVPanel.OnShow()
    
end

function UIUAVPanel.Open()
	
end


function UIUAVPanel.Close()
    self = UIUAVPanel
    self.OnClickClose()
end

function UIUAVPanel.OnUpdate()
    self = UIUAVPanel
    if self.levelUpPanel then
        self.levelUpPanel:OnUpdate()
    end
end

function UIUAVPanel.OnRelease()
    UAVUtility.NowArmId = -1
    UAVUtility.NowRealBottomArmId = -2
    UAVUtility.NowFakeBottomArmId=-2
    UAVUtility.IsClickUninstall=false
    UAVUtility.NowBottomPos = -1
    UAVUtility.AniState=-1
    self.levelUpPanel=nil
    self.FuelGetPanel=nil
    self.BreakPanel=nil
end

--更新无人机主界面的信息,包括界面和数据
function UIUAVPanel.UpdateInfo()

end

--一开始给无人机主界面的相关信息进行初始化
function UIUAVPanel.InitInfo()
    self=UIUAVPanel
    self.mView.mText_UAVName.text=TableData.GetHintById(105009)
    self.mView.mText_HasEquipedSkill.text=TableData.GetHintById(105010)
    self.mView.mText_FuelName.text=TableData.GetHintById(105008)
    self.mView.mText_RangeName.text=TableData.GetHintById(105013)
    self.mView.mText_OilCost.text=TableData.GetHintById(105011)
    self.mView.mText_UseTimesDes.text=TableData.GetHintById(105012)
    local tabledata=TableData.GetUavLevelData()
    local uavdata=NetCmdUavData:GetUavData()
    self.attributelist=List:New()
    --攻击
    self.attributelist:Add(TableData.listLanguagePropertyDatas:GetDataById(7).ShowName.str)
    --生命
    self.attributelist:Add(TableData.listLanguagePropertyDatas:GetDataById(9).ShowName.str)
    --暴击几率
    self.attributelist:Add(TableData.listLanguagePropertyDatas:GetDataById(15).ShowName.str)
    --暴击伤害
    self.attributelist:Add(TableData.listLanguagePropertyDatas:GetDataById(16).ShowName.str)
    --硬质护甲
    self.attributelist:Add(TableData.listLanguagePropertyDatas:GetDataById(30).ShowName.str)
    --离子涂层
    self.attributelist:Add(TableData.listLanguagePropertyDatas:GetDataById(31).ShowName.str)
end



--更新右边的技能槽状态(位于主界面下)
function UIUAVPanel.UpdateRightSkillState(armequiplist)
    self=UIUAVPanel
    for i=0, self.mView.mTrans_RightSkillContent.childCount-1 do
        gfdestroy(self.mView.mTrans_RightSkillContent:GetChild(i))
    end
    --0到2 分别对应左中右 三个技能槽
    local unequipnum=0
    for i = 0, armequiplist.Count-1 do
        local armid=armequiplist[i]
        if armid==0 then
            unequipnum=unequipnum+1
        else
            local instObj = instantiate(UIUtils.GetGizmosPrefab("UAV/UAVTacticSkillItemV2.prefab",self),self.mView.mTrans_RightSkillContent);
            local item=UAVTacticSkillItem.New()
            --getcomponent(instObj, typeof(CS.UnityEngine.Animator)):SetLayerWeight(1,0)
            item:InitCtrl(instObj.transform);
			item:InitData(armid,self.mView)
        end
    end
    if unequipnum ==3 then
        setactive(self.mView.mTrans_NoEquip.gameObject,true)
    else
        setactive(self.mView.mTrans_NoEquip.gameObject,false)
    end
end
--更新底部技能槽的状态
function UIUAVPanel.UpdateBottomSkillState(IsRefreshWithClickLeftArmList)
    self=UIUAVPanel
    local armequiplist=NetCmdUavData:GetArmEquipState()
    for i=0, self.mView.mTrans_Skill.childCount-1 do
        gfdestroy(self.mView.mTrans_Skill:GetChild(i))
    end
    local tabledata=TableData.GetUavLevelData()
    local uavarmdic=TableData.GetUavArmsData()
    local uavdata=NetCmdUavData:GetUavData()
    local uavrevelantdata=NetCmdUavData:GetUavData()
    local uavrlevel=uavrevelantdata.UavLevel
    local uavadvancedata=TableData.GetUavAdvanceData()
    local num=0
    local EquipNum=0
    local NetUavGrade=NetCmdUavData:GetUavTotalData().Uav.UavGrade
    EquipNum=uavadvancedata[NetUavGrade].EquipNum
   
    if IsRefreshWithClickLeftArmList then
        self.fakearmequiplist:Clear()
        for i = 0,armequiplist.Count-1 do
        self.fakearmequiplist:Add(armequiplist[i])
        end
        self.fakearmequiplist[UAVUtility.NowBottomPos+1]=UAVUtility.NowArmId
        UAVUtility.NowFakeBottomArmId=UAVUtility.NowArmId
        for i=0, 2 do
            num=num+1
            if num<=EquipNum then
            local instObj = instantiate(UIUtils.GetGizmosPrefab("UAV/UAVPartsItemV2.prefab",self),self.mView.mTrans_Skill);
            local item=UAVPartsItem.New()
            item:InitCtrl(instObj.transform,self.mView);
            item:InitData(self.fakearmequiplist[i+1],true,i,self.IsShowBottomBtnRedPoint(self.fakearmequiplist[i+1]))
            else
            local instObj = instantiate(UIUtils.GetGizmosPrefab("UAV/UAVPartsItemV2.prefab",self),self.mView.mTrans_Skill);
            local item=UAVPartsItem.New()
            item:InitCtrl(instObj.transform,self.mView);
            item:InitData(num,false,i)
        end
    end
    local templist=List:New()
    for i = 1,self.fakearmequiplist:Count() do
        templist:Add(self.fakearmequiplist[i]) 
    end
    templist:Sort()
    local costnum=0
    local lastnum=0
    local nownum=0    
    for i=1,templist:Count() do
        if templist[i]~=0 then 
            lastnum =nownum
            nownum=templist[i]
           costnum=costnum+uavarmdic[templist[i]].Cost
            if nownum==lastnum then
                costnum=costnum-uavarmdic[nownum].Cost
            end
        end
    end    
    
    for i=0, self.mView.mTrans_Cost.childCount-1 do
        gfdestroy(self.mView.mTrans_Cost:GetChild(i))
    end
    local NowCostLimit=0
    NowCostLimit=uavadvancedata[NetUavGrade].Cost
    local IsNeedRed= NowCostLimit<costnum
    for i=1,NowCostLimit  do
        local script=self.mView.mTrans_Cost:GetComponent(typeof(CS.ScrollListChild))
        local itemobj=instantiate(script.childItem.gameObject,self.mView.mTrans_Cost)
        if i<=costnum then
            setactive(itemobj.transform:Find("GrpState/Trans_On"),true)
            setactive(itemobj.transform:Find("GrpState/Trans_Off"),false)
        end
        if IsNeedRed then
            itemobj.transform:Find("GrpState/Trans_On"):GetComponent(typeof(CS.UnityEngine.UI.Image)).color=ColorUtils.RedColor
        end
    end
        
        return
        
    end
    
    for i=0, 2 do
        num=num+1
        if num<=EquipNum then
            local instObj = instantiate(UIUtils.GetGizmosPrefab("UAV/UAVPartsItemV2.prefab",self),self.mView.mTrans_Skill);
            local item=UAVPartsItem.New()
            item:InitCtrl(instObj.transform,self.mView);
		    item:InitData(armequiplist[i],true,i,self.IsShowBottomBtnRedPoint())
        else
            local instObj = instantiate(UIUtils.GetGizmosPrefab("UAV/UAVPartsItemV2.prefab",self),self.mView.mTrans_Skill);
            local item=UAVPartsItem.New()
            item:InitCtrl(instObj.transform,self.mView);
		    item:InitData(num,false,i)
        end
    end
    local armequiplist=NetCmdUavData:GetArmEquipState()
    local uavarmdic=TableData.GetUavArmsData()
    local uavlevelupdata=TableData.GetUavLevelData()
    local costnum=0
    for i=0,armequiplist.Count-1 do
        if armequiplist[i]~=0 then
            costnum=costnum+uavarmdic[armequiplist[i]].Cost
        end
    end
    for i=0, self.mView.mTrans_Cost.childCount-1 do
        gfdestroy(self.mView.mTrans_Cost:GetChild(i))
    end
    local uavadvancedata=TableData.GetUavAdvanceData()
    local NowCostLimit=0
    NowCostLimit=uavadvancedata[NetUavGrade].Cost
    for i=1,NowCostLimit  do
        local script=self.mView.mTrans_Cost:GetComponent(typeof(CS.ScrollListChild))
        local itemobj=instantiate(script.childItem.gameObject,self.mView.mTrans_Cost)
        if i<=costnum then
            setactive(itemobj.transform:Find("GrpState/Trans_On"),true)
            setactive(itemobj.transform:Find("GrpState/Trans_Off"),false)
        end
    end
end

--更新无人机主界面的展示信息值(包括右边的属性数字值和燃油数值以及燃油的进度条)
function UIUAVPanel.UpdateUavMainViewInfo()
    self=UIUAVPanel
    local uavadvancedata=TableData.GetUavAdvanceData()
    local tabledata=TableData.GetUavLevelData()
    local uavdata=NetCmdUavData:GetUavData()
    local nowgrade=NetCmdUavData:GetUavData().UavGrade
    local itemscript=self.mView.mTrans_AttributeList:GetComponent("ScrollListChild")
    for i = 0,self.mView.mTrans_AttributeList.childCount-1  do
        gfdestroy(self.mView.mTrans_AttributeList:GetChild(i))
    end
    self.mView.mText_UAVLevel.text="LV."..uavdata.UavLevel
    --攻击
    local instObj = instantiate(itemscript.childItem,self.mView.mTrans_AttributeList);
    local item=UAVAttributeItem.New()
    item:InitCtrl(instObj.transform)
    item:InitData(self.attributelist[1],tabledata[uavdata.UavLevel-1].Pow)
    --生命
    local instObj = instantiate(itemscript.childItem,self.mView.mTrans_AttributeList);
    local item=UAVAttributeItem.New()
    item:InitCtrl(instObj.transform)
    item:InitData(self.attributelist[2],tabledata[uavdata.UavLevel-1].MaxHp)
    --暴击几率
    local instObj = instantiate(itemscript.childItem,self.mView.mTrans_AttributeList);
    local item=UAVAttributeItem.New()
    item:InitCtrl(instObj.transform)
    item:InitData(self.attributelist[3],math.floor((tabledata[uavdata.UavLevel-1].Crit+uavadvancedata[nowgrade].Crit)/10).."%")
    --暴击伤害
    local instObj = instantiate(itemscript.childItem,self.mView.mTrans_AttributeList);
    local item=UAVAttributeItem.New()
    item:InitCtrl(instObj.transform)
    item:InitData(self.attributelist[4],math.floor((tabledata[uavdata.UavLevel-1].CritMult+uavadvancedata[nowgrade].CritMult)/10).."%")
    --硬质护甲
    local instObj = instantiate(itemscript.childItem,self.mView.mTrans_AttributeList);
    local item=UAVAttributeItem.New()
    item:InitCtrl(instObj.transform)
    item:InitData(self.attributelist[5],tabledata[uavdata.UavLevel-1].PhysicalShield)
    --离子涂层
    local instObj = instantiate(itemscript.childItem,self.mView.mTrans_AttributeList);
    local item=UAVAttributeItem.New()
    item:InitCtrl(instObj.transform)
    item:InitData(self.attributelist[6],tabledata[uavdata.UavLevel-1].MagicalShield)
    local nowfuelnum=NetCmdItemData:GetResItemCount(23)
    local totalfuelnum=NetCmdItemData:GetResItemCount(24)
    self.mView.mText_TotalFuelNum.text=totalfuelnum
    self.mView.mText_NowFuelNum.text=nowfuelnum
    if (nowfuelnum/totalfuelnum) >1 then      
    self.mView.mImage_FuelProgress.fillAmount=1
    else 
        self.mView.mImage_FuelProgress.fillAmount=nowfuelnum/totalfuelnum
    end

    setactive(self.mView.mTrans_LevelUp.gameObject,false)
    setactive(self.mView.mTrans_Break.gameObject,false)
    setactive(self.mView.mTrans_MaxLevel.gameObject,false)
    setactive(self.redtrans1,false)
    setactive(self.redtrans2,false)
    if uavdata.UavLevel==self.Const.MaxLevel then
        setactive(self.mView.mTrans_LevelUp.gameObject,false)
        setactive(self.mView.mTrans_Break.gameObject,false)
        setactive(self.mView.mTrans_MaxLevel.gameObject,true)
    else  
        local uavdata=NetCmdUavData:GetUavData()
        local tablegrade=UAVUtility:GetUavGrade(uavdata.UavLevel)
        if tabledata[uavdata.UavLevel-1].UavMaterial~=0 and tablegrade==uavdata.UavGrade then
            setactive(self.mView.mTrans_LevelUp.gameObject,false)
            setactive(self.mView.mTrans_Break.gameObject,true)
            if self.IsShowBreakRedPoint() then
                setactive(self.redtrans2,true)
            end
            setactive(self.mView.mTrans_MaxLevel.gameObject,false)
        else
            -- if self.IsShowLevelUpRedPoint() then
            --     setactive(self.redtrans1,true)
            -- end
            setactive(self.mView.mTrans_LevelUp.gameObject,true)
            setactive(self.mView.mTrans_Break.gameObject,false)
            setactive(self.mView.mTrans_MaxLevel.gameObject,false)
        end
    end
end
--更新右边区域信息(在无人机武装信息界面打开的情况下)
function UIUAVPanel.UpdateRightAreaInfo(IsShowSkillInfo)
    self=UIUAVPanel
    if IsShowSkillInfo~=nil then
        setactive(self.mView.mTrans_RightSKiillInfo.gameObject,true)
        self.mView.mAnimator:SetInteger("UAVInfo",3)
        return 
    end
    if UAVUtility.NowArmId==0 then
        return 
    end
    local nowarmid=UAVUtility.NowArmId
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
    --setactive(self.mView.mTrans_RightSKiillInfo.gameObject,true)
    self.IsClickSave=false
    self.mView.mText_SkllName.text=armtabledata[nowarmid].Name
    if uavarmdic:ContainsKey(nowarmid) then
        self.mView.mText_SkillLevel.text="LV."..uavarmdic[nowarmid].Level.."/6"
        setactive(self.mView.mTrans_ArmLock,false)
    else
        self.mView.mText_SkillLevel.text="LV.1/6"
        setactive(self.mView.mTrans_ArmLock,true)
    end
    self.mView.mText_RangeName.text=TableData.GetHintById(105013)
    self.mView.mText_OilCost.text=TableData.GetHintById(105011)
    self.mView.mText_OilCostNum.text=battleskilldata.TeCost
    self.mView.mText_UseTimesDes.text=TableData.GetHintById(105012)
    self.mView.mText_UseTimesNum.text=battleskilldata.Stock
    self.mView.mText_SkillDes.text=battleskilldata.Detail
    self.mView.mImage_RightLeftUpIcon.sprite=UIUtils.GetIconSprite("Icon/Skill",battleskilldata.Icon)
    self.mView.mImage_RightSkillIcon.sprite=UIUtils.GetIconSprite("Icon/UAV3DModelIcon","Icon_UAV3DModelIcon_"..armtabledata[nowarmid].ResCode)
    self.mView.mText_RightCostNum.text=armtabledata[nowarmid].Cost
    self.UpdateRightBtnState()
end   
--判断左边列表item是否显示红点
function UIUAVPanel.IsShowLeftListRedPoint(armid,type)
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local armdata=TableData.GetUavArmsData()
    local levelupunlockmat=NetCmdItemData:GetItemCmdData(armdata[armid].ItemId)
    local levelupunlockmatNum=0
    if CS.LuaUtils.IsNullOrDestroyed(levelupunlockmat) then
        levelupunlockmatNum=0
    else
        levelupunlockmatNum=levelupunlockmat.Num
    end
    --武装可解锁
    if type==1 then
        if levelupunlockmatNum>=1 and uavarmdic:ContainsKey(armid)==false then
            return true
        end
    --武装可强化
    elseif type==2 then
        if uavarmdic[armid].Level==UIUAVPanel.Const.MAXArmLevel then
            return false
        end
        local upgradecost=armdata[armid].UpgradeCost[uavarmdic[armid].Level-1]
        if levelupunlockmatNum>=upgradecost then
            return true
        end
    end
    return false
end
--判断底部是否显示红点
function UIUAVPanel.IsShowBottomBtnRedPoint(ArmId)
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local armdata=TableData.GetUavArmsData()
    if ArmId~=nil and ArmId~=0 and uavarmdic:ContainsKey(ArmId)==false then
        local levelupunlockmat=NetCmdItemData:GetItemCmdData(armdata[ArmId].ItemId)
        local levelupunlockmatNum=0
        if CS.LuaUtils.IsNullOrDestroyed(levelupunlockmat) then
            levelupunlockmatNum=0
        else
            levelupunlockmatNum=levelupunlockmat.Num
        end
        if levelupunlockmatNum>=1 then
            return true
        end
    end
    
    for k,v in pairs(armdata) do
        local levelupunlockmat=NetCmdItemData:GetItemCmdData(v.ItemId)
        local levelupunlockmatNum=0
        if CS.LuaUtils.IsNullOrDestroyed(levelupunlockmat) then
            levelupunlockmatNum=0
        else
            levelupunlockmatNum=levelupunlockmat.Num
        end
        if levelupunlockmatNum>=1 and uavarmdic:ContainsKey(k)==false then
            return true
        end
        if  uavarmdic:ContainsKey(k) and uavarmdic[k].Level==UIUAVPanel.Const.MAXArmLevel then
            goto continue
        end
        if uavarmdic:ContainsKey(k) then
            local upgradecost=v.UpgradeCost[uavarmdic[k].Level-1]
            if levelupunlockmatNum>=upgradecost then
                return true
            end
        end
        ::continue::
    end
    return false

end
--判断是否显示无人机突破红点
function UIUAVPanel.IsShowBreakRedPoint()
    
    local breakitemdata=NetCmdItemData:GetItemCmdData(182)
    local breakitemnum=0
    if CS.LuaUtils.IsNullOrDestroyed(breakitemdata) then
        breakitemnum=0
    else
        breakitemnum=breakitemdata.Num
    end

    local tabledata=TableData.GetUavLevelData()
    local uavdata=NetCmdUavData:GetUavData()
    local tablegrade=UAVUtility:GetUavGrade(uavdata.UavLevel)
    if tabledata[uavdata.UavLevel-1].UavMaterial~=0 and tablegrade==uavdata.UavGrade then
        if breakitemnum>=GlobalConfig.UavBreakMatNum then
            return true
        end
    end
    return false
end

--判断是否显示无人机升级红点
-- function UIUAVPanel.IsShowLevelUpRedPoint()
--     local uavdata=NetCmdUavData:GetUavData()
--     local nowuavlevel=uavdata.UavLevel
--     local leveluptalbe=TableData.GetUavLevelData()
--     local playerlevel=AccountNetCmdHandler:GetLevel()
--     local temp=TableData.GlobalSystemData.UavExceedlevel
--     self.uavlimitlevel=temp+playerlevel
--     if self.uavlimitlevel>=60 then
--     self.uavlimitlevel=60
--     end
--     for i =nowuavlevel-1 , leveluptalbe.Count-1 do
--         if leveluptalbe[i].UavMaterial~=0 then
--             self.uavMaxLevel=leveluptalbe[i].Level
--             if UAVUtility:GetUavGrade(nowuavlevel)~=uavdata.UavGrade then
--                 self.uavMaxLevel=leveluptalbe[i].Level+10
--                 break
--             end
--             break
--         end
--     end

--     if self.uavMaxLevel>=self.uavlimitlevel then
--         self.realmaxLevel=self.uavlimitlevel
--     else
--         self.realmaxLevel=self.uavMaxLevel
--     end

--     if nowuavlevel==self.realmaxLevel then
--         return false
--     end

--     local itemexp1=NetCmdItemData:GetItemCount(121)
--     local itemexp2=NetCmdItemData:GetItemCount(122)
--     local itemexp3=NetCmdItemData:GetItemCount(123)
--     local itemexp4=NetCmdItemData:GetItemCount(124)
--     local itemgold=NetCmdItemData:GetResItemCount(2)
--     local totalexp=itemexp1*200+itemexp2*1000+itemexp3*5000+itemexp4*20000
--     if totalexp>=leveluptalbe[nowuavlevel].UavExp and itemgold>=leveluptalbe[nowuavlevel].UavCash then
--         return true
--     end
--     return false
-- end

function UIUAVPanel.SetAnim()
    self=UIUAVPanel
    setactive(self.mView.mTrans_RightSKiillInfo.gameObject,true)
    self.mView.mAnimator:SetInteger("UAVInfo",2)
end

--判断强化解锁按钮是否显示红点
function UIUAVPanel.IsShowRedPointOnBtn(armid,type)

    local uavarmdic=NetCmdUavData:GetUavArmData()

    local armdata=TableData.GetUavArmsData()

    local levelupunlockmat=NetCmdItemData:GetItemCmdData(armdata[armid].ItemId)
    local levelupunlockmatNum=0
    if CS.LuaUtils.IsNullOrDestroyed(levelupunlockmat) then
        levelupunlockmatNum=0
    else
        levelupunlockmatNum=levelupunlockmat.Num
    end

    --武装可解锁
    if type==1 then
        --if uavarmdic:ContainsKey(armid)==false then
             if levelupunlockmatNum>=1 then
                return true
             end
       -- end
    --武装可强化
    elseif type==2 then

        if uavarmdic[armid].Level==UIUAVPanel.Const.MAXArmLevel then
            return false
        end
        local upgradecost=armdata[armid].UpgradeCost[uavarmdic[armid].Level-1]
        if levelupunlockmatNum>=upgradecost then
            return true
        end
    end
    return false
end

--显示左边武装列表时
function UIUAVPanel.UpdateLeftAreaInfo(IsNeedSort)
    self=UIUAVPanel
    for i=0, self.mView.mTrans_LeftSkillListContent.childCount-1 do
        gfdestroy(self.mView.mTrans_LeftSkillListContent:GetChild(i))
    end
    setactive(self.mView.mTrans_LeftSkillList.gameObject,true)
    local armtabledata=TableData.GetUavArmsData()
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local equipstate=NetCmdUavData:GetArmEquipState()
    if IsNeedSort then
        self.sortlist=List:New()
        for k,v in pairs(armtabledata) do
            local data={}
            data.armid=k
            if equipstate:Contains(k) and k ==UAVUtility.NowFakeBottomArmId  then
                data.sort=0
            end
            if equipstate:Contains(k) and k ~=UAVUtility.NowFakeBottomArmId  then
                data.sort=1
            end
            if uavarmdic:ContainsKey(k) and equipstate:Contains(k)==false then
                data.sort=2
            end
            if uavarmdic:ContainsKey(k)==false then
                data.sort=3
            end
            table.insert(self.sortlist,data)
        end
        table.sort(self.sortlist, function(a,b)
            if a.sort==b.sort then
                return a.armid<b.armid
            end
            return a.sort<b.sort
        end)
        for i = 1, self.sortlist:Count() do
            local instObj = instantiate(UIUtils.GetGizmosPrefab("UAV/UAVPartsListItemV2.prefab",self),self.mView.mTrans_LeftSkillListContent);
            local item=UAVPartsListItem.New()
            item:InitCtrl(instObj.transform);
            if self.sortlist[i].sort<3 then
                item:InitData(self.sortlist[i].armid,UAVUtility.NowArmId,self.IsShowLeftListRedPoint(self.sortlist[i].armid,2))
            else
                item:InitData(self.sortlist[i].armid,UAVUtility.NowArmId,self.IsShowLeftListRedPoint(self.sortlist[i].armid,1))
            end
        end
    else
        for i = 1, self.sortlist:Count() do
            local instObj = instantiate(UIUtils.GetGizmosPrefab("UAV/UAVPartsListItemV2.prefab",self),self.mView.mTrans_LeftSkillListContent);
            local item=UAVPartsListItem.New()
            item:InitCtrl(instObj.transform);
            if self.sortlist[i].sort<3 then
                item:InitData(self.sortlist[i].armid,UAVUtility.NowArmId,self.IsShowLeftListRedPoint(self.sortlist[i].armid,2))
            else
                item:InitData(self.sortlist[i].armid,UAVUtility.NowArmId,self.IsShowLeftListRedPoint(self.sortlist[i].armid,1))
            end
        end
    end

    if UAVUtility.NowArmId==0 then
        setactive(self.mView.mTrans_RightSKiillInfo.gameObject,true)
        self.mView.mAnimator:SetInteger("UAVInfo",3)
        --setactive(self.mView.mTrans_RightSKiillInfo.gameObject,false)
    end
    if UAVUtility.OnlyRefreshOnce then
        local fadeManager = self.mView.mTrans_LeftSkillListContent:GetComponent("MonoScrollerFadeManager");
        fadeManager:InitFade();
        UAVUtility.OnlyRefreshOnce=false
    end
end

function UIUAVPanel.AddListener()
    self=UIUAVPanel
    self.mView.mToggle_Contrast.onValueChanged:AddListener(function (ison)
        self=UIUAVPanel
        if ison then
        local script=self.mView.mTrans_ContrastDialogParent:GetComponent(typeof(CS.ScrollListChild))
        local itemobj=instantiate(script.childItem.gameObject,self.mView.mTrans_ContrastDialogParent)
        local contrast=UAVContrastDialog.New()
        self.contrastdialog=itemobj
        for i=0, itemobj.transform:Find("GrpAction").childCount-1 do
            setactive(itemobj.transform:Find("GrpAction"):GetChild(i),false)
            if itemobj.transform:Find("GrpAction"):GetChild(i).name=="Trans_Equiped" then
            setactive(itemobj.transform:Find("GrpAction"):GetChild(i),true)
            end
        end
        contrast:InitCtrl(itemobj.transform)
        contrast:InitData()
        else
            for i=0, self.mView.mTrans_ContrastDialogParent.childCount-1 do
                gfdestroy(self.mView.mTrans_ContrastDialogParent:GetChild(i))
            end
        end
    end)
    self.mView.mToggle_Range.onValueChanged:AddListener(function (ison)
        self=UIUAVPanel
        if ison then
            setactive(self.mView.mTrans_SkillRange,true)
            local nowarmid=UAVUtility.NowArmId
            local armtabledata=TableData.GetUavArmsData()
            local armequiped=NetCmdUavData:GetArmEquipState()
            local uavarmdic=NetCmdUavData:GetUavArmData()
            local subid=string.sub(armtabledata[nowarmid].SkillSet,1,3)
            local battleskilldata
            if uavarmdic:ContainsKey(nowarmid) then
                battleskilldata=TableData.GetUarArmRevelantData(subid..uavarmdic[nowarmid].Level)
            else
                battleskilldata=TableData.GetUarArmRevelantData(subid..1)
            end
            local skillrangedata=TableData.GetSkillData(battleskilldata.SkillList[0])
            CS.SkillRangeUIHelper.SetSkillRange(self.mView.mLayoutlist,1,skillrangedata)
        else
            setactive(self.mView.mTrans_SkillRange,false)
        end
    end)
    local BtnReplace =UIUtils.GetTempBtn(self.mView.mTrans_BtnReplace)
    local BtnUninstall =UIUtils.GetTempBtn(self.mView.mTrans_BtnUnistall)
    local BtnEquip =UIUtils.GetTempBtn(self.mView.mTrans_BtnEquip)
    local BtnPowerUp =UIUtils.GetTempBtn(self.mView.mTrans_BtnPowerUp)
    local BtnUnlock =UIUtils.GetTempBtn(self.mView.mTrans_BtnUnLock)
    UIUtils.GetButtonListener(self.mView.mBtn_CloseRange.gameObject).onClick=function() self.mView.mToggle_Range.isOn=false end
    UIUtils.GetButtonListener(BtnReplace.gameObject).onClick=function()self.OnClickReplace(UAVUtility.NowFakeBottomArmId,UAVUtility.NowBottomPos) end
    UIUtils.GetButtonListener(BtnUninstall.gameObject).onClick=function()self.OnClickUninstall(UAVUtility.NowArmId) end
    UIUtils.GetButtonListener(BtnEquip.gameObject).onClick=function()self.OnClickEquip(UAVUtility.NowArmId,UAVUtility.NowBottomPos) end
    UIUtils.GetButtonListener(BtnPowerUp.gameObject).onClick=function()self.OnClickPowerUp() end
    UIUtils.GetButtonListener(BtnUnlock.gameObject).onClick=function()self.OnClickUnlock(UAVUtility.NowArmId) end
    local btnlevelup=UIUtils.GetTempBtn(self.mView.mTrans_LevelUp)
    local btnbreak=UIUtils.GetTempBtn(self.mView.mTrans_Break)
   
    self.btnlevelup=btnlevelup
    self.btnbreak=btnbreak
    self.btnpowerup=BtnPowerUp
    self.btnunlock=BtnUnlock

    self.redtrans1=self.btnlevelup.transform:Find("Root/Trans_RedPoint")
    local script1=self.redtrans1:GetComponent(typeof(CS.ScrollListChild))
    instantiate(script1.childItem.gameObject,self.redtrans1)
    

    self.redtrans2=self.btnbreak.transform:Find("Root/Trans_RedPoint")
    local script2=self.redtrans2:GetComponent(typeof(CS.ScrollListChild))
    instantiate(script2.childItem.gameObject,self.redtrans2)
    

    self.redtrans3=self.btnpowerup.transform:Find("Root/Trans_RedPoint")
    local script3=self.redtrans3:GetComponent(typeof(CS.ScrollListChild))
    instantiate(script3.childItem.gameObject,self.redtrans3)

    self.redtrans4=self.btnunlock.transform:Find("Root/Trans_RedPoint")
    local script4=self.redtrans4:GetComponent(typeof(CS.ScrollListChild))
    instantiate(script4.childItem.gameObject,self.redtrans4)
    



    UIUtils.GetButtonListener(btnlevelup.gameObject).onClick=function() UIUAVPanel.OnClickBtnLevelUp() end
    UIUtils.GetButtonListener(btnbreak.gameObject).onClick=function() UIUAVPanel.OnClickBtnBreak() end
    UIUtils.GetButtonListener(self.mView.mTrans_BtnSave.gameObject).onClick=function() UIUAVPanel.OnClickSave() end

end
--更新 升级解锁替换等按钮状态
function UIUAVPanel. UpdateRightBtnState()
    self=UIUAVPanel
    local armtabledata=TableData.GetUavArmsData()
    local armequiped=NetCmdUavData:GetArmEquipState()
    local uavarmdic=NetCmdUavData:GetUavArmData()

    setactive(self.mView.mTrans_BtnReplace.gameObject,false)
    setactive(self.mView.mTrans_BtnUnistall.gameObject,false)
    setactive(self.mView.mTrans_BtnEquip.gameObject,false)
    setactive(self.mView.mTrans_BtnPowerUp.gameObject,false)
    setactive(self.mView.mTrans_BtnUnLock.gameObject,false)
    setactive(self.mView.mTrans_ArmMaxLevel.gameObject,false)

    for i=0, self.mView.mTrans_UnlockItem.childCount-1  do 
        gfdestroy(self.mView.mTrans_UnlockItem:GetChild(i))
    end

    setactive(self.redtrans3,false)
    setactive(self.redtrans4,false)


    --self.mView.mToggle_Contrast.interactable=false
    setactive(self.mView.mToggle_Contrast,false)
    
    --替换按钮显示
    --if uavarmdic:ContainsKey(UAVUtility.NowArmId) and not armequiped:Contains(UAVUtility.NowArmId)
    --and armequiped:Contains(UAVUtility.NowRealBottomArmId) and UAVUtility.NowRealBottomArmId~=0 then
    if uavarmdic:ContainsKey(UAVUtility.NowArmId) and UAVUtility.NowRealBottomArmId~=UAVUtility.NowArmId
    and UAVUtility.NowRealBottomArmId~=0 then
        setactive(self.mView.mTrans_BtnReplace.gameObject,true)
        setactive(self.mView.mToggle_Contrast,true)
    end
    --卸载按钮显示
    if uavarmdic:ContainsKey(UAVUtility.NowArmId) and UAVUtility.NowArmId==UAVUtility.NowRealBottomArmId then
    --if uavarmdic:ContainsKey(UAVUtility.NowArmId) and armequiped:Contains(UAVUtility.NowArmId) and
    --UAVUtility.NowRealBottomArmId~=0 then
        setactive(self.mView.mTrans_BtnUnistall.gameObject,true)
    end
    --装备按钮显示
    if uavarmdic:ContainsKey(UAVUtility.NowArmId) and UAVUtility.NowRealBottomArmId==0  then
        setactive(self.mView.mTrans_BtnEquip.gameObject,true)
    end
    --强化按钮显示
    if uavarmdic:ContainsKey(UAVUtility.NowArmId) and uavarmdic[UAVUtility.NowArmId].Level<self.Const.MAXArmLevel then
        setactive(self.mView.mTrans_BtnPowerUp.gameObject,true)
        if self.IsShowRedPointOnBtn(UAVUtility.NowArmId,2) then
            setactive(self.redtrans3,true)
        end
    end
    --解锁按钮显示
    if not uavarmdic:ContainsKey(UAVUtility.NowArmId) then
        setactive(self.mView.mTrans_BtnUnLock.gameObject,true)
        if self.IsShowRedPointOnBtn(UAVUtility.NowArmId,1) then
            setactive(self.redtrans4,true)
        end
        local script=self.mView.mTrans_UnlockItem:GetComponent(typeof(CS.ScrollListChild))
        local itemobj=instantiate(script.childItem.gameObject,self.mView.mTrans_UnlockItem)
        local itembtn=itemobj.transform:GetComponent(typeof(CS.UnityEngine.UI.Button))
        local itemtext=itemobj.transform:Find("Trans_GrpNum/ImgBg/Text_Num"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        
        local itemimg= UIUtils.GetImage(itemobj,"GrpItem/Img_Item")
        local itemrankimg=UIUtils.GetImage(itemobj,"GrpBg/Img_Bg")
        local itemData=nil
        local NowPartsNum=0
        if CS.LuaUtils.IsNullOrDestroyed(NetCmdItemData:GetItemCmdData(armtabledata[UAVUtility.NowArmId].ItemId)) then
        NowPartsNum=0
        else
        NowPartsNum=NetCmdItemData:GetItemCmdData(armtabledata[UAVUtility.NowArmId].ItemId).Num
        end
        local num=armtabledata[UAVUtility.NowArmId].ItemId
        itemData=TableData.GetItemData(armtabledata[UAVUtility.NowArmId].ItemId)
        TipsManager.Add(itemobj.gameObject,itemData,nil,true)
        itemimg.sprite=UIUtils.GetIconSprite("Icon/" .. itemData.icon_path, itemData.icon)
        itemrankimg.sprite=IconUtils.GetQuiltyByRank(itemData.rank)
        local NowUnLockCost=armtabledata[UAVUtility.NowArmId].UnlockNum
        if NowPartsNum<NowUnLockCost then
            itemtext.text=string.format("<color=#FF5E41>%d</color>/<color=#FFFFFF>%d</color>",NowPartsNum,NowUnLockCost)
        else
            itemtext.text=NowPartsNum.."/"..NowUnLockCost
        end
    end
    if uavarmdic:ContainsKey(UAVUtility.NowArmId) and uavarmdic[UAVUtility.NowArmId].Level==self.Const.MAXArmLevel then
        setactive(self.mView.mTrans_ArmMaxLevel.gameObject,true)
    end
end

function UIUAVPanel.OnClickSave()
    self=UIUAVPanel
    --卸载
    if self.SaveType==1 then
        self.IsClickSave=true
        NetCmdUavData:SendUavArmInstallData(self.UnInstallPos,0,function(ret)
            if ret == CS.CMDRet.eSuccess then
                UAVUtility.NowArmId=0
                UAVUtility.NowRealBottomArmId=0
                UAVUtility.NowFakeBottomArmId=0
                self.UpdateBottomSkillState()
                self.UpdateRightAreaInfo(true)
                self.UpdateLeftAreaInfo()
                --self.UpOrDown(false)
            end
        end)
    end
    ----替换
    --if self.SaveType==2 then
    --NetCmdUavData:SendUavArmInstallData(self.ReplacePos,UAVUtility.NowArmId,function(ret)self:FreshCallBack(ret)end)
    --UAVUtility.NowRealBottomArmId=UAVUtility.NowArmId
    --end
    ----装备
    --if self.SaveType==3 then
    --    local a=self.viewequippos
    --    local b=UAVUtility.NowArmId
    --NetCmdUavData:SendUavArmInstallData(self.viewequippos,UAVUtility.NowArmId,function(ret)self:FreshCallBack(ret)end)
    --UAVUtility.NowRealBottomArmId=UAVUtility.NowArmId
    --end
    ----self.UpdateRightBtnState()
end

function UIUAVPanel.OnClickReplace(desarmid,ReplacePos)
    self=UIUAVPanel
    local armequiplist=NetCmdUavData:GetArmEquipState()
    local tempequiplist=List:New()
    for i= 0, armequiplist.Count-1 do
        tempequiplist:Add(armequiplist[i])
    end
    tempequiplist[ReplacePos+1]=desarmid
    local uavarmlist=TableData.GetUavArmsData()
    local costnum=0
    local NetUavGrade=NetCmdUavData:GetUavTotalData().Uav.UavGrade
    local uavadvancedata=TableData.GetUavAdvanceData()
    local NowCostLimit=uavadvancedata[NetUavGrade].Cost
    --for i=1,tempequiplist:Count() do
    --    if tempequiplist[i]~=0 then
    --        costnum=costnum+uavarmlist[tempequiplist[i]].Cost
    --    end
    --end
    local templist=List:New()
    for i = 1,tempequiplist:Count() do
        templist:Add(tempequiplist[i])
    end
    templist:Sort()
    local lastnum=0
    local nownum=0
    for i=1,templist:Count() do
        if templist[i]~=0 then
            lastnum =nownum
            nownum=templist[i]
            costnum=costnum+uavarmlist[templist[i]].Cost
            if nownum==lastnum then
                costnum=costnum-uavarmlist[nownum].Cost
            end
        end
    end
    if costnum>NowCostLimit then
        --弹出载重已超标
        local hint=TableData.GetHintById(105023)
        CS.PopupMessageManager.PopupString(hint)
        return 
    end
    NetCmdUavData:SendUavArmInstallData(ReplacePos,desarmid,function(ret)
        if ret == CS.CMDRet.eSuccess then
            UAVUtility.NowRealBottomArmId=desarmid
            UAVUtility.NowFakeBottomArmId=desarmid
            self.UpdateBottomSkillState()
            self.UpdateLeftAreaInfo()
            self.UpdateRightBtnState()
            --self.UpOrDown(false)
        end
    end)
end

function UIUAVPanel.OnClickUninstall(uninstallarmid)
    self=UIUAVPanel
    
    local restarmnum=0
    local armequiplist=NetCmdUavData:GetArmEquipState()
    local tempequiplist=List:New()
    for i=0,armequiplist.Count-1 do
        tempequiplist:Add(armequiplist[i])
    end
    for i=0,armequiplist.Count-1 do
        if armequiplist[i]~=0 then
           restarmnum=restarmnum+1
        end
    end
    if restarmnum==1  then
        CS.PopupMessageManager.PopupString(TableData.GetHintById(105005))
        return
    end
    UAVUtility.IsClickUninstall=true
    --self.UpOrDown(true)
    -- 0 1 2 槽位
    for i=0,armequiplist.Count-1 do
        if armequiplist[i]==uninstallarmid then
            setactive(self.mView.mTrans_Skill:GetChild(i):Find("Trans_GrpItem"),false)
            setactive(self.mView.mTrans_Skill:GetChild(i):Find("Trans_GrpAdd"),true)
            self.UnInstallPos=i
            self.SaveType=1
            tempequiplist[i+1]=0
            break
        end
    end
    for i=0, self.mView.mTrans_Cost.childCount-1 do
        gfdestroy(self.mView.mTrans_Cost:GetChild(i))
    end
    local uavarmdic=TableData.GetUavArmsData()
    local costnum=0
    for i=1,tempequiplist:Count() do
        if tempequiplist[i]~=0 then
            costnum=costnum+uavarmdic[tempequiplist[i]].Cost
        end
    end
    local NetUavGrade=NetCmdUavData:GetUavTotalData().Uav.UavGrade
    local uavadvancedata=TableData.GetUavAdvanceData()
    local NowCostLimit=uavadvancedata[NetUavGrade].Cost
    for i=1,NowCostLimit  do
        local script=self.mView.mTrans_Cost:GetComponent(typeof(CS.ScrollListChild))
        local itemobj=instantiate(script.childItem.gameObject,self.mView.mTrans_Cost)
        if i<=costnum then
            setactive(itemobj.transform:Find("GrpState/Trans_On"),true)
        end
    end
    NetCmdUavData:SendUavArmInstallData(self.UnInstallPos,0,function(ret)
        if ret == CS.CMDRet.eSuccess then
            UAVUtility.NowArmId=0
            UAVUtility.NowRealBottomArmId=0
            UAVUtility.NowFakeBottomArmId=0
            self.UpdateBottomSkillState()
            self.UpdateRightAreaInfo(true)
            self.UpdateLeftAreaInfo()
            --self.UpOrDown(false)
        end
    end)
end

function UIUAVPanel.OnClickEquip(equiparmid,bottompos)
    self=UIUAVPanel
    local armequiplist=NetCmdUavData:GetArmEquipState()
    local uavarmlist=TableData.GetUavArmsData()
    local uavlevelupdata=TableData.GetUavLevelData()
    local uavdata=NetCmdUavData:GetUavData()
    local costnum=0
    local NetUavGrade=NetCmdUavData:GetUavTotalData().Uav.UavGrade
    local uavadvancedata=TableData.GetUavAdvanceData()
    local NowCostLimit=uavadvancedata[NetUavGrade].Cost


    local templist=List:New()
    for i = 1,self.fakearmequiplist:Count() do
        templist:Add(self.fakearmequiplist[i])
    end
    templist:Sort()
    local lastnum=0
    local nownum=0
    for i=1,templist:Count() do
        if templist[i]~=0 then
            lastnum =nownum
            nownum=templist[i]
            costnum=costnum+uavarmlist[templist[i]].Cost
            if nownum==lastnum then
                costnum=costnum-uavarmlist[nownum].Cost
            end
        end
    end
    if costnum>NowCostLimit then
        --弹出载重已超标
        local hint=TableData.GetHintById(105023)
        CS.PopupMessageManager.PopupString(hint)
        return 
    end
    NetCmdUavData:SendUavArmInstallData(bottompos,equiparmid,
        function(ret)
        if ret == CS.CMDRet.eSuccess then
            UAVUtility.NowRealBottomArmId=UAVUtility.NowArmId
            UAVUtility.NowFakeBottomArmId=UAVUtility.NowArmId
            self.UpdateBottomSkillState()
            self.UpdateRightAreaInfo()
            self.UpdateLeftAreaInfo()
            self.UpdateRightBtnState()
        end
    end)
end

function UIUAVPanel.OnClickPowerUp()
    self=UIUAVPanel
    --self.UpOrDown(false)
    --UIManager.OpenUI(UIDef.UIUAVPartsSkillUpDialogPanel)
    self.PartsSkillUpPanel = UAVPartsSkillUpDialogContent.New()
    self.PartsSkillUpPanel:InitCtrl(self.mView.Canvas)
    self.PartsSkillUpPanel:SetData(nil,self.mView.Canvas)
end

function UIUAVPanel.OnClickUnlock(unlockarmid)
    self=UIUAVPanel
    --self.UpOrDown(false)
     local armtabledata=TableData.GetUavArmsData()
     local uavrevelantdata=NetCmdUavData:GetUavData()
     local uavarmdic=NetCmdUavData:GetUavArmData()
     local armequiplist=NetCmdUavData:GetArmEquipState()
    local partsnum=0
    if CS.LuaUtils.IsNullOrDestroyed(NetCmdItemData:GetItemCmdData(armtabledata[unlockarmid].ItemId)) then
        partsnum=0
    else
        partsnum=NetCmdItemData:GetItemCmdData(armtabledata[unlockarmid].ItemId).Num
    end
    if partsnum<armtabledata[unlockarmid].UnlockNum then
        local uavarmdata=TableData.GetUavArmsData()
        local hint=TableData.GetHintById(225)
        local str=string_format(hint,TableData.GetItemData(uavarmdata[unlockarmid].ItemId).Name.str)
        CS.PopupMessageManager.PopupString(str)
        return
     else
        self:OnUnlockCallBack(unlockarmid) 
     end
end

function UIUAVPanel.OnClickBtnLevelUp()
    self=UIUAVPanel
    --self.UpOrDown(false)
    self.levelUpPanel = UIUAVLevelUpContent.New()
    self.levelUpPanel:InitCtrl(self.mView.Canvas)
    local uavdata=NetCmdUavData:GetUavData()
    
    self.levelUpPanel:SetData(uavdata,self.mView.Canvas)
end

function UIUAVPanel.OnClickBtnBreak()
    self=UIUAVPanel
    --self.UpOrDown(false)
    self.BreakPanel = UAVBreakDialogContent.New()
    self.BreakPanel:InitCtrl(self.mView.Canvas)
    self.BreakPanel:SetData(nil,self.mView.Canvas)
end

function UIUAVPanel.OnClickFuel()
    self=UIUAVPanel
    local nowfuelnum=NetCmdItemData:GetResItemCount(23)
    local totalfuelnum=NetCmdItemData:GetResItemCount(24)
    if nowfuelnum>=totalfuelnum then
        CS.PopupMessageManager.PopupString(TableData.GetHintById(105007))
        return 
    end

    self.FuelGetPanel = UAVFuelGetDialogContent.New()
    self.FuelGetPanel:InitCtrl(self.mView.Canvas)
    self.FuelGetPanel:SetData(nil,self.mView.Canvas)
    
    --UIManager.OpenUI(UIDef.UIUAVFuelDialogPanel)
end
function UIUAVPanel:OnUnlockCallBack(unlockarmid)
   NetCmdUavData:SendUnlockUavArmData(unlockarmid,function(ret)
       self=UIUAVPanel
       if ret == CS.CMDRet.eSuccess then
           self.UpdateBottomSkillState(true)
           self.UpdateLeftAreaInfo()
           self.UpdateRightBtnState()
           self.UpdateRightAreaInfo()
           local hint=TableData.GetHintById(105030)
           local data={}
           data.type="yanfa"
           data.str=hint
           UIManager.OpenUIByParam(UIDef.UAVLevelUpBreakPanel,data)
       end
       end)    
end
--刷新信息回调
function UIUAVPanel:FreshCallBack(ret)
    self=UIUAVPanel
    if ret == CS.CMDRet.eSuccess then
    self.UpdateBottomSkillState()
    if self.IsClickSave then
    self.UpdateRightAreaInfo(self.IsClickSave)
    end
    self.UpdateLeftAreaInfo()
    self.UpdateRightBtnState()
    end
end
--控制底部save按钮出现与否
function UIUAVPanel.UpOrDown(IsUp)
    --self=UIUAVPanel
    --self.mView.mAnim:ResetTrigger("UP")
    --self.mView.mAnim:ResetTrigger("Down")
    --if IsUp then
    --    self.mView.mAnim:SetTrigger("UP")
    --else
    --    self.mView.mAnim:SetTrigger("Down")
    --end
end

function UIUAVPanel.OnClickClose()
    if self.mView.mTrans_UAVInfo.gameObject.activeSelf==true then
        self.mView.mAnimator:SetInteger("UAVInfo",1)
        UIManager.CloseUI(UIDef.UIUAVPanel)
    end
    if self.mView.mTrans_UAVPartsInfo.gameObject.activeSelf==true then
        setactive(self.mView.mTrans_RightSKiillInfo.gameObject,true)
        self.mView.mAnimator:SetInteger("UAVInfo",3)
        self.mView.mAnimator:SetInteger("List",5)
        TimerSys:DelayCall(0.3,function ()
            setactive(self.mView.mTrans_UAVPartsInfo.gameObject,false)
            self.mView.mAnimator:SetInteger("UAVInfo",0)
            setactive(self.mView.mTrans_UAVInfo.gameObject,true)
            setactive(self.mView.mTrans_SkillRange,false)
        end)
        self.mView.mToggle_Range.isOn=false
        self.mView.mToggle_Contrast.isOn=false
        local pos=self.mView.mTrans_ScrollContent.localPosition
        self.mView.mTrans_ScrollContent.localPosition=Vector3(pos.x,0,pos.z)
        for i=0, self.mView.mTrans_ContrastDialogParent.childCount-1 do
            gfdestroy(self.mView.mTrans_ContrastDialogParent:GetChild(i))
        end
        UAVUtility.NowRealBottomArmId=-1
        UAVUtility.NowFakeBottomArmId=-1
        UAVUtility.IsClickUninstall=false
        self.UpdateBottomSkillState()
        --self.UpOrDown(false)
        self.UpdateUavMainViewInfo()
        local listequip=NetCmdUavData:GetArmEquipState()
        self.UpdateRightSkillState(listequip)
    end
end 
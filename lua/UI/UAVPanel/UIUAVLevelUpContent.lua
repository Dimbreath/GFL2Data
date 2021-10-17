
UIUAVLevelUpContent = class("UIUAVLevelUpContent", UIUAVContentBase)
UIUAVLevelUpContent.__index = UIUAVLevelUpContent
UIUAVLevelUpContent.PrefabPath = "Character/ChrLevelUpDialogV2.prefab"
UIUAVLevelUpContent.enterstate=false
function UIUAVLevelUpContent:ctor(obj)
    self.attributeList = {}
    self.expItems = {}
    self.currentItem = nil
    self.isLongPress = false
    self.pressType = 0
    self.framer = 0
    self.dicLevelExp = {}
    self.diclevelCash={}
    self.curExp = 0
    self.curLevel = 0
    self.canAddItemOnce = true
    self.uavexp=0
    -- self.isPlayAni = false
    self.pressUpdateFrame, self.pressAddCount = FacilityBarrackGlobal:GetPressParam()
    --可以添加经验书但是不能升级只是增加当前经验
    self.canaddexp=false
    --限制无人机等级不能超过指挥官等级+GlobalSystemExceedLevel
    self.uavlimitlevel=0
    self.showlevel=0
    self.IsFirstOverExp=false
    self.realmaxLevel=0
    self.canLongPress=true
    self.firstclickadd=false
    self.canadd=true
    self.firstenter=true
    self.nowexp=0
    self.totalExp=0
    self.IsFirstLevelUp=false
    self.Levelupdata=TableData.GetUavLevelData()
    self.breakleveldic={}
    self.topBar = nil
    UIUAVLevelUpContent.super.ctor(self, obj)
end

function UIUAVLevelUpContent:__InitCtrl()
    UISystem:AddContentUi("ChrLevelUpDialogV2")
    UIUAVLevelUpContent.enterstate=true
    self.mBtn_LevelUp = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpAction/BtnConfirm"))
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_LevelUpCancel = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpAction/BtnCancel"))
    --BgClose
    self.mBtn_EmptyArea = self:GetButton("Root/GrpBg/Btn_Close")
    self.mText_Lv = self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextLevel/GrpTextLevel/Text_LevelNow")
    self.mText_LvMax = self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextLevel/GrpTextLevel/Text_LevelMax")
    --0/100的text
    self.mText_Exp = self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextLevel/GrpTextExp/Text_Exp")
    --self.mText_ExpMax = self:GetText("levelUpDetail/UI_status/lvtext/Text_expNumMax")

    self.mTrans_ItemList = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItemList/Content")
    --上头的蓝色字加经验总共多少
    self.mText_ConfirmAddExp = self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextLevel/GrpTextAdd/Text_Add")
    self.mImage_ExpBefore = self:GetImage("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpProgressBar/Img_ProgressBarBefore")
    self.mImage_ExpAfter = self:GetImage("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpProgressBar/Img_ProgressBarAfter")

    self.mText_Title=self:GetText("Root/GrpDialog/GrpTop/GrpText/TitleText")
    self.mText_Title.text=TableData.GetHintById(105029)
    self.mText_BottomDes=self:GetText("Root/GrpDialog/GrpCenter/GrpText2/Text")
    --TODO 配表
    self.mText_BottomDes.text=TableData.GetHintById(105006)
    self.mText_GoldNum=self:GetText("Root/GrpDialog/GrpCenter/GrpGoldConsume/Text_Num")
    self.mTrans_Topbar=self:GetRectTransform("Root/GrpTop/GrpCurrency")
    self:InitBreakLevelDic()
    local playerlevel=AccountNetCmdHandler:GetLevel()
    --if exp>0
    local temp=TableData.GlobalSystemData.UavExceedlevel
    self.uavlimitlevel=temp+playerlevel
    self.maxlevel= TableData.listUavLevelDatas:GetList().Count;
    if self.uavlimitlevel>=self.maxlevel then
        self.uavlimitlevel=self.maxlevel
    end
    UIUtils.GetButtonListener(self.mBtn_LevelUp.gameObject).onClick = function()
        self:OnClickLevelUp()
    end

    UIUtils.GetButtonListener(self.mBtn_LevelUpCancel.gameObject).onClick = function()
        self:OnClickCloseLevelUp()
    end

    UIUtils.GetButtonListener(self.mBtn_EmptyArea.gameObject).onClick = function()
        self:OnClickCloseLevelUp()
    end

    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = function()
        self:OnClickCloseLevelUp()
    end

    self:InitTopbar()
    --self:InitAttributeList()
    self:InitLevelToExpDic()
end


function UIUAVLevelUpContent:SetData(data, parent)
    UIUAVLevelUpContent.super.SetData(self, data, parent)
    CS.LuaUIUtils.AddCanvas(self.mUIRoot.gameObject,GlobalConfig.ContentPrefabOrder)
    self.mGraphRayCaster=getcomponent(self.mUIRoot,typeof(CS.UnityEngine.UI.GraphicRaycaster))
    
    self:UpdateLevelInfo(data)
    --self:UpdateAttributeList()
    self:OnClickLevelUpConfirm()
    self:UpdateTopbar()
    self:OnEnable(true)
    
end

function UIUAVLevelUpContent:UpdateLevelInfo(cmdData)
    --self.uavMaxLevel = AccountNetCmdHandler:GetLevel()
    local uavdata=NetCmdUavData:GetUavData()
    local nowuavlevel=uavdata.UavLevel
    local leveluptalbe=TableData.GetUavLevelData()
    for i =nowuavlevel-1 , leveluptalbe.Count-1 do
        if leveluptalbe[i].UavMaterial~=0 then
            self.uavMaxLevel=leveluptalbe[i].Level
            if UAVUtility:GetUavGrade(nowuavlevel)~=uavdata.UavGrade then
                self.uavMaxLevel=leveluptalbe[i].Level+self.breakleveldic[uavdata.UavGrade]-self.breakleveldic[UAVUtility:GetUavGrade(nowuavlevel)]
                break
            end
            break
        end
    end
    if self.uavMaxLevel==nil then
        self.uavMaxLevel=self.uavlimitlevel
    end
    if self.uavMaxLevel>=self.uavlimitlevel then
        self.realmaxLevel=self.uavlimitlevel
    else
        self.realmaxLevel=self.uavMaxLevel
    end
    
    self.maxLevelTotalExp = TableData.UavExpToLevel(self.realmaxLevel)
    self.mText_Lv.text = cmdData.UavLevel
    self.mText_LvMax.text = "/" .. self.realmaxLevel
end

function UIUAVLevelUpContent:OnClickLevelUpConfirm()
    local nextLevel = self.mData.UavLevel >= self.uavMaxLevel and self.uavMaxLevel or self.mData.UavLevel + 1
    local levelupdata=TableData.GetUavLevelData()
    self.nextLevelExp = levelupdata[self.mData.UavLevel].UavExp
    self.targetLevel = self.mData.UavLevel
    self.curLevel = self.mData.UavLevel  --- 记录当前等级，表现需要
    self.curExp = 0

    
    self:UpdateLevelUpItem()
    --self:UpdateLevelUpInfo()
    if self.uavMaxLevel>=self.uavlimitlevel then
        self.realmaxLevel=self.uavlimitlevel
    else
        self.realmaxLevel=self.uavMaxLevel
    end
    local currentExp=self.mData.Exp
    local maxExp=levelupdata[self.mData.UavLevel].UavExp
    self.mText_Lv.text = self.mData.UavLevel
    self.showlevel=self.mData.UavLevel
    self.nowexp=currentExp
    local sliderBeforeValue = currentExp / maxExp
    local sliderAfterValue = currentExp  / maxExp
    self.mText_Exp.text = string_format("{0}/{1}", currentExp, maxExp)
    self.mText_ConfirmAddExp.text = "+" .. 0
    self.mImage_ExpBefore.fillAmount = sliderBeforeValue
    self.mImage_ExpAfter.fillAmount= sliderAfterValue
    
end

function UIUAVLevelUpContent:UpdateLevelUpItem()
    local itemList = NetCmdItemData:GetExpItemList()
    for i = 0, itemList.Count - 1 do
        local item = nil
        if i + 1 <= #self.expItems then
            item = self.expItems[i + 1]
        else
            item = UIUavExpItem.New()
            item:InitCtrl(self.mTrans_ItemList)
            self:AddItemListener(item)
            table.insert(self.expItems, item)
        end
        item:SetData(itemList[i])
    end
end

function UIUAVLevelUpContent:UpdateLevelUpInfo()
    local exp = 0
    local viewexp=0
    for _, item in ipairs(self.expItems) do
        exp = exp + item:GetItemExp()
    end
    viewexp=exp
    if self.uavMaxLevel>=self.uavlimitlevel then
        self.realmaxLevel=self.uavlimitlevel
    else
        self.realmaxLevel=self.uavMaxLevel
    end

    local hint=TableData.GetHintById(30024)
    self.targetLevel = self:CalculateLevel(self.mData.Exp + exp + self.dicLevelExp[self.mData.UavLevel])

    if self.targetLevel >=self.realmaxLevel then
    CS.PopupMessageManager.PopupString(hint)
    self.canAddItemOnce=false
    self.canLongPress=false
    self.canadd=false
    self.uavexp=exp
    self.firstenter=false
    self.totalExp = self.dicLevelExp[self.mData.UavLevel] + self.mData.Exp + exp
    self:UpdateLevelPreview(exp,viewexp,1)
    return 
    end
    self.totalExp = self.dicLevelExp[self.mData.UavLevel] + self.mData.Exp + exp
    self:UpdateLevelPreview(exp,viewexp)
end

function UIUAVLevelUpContent: UpdateLevelPreview(exp,viewexp,state)
    if not exp then
        return
    end
    local levelupdatalist=TableData.GetUavLevelData()
    local nextLevel = 0
    local currentExp = 0
    local maxExp = 0
    local sliderBeforeValue = 0
    local sliderAfterValue = 0
    local strLevel = self.targetLevel >= self.realmaxLevel and self.realmaxLevel or self.targetLevel
    if self.mData.Exp + exp >= self.nextLevelExp then
        nextLevel = (self.targetLevel >= self.realmaxLevel) and self.realmaxLevel or (self.targetLevel + 1)
        maxExp=levelupdatalist[nextLevel-1].UavExp
        if self.targetLevel >= self.realmaxLevel then
            currentExp = maxExp
        else
            currentExp = self.dicLevelExp[self.mData.UavLevel] + self.mData.Exp + exp - self.dicLevelExp[self.targetLevel]
        end
        sliderBeforeValue = 0
        sliderAfterValue = currentExp / maxExp
    else
        maxExp = self.nextLevelExp
        if self.targetLevel >= self.realmaxLevel then
            currentExp = maxExp
            sliderBeforeValue = 1
            sliderAfterValue = 1
        else
            currentExp = self.mData.Exp + exp
            sliderBeforeValue = self.mData.Exp / self.nextLevelExp
            sliderAfterValue = (self.mData.Exp + exp) / self.nextLevelExp
        end
    end
    self.nowexp=currentExp

    if (state~=nil and state==1) then
        self.targetLevel =self.realmaxLevel 
        currentExp = maxExp
        sliderBeforeValue = 1
        sliderAfterValue = 1

        self.mText_Lv.text = self.targetLevel
        self.showlevel=self.targetLevel                
        self.mText_Exp.text = string_format("{0}/{1}", currentExp, maxExp)

        self.mText_ConfirmAddExp.text = "+" .. exp
        self.temptotalexp=exp
        self.mImage_ExpBefore.fillAmount = 0
        self.mImage_ExpAfter.fillAmount= sliderAfterValue
        self.canLevelUp = exp > 0 
        self.diclevelCash={}
        local totalcash=0
        local uavdata=NetCmdUavData:GetUavData()
        for i = 0, self.Levelupdata.Count - 1 do
            local data = self.Levelupdata[i]
            if i>uavdata.UavLevel-1 then
                totalcash=totalcash+data.UavCash
                self.diclevelCash[data.Level]=totalcash
            end
        end
        local needcash=0
        if self.targetLevel==uavdata.UavLevel then
            needcash=0
        else
            needcash=self.diclevelCash[self.targetLevel]
        end
        self.mText_GoldNum.text=needcash
        local coinNum=NetCmdItemData:GetResItemCount(GlobalConfig.CoinId)
        self.mText_GoldNum.color= coinNum>=needcash and ColorUtils.BlackColor or ColorUtils.RedColor
        
        
        return 
    end

    self.mText_Lv.text = strLevel
    self.showlevel=strLevel
    self.mText_Exp.text = string_format("{0}/{1}", currentExp, maxExp)
    self.diclevelCash={}
    local totalcash=0
    local uavdata=NetCmdUavData:GetUavData()
    for i = 0, self.Levelupdata.Count - 1 do
        local data = self.Levelupdata[i]
        if i>uavdata.UavLevel-1 then
            totalcash=totalcash+data.UavCash
            self.diclevelCash[data.Level]=totalcash
        end
    end
    local needcash=0
    if self.targetLevel==uavdata.UavLevel then
        needcash=0
    else
        needcash=self.diclevelCash[self.targetLevel]
    end
    self.mText_GoldNum.text=needcash
    local coinNum=NetCmdItemData:GetResItemCount(GlobalConfig.CoinId)
    self.mText_GoldNum.color= coinNum>=needcash and ColorUtils.BlackColor or ColorUtils.RedColor
    

    self.mText_ConfirmAddExp.text = "+" .. exp
    
    self.mImage_ExpBefore.fillAmount = sliderBeforeValue
    self.mImage_ExpAfter.fillAmount= sliderAfterValue
    self.canLevelUp = exp > 0
end

function UIUAVLevelUpContent:AddItemListener(item)
    if item then
        UIUtils.GetButtonListener(item.mBtn_Select.gameObject).onClick = function()
            self:OnClickPlusItem(item, FacilityBarrackGlobal.PressType.Plus)
        end

        UIUtils.GetButtonListener(item.mBtn_Minus.gameObject).onClick = function()
            self:OnClickMinusItem(item, FacilityBarrackGlobal.PressType.Minus)
        end

        local longPress = CS.LongPressTriggerListener.Set(item.mBtn_Select.gameObject,0.5,true)
        longPress.longPressStart = function() self:OnItemPressed(item, FacilityBarrackGlobal.PressType.Plus) end
        longPress.longPressEnd = function() self:OnItemPressedOver(item) end

        longPress = CS.LongPressTriggerListener.Set(item.mBtn_Minus.gameObject,0.5,true)
        longPress.longPressStart = function() self:OnItemPressed(item, FacilityBarrackGlobal.PressType.Minus) end
        longPress.longPressEnd = function() self:OnItemPressedOver(item) end
    end
end

function UIUAVLevelUpContent:OnUpdate()
    if self.isLongPress and self.currentItem then
        self.framer = self.framer + 1
        if self.framer >= self.pressUpdateFrame then
            if self.pressType == FacilityBarrackGlobal.PressType.Plus then
                self:OnLongPressAdd(self.pressAddCount)
            elseif self.pressType == FacilityBarrackGlobal.PressType.Minus then
                self:OnLongPressMinus(-self.pressAddCount)
            end
            self.framer = 0
        end
    end
end

function UIUAVLevelUpContent:OnClickPlusItem(item, type)
    if item then
       if self.canAddItemOnce then
           local a=item:IsItemEnough()
           local b=item:IsOutOfNum()
         if item:IsItemEnough() and item:IsOutOfNum()==false then
             if self:CheckIsMaxLevel() then
                 return
             end 
            item:OnClickItem(type)
             self:UpdateExpItemNum()
            self:UpdateLevelUpInfo()
         end
       else
            self.canAddItemOnce = true
       end
    end

end

function UIUAVLevelUpContent:OnClickMinusItem(item, type)
    if item then
        item:OnClickItem(type)
        self:UpdateExpItemNum()
        self:UpdateLevelUpInfo()
        self.canLongPress=true
        self.firstclickadd=false
    end
end

function UIUAVLevelUpContent:OnItemPressed(item, type)
    if item then
        self:SetLongPress(item.mData.ItemTableData.id)
        self:EnableLongPress(true, type)
    end
end

function UIUAVLevelUpContent:SetLongPress(itemId)
    for i = 1, #self.expItems do
        if self.expItems[i].mData.ItemTableData.id == itemId then
            self.currentItem = self.expItems[i]
            return
        end
    end
end

function UIUAVLevelUpContent:EnableLongPress(enable, pressType)
    self.isLongPress = enable
    self.pressType = pressType
    if not enable then
        self.currentItem = nil
        self.pressType = 0
    end
end

function UIUAVLevelUpContent:OnLongPressAdd(count)
   
    if self.currentItem:IsOutOfNum() or not self:CanAddItem() then
        if self:CheckIsMaxLevel() then
            return 
        end
    end
    count = self.currentItem:GetItemCount(count)
    local addExp = self.currentItem:GetItemAddExp(count)
    local constraintValue = self:ConstraintExpItem(addExp)
    if constraintValue >= 0 then
        count = math.ceil(constraintValue / self.currentItem.offerExp)
    end
    self.currentItem:UpdateData(count)
    self:UpdateExpItemNum()
    self:UpdateLevelUpInfo()
    if self:CheckIsMaxLevel() then
        local tempnum=self.dicLevelExp[self.realmaxLevel]-self.dicLevelExp[self.mData.UavLevel]-self.mData.Exp
        local temp=self.temptotalexp-tempnum
        local count= math.floor(temp/self.currentItem.offerExp)
        if count<0 then
           return  
        end
        self.currentItem:UpdateData(-count)
        self:UpdateExpItemNum()
        self:UpdateLevelUpInfo()
    end
end

function UIUAVLevelUpContent:OnLongPressMinus(count)
    if self.currentItem.mCurrentCount <= 0 then
        self:EnableLongPress(false)
        return
    end
    count = self.currentItem.mCurrentCount + count <= 0 and -self.currentItem.mCurrentCount or count
    self.firstclickadd=false
    self.currentItem:UpdateData(count)
    self:UpdateExpItemNum()
    self:UpdateLevelUpInfo()
    self.canLongPress=true
end

function UIUAVLevelUpContent:OnItemPressedOver(item)
    if item then
        self:EnableLongPress(false)
        self.canAddItemOnce = false
    end
end

function UIUAVLevelUpContent:OnClickCloseLevelUp()

    gfdestroy(self.mUIRoot)
    --setactive(self.mUIRoot, false)
    self:ResetExpItem()
end
function UIUAVLevelUpContent:OnClickLevelUp()
    if self.canLevelUp --and self.curLevel~=self.targetLevel
     then
        self:SendLevelUpReq()
    else
        local hint = TableData.GetHintById(60009)
        CS.PopupMessageManager.PopupString(hint)
    end
end

function UIUAVLevelUpContent:SendLevelUpReq()
    --self.mParent:EnableMask(true)
    local uavdata=NetCmdUavData:GetUavData()
    local uavlevelupdata=TableData.GetUavLevelData()
    local itemdic=Dictionary:New()
    local goldnum=NetCmdItemData:GetResItemCount(2)
    local totalcash=0
    local levelupdata=TableData.GetUavLevelData()
    local uavdata=NetCmdUavData:GetUavData()
    self.diclevelCash={}
    for i = 0, levelupdata.Count - 1 do
        local data = levelupdata[i]
        if i>uavdata.UavLevel-1 then
            totalcash=totalcash+data.UavCash
            self.diclevelCash[data.Level]=totalcash
        end
    end
    local needcash=self.diclevelCash[self.targetLevel]
    if self.targetLevel==uavdata.UavLevel then
        NetCmdUavData:SendUavLevelUpData(self:GetCurrentExpList(),nil,function (ret)
            self:OnLevelUpCallBack(ret)
        end)
    else
        if goldnum<needcash then
            local hint=TableData.GetHintById(225)
            local name=TableData.GetItemData(2).Name.str
            local str=string_format(hint,name)
            CS.PopupMessageManager.PopupString(str)
            return 
        end
        itemdic:Add(2,needcash)
        NetCmdUavData:SendUavLevelUpData(self:GetCurrentExpList(),itemdic,function (ret)
            self:OnLevelUpCallBack(ret)
        end)

    end
end

function UIUAVLevelUpContent:OnLevelUpCallBack(ret)
    local levelupdatalist=TableData.GetUavLevelData()
    if ret == CS.CMDRet.eSuccess then
    if self.curLevel ~= self.mData.UavLevel then
        UIUAVPanel.UpdateUavMainViewInfo()
        UIUAVPanel.UpdateBottomSkillState()
        local tabledata=TableData.GetUavLevelData()
        local uavadvancedata=TableData.GetUavAdvanceData()
        local uavdata=NetCmdUavData:GetUavData()
        local localgrade=UAVUtility:GetUavGrade(uavdata.UavLevel)
        local netgrade=NetCmdUavData:GetUavGrade()
        local tempuavlevel=uavdata.UavLevel
    --if uavdata.UavLevel==UIUAVPanel.Const.MaxLevel then
    --    tempuavlevel=UIUAVPanel.Const.MaxLevel-1
    --else
    --    tempuavlevel=uavdata.UavLevel
    --end
        --等级
        local attributeList1=
        {
            name=TableData.GetHintById(55),
            nownum=self.curLevel,
            tonum=uavdata.UavLevel
        }
        --生命
        local attributeList2=
        {
            name=TableData.listLanguagePropertyDatas:GetDataById(4).ShowName.str,
            nownum=tabledata[self.curLevel-1].MaxHp,
            tonum=tabledata[tempuavlevel-1].MaxHp
        }
        --攻击
        local attributeList3=
        {
            name=TableData.listLanguagePropertyDatas:GetDataById(7).ShowName.str,
            nownum=tabledata[self.curLevel-1].Pow,
            tonum=tabledata[tempuavlevel-1].Pow
        }
        ----暴击几率
        --local attributeList4=
        --{
        --    name=TableData.listLanguagePropertyDatas:GetDataById(15).ShowName.str,
        --    nownum=((tabledata[uavdata.UavLevel-1].Crit+uavadvancedata[localgrade].Crit)/10).."%",
        --    tonum=((tabledata[uavdata.UavLevel-1].Crit+uavadvancedata[netgrade].Crit)/10).."%",
        --    minus=uavadvancedata[netgrade].Crit-uavadvancedata[localgrade].Crit
        --}
        ----暴击伤害
        --local attributeList5=
        --{
        --    name=TableData.listLanguagePropertyDatas:GetDataById(16).ShowName.str,
        --    nownum=((tabledata[uavdata.UavLevel-1].CritMult+uavadvancedata[localgrade].CritMult)/10).."%",
        --    tonum=((tabledata[uavdata.UavLevel-1].CritMult+uavadvancedata[netgrade].CritMult)/10).."%",
        --    minus=uavadvancedata[netgrade].CritMult-uavadvancedata[localgrade].CritMult
        --}
        --硬质护甲
        local attributeList6=
        {
            name=TableData.listLanguagePropertyDatas:GetDataById(30).ShowName.str,
            nownum=tabledata[self.curLevel-1].PhysicalShield,
            tonum=tabledata[tempuavlevel-1].PhysicalShield,
            minus=tabledata[tempuavlevel-1].PhysicalShield-tabledata[self.curLevel-1].PhysicalShield
        }
        --离子涂层
        local attributeList7=
        {
            name=TableData.listLanguagePropertyDatas:GetDataById(31).ShowName.str,
            nownum=tabledata[self.curLevel-1].MagicalShield,
            tonum=tabledata[tempuavlevel-1].MagicalShield,
            minus=tabledata[tempuavlevel-1].MagicalShield-tabledata[self.curLevel-1].MagicalShield
        }
        local attributeList={}
        table.insert(attributeList,attributeList1)
        table.insert(attributeList,attributeList2)
        table.insert(attributeList,attributeList3)
        --if attributeList4.minus~=0 then
        --    table.insert(attributeList,attributeList4)
        --end
        --if attributeList5.minus~=0 then
        --    table.insert(attributeList,attributeList5)
        --end
        if attributeList6.minus~=0 then
            table.insert(attributeList,attributeList6)
        end
        if attributeList7.minus~=0 then
            table.insert(attributeList,attributeList7)
        end
        local data=
        {
            type="levelup",
            attributeList,
            fromlv=self.curLevel,
            tolv=uavdata.UavLevel,
            obj=self.instobj
        }
        self:UpdateLevelInfo(self.mData)
        self:UpdateTopbar()
        self:OpenLevelUpPanel(data)
        self.curLevel=uavdata.UavLevel
        local playerlevel=AccountNetCmdHandler:GetLevel()
        local temp=TableData.GlobalSystemData.UavExceedlevel
        self.uavlimitlevel=temp+playerlevel
        if self.uavlimitlevel>=self.maxlevel then
        self.uavlimitlevel=self.maxlevel
        end
        if self.showlevel == self.uavMaxLevel or self.showlevel==self.uavlimitlevel then
            gfdestroy(self.instobj)
        end
    
    end

    local tabledata=TableData.GetUavLevelData()
    local uavdata=NetCmdUavData:GetUavData()
    local tablegrade = UAVUtility:GetUavGrade(uavdata.UavLevel);
    local breakitemdata = NetCmdItemData:GetItemCmdData(182);
    local itemnum=0
    if CS.LuaUtils.IsNullOrDestroyed(breakitemdata) then
        itemnum=0
    else
        itemnum=breakitemdata.Num
    end

    if tabledata[uavdata.UavLevel-1].UavMaterial~=0 and tablegrade==uavdata.UavGrade and
    itemnum>=1 then
    MessageSys:SendMessage(CS.GF2.Message.RedPointEvent.RedPointUpdate,"UAV")
    end
    if  uavdata.UavLevel==UIUAVPanel.Const.MaxLevel then
        self.nextLevelExp=0
    else
        self.nextLevelExp=tabledata[uavdata.UavLevel].UavExp
    end
    self:UpdateExpItemNum()
    for _, item in ipairs(self.expItems) do
        item.mData.Num=item.mData.Num-item.mCurrentCount
    end
    self:UpdateLevelPreview(0)
    self:ResetExpItem()
    gfdebug("无人机升级成功")
    else
       -- self.mParent:EnableMask(false)
    gfdebug("无人机升级失败")
    MessageBox.Show("出错了", "无人机当前不可再添加经验!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
    end
end


function UIUAVLevelUpContent:OpenLevelUpPanel(data)
    UIManager.OpenUIByParam(UIDef.UAVLevelUpBreakPanel, data)
end

function UIUAVLevelUpContent:UpdateAttributeList()
    for _, item in ipairs(self.attributeList) do
        item.value = self.mData:GetGunPropertyValueByType(item.mData.sys_name)
    end
end

function UIUAVLevelUpContent:UpdateExpItemNum()
    for _, item in ipairs(self.expItems) do
        item:UpdateItemNum()
    end
end

function UIUAVLevelUpContent:ResetExpItem()
    self.longPress = false
    self.currentItem = nil

    for _, item in ipairs(self.expItems) do
        item:ResetItem()
    end
end

function UIUAVLevelUpContent:InitLevelToExpDic()
    if self.dicLevelExp == nil  then
        self.dicLevelExp = {}
        self.diclevelCash={}
    end

    local totalExp = 0
    --local totalcash=0
    local levelupdata=TableData.GetUavLevelData()
    --local uavdata=NetCmdUavData:GetUavData()
    for i = 0, levelupdata.Count - 1 do
        local data = levelupdata[i]
        totalExp = totalExp + data.UavExp
        self.dicLevelExp[data.Level]=totalExp
        --if i>uavdata.UavLevel-1 then
        --    totalcash=totalcash+data.UavCash
        --    self.diclevelCash[data.Level]=totalcash
        --end
    end
    self.mText_GoldNum.text=0
    self.mText_GoldNum.color=ColorUtils.BlackColor
end

function UIUAVLevelUpContent:InitAttributeList()
    local propList = {}
    for i = 0, TableData.listLanguagePropertyDatas.Count - 1 do
        local propData = TableData.listLanguagePropertyDatas[i]
        if propData then
            if propData.barrack_show ~= 0 then
                table.insert(propList, propData)
            end
        end
    end

    table.sort(propList, function (a, b) return a.barrack_show < b.barrack_show end)
    for _, prop in ipairs(propList) do
        local item = UICommonPropertyItem.New()
        item.mData = prop
        table.insert(self.attributeList, item)
    end
end

function UIUAVLevelUpContent:CheckIsMaxLevel()
    return self.targetLevel >= self.realmaxLevel
end

function UIUAVLevelUpContent:CalculateLevel(exp)
    local levelupdatalist=TableData.GetUavLevelData()
    local lastExp=0
    local needExp=0
    for i = 1, levelupdatalist.Count - 1 do
        local data = levelupdatalist[i]
        local needExp = self.dicLevelExp[data.Level]
        local lastExp = self.dicLevelExp[data.Level - 1]
        if lastExp <= exp and exp < needExp then
            return data.Level - 1
        end
    end
    return levelupdatalist[levelupdatalist.Count-1].Level
end

function UIUAVLevelUpContent:ConstraintExpItem(exp)
    if (self.totalExp + exp) - self.maxLevelTotalExp >= 0 then
        return self.maxLevelTotalExp - self.totalExp
    end
    return -1
end

function UIUAVLevelUpContent:CanAddItem()
    return self.targetLevel < self.realmaxLevel
end

function UIUAVLevelUpContent:GetCurrentExpList()
    local list ={}
    for _, item in ipairs(self.expItems) do
        if item.mCurrentCount > 0 then
            list[item.mData] = item.mCurrentCount
        end
    end
    return list
end
--
function UIUAVLevelUpContent:InitBreakLevelDic()
    local uavgrade=0
    for i = 0, self.Levelupdata.Count-1 do
        if self.Levelupdata[i].UavMaterial~=0 then
            self.breakleveldic[uavgrade]=self.Levelupdata[i].Level
            uavgrade=uavgrade+1
        end
    end
    self.breakleveldic[uavgrade]=self.Levelupdata[self.Levelupdata.Count-1].Level
end

function UIUAVLevelUpContent:InitTopbar()
    if self.topBar == nil then
        self.topBar = ResourcesCommonItem.New()
        self.topBar:InitCtrl(self.mTrans_Topbar, true)
    end
    self.paramData={}
    table.insert(self.paramData,function() self:SetGraphRayCasterState(false) end)
    table.insert(self.paramData,function() self:SetGraphRayCasterState(true) end)
end

function UIUAVLevelUpContent:UpdateTopbar()
    if self.topBar then
        self.topBar:SetData({ id = GlobalConfig.CoinId},self.paramData)
    end
end

function UIUAVLevelUpContent:SetGraphRayCasterState(active)
    if CS.LuaUtils.IsNullOrDestroyed(self.mGraphRayCaster)==false then
        self.mGraphRayCaster.enabled=active
    end
end

require("UI.UAVPanel.UIUAVContentBase")
UAVBreakDialogContent = class("UAVBreakDialogContent",UIUAVContentBase)
UAVBreakDialogContent.__index = UAVBreakDialogContent
UAVBreakDialogContent.PrefabPath = "UAV/UAVBreakDialogV2.prefab"

function UAVBreakDialogContent:ctor(obj)

    UAVBreakDialogContent.super.ctor(self, obj)
end

function UAVBreakDialogContent:__InitCtrl()
    UISystem:AddContentUi("UAVBreakDialogV2")
    self.mText_TitleName=self:GetText("Root/GrpDialog/GrpTop/GrpText/TitleText")
    self.mBtn_BgClose=self:GetButton("Root/GrpBg/Btn_Close")
    self.mBtn_Close=self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_Cancle=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnCancel"))
    self.mBtn_Confirm=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnConfirm"))
    self.mText_Des=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillUp/GrpAllSkillDescription/GrpDescription/Viewport/Content/Text_SkillUp")
    self.mText_Des2=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillUp/GrpAllSkillDescription/GrpDescription/Viewport/Content/Text_SkillUp2")
    self.mText_Des3=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillUp/GrpAllSkillDescription/GrpDescription/Viewport/Content/Text_SkillUp3")
    self.mText_Consume=self:GetText("Root/GrpDialog/GrpCenter/GrpConsume/GrpTextName/TextName")
    self.mTrans_ItemScript=self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpConsume/GrpItem")
    

    local wurenji=TableData.GetHintById(105009)
    local dengji=TableData.GetHintById(101001)
    local tupo=TableData.GetHintById(105014)
    local LevelLimitUnlock=TableData.GetHintById(105004)
    local zaizhong=TableData.GetHintById(105001)
    local wuzhuanglan=TableData.GetHintById(105002)
    local xiaohao=TableData.GetHintById(901005)
    local baoji=TableData.listLanguagePropertyDatas:GetDataById(15).ShowName.str
    local baojishanghai=TableData.listLanguagePropertyDatas:GetDataById(16).ShowName.str

    local OilitemData=TableData.GetItemData(23);
    local goodsdata=TableData.GetStoreDataById(OilitemData.Goodsid)
    local diamonditemdata=TableData.GetItemData(1);
    local remaindiamondnum=NetCmdItemData:GetResItemCount(1)

    local nowuavlevel=NetCmdUavData:GetUavData().UavLevel
    local nextgradelevel=nowuavlevel+10
    local uavlevelupdata=TableData.GetUavLevelData()
    local uavadvancedata=TableData.GetUavAdvanceData()
    local NowGrade=NetCmdUavData:GetUavGrade()
    local nextcost=0
    local nextequip=0
    local nextcrit=0
    local nextcritmult=0
    nextcost=uavadvancedata[NowGrade+1].Cost-uavadvancedata[NowGrade].Cost
    nextequip=uavadvancedata[NowGrade+1].EquipNum-uavadvancedata[NowGrade].EquipNum
    nextcrit=uavadvancedata[NowGrade+1].Crit-uavadvancedata[NowGrade].Crit
    nextcritmult=uavadvancedata[NowGrade+1].CritMult-uavadvancedata[NowGrade].CritMult

    local script=self.mTrans_ItemScript:GetComponent(typeof(CS.ScrollListChild))
    local itemobj=instantiate(script.childItem.gameObject,self.mTrans_ItemScript)
    local itembtn=UIUtils.GetButton(itemobj)
    local itemimg=UIUtils.GetImage(itemobj,"GrpItem/Img_Item")
    local itemData=TableData.GetItemData(182)
    itemimg.sprite=UIUtils.GetIconSprite("Icon/Item",itemData.Icon)
    --itembtn.interactable=false;
    TipsManager.Add(itemobj.gameObject,itemData,nil,true,nil,nil,
            function() self:SetGraphRayCasterState(false) end,function() self:SetGraphRayCasterState(true)  end)
    local itemrankimg=UIUtils.GetImage(itemobj,"GrpBg/Img_Bg")
    itemrankimg.sprite=IconUtils.GetQuiltyByRank(itemData.rank)
    MessageSys:AddListener(5111,function() self:OnClickClose() end)
    local itemtext=UIUtils.GetText(itemobj,"Trans_GrpNum/ImgBg/Text_Num")
    local Citem=NetCmdItemData:GetNormalItem(182)
    local ownbreakmatnum=Citem.item_num
    local needmatnum=1
    local isItemEnough=false
    if ownbreakmatnum<needmatnum then
        itemtext.text=string.format("<color=#FF5E41>%d</color>/<color=#FFFFFF>%d</color>",ownbreakmatnum,needmatnum)
        isItemEnough=false
    else
        itemtext.text=ownbreakmatnum.."/"..needmatnum
        isItemEnough=true
    end

    --self.mview.mText_HasBuyNum.text=string.format(hin1,)
    self.mText_TitleName.text=TableData.GetHintById(105021)
    self.mText_Consume.text=TableData.GetHintById(105022)
    --self.mview.mText_Des.text=string.format(LevelLimitUnlock,"<color=#0068B7>Lv.</color>".."<color=#0068B7>nextgradelevel</color>")
    local str1="<color=#0068B7>Lv.</color>".."<color=#0068B7>"..tostring(nextgradelevel).."</color>"
    local str2="<color=#0068B7>"..tostring(nextcost).."</color>"
    local str3="<color=#0068B7>"..tostring(nextequip).."</color>"
    self.mText_Des.text=string_format(LevelLimitUnlock,str1)
    self.mText_Des2.text=string_format(zaizhong,str2)
    self.mText_Des3.text=string_format(wuzhuanglan,str3)
    if NowGrade==2 then
        --setactive()
        str2="<color=#0068B7>"..tostring(nextcost).."</color>"
        str3="<color=#0068B7>+5%</color>"
        self.mText_Des2.text=string_format(zaizhong,str2)
        self.mText_Des3.text=baoji..str3
    end
    if NowGrade==3 then
        setactive(self.mText_Des3.gameObject,false)
        str2="<color=#0068B7>+20%</color>"
        self.mText_Des2.text=baojishanghai..str2
    end
    if NowGrade==4 then
        setactive(self.mText_Des3.gameObject,false)
        str2="<color=#0068B7>+5%</color>"
        self.mText_Des2.text=baoji..str2
    end

    UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick=function ()
        
        self:OnClickClose() end

    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick=function ()
        
        self:OnClickClose() end

    UIUtils.GetButtonListener(self.mBtn_Cancle.gameObject).onClick=function()
        
        self:OnClickClose() end

    UIUtils.GetButtonListener(self.mBtn_Confirm.gameObject).onClick=function()
        if isItemEnough then
            NetCmdUavData:SendUavUpGrade(
                    function(ret)
                        self:OnUpGradeCallback(ret)
                    end)
        else
            local str=string_format(TableData.GetHintById(225),TableData.GetItemData(Citem.item_id).Name.str)
            CS.PopupMessageManager.PopupString(str)
            return
        end
    end
    
end



function UAVBreakDialogContent:OnClickClose()
    gfdestroy(self.mUIRoot)
    MessageSys:RemoveListener(5111,self.MessageCallback)
end

function UAVBreakDialogContent:MessageCallback()
    print(1)
end

function UAVBreakDialogContent:SetData(data, parent)
    UAVBreakDialogContent.super.SetData(self, data, parent)
    CS.LuaUIUtils.AddCanvas(self.mUIRoot.gameObject,GlobalConfig.ContentPrefabOrder)
    self.mGraphRayCaster=getcomponent(self.mUIRoot,typeof(CS.UnityEngine.UI.GraphicRaycaster))
end

function UAVBreakDialogContent:OnUpGradeCallback(ret)
    local levelupdatalist=TableData.GetUavLevelData()
    if ret == CS.CMDRet.eSuccess then
        gfdebug("无人机突破成功")
        UIUAVPanel.UpdateUavMainViewInfo()
        UIUAVPanel.UpdateBottomSkillState()
        MessageSys:SendMessage(CS.GF2.Message.RedPointEvent.RedPointUpdate,"UAV");
        local uavdata=NetCmdUavData:GetUavData()
        local tabledata=TableData.GetUavAdvanceData()
        local uavleveldata=TableData.GetUavLevelData()
        local localgrade=UAVUtility:GetUavGrade(uavdata.UavLevel)
        local netgrade=NetCmdUavData:GetUavGrade()
        local attributeList1=
        {
            --等级上限
            name=TableData.GetHintById(105028),
            --TableData.GetHintById(55),
            nownum=UAVUtility:GetUavLevelMax(localgrade),
            tonum=UAVUtility:GetUavLevelMax(netgrade)
        }
        local attributeList2=
        {
            --载重
            name=TableData.GetHintById(105016),
            nownum=tabledata[localgrade].Cost,
            tonum=tabledata[netgrade].Cost,
            minus=tabledata[netgrade].Cost-tabledata[localgrade].Cost
        }
        local attributeList3=
        {
            --武装栏
            name=TableData.GetHintById(105027),
            --TableData.GetHintById(),
            nownum=tabledata[localgrade].EquipNum,
            tonum=tabledata[netgrade].EquipNum,
            minus=tabledata[netgrade].EquipNum-tabledata[localgrade].EquipNum
        }
        local attributeList4=
        {
            --暴击
            name=TableData.listLanguagePropertyDatas:GetDataById(15).ShowName.str,
            nownum=math.floor((uavleveldata[uavdata.UavLevel-1].Crit+tabledata[localgrade].Crit)/10).."%",
            tonum=math.floor((uavleveldata[uavdata.UavLevel-1].Crit+tabledata[netgrade].Crit)/10).."%" ,
            minus=tabledata[netgrade].Crit-tabledata[localgrade].Crit
        }

        local attributeList5=
        {
            --暴击伤害
            name=TableData.listLanguagePropertyDatas:GetDataById(16).ShowName.str,
            nownum=math.floor((uavleveldata[uavdata.UavLevel-1].CritMult+tabledata[localgrade].CritMult)/10).."%",
            tonum=math.floor((uavleveldata[uavdata.UavLevel-1].CritMult+tabledata[netgrade].CritMult)/10).."%",
            minus=tabledata[netgrade].CritMult-tabledata[localgrade].CritMult
        }

        local attributeList={}

        table.insert(attributeList,attributeList1)
        if attributeList2.minus~=0 then
            table.insert(attributeList,attributeList2)
        end
        if attributeList3.minus~=0 then
            table.insert(attributeList,attributeList3)
        end
        if attributeList4.minus~=0 then
            table.insert(attributeList,attributeList4)
        end
        if attributeList5.minus~=0 then
            table.insert(attributeList,attributeList5)
        end

        local data=
        {
            type="break",
            attributeList,
            fromlv=localgrade,
            tolv=netgrade
        }
        self:OpenSuccessBreakPanel(data)
        --gfdestroy(self.mUIRoot)
        self:OnClickClose()

    else
        gfdebug("无人机突破失败")
        MessageBox.Show("出错了", "无人机突破失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
    end
end

function UAVBreakDialogContent:OpenSuccessBreakPanel(data)
    UIManager.OpenUIByParam(UIDef.UAVLevelUpBreakPanel, data)
end

function UAVBreakDialogContent:SetGraphRayCasterState(active)
    if CS.LuaUtils.IsNullOrDestroyed(self.mGraphRayCaster)==false then
        self.mGraphRayCaster.enabled=active
    end
end




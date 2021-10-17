require("UI.UAVPanel.UIUAVContentBase")
UAVFuelGetDialogContent = class("UAVFuelGetDialogContent",UIUAVContentBase)
UAVFuelGetDialogContent.__index = UAVFuelGetDialogContent
UAVFuelGetDialogContent.PrefabPath = "UAV/UAVFuelGetDialogV2.prefab"

function UAVFuelGetDialogContent:ctor(obj)
    
    UAVFuelGetDialogContent.super.ctor(self, obj)
end

function UAVFuelGetDialogContent:__InitCtrl()
    UISystem:AddContentUi("UAVFuelGetDialogV2")
    self.mText_TitleName=self:GetText("Root/GrpDialog/GrpTop/GrpText/TitleText")
    self.mBtn_BgClose=self:GetButton("Root/GrpBg/Btn_Close")
    self.mBtn_Close=self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mText_HasBuyNum=self:GetText("Root/GrpDialog/GrpCenter/GrpTextBuy/Text_Num")
    self.mText_CostDes=self:GetText("Root/GrpDialog/GrpCenter/GrpTextInfo/Text_Description1")
    self.mText_BottomDes=self:GetText("Root/GrpDialog/GrpCenter/GrpTextInfo/Text_Description2")
    self.mTrans_Item=self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItemList/Content")
    self.mBtn_Cancle=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnCancel"))
    self.mBtn_Confirm=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnConfirm"))
    local hint1=TableData.GetHintById(901010)
    local hint2=TableData.GetHintById(204)
    local hint3=TableData.GetHintById(901011)
    local OilitemData=TableData.GetItemData(23);
    local goodsdata=TableData.GetStoreDataById(OilitemData.Goodsid)
    local diamonditemdata=TableData.GetItemData(1);
    local remaindiamondnum=NetCmdItemData:GetResItemCount(1)
    UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick=function ()
        self:OnClickClose()
    end
    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick=function ()
        self:OnClickClose()
    end
    UIUtils.GetButtonListener(self.mBtn_Cancle.gameObject).onClick=function() 
        self:OnClickClose()
    end
    UIUtils.GetButtonListener(self.mBtn_Confirm.gameObject).onClick=function() 
        local goodsdata3070=TableData.GetStoreDataById(OilitemData.Goodsid)
        local goodsdata3071=TableData.GetStoreDataById(OilitemData.Goodsid+1)
        
        local netgoodsdata3070=NetCmdStoreData:GetStoreGoodById(goodsdata3070.Id)
        local netgoodsdata3071=NetCmdStoreData:GetStoreGoodById(goodsdata3071.Id)

        local todaybuyoil3070Num=0
        local todaybuyoil3071Num=0
        if CS.LuaUtils.IsNullOrDestroyed(netgoodsdata3070) then
        todaybuyoil3070Num=0 
        else
        todaybuyoil3070Num=netgoodsdata3070.buy_times*goodsdata3070.Reward[23]
        end

        if CS.LuaUtils.IsNullOrDestroyed(netgoodsdata3071) then
        todaybuyoil3071Num=0
        else
        todaybuyoil3071Num=netgoodsdata3071.buy_times*goodsdata3071.Reward[23]
        end

        local diamondnum=NetCmdItemData:GetResItemCount(1)
        local nowfuelnum=NetCmdItemData:GetResItemCount(23)
        local totalfuelnum=NetCmdItemData:GetResItemCount(24)
        local hint=TableData.GetHintById(2)
        local itemhint=TableData.GetHintById(225)
        local diamoundname=TableData.GetItemData(1).Name.str
        if todaybuyoil3070Num<goodsdata3070.Limit*goodsdata3070.Reward[23] then
            --用数字是因为表中没看到数据
            if diamondnum<100 then
                CS.PopupMessageManager.PopupString(string_format(itemhint,diamoundname))
                return
            else
                NetCmdStoreData:SendStoreBuy(OilitemData.Goodsid,1,function(ret)
                self:OnSuccessBuyOilFirstCallback(ret)end)
            end
        else
            if diamondnum<200 then
                CS.PopupMessageManager.PopupString(string_format(itemhint,diamoundname))
                return
            else
                NetCmdStoreData:SendStoreBuy(OilitemData.Goodsid+1,1,function(ret)
                self:OnSuccessBuyOilSecondCallback(ret)end)
            end
        end
    end
    local goodsdata3070=TableData.GetStoreDataById(OilitemData.Goodsid)
    local goodsdata3071=TableData.GetStoreDataById(OilitemData.Goodsid+1)
    local netgoodsdata3070=NetCmdStoreData:GetStoreGoodById(goodsdata3070.Id)
    local netgoodsdata3071=NetCmdStoreData:GetStoreGoodById(goodsdata3071.Id)
    local todaybuyoil3070Num=0
    local todaybuyoil3071Num=0
    if CS.LuaUtils.IsNullOrDestroyed(netgoodsdata3070) then
    todaybuyoil3070Num=0 
    else
    todaybuyoil3070Num=netgoodsdata3070.buy_times*goodsdata3070.Reward[23]
    end
    if CS.LuaUtils.IsNullOrDestroyed(netgoodsdata3071) then
    todaybuyoil3071Num=0
    else
    todaybuyoil3071Num=netgoodsdata3071.buy_times*goodsdata3071.Reward[23]
    end
    local totalOilNum=todaybuyoil3070Num+todaybuyoil3071Num
    self.mText_HasBuyNum.text=string_format(hint1,TableData.GetHintById(105008),totalOilNum)
    if CS.LuaUtils.IsNullOrDestroyed(netgoodsdata3070)==false and netgoodsdata3070.buy_times>=2 then
        self.mText_CostDes.text=string_format(hint2,200,diamonditemdata.Name.str,goodsdata3071.Reward[23],OilitemData.Name.str)
    else
        self.mText_CostDes.text=string_format(hint2,100,diamonditemdata.Name.str,goodsdata3070.Reward[23],OilitemData.Name.str)
    end
    self.mText_BottomDes.text=string_format(hint3,OilitemData.Name.str,diamonditemdata.Name.str,goodsdata.Limit*goodsdata.Reward[23])
    local script=self.mTrans_Item:GetComponent(typeof(CS.ScrollListChild))
    local itemobj=instantiate(script.childItem.gameObject,self.mTrans_Item)
    local itembtn=itemobj.transform:GetComponent(typeof(CS.UnityEngine.UI.Button))
    self.itemtext=itemobj.transform:Find("Trans_GrpNum/ImgBg/Text_Num"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.itemimg=itemobj.transform:Find("GrpItem/Img_Item"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    local itemData=TableData.GetItemData(1)
    self.itemimg.sprite=UIUtils.GetIconSprite("Icon/Item",itemData.Icon)
    local itemset=itemobj.transform:Find("GrpSel")
    local itemchoose=itemobj.transform:Find("Trans_GrpChoose")
    setactive(itemset,false)
    setactive(itemchoose,false)
    TipsManager.Add(itemobj.gameObject,itemData,nil,false,nil,nil,
    function() self:SetGraphRayCasterState(false) end,function() self:SetGraphRayCasterState(true)  end)
    local itemrankimg=UIUtils.GetImage(itemobj,"GrpBg/Img_Bg")
    itemrankimg.sprite=IconUtils.GetQuiltyByRank(itemData.rank)
    self.itemtext.text=NetCmdItemData:GetResItemCount(1)
end

function UAVFuelGetDialogContent:OnClickClose()
    gfdestroy(self.mUIRoot)
end

function UAVFuelGetDialogContent:SetData(data, parent,IsOpenFromBattle)
    UAVFuelGetDialogContent.super.SetData(self, data, parent)
    CS.LuaUIUtils.AddCanvas(self.mUIRoot.gameObject,GlobalConfig.ContentPrefabOrder)
    self.mGraphRayCaster=getcomponent(self.mUIRoot,typeof(CS.UnityEngine.UI.GraphicRaycaster))
    self.IsOpenFromBattle=IsOpenFromBattle
    
end


--成功购买燃油回调1 
function UAVFuelGetDialogContent:OnSuccessBuyOilFirstCallback(ret)
    
    if ret == CS.CMDRet.eSuccess then
    --UIUtils.PopupHintMessage(202)  
    local OilitemData=TableData.GetItemData(23);
    local goodsdata3070=TableData.GetStoreDataById(OilitemData.Goodsid)
    local goodsdata3071=TableData.GetStoreDataById(OilitemData.Goodsid+1)
    local diamonditemdata=TableData.GetItemData(1);
    local remaindiamondnum=NetCmdItemData:GetResItemCount(1)
    local hint1=TableData.GetHintById(901010)
    local hint2=TableData.GetHintById(204)
    local netgoodsdata3070=NetCmdStoreData:GetStoreGoodById(goodsdata3070.Id)
    local netgoodsdata3071=NetCmdStoreData:GetStoreGoodById(goodsdata3071.Id)
    local todaybuyoil3070Num=0
    local todaybuyoil3071Num=0
        if CS.LuaUtils.IsNullOrDestroyed(netgoodsdata3070) then
         todaybuyoil3070Num=0 
        else
        todaybuyoil3070Num=netgoodsdata3070.buy_times*goodsdata3070.Reward[23]
        end
        if CS.LuaUtils.IsNullOrDestroyed(netgoodsdata3071) then
        todaybuyoil3071Num=0
        else
        todaybuyoil3071Num=netgoodsdata3071.buy_times*goodsdata3071.Reward[23]
        end   
    local totalOilNum=todaybuyoil3070Num+todaybuyoil3071Num
    --self.itemtext.text=remaindiamondnum
    --self.mText_HasBuyNum.text=string_format(hint1,TableData.GetHintById(105008),totalOilNum)
    --self.mText_CostDes.text=string_format(hint2,200,diamonditemdata.Name.str,goodsdata3070.Reward[23],OilitemData.Name.str)
    local nowfuelnum=NetCmdItemData:GetResItemCount(23)
    local totalfuelnum=NetCmdItemData:GetResItemCount(24)
        if self.IsOpenFromBattle==nil then     
            UIUAVPanel.UpdateUavMainViewInfo()
        end
    if nowfuelnum>=totalfuelnum then
        gfdestroy(self.mUIRoot)
    end
    UIUtils.PopupPositiveHintMessage(202)
    else
        gfdebug("购买燃油失败")
        MessageBox.Show("出错了", "购买燃油失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
    end
end
--成功购买燃油回调2
function UAVFuelGetDialogContent:OnSuccessBuyOilSecondCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        local OilitemData=TableData.GetItemData(23);
        local goodsdata3070=TableData.GetStoreDataById(OilitemData.Goodsid)
        local goodsdata3071=TableData.GetStoreDataById(OilitemData.Goodsid+1)
        local diamonditemdata=TableData.GetItemData(1);
        local remaindiamondnum=NetCmdItemData:GetResItemCount(1)
        local hint1=TableData.GetHintById(901010)
        local hint2=TableData.GetHintById(204)
        local netgoodsdata3070=NetCmdStoreData:GetStoreGoodById(goodsdata3070.Id)
        local netgoodsdata3071=NetCmdStoreData:GetStoreGoodById(goodsdata3071.Id)
        local todaybuyoil3070Num=0
        local todaybuyoil3071Num=0
        if CS.LuaUtils.IsNullOrDestroyed(netgoodsdata3070) then
        todaybuyoil3070Num=0 
        else
        todaybuyoil3070Num=netgoodsdata3070.buy_times*goodsdata3070.Reward[23]
        end
        if CS.LuaUtils.IsNullOrDestroyed(netgoodsdata3071) then
        todaybuyoil3071Num=0
        else
        todaybuyoil3071Num=netgoodsdata3071.buy_times*goodsdata3071.Reward[23]
        end
        local totalOilNum=todaybuyoil3070Num+todaybuyoil3071Num
        --self.itemtext.textt=remaindiamondnum
        --self.mText_HasBuyNum.text=string_format(hint1,TableData.GetHintById(105008),totalOilNum)
        --self.mText_CostDes.text=string_format(hint2,300,diamonditemdata.Name.str,goodsdata3071.Reward[23],OilitemData.Name.str)
        local nowfuelnum=NetCmdItemData:GetResItemCount(23)
        local totalfuelnum=NetCmdItemData:GetResItemCount(24)
        if self.IsOpenFromBattle==nil then
            UIUAVPanel.UpdateUavMainViewInfo()
        end
        if nowfuelnum>=totalfuelnum then
            gfdestroy(self.mUIRoot)
        end
        UIUtils.PopupPositiveHintMessage(202)
        else
            gfdebug("购买燃油失败")
            MessageBox.Show("出错了", "购买燃油失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
        end
end

function UAVFuelGetDialogContent:SetGraphRayCasterState(active)
    if CS.LuaUtils.IsNullOrDestroyed(self.mGraphRayCaster)==false then
        self.mGraphRayCaster.enabled=active
    end
end



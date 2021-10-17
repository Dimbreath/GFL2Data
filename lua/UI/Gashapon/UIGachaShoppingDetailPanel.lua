require("UI.UIBasePanel")
require("UI.Gashapon.UIGachaMainPanelV2")
UIGachaShoppingDetailPanel=class("UIGachaShoppingDetailPanel",UIBasePanel)
UIGachaShoppingDetailPanel.__index=UIGachaShoppingDetailPanel

UIGachaShoppingDetailPanel.mView=nil
UIGachaShoppingDetailPanel.allGunIdList={}   --ssr和srlist全部weaponid的集合
UIGachaShoppingDetailPanel.allWeaponIdList={}
UIGachaShoppingDetailPanel.curTabId=nil
UIGachaShoppingDetailPanel.tabList={}
UIGachaShoppingDetailPanel.hasOpened=false;
function UIGachaShoppingDetailPanel:ctor()

end

function UIGachaShoppingDetailPanel:Close()

     UIManager.CloseUI(UIDef.UIGachaShoppingDetailPanel)
end

function UIGachaShoppingDetailPanel.Init(root,data)
    UIGachaShoppingDetailPanel.super.SetRoot(UIGachaShoppingDetailPanel, root);
    self=UIGachaShoppingDetailPanel
    self.mIsPop = true

    self.mView=UIGachaShoppingDetailPanelView
    self.mView:InitCtrl(root)
end


function UIGachaShoppingDetailPanel.OnInit()
    self=UIGachaShoppingDetailPanel
   UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick=function()
       UIGachaShoppingDetailPanel:Close()
   end
    self:InitLeftTab()

    self.curTabId=1   --刚开始默认打开
    self.mView.mText_topTitle.text=TableData.GetHintById(107013)
    setactive(self.mView.mTrans_GrpOrderDetails.gameObject,true)
    setactive(self.mView.mTrans_GrpOdds.gameObject,false)
    self.mView.mText_Description.text= UIGachaMainPanelV2.mCurGachaData.CommonHint
    self:OnClickTab(self.tabList[1],1)
    self:RegistrationKeyboard(KeyCode.Escape,self.mView.mBtn_Close)
end

function UIGachaShoppingDetailPanel:InitLeftTab()
    self.hasOpened=false
    self.tabList={}
    for id=1,2 do

        local item=GashaponDialogLeftTabItemV2.New()
        table.insert(self.tabList,item)
        item:InitCtrl(self.mView.mLeftTabList)
        item:SetData({ name = TableData.GetHintById(107012 + id) })
        local itemBtn=UIUtils.GetListener(item.mBtn_Self.gameObject)
        itemBtn.param=id
        itemBtn.paramData=item
        itemBtn.onClick=function() self:OnClickTab(item,id)end
    end
end

function UIGachaShoppingDetailPanel:OnClickTab(gameObj,idValue)

    self.curTabId=idValue
    self.mView.mText_topTitle.text=TableData.GetHintById(107012+idValue)


    if idValue==1 and self.tabList[idValue].mBtn_Self.interactable==true then
        setactive(self.mView.mTrans_GrpOrderDetails.gameObject,true)
        setactive(self.mView.mTrans_GrpOdds.gameObject,false)

    elseif idValue==2 and self.tabList[idValue].mBtn_Self.interactable==true then
        setactive(self.mView.mTrans_GrpOrderDetails.gameObject,false)
        setactive(self.mView.mTrans_GrpOdds.gameObject,true)
        if self.hasOpened==false then
            self:OnShowOddsUpAndPublicity(UIGachaMainPanelV2.mCurGachaData.Type)
            self.hasOpened=true
        end

    end


    --local itemBtn=UIUtils.GetListener(gameObj.mBtn_Self.gameObject)
    for i=1,#self.tabList do
        self.tabList[i]:SetSelect(false);

        if((UIUtils.GetListener(self.tabList[i].mBtn_Self.gameObject).param) == self.curTabId) then
            --printstack("应该让第"..i.."个不可交互")
            self.tabList[i]:SetSelect(true);
        end
    end

end

function UIGachaShoppingDetailPanel:OnShowOddsUpAndPublicity(typeId)
   -- printstack("type is======="..typeId)


    local ssrList=UIGachaMainPanelV2.mCurGachaData.SSRPickUpList  ---------ssr是itemData的类型了
    if ssrList~=nil then
        setactive(self.mView.mTrans_GrpOddsUp.gameObject,true)
        for i=0,ssrList.Count-1 do
            self:InitOddsUp(ssrList[i])
        end

    end

    local srList=UIGachaMainPanelV2.mCurGachaData.SRPickUpList  ---------sr是itemData的类型了
    if srList~=nil then
        setactive(self.mView.mTrans_GrpOddsUp.gameObject,true)
        for i=0,srList.Count-1 do
            self:InitOddsUp(srList[i])
        end
    end

    if ssrList.Count==0 and  srList.Count==0 then
    setactive(self.mView.mTrans_GrpOddsUp.gameObject,false)
    end

    setactive(self.mView.mTrans_OddsPublicity.gameObject,true)
    UIGachaShoppingDetailPanel:InitGunOddsPublicity()
    UIGachaShoppingDetailPanel:InitWeaponOddsPublicity()

end

function UIGachaShoppingDetailPanel:InitOddsUp(ListElement)
    if ListElement.type==4    then   --人形

        table.insert(self.allGunIdList,ListElement.id)

        setactive(self.mView.mTrans_UpGrpChr.gameObject,true)
        local gunItemRank=ListElement.rank
        local starCount=TableData.GlobalSystemData.QualityStar[gunItemRank-1]
        local chrUpItem=GashaponChrUpItemV2.New()
        chrUpItem:InitCtrl(self.mView.mTrans_GrpChrContent)
        chrUpItem.mText_Name.text=ListElement.name.str
        chrUpItem:SetStars(starCount)
        local  BarrackChrCardItem=UIBarrackChrCardItem.New()
        BarrackChrCardItem:InitCtrl(chrUpItem.mTrans_GrpAvatar)
        BarrackChrCardItem:SetData(ListElement.args[0],false,ListElement.id,true)

    elseif ListElement.type==8      then    --武器

        table.insert(self.allWeaponIdList,ListElement.id)

        setactive(self.mView.mTrans_UpGrpWeapon.gameObject,true)
        local weaponItemRank=ListElement.rank
        local starCount= TableData.GlobalSystemData.QualityStar[weaponItemRank-1]
        local weaponItem=UICommonWeaponInfoItem.New()
        weaponItem:InitCtrl(self.mView.mTrans_GrpWeaponContent)

        weaponItem:SetData(ListElement.args[0], 0,0,true)
        --if self.mCurSelMailItem.mData.get_attachment > 0 then
        --    weaponInfoItem:SetReceived(true)
        --end
        --return weaponInfoItem
    else
        print("该物品不是人形武器或人形")
    end
end





function UIGachaShoppingDetailPanel:InitGunOddsPublicity()
    local gunDic=UIGachaMainPanelV2.mCurGachaData.GunRateDict
    if gunDic.Count==0 then
        setactive(self.mView.mTrans_PublicityGrpChr.gameObject,false)
    
    else
        setactive(self.mView.mTrans_PublicityGrpChr.gameObject,true)
        local infoTable={}
        local idTable={}
        local oddsTable={}
        local indexTable={}
        local rankTable={}
        local num=1
        for k,v in pairs(gunDic) do
            local id=k
            local odds=v
            local index=num
            local rank=TableData.GetItemData(k).rank
            table.insert(idTable,id)
            table.insert(oddsTable,odds)
            table.insert(rankTable,rank)
            table.insert(indexTable,index)
            table.insert(infoTable,{rank,odds,id})
            num=num+1
        end
        rankTable=UIGachaShoppingDetailPanel:DeleteSameElementsAndDeOrder(rankTable)
        local detailItemList={}
        for  i=1,#rankTable do
            local item=GashaponOddsPublicityItemV2.New()
            item:InitCtrl(self.mView.mTrans_PublicityGrpChr)
            item.mTrans_ImgBg.color=TableData.GetGlobalGun_Quality_Color2(rankTable[i])
            local starNum= TableData.GlobalSystemData.QualityStar[rankTable[i]-1]
            for start=1,starNum do
                local starObj = instantiate(UIUtils.GetGizmosPrefab("Gashapon/ComStarV2.prefab", self))
                CS.LuaUIUtils.SetParent(starObj, item.mTrans_GrpChrStar.gameObject)
            end

            local  oddsList={}
            for   Dicj,Dick  in  pairs(gunDic) do
                if TableData.GetItemData(Dicj).rank==rankTable[i] then
                    table.insert(oddsList,Dick)
                end
            end

            oddsList=UIGachaShoppingDetailPanel:DeOrderList(oddsList)


            for begin=1,#oddsList  do
                local detailItem=GashaponOddsDeatailsItemV2.New()
                table.insert(detailItemList,detailItem)
                detailItem:InitCtrl(item.mTrans_Content)
                detailItem.mText_Percentage.text=(tonumber(string.format("%.4f",oddsList[begin]))*100).."%"
                setactive(detailItem.ImgIcon.gameObject,false)----概率提升隐藏



                setactive(detailItem.mTrans_ImgBg.gameObject,false)
                if begin%2==0 then
                    setactive( detailItem.mTrans_ImgBg.gameObject,true)
                end
            end
        end

        --给{rank,odds,id}  进行rank降序，odds降序，id降序
        table.sort(infoTable,function(a,b)
            if a[1]~=b[1] then
                return  a[1]>b[1]
            elseif a[2]~=b[2]  then
                return a[2]>b[2]
            else if a[3]~=b[3] then
                return a[3]>b[3]
            end

            end
        end)

        for k,v in pairs(infoTable) do
            detailItemList[k]:SetData(TableData.GetItemData(v[3]))
            for paraK,paraV in pairs(self.allGunIdList) do
                if infoTable[k][3]==self.allGunIdList[paraK] then
                    setactive(detailItemList[k].ImgIcon.gameObject,true)
                end

            end
        end
        self.allGunIdList={};

    end

end

function UIGachaShoppingDetailPanel:InitWeaponOddsPublicity()
    local weaponDic=UIGachaMainPanelV2.mCurGachaData.WeaponRateDict
    if   weaponDic.Count==0 then
        setactive(self.mView.mTrans_PublicityGrpWeapon.gameObject,false)
    else
        setactive(self.mView.mTrans_PublicityGrpWeapon.gameObject,true)
        local infoTable={}
        local idTable={}
        local oddsTable={}
        local indexTable={}
        local rankTable={}
        local num=1
        for k,v in pairs(weaponDic) do
            local id=k
            local odds=v
            local index=num
            local rank=TableData.GetItemData(k).rank
            table.insert(idTable,id)
            table.insert(oddsTable,odds)
            table.insert(rankTable,rank)
            table.insert(indexTable,index)
            table.insert(infoTable,{rank,odds,id})
            num=num+1
        end
        rankTable=UIGachaShoppingDetailPanel:DeleteSameElementsAndDeOrder(rankTable)
        local detailItemList={}
        for  i=1,#rankTable do
            local item=GashaponOddsPublicityItemV2.New()
            item:InitCtrl(self.mView.mTrans_PublicityGrpWeapon)
            item.mTrans_ImgBg.color=TableData.GetGlobalGun_Quality_Color2(rankTable[i])
            local starNum= TableData.GlobalSystemData.QualityStar[rankTable[i]-1]
            for start=1,starNum do
                local starObj = instantiate(UIUtils.GetGizmosPrefab("Gashapon/ComStarV2.prefab", self))
                CS.LuaUIUtils.SetParent(starObj, item.mTrans_GrpChrStar.gameObject)
            end

            local  oddsList={}
            for   Dicj,Dick  in  pairs(weaponDic) do
                if TableData.GetItemData(Dicj).rank==rankTable[i] then
                    table.insert(oddsList,Dick)
                end
            end

            oddsList=UIGachaShoppingDetailPanel:DeOrderList(oddsList)
            --printstack("oddsList length  is   "..#oddsList)

            for begin=1,#oddsList  do
                local detailItem=GashaponOddsDeatailsItemV2.New()
                table.insert(detailItemList,detailItem)
                detailItem:InitCtrl(item.mTrans_Content)
                setactive(detailItem.ImgIcon.gameObject,false)----概率提升隐藏
                -- print("value=============="..string.format("%.4f",oddsList[begin]))
                detailItem.mText_Percentage.text=(tonumber(string.format("%.4f",oddsList[begin]))*100).."%"
                if begin%2==0 then
                    setactive( detailItem.mTrans_ImgBg.gameObject,true)
                end
            end
        end

        --给{rank,odds,id}  进行rank降序，odds降序，id降序
        table.sort(infoTable,function(a,b)
            if a[1]~=b[1] then
                return  a[1]>b[1]
            elseif a[2]~=b[2]  then
                return a[2]>b[2]
            else if a[3]~=b[3] then
                return a[3]>b[3]
            end

            end
        end)

        for k,v in pairs(infoTable) do
            --print(k,"rank"..v[1],"odds"..v[2],"id"..v[3])
            detailItemList[k]:SetData(TableData.GetItemData(v[3]))
            for paraK,paraV in pairs(self.allWeaponIdList) do
                if infoTable[k][3]==self.allWeaponIdList[paraK] then
                    setactive(detailItemList[k].ImgIcon.gameObject,true)
                end

            end
        end
        self.allWeaponIdList={}

    end
end

function UIGachaShoppingDetailPanel:DeleteSameElementsAndDeOrder(tablelist)
    local exist = {}
    --把相同的元素进行覆盖掉
    for v, value in pairs(tablelist) do
        exist[value] = true  --value进行保存 当成一个key
    end
    --重新排序表
    local newTable = {}
    for v, k in pairs(exist) do
        table.insert(newTable, v)--这里的v就相当于上面的value
    end
    table.sort(newTable,function(a,b) return a>b  end)
    return newTable --返回已经去重的表

end

function UIGachaShoppingDetailPanel:DeOrderList(tablelist)
    table.sort(tablelist,function(a,b) return a>b end)
    return tablelist
end

function UIGachaShoppingDetailPanel.OnRelease()
    self=UIGachaShoppingDetailPanel
    UIGachaShoppingDetailPanel.mView=nil
    UIGachaShoppingDetailPanel.allGunIdList={}
    UIGachaShoppingDetailPanel.allWeaponIdList={}
    UIGachaShoppingDetailPanel.curTabId=nil
    UIGachaShoppingDetailPanel.tabList={}
    UIGachaShoppingDetailPanel.hasOpened=false;
    self:UnRegistrationKeyboard(nil)
end
require("UI.UIBaseCtrl")
require("UI.QuicklyBuyPanelItem.UIQuicklyBuyPanelItemView")
require("UI.QuicklyBuyPanelItem.UIQuickCorePanelItemView")

UIHowToGetInfoItem = class("UIHowToGetInfoItem", UIBaseCtrl);
UIHowToGetInfoItem.__index = UIHowToGetInfoItem
--@@ GF Auto Gen Block Begin
UIHowToGetInfoItem.mText_HowToGetInfoText = nil;

function UIHowToGetInfoItem:__InitCtrl()
    self.mText_HowToGetInfoText = self:GetText("Text_HowToGetInfoText");
    self.mTrans_Lock = self:GetRectTransform("Trans_UIHowToGetInfoItemLock")

    UIUtils.GetButtonListener(self.mUIRoot.gameObject).onClick = function(gameObj)
        self:onClickJump()
    end
end

--@@ GF Auto Gen Block End

UIHowToGetInfoItem.mData = nil
UIHowToGetInfoItem.howToGetData = nil
UIHowToGetInfoItem.goodId = 0
UIHowToGetInfoItem.root = nil

function UIHowToGetInfoItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UIHowToGetInfoItem.prefab",self));
    setparent(parent, obj.transform)
    obj.transform.localScale = vectorone
    obj.transform.localPosition =vectorone

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIHowToGetInfoItem:SetData(data)
    if data then
        self.mData = data
        self.howToGetData = data.howToGetData
        self.goodId = data.itemData.goodsid
        self.root = data.root
        self.mText_HowToGetInfoText.text = self.howToGetData.title.str

        setactive(self.mTrans_Lock, not self:CheckIsUnLock())
    end
end

function UIHowToGetInfoItem:CheckIsUnLock()
    local jumpData = string.split(self.howToGetData.jump_code, ":")
    if tonumber(jumpData[1]) == 1 then
        --- 判断章节是否解锁
        return NetCmdDungeonData:IsUnLockChapter(jumpData[2])
    elseif tonumber(jumpData[1]) == 14 then
        --- 判断关卡是否解锁
        local chapterId = TableData.listStoryDatas:GetDataById(jumpData[2]).chapter
        if NetCmdDungeonData:IsUnLockChapter(chapterId) then
            return NetCmdDungeonData:IsUnLockStory(jumpData[2])
        end
        return false
    --elseif tonumber(jumpData[1]) == 5 then
    --    local good = NetCmdStoreData:GetStoreGoodById(self.goodId)
    --    if not good then
    --        return false
    --    end
    end
    return true
end

function UIHowToGetInfoItem:onClickJump()
    -------------------人形核心购买处理逻辑---------------------
    -- if (self.mData.itemData.type == 12) then
    --     --- 人形升星以后要走统一逻辑，暂时通过人形是否解锁来判断走哪边逻辑，以后修改可以删掉
    --     local gunInfo = NetCmdTeamData:GetGunByID(self.mData.itemData.Args[0])
    --     if gunInfo then
    --         UIQuickCorePanelItemView.OpenConfirmPanel(self.mData, self.root.transform, 1, self.mData.itemData.id)
    --         return
    --     end
    -- end
    ----------------------------------------------------------

    if not self.howToGetData or not self.howToGetData.can_jump or self.howToGetData.jump_code == nil then
        return
    end
    local jump = string.split(self.howToGetData.jump_code, ":")

    if tonumber(jump[1]) == 5 and self.howToGetData.quickly_buy == 1 then
        --- 是否可以快速购买
        local good = NetCmdStoreData:GetStoreGoodById(self.goodId)
        if good then
            UIQuicklyBuyPanelItemView.OpenConfirmPanel(good, self.root.transform, 1, self.mData.itemData.id, function()
                MessageSys:SendMessage(5002, nil)
            end, function()
                SceneSwitch:SwitchByID(tonumber(jump[1]), { tonumber(jump[2]) })
                UITipsPanel.Close()
            end)
            return
        end

    end
    SceneSwitch:SwitchByID(tonumber(jump[1]), { tonumber(jump[2]) })

    UITipsPanel.Close()
end

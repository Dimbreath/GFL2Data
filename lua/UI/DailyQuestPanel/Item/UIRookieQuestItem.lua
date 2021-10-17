require("UI.UIBaseCtrl")

UIRookieQuestItem = class("UIRookieQuestItem", UIBaseCtrl);
UIRookieQuestItem.__index = UIRookieQuestItem
--@@ GF Auto Gen Block Begin


function UIRookieQuestItem:__InitCtrl()
    self.mText_Num = self:GetText("GrpTopTarget/Text_Num");
    self.mText_Name = self:GetText("GrpCenterText/Text/Text_Content");
    self.mText_Progress = self:GetText("GrpProgress/Text_Progress");
    self.mTrans_Item1 = self:GetRectTransform("GrpItem/GrpItem1");
    self.mTrans_Item2 = self:GetRectTransform("GrpItem/GrpItem2");
    self.mTrans_Receive = self:GetRectTransform("GrpState/Trans_GrpReceive")
    self.mTrans_Complete = self:GetRectTransform("GrpCompleted")
    self.mBtn_Receive = self:GetButton("GrpState/Trans_GrpReceive/QuestAccessItemV2")
    self.mBtn_Self = self:GetSelfButton();
    self.mImg_progress = self:GetImage("GrpProgress/GrpProgressBar/Img_ProgressBar");

    

    local obj1 = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab",self))
	local obj2 = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab",self))

	CS.LuaUIUtils.SetParent(obj1.gameObject, self.mTrans_Item1.gameObject, true)
	CS.LuaUIUtils.SetParent(obj2.gameObject, self.mTrans_Item2.gameObject, true)

    self.mBtn_Item1 = obj1:GetComponent("GFButton")
    self.mBtn_Item2 = obj2:GetComponent("GFButton")
    --self.mBtn_Item = self:GetSelfButton();

    self.mImg_ItemIcon1 = UIUtils.GetImage(obj1.transform,"GrpItem/Img_Item")
    self.mImg_ItemIcon2 = UIUtils.GetImage(obj2.transform,"GrpItem/Img_Item")
    self.mImg_ItemRank1 = UIUtils.GetImage(obj1.transform,"GrpBg/Img_Bg")
    self.mImg_ItemRank2 = UIUtils.GetImage(obj2.transform,"GrpBg/Img_Bg")
    self.mText_ItemNum1 = UIUtils.GetText(obj1.transform,"Trans_GrpNum/ImgBg/Text_Num")
    self.mText_ItemNum2 = UIUtils.GetText(obj2.transform,"Trans_GrpNum/ImgBg/Text_Num")

    self.mAnimator = self.mUIRoot.gameObject:GetComponent("Animator")
end

--@@ GF Auto Gen Block End

function UIRookieQuestItem:InitCtrl(root)


    local obj=instantiate(UIUtils.GetGizmosPrefab("DailyQuest/RookieQuestItemV2.prefab",self));

    self:SetRoot(obj.transform);
    obj.transform:SetParent(root,false);
    obj.transform.localScale=vectorone;

	self:__InitCtrl();

end


function UIRookieQuestItem:SetData(data,index)
    if(data == nil) then
        setactive(self.mUIRoot,false);
    else
        setactive(self.mUIRoot,true);
        self.mText_Name.text = data.description;
        self.mText_Num.text = index;
        self.mText_Progress.text = data:GetProgressStr();
        self.mImg_progress.fillAmount = data:GetProgress();

        setactive(self.mTrans_Receive,data.isComplete and not data.isReceived)
        self.mBtn_Self.interactable = not data.isReceived

        if(data.isUnlocked) then
            self.mAnimator:SetBool("Unlocked",true);
        end

        local itemTable = {
            {self.mTrans_Item1,self.mImg_ItemIcon1,self.mText_ItemNum1,self.mImg_ItemRank1,self.mBtn_Item1},
            {self.mTrans_Item2,self.mImg_ItemIcon2,self.mText_ItemNum2,self.mImg_ItemRank2,self.mBtn_Item2}
        }
        local i = 1;

        setactive(self.mTrans_Item1,false);
        setactive(self.mTrans_Item2,false);

        for k, v in pairs(data.rewardList) do
            local item = itemTable[i]
            setactive(item[1],true)
            
            local stcData = TableData.GetItemData(k)
            if stcData == nil then
                gferror("itemID : " .. k .. "的配置为空请检查")
                return
            end

            item[4].sprite =  IconUtils.GetQuiltyByRank(stcData.rank)
            item[2].sprite =  IconUtils.GetItemIconSprite(k)
            item[3].text = v
            i = i + 1;

            TipsManager.Add(item[5].gameObject, stcData)
        end
    end
end
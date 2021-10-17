require("UI.UIBaseCtrl")

UIComAccessItem = class("UIComAccessItem", UIBaseCtrl);
UIComAccessItem.__index = UIComAccessItem
--@@ GF Auto Gen Block Begin


function UIComAccessItem:__InitCtrl()

	-- self.mImage_GetChapterReward1_Rank = self:GetImage("Image_Rank");
	-- self.mImage_GetChapterReward1_Picture = self:GetImage("Image_Picture");
	-- self.mText_GetChapterReward1_Count = self:GetText("Text_Count");

    self.mText_Name = self:GetText("GrpAction/ComBtn4AccessItemV2/Root/GrpText/TextName");
    self.mBtn_Goto = self:GetButton("GrpAction/ComBtn4AccessItemV2");
    self.mText_AccessName = self:GetText("GrpTextName/Text_AccessName");
	
	local mTrans_ItemParent=self:GetRectTransform("GrpAction")
	local itemscript=getcomponent(mTrans_ItemParent,typeof(CS.ScrollListChild))
	local itemobj=instantiate(itemscript.childItem,mTrans_ItemParent)
	self.mBtn_Goto=getcomponent(itemobj,typeof(CS.UnityEngine.UI.Button))

    UIUtils.GetButtonListener(self.mBtn_Goto.gameObject).onClick = function(gameObj)
		self:onClickJump()
	end
end

--@@ GF Auto Gen Block End

function UIComAccessItem:InitCtrl(root)


    local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComAccessListItemV2.prefab",self));

    self:SetRoot(obj.transform);
    --setparent(root,obj.transform);
    obj.transform:SetParent(root,false);
    obj.transform.localScale=vectorone;

	self:__InitCtrl();

end


function UIComAccessItem:SetData(data)

    self.mData = data
	self.howToGetData = data.howToGetData
	self.goodId = data.itemData.goodsid
	self.root = data.root.mParent
	self.callback = data.root.callback
	self.parent = data.root	

    --self.mText_Name.text = data.getList.title.str 
    self.mText_AccessName.text = data.title
	
    self.mBtn_Goto.interactable = self:CheckIsUnLock()
	if not self.howToGetData or not self.howToGetData.can_jump or self.howToGetData.jump_code == nil then
		setactive(self.mBtn_Goto,false)
	end
	
end

function UIComAccessItem:CheckIsUnLock()
	local jumpData = string.split(self.howToGetData.jump_code, ":")
	if tonumber(jumpData[1]) == 1 then
		--- 判断章节是否解锁
		return NetCmdDungeonData:IsUnLockChapter(jumpData[2])
	elseif tonumber(jumpData[1]) == 14 or tonumber(jumpData[1])==29 or tonumber(jumpData[1])==28  then
		--- 判断关卡是否解锁
        local numb=tonumber(jumpData[1])
		if numb==14 or numb==28 then
			local storyData = TableData.listStoryDatas:GetDataById(tonumber(jumpData[2]));
			if(storyData == nil) then
				return false
			end
			local chapterId = storyData.chapter
			if NetCmdDungeonData:IsUnLockChapter(chapterId) then
				return NetCmdDungeonData:IsUnLockStory(jumpData[2])
			end
			return false
		else
			local SimCombatData = TableData.listSimCombatDatas:GetDataById(tonumber(jumpData[2]));
			local jumpunlockid=TableData.listJumpListDatas:GetDataById(numb).UnlockId
			if(SimCombatData == nil) then
				return false
			end
			return NetCmdDungeonData:IsUnLockSimCombat(SimCombatData,jumpunlockid)
		end
	end
	return true
end

function UIComAccessItem:onClickJump()
	-------------------人形核心购买处理逻辑---------------------
	-- if(self.mData.itemData.type == 12) then
	-- 	UIQuickCorePanelItemView.OpenConfirmPanel(self.mData, self.root.transform, 1, self.mData.itemData.id)
	-- 	return
	-- end
	----------------------------------------------------------

	if not self.howToGetData or not self.howToGetData.can_jump or self.howToGetData.jump_code == nil then
		return
	end
	local jump = string.split(self.howToGetData.jump_code, ":")

	if (tonumber(jump[1]) == 5 or tonumber(jump[1]) == 19) and self.howToGetData.quickly_buy == 1 then
		--- 是否可以快速购买
		local good = NetCmdStoreData:GetStoreGoodById(self.goodId)
		if good then
			UIQuicklyBuyPanelItemView.OpenConfirmPanel(good, self.root.transform, 1, self.mData.itemData.id, function()
				MessageSys:SendMessage(5002, nil)
				if self.callback then
					self.callback()
				end

				if self.parent then
					self.parent:UpdatePanel()
				end
			end, function()
				SceneSwitch:SwitchByID(tonumber(jump[1]), { tonumber(jump[2]) })
				UITipsPanel.Close()
			end)
			return
		end

	end
	MessageSys:SendMessage(CS.GF2.Message.UIEvent.MergeEquipJump,nil);
	--通知UAVBreakDialogContent脚本所对应的Content预制体销毁
	MessageSys:SendMessage(5111,nil)
	--通知UAVPartsSkillUpDialogContent脚本所对应的Content预制体销毁
	MessageSys:SendMessage(5112,nil)
	SceneSwitch:SwitchByID(tonumber(jump[1]), { tonumber(jump[2]) })

    UITipsPanel.Close()
end


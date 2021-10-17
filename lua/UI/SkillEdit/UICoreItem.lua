require("UI.UIBaseCtrl")

UICoreItem = class("UICoreItem", UIBaseCtrl);
UICoreItem.__index = UICoreItem

--UI控件
UICoreItem.mText_UI_CoreItemName = nil;
UICoreItem.mText_UI_CoreItemlv = nil;
UICoreItem.mImage_UI_CoreItemImage = nil;
UICoreItem.mImage_UI_CoreItemSkillName = nil;
UICoreItem.mImage_UI_CoreItem_Icon = nil;
UICoreItem.mImage_UI_CoreItem_Icon_Bg = nil;
UICoreItem.mImage_UI_CoreItemSkillImage = nil;
UICoreItem.mImage_UI_CoreItemDragImage = nil;
UICoreItem.mImage_UI_CoreItemSelected = nil;
UICoreItem.mImage_UI_CoreItemEquiped = nil;
UICoreItem.mButton_UI_CoreItemDragImage = nil;
UICoreItem.mImage_UI_CoreItemDisableMask = nil;

--逻辑参数
UICoreItem.mParentRect = nil;
UICoreItem.mDragBeginPos = nil;
UICoreItem.mCoreItemDragAreaTrans = nil;
UICoreItem.mOriginalScale = nil;
UICoreItem.mIsDrag = false;
UICoreItem.mIsCoreSelected = false;

--回调函数
UICoreItem.mFunc_DragBeginCallback = nil;
UICoreItem.mFunc_DragEndCallback = nil;
UICoreItem.mFunc_RotateCallback = nil;

--核心数据
UICoreItem.mCoreId = 0;
UICoreItem.mIsEquipped = false;
UICoreItem.mCoreDir = 0;
UICoreItem.mStartIndex = -1;

UICoreItem.mStcData = nil;
UICoreItem.mData = nil;

function UICoreItem:InitCtrl(root)
	self:SetRoot(root);

	self.mText_UI_CoreItemName = self:GetText("SkillName/Text");
	self.mText_UI_CoreItemlv = self:GetText("SkillLV/lv");
	self.mImage_UI_CoreItemImage = self:GetImage("Image");
	self.mImage_UI_CoreItemSkillName = self:GetImage("UI_CoreItemSkillName");
	self.mImage_UI_CoreItem_Icon = self:GetImage("SkillIcon/Icon");
	self.mImage_UI_CoreItem_Icon_Bg = self:GetImage("SkillIcon");
	self.mImage_UI_CoreItemSkillImage = self:GetImage("SkillImage");
	self.mImage_UI_CoreItemDragImage = self:GetImage("DragImage");
	self.mImage_UI_CoreItemSelected = self:GetImage("Selected");
	self.mImage_UI_CoreItemEquiped = self:GetImage("Equiped");
	self.mImage_UI_CoreItemDisableMask = self:GetImage("DisableMask");;
	self.mButton_UI_CoreItemDragImage = self:GetButton("DragImage");
	
	setactive(self.mImage_UI_CoreItemDragImage.gameObject,true);
	setactive(self.mImage_UI_CoreItemSelected.gameObject,false);
	
	self.mParentRect = self.mImage_UI_CoreItemDragImage.gameObject.transform.parent;
	self.mDragBeginPos = self.mImage_UI_CoreItemDragImage.transform.anchoredPosition;	
	self.mCoreItemDragAreaTrans = CS.UnityEngine.GameObject.Find("CoreItemDragArea").transform;
	self.mOriginalScale = self.mImage_UI_CoreItemDragImage.transform.localScale;
		
	--Unity拖曳事件回调
	CS.EventTriggerListener.GetDrag(self.mImage_UI_CoreItemDragImage.gameObject,self).onBeginDrag = self.OnBeginDrag;
	CS.EventTriggerListener.GetDrag(self.mImage_UI_CoreItemDragImage.gameObject,self).onEndDrag = self.OnEndDrag;
	CS.EventTriggerListener.GetDrag(self.mImage_UI_CoreItemDragImage.gameObject,self).onDrag = self.OnDrag;
	
	UIUtils.GetListener(self.mButton_UI_CoreItemDragImage.gameObject).onClick = self.OnSelectDragCore;
	UIUtils.GetListener(self.mButton_UI_CoreItemDragImage.gameObject).param = self;
	
end

function UICoreItem:SetDragCallBack(beginCallback,endCallback,rotateCallback)
	self.mFunc_DragBeginCallback = beginCallback;
	self.mFunc_DragEndCallback = endCallback;
	self.mFunc_RotateCallback = rotateCallback;
end

function UICoreItem:SetupDragImage (isDrag)
	if isDrag then
		setparent(self.mCoreItemDragAreaTrans,self.mImage_UI_CoreItemDragImage.transform)
		setscale(self.mImage_UI_CoreItemDragImage.transform,CS.UnityEngine.Vector3(1,1,1));
	else
		setparent(self.mImage_UI_CoreItemSelected.transform.parent,self.mImage_UI_CoreItemDragImage.transform)
		setscale(self.mImage_UI_CoreItemDragImage.transform,self.mOriginalScale);
	end
end

function UICoreItem:SetData(data,stcData)
	self.mCoreId = data.id;
	self.mStcData = stcData;
	self.mData = data;
	self.mStartIndex = CS.UICoreDragUtility.GetStartIndexByPosString(data.position);
	self.mCoreDir = data.rotate;
	
	self:SetShapeImage();
	self:SetSkillIcon();
	self:SetCoreData();
end

function UICoreItem:InitEquippedCore(coreSpaceInfo, coreSpaceTrans,start,dir)
	local checkData = CS.DragCheckData();
	checkData.mStcCoreId = self.mStcData.id;
	checkData.mCoreId = self.mCoreId;
	checkData.mDictSpaceInfo = coreSpaceInfo;
	checkData.mListSpaceRect = coreSpaceTrans;
	checkData.mCoreDir = dir;
	
	self:SetupDragImage(true);
	local v = CS.UICoreDragUtility.EquipCoreToSpace(self.mCoreItemDragAreaTrans,checkData,start);
	if v ~= nil then
		self.mImage_UI_CoreItemDragImage.transform.anchoredPosition = v.mDockCenter;
		self.mStartIndex = v.mStartIndex;
		
		local angle = -1 * 90 * dir;
		setangles(self.mImage_UI_CoreItemDragImage.transform,CS.UnityEngine.Vector3(0,0,angle));
		setangles(self.mImage_UI_CoreItemSkillImage.transform,CS.UnityEngine.Vector3(0,0,angle));
	
		self:SetEquippedBySelf(true);
	end
	return v;
end


function UICoreItem:SetShapeImage ()
	local name = TableData.GetSkillCoreIconNameById(self.mStcData.id);
	self.mImage_UI_CoreItemSkillImage.sprite = UIUtils.GetIconSprite("Icon/SkillCore",name);
	self.mImage_UI_CoreItemDragImage.sprite = UIUtils.GetIconSprite("Icon/SkillCore",name);
	
	local width = self.mImage_UI_CoreItemSkillImage.sprite.bounds.size.x * 100;
	local height = self.mImage_UI_CoreItemSkillImage.sprite.bounds.size.y * 100;
	self.mImage_UI_CoreItemSkillImage.transform.sizeDelta = CS.UnityEngine.Vector2(width,height);
	self.mImage_UI_CoreItemDragImage.transform.sizeDelta = CS.UnityEngine.Vector2(width,height);
end

function UICoreItem:SetSkillIcon ()
	local name = TableData.GetSkillIconByCoreId(self.mStcData.id);
	self.mImage_UI_CoreItem_Icon.sprite = UIUtils.GetIconSprite("Icon/Skill",name);
	
	if(self.mStcData.type == 0) then
		self.mImage_UI_CoreItem_Icon_Bg.color = TableData.GetPositiveSkillIconColor();
	else
		self.mImage_UI_CoreItem_Icon_Bg.color = TableData.GetActiveSkillIconColor();
	end
end

function UICoreItem:SetCoreData ()
	--self.mText_UI_CoreItemName.text = self.mStcData.name;
	self.mText_UI_CoreItemName.text = TableData.GetSkillCoreSkillNameById(self.mStcData.skill_group_id);
	self.mText_UI_CoreItemlv.text = self.mData.level;
end

function UICoreItem.OnBeginDrag(self,go, data)
	self.mFunc_DragBeginCallback(self.mCoreId);
	self:SetupDragImage(true);
	self:SetSelected(true);
end

function UICoreItem.OnEndDrag(self,go, data)
	local v = self.mFunc_DragEndCallback(self.mCoreItemDragAreaTrans,data,self.mStcData,self.mCoreId,self.mCoreDir);
	if v == nil then
		self:SetupDragImage(false);
		self.mImage_UI_CoreItemDragImage.transform.anchoredPosition = self.mDragBeginPos;
		self:StopBlink();
		self.mStartIndex = -1;
		return;
	end
	
	self.mStartIndex = v.mStartIndex;
	local t = self.mImage_UI_CoreItemDragImage.transform;
	if v.mReturnCode == 1 then		
		t.anchoredPosition = v.mDockCenter;
		self:StopBlink();
		self:SetEquippedBySelf(true);
	elseif v.mReturnCode == 2 then
		t.anchoredPosition = v.mDockCenter;
		self:OverlayBlink();
		self:SetEquippedBySelf(false);
	else
		-- self:SetupDragImage(false);
		-- self.mImage_UI_CoreItemDragImage.transform.anchoredPosition = self.mDragBeginPos;
		-- self:StopBlink();
		-- self.mStartIndex = -1;
		-- self:SetEquippedBySelf(false);
		self:ReturnToList();
	end	
	self.mIsDrag = false;
end

function UICoreItem.OnDrag(self,go,data)
	self.mIsDrag = true;
	local pos = CS.UICoreDragUtility.CalDragLocalPos(self.mCoreItemDragAreaTrans, data);
	self.mImage_UI_CoreItemDragImage.transform.anchoredPosition = pos;	
end

function UICoreItem:OverlayBlink()
	local image = self.mImage_UI_CoreItemDragImage;
	local c0 = CS.UnityEngine.Color(1,0,0,0.25);
	local c1 = CS.UnityEngine.Color(1,0,0,0.5);
	local duration = 0.5;
	CS.UITweenManager.PlayColorPingPangTween(image.transform,c0,c1,duration);
end

function UICoreItem:StopBlink()
	local image = self.mImage_UI_CoreItemDragImage;
	CS.UITweenManager.KillTween(image.transform);
	image.color = CS.UnityEngine.Color(1,1,1,1);
end

function UICoreItem:ReturnToList()
	self:SetupDragImage(false);
	self.mImage_UI_CoreItemDragImage.transform.anchoredPosition = self.mDragBeginPos;
	self:StopBlink();
	self.mStartIndex = -1;
	self:SetEquippedBySelf(false);
	self:SetSelected(false);
end

function UICoreItem.OnSelectDragCore(gameobj)
	local eventClick = UIUtils.GetListener(gameobj);
    local tempSelf = eventClick.param;
	
	tempSelf:SendClickMessage();

end

function UICoreItem:SendClickMessage()
	CS.GF2.Message.MessageSys.Instance:SendMessage(11005,self);
end


function UICoreItem:RotateCore()
	if self.mStartIndex == -1 then
		gfdebug("没有装备，不能旋转");
		return;
	end

	self.mCoreDir = self.mCoreDir + 1;
	if self.mCoreDir > 3 then
		self.mCoreDir = 0;
	end
	local angle = -1 * 90 * self.mCoreDir;

	setangles(self.mImage_UI_CoreItemDragImage.transform,CS.UnityEngine.Vector3(0,0,angle));	
	setangles(self.mImage_UI_CoreItemSkillImage.transform,CS.UnityEngine.Vector3(0,0,angle));
	
	local v = self.mFunc_RotateCallback(self.mCoreItemDragAreaTrans,data,self.mStcData,self.mCoreId,self.mCoreDir,self.mStartIndex);
	local t = self.mImage_UI_CoreItemDragImage.transform;
	t.anchoredPosition = v.mDockCenter;
	self.mStartIndex = v.mStartIndex;
	
	if v.mReturnCode == 1 then		
		t.anchoredPosition = v.mDockCenter;
		self:StopBlink();
		self:SetEquippedBySelf(true);
	elseif v.mReturnCode == 2 then
		t.anchoredPosition = v.mDockCenter;
		self:OverlayBlink();
		self:SetEquippedBySelf(false);
	else
		self:StopBlink();
		self:SetEquippedBySelf(false);
	end

end

function UICoreItem:SetSelected(isSelected)
	self.mIsCoreSelected = isSelected;
	if(isSelected == true) then
		setactive(self.mImage_UI_CoreItemSelected.gameObject,true);
		CS.GF2.Message.MessageSys.Instance:SendMessage(11002,self);
	else
		setactive(self.mImage_UI_CoreItemSelected.gameObject,false);
	end
end

function UICoreItem:GetVerticalPos()
	return self.mUIRoot.transform.localPosition.y;
end


function UICoreItem:SetEquippedBySelf (isEquipped)
	setactive(self.mImage_UI_CoreItemEquiped.gameObject,isEquipped);
end

function UICoreItem:SetEquippedByOther()
	setactive(self.mImage_UI_CoreItemDisableMask.gameObject,true);
end








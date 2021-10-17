 require("UI.UIBaseView")

UICharacterEquipPanelView = class("UICharacterEquipPanelView", UIBaseView)
UICharacterEquipPanelView.__index = UICharacterEquipPanelView

function UICharacterEquipPanelView:ctor()
    self.slotList = {}
    self.tabList = {}
    self.posBtnList = {}
end

function UICharacterEquipPanelView:__InitCtrl()
    self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
    self.mBtn_CommandCenter = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
    self.mBtn_Reset = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpRight/BtnUnistall"))
    self.mBtn_DropSet = self:GetButton("Root/GrpLeft/GrpTop/Trans_GrpSuit/BtnDropdown")
    self.mBtn_CloseDrop = self:GetButton("Root/GrpLeft/Trans_GrpSuitList/Btn_Close")

    self.mTrans_SortContent = self:GetRectTransform("Root/GrpLeft/GrpScreen")
    self.mTrans_Sort = self:GetRectTransform("Root/GrpLeft/GrpScreen/BtnScreen")
    self.mTrans_SortList = self:GetRectTransform("Root/GrpLeft/GrpScreen/Trans_GrpScreenList")

    self.mTrans_ButtonGroup = self:GetRectTransform("Root/GrpLeft/GrpTop/Trans_GrpScreen")
    self.mText_DropSetName = self:GetText("Root/GrpLeft/GrpTop/Trans_GrpSuit/BtnDropdown/Text_SuitName")
    self.mTrans_DropSetBtn = self:GetRectTransform("Root/GrpLeft/GrpTop/Trans_GrpSuit")
    self.mTrans_ChangeSet = self:GetRectTransform("Root/GrpLeft/Trans_GrpSuit")
    self.mTrans_ChangePos = self:GetRectTransform("Root/GrpLeft/Trans_GrpPosition")
    self.mTrans_DropSet = self:GetRectTransform("Root/GrpLeft/Trans_GrpSuitList")
    self.mTrans_DropSetList = self:GetRectTransform("Root/GrpLeft/Trans_GrpSuitList/Viewport/Content")
    self.mTrans_ChangeSetList = self:GetRectTransform("Root/GrpLeft/Trans_GrpSuit/GrpEquipSuitList/Viewport/Content")
    self.mTrans_ShowInfo = self:GetRectTransform("Root/GrpRight/GrpInfoDescription/GrpBottom/Trans_GrpAttribute")
    self.mTrans_ShowSet = self:GetRectTransform("Root/GrpRight/GrpInfoDescription/GrpBottom/Trans_GrpSuitSkill")
    self.mTrans_EquipListEmpty = self:GetRectTransform("Root/GrpLeft/Trans_GrpPosition/GrpEquipList/Viewport/Trans_GrpEmpty")

    self.mTrans_ChangeAttrList = self:GetRectTransform("Root/GrpRight/GrpInfoDescription/GrpBottom/Trans_GrpAttribute/AttributeList/Viewport/Content")
    self.mTrans_ChangeAttrEmpty = self:GetRectTransform("Root/GrpRight/GrpInfoDescription/GrpBottom/Trans_GrpAttribute/AttributeList/Viewport/Content/Trans_GrpEmpty")
    self.mTrans_ChangeShowSetList = self:GetRectTransform("Root/GrpRight/GrpInfoDescription/GrpBottom/Trans_GrpSuitSkill/SuitSkillList/Viewport/Content/GrpSkill")
    self.mTrans_ChangeSetEmpty = self:GetRectTransform("Root/GrpRight/GrpInfoDescription/GrpBottom/Trans_GrpSuitSkill/SuitSkillList/Viewport/Content/Trans_GrpEmpty")

    self.mTrans_EquipList = self:GetRectTransform("Root/GrpLeft/Trans_GrpPosition/GrpEquipList")

    self.mTrans_LeftDetail = self:GetRectTransform("Root/GrpLeft/Trans_GrpEquipDetailsLeft")
    self.mTrans_RightDetail = self:GetRectTransform("Root/GrpLeft/Trans_GrpEquipDetailsRight")

    self.mVirtualList = UIUtils.GetVirtualListEx(self.mTrans_EquipList)
    self.mScroll_SetList = self:GetScrollRect("Root/GrpLeft/Trans_GrpSuit/GrpEquipSuitList")

    for i = 1, GlobalConfig.MaxEquipCount do
        local parent = self:GetRectTransform("Root/GrpRight/GrpEquip/Content")
        table.insert(self.slotList, self:InitEquipSlot(parent, i))
    end

    for i = 1, GlobalConfig.MaxEquipCount do
        local parent = self:GetRectTransform("Root/GrpLeft/Trans_GrpPosition/GrpEquipNum/GrpEquipNumList")
        table.insert(self.posBtnList, self:InitPosBtn(parent, i))
    end

    local obj = self:GetRectTransform("Root/GrpLeft/GrpTop/Trans_GrpScreen")
    table.insert(self.tabList, self:InitTabButton(obj, UIEquipGlobal.FiltrateType.Suit, 102001))
    table.insert(self.tabList, self:InitTabButton(obj, UIEquipGlobal.FiltrateType.Position, 102002))

    obj = self:GetRectTransform("Root/GrpRight/GrpInfoDescription/GrpTopTab")
    self.mBtn_ChangeLeft = self:InitTabButton(obj, 0, 102003).btnTab
    self.mBtn_ChangeRight = self:InitTabButton(obj, 0, 102004).btnTab
end

function UICharacterEquipPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end

function UICharacterEquipPanelView:InitEquipSlot(parent, index)
    if parent then
        local obj = self:InstanceUIPrefab("Character/ChrEquipItemV2.prefab", parent)
        local slot = {}
        slot.obj = obj
        slot.data = nil
        slot.index = index
        slot.animator = UIUtils.GetRectTransform(obj):GetComponent("Animator")
        slot.btnEquip = UIUtils.GetButton(obj)
        slot.transSelect = UIUtils.GetRectTransform(obj, "GrpSel")
        slot.imgBg = UIUtils.GetImage(obj, "GrpEquipInfo/GrpQualityLine/Img_Bg")
        slot.imgLine = UIUtils.GetImage(obj, "GrpEquipInfo/GrpQualityLine/Img_Line")
        slot.textLv = UIUtils.GetText(obj, "GrpEquipInfo/GrpLevel/Text_Lv")
        slot.imageIcon = UIUtils.GetImage(obj, "GrpEquipInfo/GrpEquipmentIcon/Img_Item")
        slot.imgPos = UIUtils.GetImage(obj, "GrpEquipInfo/GrpPosition/GrpPositionIcon/Img_Icon")
        slot.txtPos = UIUtils.GetText(obj, "GrpBg/Text_Num")

        slot.imgPos.sprite = IconUtils.GetEquipNum(index)
        slot.txtPos.text = "0" .. index

        return slot
    end
end

 function UICharacterEquipPanelView:InitTabButton(parent, index, hintId)
     if parent then
         local obj = self:InstanceUIPrefab("UICommonFramework/ComTabBtn1ItemV2.prefab", parent, true)
         local tab = {}
         tab.obj = obj
         tab.index = index
         tab.txtName = UIUtils.GetText(obj, "Root/GrpText/Text_Name")
         tab.btnTab = UIUtils.GetButton(obj)

         tab.txtName.text = TableData.GetHintById(hintId)

         return tab
     end
 end

 function UICharacterEquipPanelView:InitPosBtn(parent, index)
     if parent then
         local obj = self:InstanceUIPrefab("Character/ChrEquipReplacePositionItemV3.prefab", parent, true)
         local pos = {}
         pos.obj = obj
         pos.index = index
         pos.btnPos = UIUtils.GetButton(obj)
         pos.imgIndex = UIUtils.GetImage(obj,"GrpPosition/GrpPositionIcon/Img_Icon")

         pos.imgIndex.sprite = IconUtils.GetEquipNum(index)

         return pos
     end
 end
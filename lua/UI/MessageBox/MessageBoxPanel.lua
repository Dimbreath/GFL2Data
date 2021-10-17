require("UI.UIBasePanel")
---@class MessageBoxPanel : UIBasePanel
MessageBoxPanel = class("MessageBoxPanel", UIBasePanel)
MessageBoxPanel.__index = MessageBoxPanel

--- static func
function MessageBoxPanel.Show(messageContent)
    UIManager.OpenUIByParam(UIDef.MessageBoxPanel, messageContent)
end

function MessageBoxPanel.ShowByParam(content, showType, okCb, cancelCb, title, okTxt, cancelTxt, zPos)
    local messageData = MessageContent.New(content, showType, okCb, cancelCb, title, okTxt, cancelTxt, zPos)
    MessageBoxPanel.Show(messageData)
end

function MessageBoxPanel.ShowDoubleType(content, okCb ,cancelCb, title, okTxt, cancelTxt)
    local messageData = MessageContent.New(content, nil, okCb, cancelCb, title, okTxt, cancelTxt, nil)
    MessageBoxPanel.Show(messageData)
end

function MessageBoxPanel.ShowGotoType(content, okCb ,cancelCb, title, gotoTxt, cancelTxt)
    local messageData = MessageContent.New(content, MessageContent.MessageType.GotoBtn, okCb, cancelCb, title, gotoTxt, cancelTxt, nil)
    MessageBoxPanel.Show(messageData)
end

function MessageBoxPanel.ShowSingleType(content, okCb, title, okTxt)
    local messageData = MessageContent.New(content, MessageContent.MessageType.SingleBtn, okCb, nil, title, okTxt, nil, nil)
    MessageBoxPanel.Show(messageData)
end

function MessageBoxPanel.ShowItemNotEnoughMessage(itemId, jumpFunc, zPos)
    local hint = TableData.GetHintById(200)
    local itemData = TableData.listItemDatas:GetDataById(itemId)
    if itemData then
        hint = string_format(hint, itemData.name.str)
        local messageData = MessageContent.New(hint, MessageContent.MessageType.GotoBtn, jumpFunc, function () MessageBoxPanel.IsItemNotEnough = false end, nil, nil, nil, zPos)
        MessageBoxPanel.Show(messageData)
        MessageBoxPanel.IsItemNotEnough = true;
    end
end
--- static func

MessageBoxPanel.IsQuickClose = false;

function MessageBoxPanel.Close()
    self = MessageBoxPanel
    self.animator:SetBool("ComDialog_FadeOut", true);

    if(MessageBoxPanel.IsQuickClose) then
        UIManager.CloseUI(UIDef.MessageBoxPanel)
        MessageBoxPanel.IsQuickClose = false;
    else
        TimerSys:DelayCall(0.3, function ()
            UIManager.CloseUI(UIDef.MessageBoxPanel)
        end)
    end
end

function MessageBoxPanel.OnRelease()
    self = MessageBoxPanel
    -- self.messageData = nil
end

function MessageBoxPanel.Init(root, data)
    self = MessageBoxPanel
    self.messageData = data
    self.mIsPop = true
    MessageBoxPanel.super.SetRoot(MessageBoxPanel, root)
    self:InitCtrl(root)
end

function MessageBoxPanel.OnInit()
    self = MessageBoxPanel

    MessageBoxPanel.super.SetPosZ(MessageBoxPanel)

    self:UpdatePanel()
end

function MessageBoxPanel:InitCtrl(root)
    self.mBtn_BgClose = UIUtils.GetRectTransform(root, "Root/GrpBg/Btn_Close")
    self.mBtn_Close = UIUtils.GetRectTransform(root, "Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mText_Title = UIUtils.GetText(root, "Root/GrpDialog/GrpTop/GrpText/TitleText")
    self.mText_Content = UIUtils.GetText(root, "Root/GrpDialog/GrpCenter/GrpText/Text_Content")
    self.mTrans_Cancel = UIUtils.GetRectTransform(root,"Root/GrpDialog/GrpAction/Trans_BtnCancel")
    self.mTrans_Ok = UIUtils.GetRectTransform(root,"Root/GrpDialog/GrpAction/BtnConfirm")
    self.mTrans_Goto = UIUtils.GetRectTransform(root,"Root/GrpDialog/GrpAction/Trans_BtnGoTo")

    self.mBtn_Cancel = UIUtils.GetTempBtn(self.mTrans_Cancel)
    self.mBtn_Ok = UIUtils.GetTempBtn(self.mTrans_Ok)
    self.mBtn_Goto = UIUtils.GetTempBtn(self.mTrans_Goto)

    UIUtils.GetButtonListener(self.mBtn_Ok.gameObject).onClick = function()
        if self.messageData.okCallback ~= nil then
            self.Close()
            self.messageData.okCallback()
        else
            self.Close()
        end
    end

    UIUtils.GetButtonListener(self.mBtn_Cancel.gameObject).onClick = function()
        if self.messageData.cancelCallback ~= nil then
            self.Close()
            self.messageData.cancelCallback()
        else
            self.Close()
        end
    end

    UIUtils.GetButtonListener(self.mBtn_Goto.gameObject).onClick = function()
        if self.messageData.okCallback ~= nil then
            self.Close()
            self.messageData.okCallback()
        else
            self.Close()
        end
    end

    self.animator = getchildcomponent(root,"Root", typeof(CS.UnityEngine.Animator))

    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = function()
        if self.messageData.closeCallback ~= nil then
            self.messageData.closeCallback()
        end
        self.Close()
    end
    UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick = function()
        if self.messageData.closeCallback ~= nil then
            self.messageData.closeCallback()
        end
        self.Close()
    end
end

function MessageBoxPanel:UpdatePanel()
    self.mText_Title.text = self.messageData.title
    self.mText_Content.text = self.messageData.content

    if self.messageData.showType == MessageContent.MessageType.DoubleBtn then
        setactive(self.mTrans_Cancel.gameObject, true)
        setactive(self.mTrans_Goto.gameObject, false)
        setactive(self.mTrans_Ok.gameObject, true)
    elseif self.messageData.showType == MessageContent.MessageType.GotoBtn then
        setactive(self.mTrans_Cancel.gameObject, true)
        setactive(self.mTrans_Goto.gameObject, true)
        setactive(self.mTrans_Ok.gameObject, false)
    elseif self.messageData.showType == MessageContent.MessageType.SingleBtn then
        setactive(self.mTrans_Cancel.gameObject, false)
        setactive(self.mTrans_Goto.gameObject, false)
        setactive(self.mTrans_Ok.gameObject, true)
    end
    --if self.messageData.zPos ~= 0 then
    --    local pos = self.mUIRoot.localPosition
    --    local z = math.min(-1500, self.messageData.zPos)
    --    pos.z = z
    --    self.mUIRoot.localPosition = pos
    --end
end


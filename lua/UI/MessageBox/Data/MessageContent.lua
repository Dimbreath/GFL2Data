MessageContent = class("MessageContent")
MessageContent.__index = MessageContent

MessageContent.MessageType =
{
    DoubleBtn = 1,
    SingleBtn = 2,
    GotoBtn = 3,
}

function MessageContent:ctor(content, showType, okCb, cancelCb, title, okTxt, cancelTxt, zPos)
    if self:StrIsNilOrEmpty(title) then
        title = TableData.GetHintById(64)
    end
    if self:StrIsNilOrEmpty(okTxt) then
        okTxt = TableData.GetHintById(18)
    end
    if self:StrIsNilOrEmpty(cancelTxt) then
        cancelTxt = TableData.GetHintById(19)
    end

    self.title          = title
    self.content        = content
    self.showType       = showType == nil and MessageContent.MessageType.DoubleBtn or showType
    self.okCallback     = okCb
    self.cancelCallback = cancelCb
    self.okTxt          = okTxt
    self.cancelTxt      = cancelTxt
    self.zPos           = zPos == nil and 0 or zPos

    if showType == MessageContent.MessageType.DoubleBtn then
        self.closeCallback = cancelCb
    elseif showType == MessageContent.MessageType.SingleBtn then
        self.closeCallback = okCb
    else
        self.closeCallback = nil
    end
end

function MessageContent:StrIsNilOrEmpty(str)
    return str == nil or str == ""
end

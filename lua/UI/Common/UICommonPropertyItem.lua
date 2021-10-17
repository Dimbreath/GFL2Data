require("UI.UIBaseCtrl")

UICommonPropertyItem = class("UICommonPropertyItem", UIBaseCtrl)
UICommonPropertyItem.__index = UICommonPropertyItem

function UICommonPropertyItem:ctor()
    self.mData = nil
    self.value = 0
    self.upValue = 0
    self.needPlus = false
end

function UICommonPropertyItem:__InitCtrl()
    self.mTrans_Bg = self:GetRectTransform("Trans_GrpBg")
    self.mTrans_Icon = self:GetRectTransform("GrpList/Trans_GrpIcon")
    self.mImage_Icon = self:GetImage("GrpList/Trans_GrpIcon/Img_Icon")
    self.mText_Name = self:GetText("GrpList/Text_Name")
    self.mText_Num = self:GetText("Text_Num")
    self.mTrans_Line = self:GetRectTransform("Trans_GrpLine")
    self.mTrans_ValueChange = self:GetRectTransform("Trans_GrpNumRight")
    self.mText_ValueNow = self:GetText("Trans_GrpNumRight/Text_NumNow")
    self.mText_ValueUp = self:GetText("Trans_GrpNumRight/Text_NumAfter")
end

function UICommonPropertyItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComAttributeUpListItemV2.prefab", self))
    self:SetRoot(obj.transform)

    if parent then
        obj.transform.parent = parent
        obj.transform.localPosition = vectorzero
        obj.transform.localScale = vectorone
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonPropertyItem:SetData(data, value, needLine, needIcon, needBg, needPlus)
    needPlus = (needPlus == nil) and true or needPlus
    needLine = (needLine == nil) and true or needLine
    needIcon = (needIcon == nil) and true or needIcon
    needBg = (needBg == nil) and true or needBg
    self.needPlus = needPlus
    if data then
        self.mData = data
        self.value = value
        self.mText_Name.text = data.show_name.str

        if self.mData.show_type == 2 then
            value = math.ceil(value / 10).."%"
        end

        if needPlus then
            self.mText_Num.text =  "+" .. value
            self.mText_ValueNow.text =  "+" .. value
        else
            self.mText_Num.text = value
            self.mText_ValueNow.text = value
        end

        if needIcon then
            self.mImage_Icon.sprite = IconUtils.GetAttributeIcon(self.mData.icon)
        end

        setactive(self.mTrans_Bg, needBg)
        setactive(self.mTrans_Icon, needIcon)
        setactive(self.mTrans_Line, needLine)
        setactive(self.mText_Num.gameObject,true)
        setactive(self.mUIRoot, true)
    else
        self.mData = nil
        setactive(self.mUIRoot, false)
    end
end

function UICommonPropertyItem:SetDataByName(name, value, needLine, needIcon, needBg, needPlus)
    needPlus = (needPlus == nil) and true or needPlus
    needLine = (needLine == nil) and true or needLine
    needIcon = (needIcon == nil) and true or needIcon
    needBg = (needBg == nil) and true or needBg
    if name then
        self.mData = TableData.GetPropertyDataByName(name, 1)
        self.value = value
        self.mText_Name.text = self.mData.show_name.str

        if self.mData.show_type == 2 then
            value = math.ceil(value / 10).."%"
        end
        if needPlus then
            self.mText_Num.text =  "+" .. value
            self.mText_ValueNow.text =  "+" .. value
        else
            self.mText_Num.text = value
            self.mText_ValueNow.text = value
        end

        if needIcon then
            self.mImage_Icon.sprite = IconUtils.GetAttributeIcon(self.mData.icon)
        end

        setactive(self.mTrans_Bg, needBg)
        setactive(self.mTrans_Icon, needIcon)
        setactive(self.mTrans_Line, needLine)
        setactive(self.mText_Num.gameObject, true)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UICommonPropertyItem:SetGunProp(data ,value, addValue, needBg)
    if data then
        self.mData = data
        self.value = value
        self.mText_Name.text = data.show_name.str

        local strValue = 0
        local strAddValue = 0

        if self.mData.show_type == 2 then
            value = math.ceil(value / 10)
            addValue = math.ceil(addValue / 10)
            strValue = value .. "%"
            strAddValue = addValue .. "%"
        else
            strValue = value
            strAddValue = addValue
        end

        if addValue > 0 then
            self.mText_Num.text = string_format(TableData.GetHintById(809), strValue, strAddValue)
        else
            self.mText_Num.text = strValue
        end

        self.mImage_Icon.sprite = IconUtils.GetAttributeIcon(self.mData.icon)

        setactive(self.mTrans_Bg, needBg)
        setactive(self.mTrans_Icon, true)
        setactive(self.mTrans_Line, false)
        setactive(self.mText_Num.gameObject,true)
        setactive(self.mUIRoot, true)
    else
        self.mData = nil
        setactive(self.mUIRoot, false)
    end
end

function UICommonPropertyItem:UpdateAttrValue(value)
    self.value = value
    if self.mData.show_type == 2 then
        value = math.ceil(value / 10).."%"
    end

    if self.needPlus then
        self.mText_Num.text =  "+" .. value
    else
        self.mText_Num.text = value
    end
end

function UICommonPropertyItem:SetValueUp(upValue)
    self.upValue = upValue
    if self.value ~= self.upValue then
        setactive(self.mTrans_ValueChange, upValue ~= 0)
        setactive(self.mText_Num.gameObject, upValue == 0)
        if upValue ~= 0 then
            local value = upValue
            if self.mData.show_type == 2 then
                value = math.ceil(upValue / 10).."%"
            end
            self.mText_ValueUp.text = value
        end
    end
end

function UICommonPropertyItem:SetEquipNewProp()
    setactive(self.mTrans_ValueChange, false)
    setactive(self.mText_Num.gameObject, true)
    local color = self.mText_ValueUp.color
    self.mText_Name.color = color
    self.mText_Num.color = color
end

function UICommonPropertyItem:SetTipsName(hintId, param)
    if hintId then
        local hint = TableData.GetHintById(hintId)
        if param then
            hint = string_format(hint, param)
        end
        self.mText_Name.text = hint
        setactive(self.mTrans_ValueChange, false)
        setactive(self.mText_Num.gameObject, false)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UICommonPropertyItem:SetTextColor(color)
    if color == nil then
        color = ColorUtils.BlackColor
    end
    self.mText_Name.color = color
    self.mText_Num.color = color
end

function UICommonPropertyItem:SetTextFont(font)
    local f = nil
    if font == nil then
        f = CS.CommonResUtils.GetCommonFont(CS.enumFont.eNOTOSANSHANS_MEDIUM)
    else
        f = CS.CommonResUtils.GetCommonFont(font)
    end
    self.mText_Name.font = f
end

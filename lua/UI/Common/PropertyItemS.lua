require("UI.UIBaseCtrl")

PropertyItemS = class("PropertyItemS", UIBaseCtrl)
PropertyItemS.__index = PropertyItemS

function PropertyItemS:ctor()
    self.value = 0
end

function PropertyItemS:__InitCtrl()
    self.mText_Name = self:GetText("GrpList/Text_Name")
    self.mText_Num = self:GetText("Text_Num")
    self.mTrans_BG = self:GetRectTransform("Trans_GrpBg")
end

function PropertyItemS:InitCtrl(parent)
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

function PropertyItemS:SetData(data, value, needBg, color, needPlus)
    needPlus = (needPlus == nil) and true or needPlus
    if data then
        self.mData = data
        self.value = value
        self.mText_Name.text = data.show_name.str

        if self.mData.show_type == 2 then
            value = math.ceil(value / 10).."%"
        end
        if needPlus then
            self.mText_Num.text =  "+" .. value
        else
            self.mText_Num.text = value
        end

        if color then
            self.mText_Name.color = color
            self.mText_Num.color = color
        end

        if needBg then
            setactive(self.mTrans_BG, needBg)
        else
            setactive(self.mTrans_BG, false)
        end

        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function PropertyItemS:SetDataByName(name, value, needBg, color, needPlus)
    needPlus = (needPlus == nil) and true or needPlus
    if name then
        self.mData = TableData.GetPropertyDataByName(name, 1)
        self.value = value
        self.mText_Name.text = self.mData.show_name.str

        if self.mData.show_type == 2 then
            value = math.ceil(value / 10).."%"
        end
        if needPlus then
            self.mText_Num.text =  "+" .. value
        else
            self.mText_Num.text = value
        end

        if color then
            self.mText_Num.color = color
        end

        if needBg then
            setactive(self.mTrans_BG, needBg)
        else
            setactive(self.mTrans_BG, false)
        end
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function PropertyItemS:SetNameColor(color)
    if color then
        self.mText_Name.color = color
    end
end

function PropertyItemS:SetTextSize(size)
    if size then
        self.mText_Name.fontSize = size
        self.mText_Num.fontSize = size
    end
end

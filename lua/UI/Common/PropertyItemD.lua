require("UI.UIBaseCtrl")

PropertyItemD = class("PropertyItemD", UIBaseCtrl)
PropertyItemD.__index = PropertyItemD

function PropertyItemD:ctor()
    self.mData = nil
    self.value = 0
    self.addValue = 0
end

function PropertyItemD:__InitCtrl()
    self.mText_Name = self:GetText("Text_name")
    self.mText_NumAll = self:GetText("Text_numAll")
    self.mText_NumAdd = self:GetText("Text_numAdd")
end

function PropertyItemD:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("Character/propertyItemD.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function PropertyItemD:SetData(data, value, addValue)
    if data then
        self.mData = data
        self.value = value
        self.addValue = addValue
        self.mText_Name.text = data.show_name.str
        if self.mData.show_type == 2 then
            value = math.ceil(value / 10).."%"
            addValue = math.ceil(addValue / 10).."%"
        end
        if self.addValue > 0 then
            self.mText_NumAdd.text = string_format("[+{0}]", addValue)
        end
        self.mText_NumAll.text = value
        setactive(self.mText_NumAdd.gameObject, self.addValue > 0)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function PropertyItemD:SetDataByName(name, value, addValue)
    if name then
        self.mData = TableData.GetPropertyDataByName(name, 1)
        self.value = value
        self.addValue = addValue
        self.mText_Name.text = self.mData.show_name.str
        if self.mData.show_type == 2 then
            value = math.ceil(value / 10).."%"
            addValue = math.ceil(addValue / 10).."%"
        end
        if self.addValue > 0 then
            self.mText_NumAdd.text = string_format("[+{0}]", addValue)
        end
        self.mText_NumAll.text = value
        setactive(self.mText_NumAdd.gameObject, self.addValue > 0)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function PropertyItemD:SetName(name, color)
    if name then
        self.mData = TableData.GetPropertyDataByName(name, 1)
        self.mText_Name.text = self.mData.show_name.str
        if color then
            self.mText_Name.color = color
            self.mText_NumAll.color = color
        end
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function PropertyItemD:SetValue(value, addValue)
    if self.mData then
        self.value = value
        self.addValue = addValue
        if self.mData.show_type == 2 then
            value = math.ceil(value / 10).."%"
            addValue = math.ceil(addValue / 10).."%"
        end
        if self.addValue > 0 then
            self.mText_NumAdd.text = string_format("[+{0}]", addValue)
        end
        self.mText_NumAll.text = value
        setactive(self.mText_NumAdd.gameObject, self.addValue > 0)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end



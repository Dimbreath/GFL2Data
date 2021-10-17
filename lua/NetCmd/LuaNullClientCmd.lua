require("NetCmd.NetLib")

LuaNullClientCmd = class("LuaNullClientCmd");
LuaNullClientCmd.__index = LuaNullClientCmd;

LuaNullClientCmd.cmd = CS.CmdConst.NULL_CLIENT_CMD; --命令参数
LuaNullClientCmd.length = 0; --命令长度


function LuaNullClientCmd:Pack()
    return CommonPack(self.cmd,function(byteBuffer)
        self:PackData(byteBuffer);
    end);
end

function LuaNullClientCmd:UnPack(msg)
    CommonUnPack(self.cmd,msg,function(byteBuffer)
        self:UnPackData(byteBuffer);
    end);
end

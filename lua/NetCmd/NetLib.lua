NetTool = CS.NetTool;
ByteBuffer = CS.ByteBuffer;
CmdConst = CS.CmdConst;
CmdDef = CS.Cmd.CmdDef;

function CommonUnPack(cmd,msg,_UnPack)
    local byteBuffer = ByteBuffer(msg);
    local tempcmd = byteBuffer:ReadUShort();
    if tempcmd ~= cmd then
        print("错误的指令:" .. tempcmd .. "  实际指令:".. tostring(cmd));
    end
    local len = byteBuffer:ReadUShort();
    local msgLength = string.len(msg);
    if len ~= msgLength - CmdConst.CMD_HEAD_LEN then
        print("错误的指令长度:".. len .."  实际指令长度:"..(msgLength - CmdConst.CMD_HEAD_LEN));
    end
    _UnPack(byteBuffer);
    byteBuffer:Close();
end

function CommonPack(cmd,_Pack)
    local byteBuffer = ByteBuffer();
    --整包头
    byteBuffer:WriteUShort(0);
    byteBuffer:WriteByte(0);
    byteBuffer:WriteUShort(0);

    byteBuffer:WriteUShort(cmd);
    local offset = byteBuffer.Pos;
    byteBuffer:WriteUShort(0);
    local length = byteBuffer.Pos;
    _Pack(byteBuffer);
    length = byteBuffer.Pos - length;
    --写子包的长度
    byteBuffer:WriteLength(offset, length);
    local res = byteBuffer:ToBytes();
    byteBuffer:Close();
    return res;
end
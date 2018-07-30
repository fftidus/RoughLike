package Games.Datas {
import StaticDatas.SData_Skills;

import com.MyClass.Config;

import com.MyClass.Tools.Tool_Function;

public class Data_Skill {
    public var Name:String;
    public var SID:int;
    public var Lv:int;
    public var Type:String;//攻击，被动，辅助
    //被动
    public var buffPassive:Array;//被动buff
    public var isPassive:Boolean=false;
    //主动
    public var cd:int;
    public var costValue:String;
    public var costNum:int;
    public var isSpdEffectByValue:String;//变速源
    public var buffTar:Array;//给作用目标添加的buff
    public var buffSelf:Array;//是施法者自身添加的buff
    //动作
    public var Steps:Array;
    //其他属性：攻击，攻击p……
    public var values:*;
    
    public function Data_Skill(id:int,  lv:int) {
        SID=id;
        Lv=lv;
        var dic:* =SData_Skills.getInstance().Dic[SID];
        if(dic==null){
            Config.Log("没有找到技能数据"+SID);
            return;
        }
        var dicLv:*;
        if (dic["升级"] != null) {
            dicLv = {};
            var tlv:int = 2;
            while (dic["升级"][tlv] != null && Lv >= tlv) {
                for (var key:String in  dic["升级"][tlv]) {
                    var tmpvalue:* = dic["升级"][tlv][key];
                    if (Tool_Function.isTypeOf(tmpvalue, String) == true) {
                        if ((tmpvalue as String).charAt(0) == "+" || (tmpvalue as String).charAt(0) == "-") {
                            if (dicLv[key] == null) dicLv[key] = Tool_Function.onForceConvertType(dic[key]);
                            dicLv[key] += Tool_Function.onForceConvertType(tmpvalue.substr(1));
                        } else {
                            dicLv[key] = tmpvalue;
                        }
                    } else {
                        dicLv[key] = tmpvalue;
                    }
                }
                tlv++;
            }
        }
        for(var vname:String in dic) {
            if(vname=="升级" || vname=="ID")continue;
            if(vname=="Name")       Name = dic[vname];
            else if(vname="Type"){
                Type = dic[vname];
                isPassive = Type == "被动";
            }
            else if(vname=="cd")   cd = getvalueFromDicOrDiclv(vname);
            else if(vname=="costValue") costValue = getvalueFromDicOrDiclv(vname);
            else if(vname=="cost")      costNum = getvalueFromDicOrDiclv(vname);
            else if(vname=="变速源")   isSpdEffectByValue=dic[vname];
            else if(vname=="step"){
                Steps=[];
                for(var i:int=0;i<dic[vname].length;i++) {
                    Steps[i]=new Data_FActionStep(dic[vname][i]);
                }
            }
            else if(vname="buff被动") {
                if (dic[vname] != null) {
                    buffPassive = [];
                    for (i = 0; i < dic[vname].length; i++) {
                        buffPassive.push(new Data_Buff(dic[vname][i]));
                    }
                }
            }
            else if(vname="buff目标") {
                if (dic[vname] != null) {
                    buffTar = [];
                    for (var i:int = 0; i < dic[vname].length; i++) {
                        buffTar.push(new Data_Buff(dic[vname][i]));
                    }
                }
            }
            else if(vname="buff自身") {
                if (dic[vname] != null) {
                    buffSelf = [];
                    for (var i:int = 0; i < dic[vname].length; i++) {
                        buffSelf.push(new Data_Buff(dic[vname][i]));
                    }
                }
            }
            else{//其他属性，保存在values中
                if(values==null)  values = {};
                values[vname] = getvalueFromDicOrDiclv(vname);
            }
        }
        if(isPassive==false && Steps==null){
            Config.Log("技能"+SID+"没有Step")
        }
        function getvalueFromDicOrDiclv(key:String):*{
            if(dicLv && dicLv[key] != null){
                return dicLv[key];
            }
            return dic[key];
        }
    }
    
}
}

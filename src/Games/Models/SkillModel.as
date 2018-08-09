package Games.Models{
import Games.Datas.Data_Buff;
import Games.Datas.Data_FActionStep;

import StaticDatas.SData_Skills;

import com.MyClass.Config;
import com.MyClass.Tools.Tool_Function;

public class SkillModel{
	public var SID:int;
    public var Name:String;
    public var Lv:int;
    public var LvMax:int;
	public var className:String;//特殊类的名字
    public var Type:String;//攻击，被动，辅助
    //被动
    public var buffPassive:Array;//被动buff
    public var valuePassive:*;//被动修改玩家某个属性而不需要buff
    public var isPassive:Boolean=false;
    //主动
    public var cd:int;
    public var costValue:String;
    public var costNum:int;
    public var dependValue:String;
    public var dependValueNum:int;
    public var isSpdEffectByValue:String;//变速源
    public var buffTar:Array;//给作用目标添加的buff
    public var buffSelf:Array;//是施法者自身添加的buff
    //动作
    public var Steps:Array;
    //其他属性：攻击，攻击p……
    public var values:*;
	
	
	public function SkillModel(id:int){
		SID=id;
	}
	/** 初始化：在所有buff和被动都初始化后调用 */
	public function initF():void{
        var dic:* =SData_Skills.getInstance().Dic[SID];
        if(dic==null){
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
            else if(vname=="Type"){
                Type = dic[vname];
                isPassive = Type == "被动";
            }
			else if(vname=="class")	className=dic[vname];
            else if(vname=="cd")   cd = getvalueFromDicOrDiclv(vname);
            else if(vname=="costValue") costValue = getvalueFromDicOrDiclv(vname);
            else if(vname=="cost")      costNum = getvalueFromDicOrDiclv(vname);
            else if(vname=="depend")    dependValue=dic[vname];
            else if(vname=="dependNum") dependValueNum=dic[vname];
            else if(vname=="变速源")   isSpdEffectByValue=dic[vname];
            else if(vname=="step"){
                Steps=[];
                for(var i:int=0;i<dic[vname].length;i++) {
                    Steps[i]=new Data_FActionStep(dic[vname][i]);
                }
            }
            else if(vname=="buff被动") {
                if (dic[vname] != null) {
                    buffPassive = [];
                    for (i = 0; i < dic[vname].length; i++) {
                        buffPassive.push(new Data_Buff(dic[vname][i]));
                    }
                }
            }
            else if(vname=="被动属性"){
                if (dic[vname] != null) {
                    buffPassive = [];
                    for (i = 0; i < dic[vname].length; i++) {
                        buffPassive.push(new Data_Buff(dic[vname][i]));
                    }
                }
            }
            else if(vname=="buff目标") {
                if (dic[vname] != null) {
                    buffTar = [];
                    for (i = 0; i < dic[vname].length; i++) {
                        buffTar.push(new Data_Buff(dic[vname][i]));
                    }
                }
            }
            else if(vname=="buff自身") {
                if (dic[vname] != null) {
                    buffSelf = [];
                    for (i = 0; i < dic[vname].length; i++) {
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
	
	
	
	public function getIconURL():String{
		return "img_SIco_"+SID;
	}
	
	public function getIntroduce():String{
		var dic:* =SData_Skills.getInstance().Dic[SID];
		if(dic){
			return dic["介绍"];
		}
		return "";
	}
	
}
}
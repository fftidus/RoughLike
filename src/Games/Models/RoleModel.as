package Games.Models {
import StaticDatas.SData_Strings;

import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import StaticDatas.SData_RolesInfo;
import StaticDatas.SData_Set;

public class RoleModel {
	public var NetID:int;
	public var baseID:int;
	public var job:int;
	public var Name:String;
	public var Sex:String;
	public var Race:String;//种族
	public var Lv:int=1;
	public var Rank:int=1;
	public var Potential:int;//潜力
	public var spine:String;//spine动画的名字
    public var Exp:int;
	public var DicBaseValues:* =Tool_ObjUtils.getNewObjectFromPool();
	public var DicValues:* =Tool_ObjUtils.getNewObjectFromPool();
	public var DicEquipe:*;
	public var DicSkills:*;
	public var Arr_SkillEquip:Array;
	
	/** 
	 * 角色模型，用来保存每个角色，可以生成战斗用Fight_Role
	 * */
	public function RoleModel() {
	}
	/** 外部的属性 */
	public function initRoleInfo(dic:*):void{//{"netid","baseid","lv","rank","属性","skill"}
		if(dic["id"]!=null){NetID=dic["id"]};
		if(dic["baseid"]!=null){	baseID=dic["baseid"];	}
        if(dic["Name"]!=null){Name=dic["Name"];}
        if(dic["性别"]!=null){Sex=dic["性别"];}
        if(dic["种族"]!=null){Race=dic["种族"];}
        if(dic["spine"]!=null){spine=dic["spine"];}
        if(dic["职业"]!=null){job=dic["职业"];}
        if(dic["等级"]!=null){Lv=dic["等级"];}
        else if(dic["lv"]!=null){Lv=dic["lv"];}
        if(dic["当前经验"]!=null){Exp=dic["当前经验"];}
        if(dic["品质"]!=null){Rank=dic["品质"];}
        if(dic["潜力"]!=null){Potential=dic["潜力"];}
		if(dic["当前经验"]!=null){Exp=dic["当前经验"];}
		if(dic["装备"]!=null){
			if(DicEquipe==null)DicEquipe=Tool_ObjUtils.getNewObjectFromPool("防具",Tool_ObjUtils.getNewObjectFromPool());
			if(dic["装备"]["武器"]==null || dic["装备"]["武器"]==-1){
				delete DicEquipe["武器"];
			}else if(DicEquipe["武器"]==null){
				var wea:WeaponModel=new  WeaponModel(0);
				wea.setInfo(dic["装备"]["武器"]);
				DicEquipe["武器"]=wea;
			}else{
				wea =DicEquipe["武器"];
				wea.setInfo(dic["装备"]["武器"]);
			}
			if(dic["装备"]["防具"]!=null){
				for(var i:int=1;i<=5;i++){
					if(dic["装备"]["防具"][i]==null || dic["装备"]["防具"][i]==-1){
						delete DicEquipe["防具"][i];
					}else if(DicEquipe["防具"][i]==null){
						var arm:ArmorModel=new  ArmorModel(0);
						arm.setInfo(dic["装备"]["防具"][i]);
						DicEquipe["防具"][i]=arm;
					}else{
						arm =DicEquipe["防具"][i];
						arm.setInfo(dic["装备"]["防具"][i]);
					}
				}
			}
		}
		if(dic["拥有技能"] != null){
			DicSkills=dic["拥有技能"];
			for(var sid:int in DicSkills){
				var smodel:SkillModel=new  SkillModel(sid,DicSkills[sid]);
				DicSkills[sid]=smodel;
			}
		}
		if(dic["携带技能"] != null){
			Arr_SkillEquip=dic["携带技能"];
		}
        if(dic["基础属性"]!=null){
            for(var key:String in dic["基础属性"]){
                DicBaseValues[key]=dic["基础属性"][key];
                onChangeValues(key,dic["基础属性"][key],true);
            }
        }
		if(dic["属性"]!=null){
            for(var key:String in dic["属性"]){
				if(Tool_Function.isTypeOf(dic["属性"][key],String)==false) {//直接增加数值
                    onChangeValues(key, dic["属性"][key]);
                }else{//增加基础值的百分比
					if((dic["属性"][key] as String).indexOf("%") != -1){
                        onChangeValues(key, Tool_Function.onForceConvertType(Tool_Function.onForceConvertType(dic["属性"][key].substr(0,dic["属性"][key].length-1)) * getValues(key) * 0.01));
					}else{
                        onChangeValues(key, Tool_Function.onForceConvertType(Tool_Function.onForceConvertType(dic["属性"][key]) * getValues(key) * 0.01));
					}
				}
            }
		}
	}
	/** 修改某个属性，几个特殊属性特殊修改 */
	public function onChangeValues(key:String,value:*,	fouse:Boolean=false):void{
		if(key=="生命")key="hp";
		if(DicValues==null)DicValues=Tool_ObjUtils.getNewObjectFromPool();
		if(DicValues[key]==null || fouse==true){
			DicValues[key]=value;
			return;
		}
		DicValues[key]+=value;
	}
	
	public function getValues(vname:String,	nullToZero:Boolean=true):*{
		if(DicValues[vname]==null){
			if(nullToZero==true){return 0;}
		}
		return DicValues[vname];
	}
	
	public function getHeadIcon():String{
		if(SData_RolesInfo.getInstance().Dic[baseID]!=null && SData_RolesInfo.getInstance().Dic[baseID]["头像"]!=null)
		{
			return SData_RolesInfo.getInstance().Dic[baseID]["头像"];
		}
		return "img_Head_"+baseID;
	}
	
	/** 加载资源：types表示加载类型：null表示全部 */
	public function addSource(source:Array,	types:Array):void{
		var dic:* =SData_RolesInfo.getInstance().Dic[baseID];
		if(dic==null){return;}
		if(dic[SData_Strings.ActionName_Stand] != null && (types==null || types.indexOf(SData_Strings.ActionName_Stand)!=-1)){
            addSwfToSource(dic[SData_Strings.ActionName_Stand]["swf"]);
		}
        if(dic[SData_Strings.ActionName_Run] != null && (types==null || types.indexOf(SData_Strings.ActionName_Run)!=-1)){
            addSwfToSource(dic[SData_Strings.ActionName_Run]["swf"]);
        }
        if(dic[SData_Strings.ActionName_RunStop] != null && (types==null || types.indexOf(SData_Strings.ActionName_RunStop)!=-1)){
            addSwfToSource(dic[SData_Strings.ActionName_RunStop]["swf"]);
        }
        if(dic[SData_Strings.ActionName_Jump] != null && (types==null || types.indexOf(SData_Strings.ActionName_Jump)!=-1)){
            addSwfToSource(dic[SData_Strings.ActionName_Jump]["swf"]);
        }
		function addSwfToSource(swfName:String):void{
			for(var i:int=0;i<source.length;i++){
				if(source[i] && source[i][0] == swfName && source[i][1]=="swf"){
					return;
				}
			}
			source.push([swfName,"swf","Roles/"+swfName])
		}
	}
	
	/** 生成战斗Role需要的数据 */
	public function getFightRoleInfo():*{
		//{"ID":"E1","阵营":2,"RoleID":1,"技能":{1:{"数量":10},2:{"数量":5}},"行":1,"列":3,"方向":"上","Name":"角色1","属性":{"hp":100,"物攻":10}
		var save:* =Tool_ObjUtils.getInstance().CopyF(DicValues);
		//装备
		var dicSet:* ={};
		if(DicEquipe){
			var wea:WeaponModel=DicEquipe["武器"];
			if(wea){	
				wea.getFightValue(this);	
				if(wea.setID>0){
					if(dicSet[wea.setID]==null)dicSet[wea.setID]=0;
					else	dicSet[wea.setID]++;
				}
			}
			if(DicEquipe["防具"]){
				for(var po:int in DicEquipe["防具"]){
					var arm:ArmorModel=DicEquipe["防具"][po];
					if(arm){
						arm.getFightValue(this);
						if(arm.setID>0){
							if(dicSet[arm.setID]==null)dicSet[arm.setID]=0;
							else	dicSet[arm.setID]++;
						}
					}
				}
			}
		}
		//套装
		for(var setID:int in  dicSet){
			var info:* =SData_Set.getInstance().Dic[setID];
			if(info==null || info["效果"]==null)continue;
			for(var i:int=2;i<=6;i++){
				if(dicSet[setID]<i)break;
				if(info["效果"][i]==null)continue;
				var dicSetOne:* =info["效果"][i];//{"伤害加成":0.1, "MF":100}
				for(var key:String in dicSetOne){
					onChangeValues(key,dicSetOne[key]);
				}
			}
		}
		//---------------------------------
		info ={};
		info["rm"]=this;
		info["ID"]=NetID;
		info["RoleID"]=baseID;
		info["Name"]=Name;
		info["Lv"]=Lv;
		info["基础属性"]=Tool_ObjUtils.CopyF(DicBaseValues);
		var dic:* =Tool_ObjUtils.getInstance().CopyF(DicValues);
		info["属性"]=dic;
		//技能
		if(DicSkills){
			info["技能"]=[];
			for(var sid:int in DicSkills){
				var sdata:SkillModel=DicSkills[sid];
//				if(sdata.isPassive==false && Arr_SkillEquip!=null && Arr_SkillEquip.indexOf(sid)==-1){continue;}
				var slv:int =sdata.getRealLv(this);
				info["技能"].push({"id":sdata.SID,"lv":sdata.Lv});
			}
		}
		//特殊属性
		if(dic["属性随等级加成"]!=null){
			for(key in dic["属性随等级加成"]){
				var add:int =Lv * dic["属性随等级加成"][key] * 0.01;
				if(dic[key]==null)dic[key]=add;
				else dic[key]+=add;
			}
			delete dic["属性随等级加成"];
		}
		delete dic["技能等级增加"];
		//还原基础属性
		DicValues=save;
		return info;
	}
	
	public function toString():String{
		return "RoleModel："+Name+"(nid="+NetID+",baseid="+baseID+")";
	}
	
	public function destroyF():void{
		Arr_SkillEquip=Tool_ObjUtils.getInstance().destroyF_One(Arr_SkillEquip);
		DicEquipe=Tool_ObjUtils.getInstance().destroyF_One(DicEquipe);
		DicValues=Tool_ObjUtils.getInstance().destroyF_One(DicValues);
        DicBaseValues=Tool_ObjUtils.destroyF_One(DicBaseValues);
	}
}
}

package Games.Models {
	import StaticDatas.SData_Default;
	import StaticDatas.SData_Weapon;
	
/**
 * 武器
 * */
public class WeaponModel{
	public var NetID:int;
	public var baseID:int;
	public var RoleID:int;
	public var UID:int;
	public var Name:String;
	public var rank:int;
	public var position:int;
	public var lv:int=1;
	public var jobs:Array;
	public var dicBaseValue:*;
	public var dicValues:*;
	public var strIntro:String;
	public var priceSold:int;
	public var setID:int;
	public var buffs:*;
	public var urlIcon:String;
	public var isChecked:Boolean=false;
	
	public function WeaponModel(nid:int) {
		NetID=nid;
	}
	
	public function setInfo(info:*):void{
		if(info["名称"]!=null)	Name=info["名称"];
		else 							Name=info["Name"];
		if(info["id"]!=null)NetID=info["id"];
		if(info["baseid"]!=null)baseID=info["baseid"];
		if(info["uid"]!=null)UID=info["uid"];
		if(info["品质"]!=null)rank=info["品质"];
		if(info["部位"]!=null)position=info["部位"];
		if(info["等级"]!=null)lv=info["等级"];
		if(info["职业"]!=null)jobs=info["职业"];
		if(info["基础属性"]!=null){dicBaseValue=info["基础属性"];}
		if(info["附加属性"]!=null)dicValues=info["附加属性"];
		if(info["介绍"]!=null)strIntro=info["介绍"];
		if(info["售价"]!=null)priceSold=info["售价"];
		if(info["rid"]!=null)RoleID=info["rid"];
		if(info["套装"]!=null)setID=info["套装"];
		if(info["buff"]!=null)buffs=info["buff"];
		if(info["图标"]!=null)urlIcon=info["图标"];
		if(info["辨识"]==true)isChecked=true;
	}
	
	public function getURL():String{
		if(urlIcon!=null)	return urlIcon;
		return SData_Weapon.getInstance().Dic[baseID]["图标"];
	}
	
	public function getTypeString():String{
		return SData_Default.getInstance().Dic["品质名"][rank]+"武器";
	}
	/** 获得基础属性文字介绍 */
	public function getBaseValueString():String{
		var str:String="";
		if(dicBaseValue){
			for(var key:String in dicBaseValue){
				if(str.length>0)str+=",";
				if(dicBaseValue[key]>0)str+="+";
				str+=dicBaseValue[key];
				if(SData_Default.isNeet百分比(key)==true)str+="%";
				str+=SData_Default.getShowValueName(key);
			}
		}
		return str;
	}
	
	public function isFitJob(job:int):Boolean{
		if(jobs!= null && jobs.indexOf(job) != -1){
			return true;
		}
		return false;
	}
	
	public function toString():String{
		return "WeaponModel："+Name+"(nid="+NetID+",baseid="+baseID+")";
	}
	
	/** 获得战斗加成属性 */
	public function getFightValue(role:RoleModel):void{
		if(dicBaseValue){
			for(var key:String in dicBaseValue){
				role.onChangeValues(key,dicBaseValue[key]);
			}
		}
		if(dicValues){
			for(key in dicValues){
				role.onChangeValues(key,dicValues[key]);
			}
		}
		role.onChangeValues("武器buff",buffs);
	}
	
	public function destroyF():void{
	}
}
}

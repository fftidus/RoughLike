package Games.Models{
	import com.MyClass.Tools.Tool_Function;
	
	import StaticDatas.SData_Skills;

public class SkillModel{
	public var Name:String;
	public var SID:int;
	public var Lv:int;
	public var isPassive:Boolean=false;
	public var Type:String;
	public var cd:int;
	public var costValue:String;
	public var costNum:int;
	
	public function SkillModel(id:int,lv:*){
		SID=id;
		if(Tool_Function.isTypeOf(lv,Number)==true){
			Lv=lv;
		}else{
			Lv=lv["等级"];
		}
		var dic:* =SData_Skills.getInstance().Dic[SID];
		if(dic){
			Name =dic["Name"];
			isPassive=dic["Type"]=="被动";
			Type=dic["Type"];
			cd=dic["CD"];
			costValue=dic["costValue"];
			costNum=dic["cost"];
		}
	}
	
	public function getRealLv(role:RoleModel):int{
		if(role){
			if(role.DicValues && role.DicValues["技能等级增加"]!=null && role.DicValues["技能等级增加"][SID]!=null){
				return Lv+role.DicValues["技能等级增加"][SID];
			}
		}
		return Lv;
	}
	public function getURL():String{
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
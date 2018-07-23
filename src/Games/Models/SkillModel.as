package Games.Models{
import StaticDatas.SData_Skills;

public class SkillModel{
	public var Name:String;
	public var SID:int;
	public var Lv:int;
	public var isPassive:Boolean=false;
	public var Type:String;//攻击，被动，辅助
	public var cd:int;
	public var costValue:String;
	public var costNum:int;
	
	public function SkillModel(id:int,lv:int){
		SID=id;
		Lv=lv;
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
		return Lv;
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
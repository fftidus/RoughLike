package Games.Models{
import Games.Datas.Data_Skill;

import StaticDatas.SData_Skills;

public class SkillModel{
	public var Name:String;
	public var SID:int;
	public var Lv:int;
	public var data:Data_Skill;
	
	
	public function SkillModel(id:int,lv:int){
		SID=id;
		Lv=lv;
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
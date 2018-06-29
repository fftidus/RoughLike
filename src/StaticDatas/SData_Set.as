package StaticDatas{
	import com.MyClass.VertionVo;

public class SData_Set	{
	private static var instance:SData_Set;
	public static function getInstance():SData_Set{
		if(instance==null)instance=new  SData_Set();
		return instance;
	}
	
	public var Dic:*;
	public function SData_Set()		{
		Dic=VertionVo.getData(this);
		if(Dic==null)onLocalF();
	}
	
	private function onLocalF():void{
		Dic={};
		var sid:int;
		var dic:*;
		//---------------------------
		sid=1;dic={};Dic[sid]=dic;
		dic["名称"]="套装1";
		dic["武器"]={0:{"品质":1}};
		dic["防具"]=[{"baseid":1,"品质":3}];
		dic["效果"]={2:{"伤害加成":0.1, "MF":100}, 4:{"生命":200, "物理防御":81}, 6:{"魔法防御":108}}
	}
	
	
}
}
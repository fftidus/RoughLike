package StaticDatas{
import com.MyClass.VertionVo;	
public class SData_Roles	{
	private static var instance:SData_Roles;
	public static function getInstance():SData_Roles
	{
		if(instance==null)instance=new SData_Roles();
		return instance;
	}
	
	public	var Dic:*;
	public function SData_Roles()
	{
		Dic=VertionVo.getData(this);
		if(Dic==null)on本地();
	}
	
	private function on本地():void{
		Dic={};
		var dic:*;
		var rid:int;
		//-------------------------------------------
		rid=1;dic={};Dic[rid]=dic;
		dic["Name"]="男剑士";
		dic["性别"]="男";
		dic["种族"]="人";
		dic["移动类型"]=1;
		dic["rank"]=1;
		dic["属性"]={"hp":100,"物攻":10,"移动距离":5};
		dic["技能"]={1:{"数量":10},2:{"数量":5}};
	}
}
}
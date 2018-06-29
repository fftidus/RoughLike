package StaticDatas{
	import com.MyClass.VertionVo;

public class SData_Task{
	private static var instance:SData_Task;
	public static function getInstance():SData_Task{
		if(instance==null)instance=new  SData_Task();
		return instance;
	}
	
	public var Dic:*;
	public function SData_Task(){
		Dic=VertionVo.getData(this);
		if(Dic==null){
			onLocalF();
		}
	}
	
	private function onLocalF():void{
		Dic={};
		var dic:*;
		var id:int;
		//==========================
		id=1;dic={};Dic[id]=dic;
		dic["类型"]=1;//讨伐
		dic["名称"]="讨伐骷髅战士10个";
		dic["内容"]={1001:10};
		dic["前置"]=0;
		dic["奖励"]=[];
	}
}
}
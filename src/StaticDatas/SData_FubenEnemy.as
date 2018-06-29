package StaticDatas{
	import com.MyClass.VertionVo;

public class SData_FubenEnemy{
	private static var instance:SData_FubenEnemy;
	private static function getInstance():SData_FubenEnemy{
		if(instance==null){
			instance=new  SData_FubenEnemy();
		}
		return instance;
	}
	
	public var Dic:*
	public function SData_FubenEnemy(){
		Dic=VertionVo.getData(this);
		if(Dic==null){
			onLocalF();
		}
	}
	
	private function onLocalF():void{
		Dic={};
		var id:int;
		var dic:*;
		
		id=1101;dic={};Dic[id]=dic;
		dic["队长"]=83;
	}
	
	
}
}
package StaticDatas{
	import com.MyClass.VertionVo;

public class SData_DungeonMonster{
	private static var instance:SData_DungeonMonster;
	public static function getInstance():SData_DungeonMonster{
		if(instance==null)instance=new  SData_DungeonMonster();
		return instance;
	}
	
	public var Dic:*
	public function SData_DungeonMonster()	{
		Dic=VertionVo.getData(this);
		if(Dic==null){
			onLocalF();
		}
	}
	
	private function onLocalF():void{
		Dic={};
		//1101::{队长::1001}
	}
	
	
}
}
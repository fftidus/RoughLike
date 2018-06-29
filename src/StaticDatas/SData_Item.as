package StaticDatas {
import com.MyClass.VertionVo;

public class SData_Item {
	private static var instance:SData_Item;
	public static function getInstance():SData_Item{
		if(instance==null){instance=new SData_Item();}
		return instance;
	}
	
	public var Dic:*;
	public function SData_Item() {
		Dic=VertionVo.getData(this);
		if(Dic==null){
			onLocalF();
		}
	}
	
	private function onLocalF():void{
		Dic={};
		Dic[1] = {
			"Name":"1号"
		};
	}
	
}
}

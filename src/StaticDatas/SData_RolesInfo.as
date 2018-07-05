package StaticDatas{
import com.MyClass.VertionVo;
	
public class SData_RolesInfo{
	public static const ActionName_Stand:String="站立";
    public static const ActionName_Run:String="跑步";
    public static const ActionName_RunStop:String="跑步停";
	
	private static var instance:SData_RolesInfo;
	private static function getInstance():SData_RolesInfo{
		if(instance==null)instance=new SData_RolesInfo();
		return instance;
	}
	
	public var Dic:*;
	public function SData_RolesInfo(){
		Dic=VertionVo.getData(this);
		if(Dic==null)	_本地数据();
		else{
			trace("使用网络RolesInfo");
		}
	}
	
	private function _本地数据():void{
		Dic={};
		var id:int;
		var dic:*;
		var dicAct:*;
		//==================
	}
		
		
		
		
}
}
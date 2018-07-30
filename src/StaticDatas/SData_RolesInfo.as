package StaticDatas{
import com.MyClass.VertionVo;
	
public class SData_RolesInfo{
	
	private static var instance:SData_RolesInfo;
	public static function getInstance():SData_RolesInfo{
		if(instance==null)instance=new SData_RolesInfo();
		return instance;
	}
	
	public var Dic:*;
	public function SData_RolesInfo(){
		Dic=VertionVo.getData(this);
		if(Dic==null)	_localF();
		else{
			trace("使用网络RolesInfo");
		}
	}
	
	private function _localF():void{
		Dic={};
		var id:int;
		var dic:*;
		var dicAck:*;
		//==================
		id=1;dic={"baseid":id};Dic[id]=dic;
		dic["Name"]="角色1";
		dic["品质"]=1;
		dic["潜力"]=1;
		dic["职业"]=1;
		dic["拥有技能"]=[1];
		dic["基础属性"]={"hp":800,"mp":50,"物攻":30,"魔攻":30,"物防":30,"魔防":30,"命中":0,"闪避":0,"暴击率":3,"暴击值":120,"移速":100
			,"重量":10,"硬直":0,"韧性":100};
		dic["站立"]={"swf":"Role1","url":"mc_站立",	"被击范围":{"上":20,"下":20,"点":[-20,0,	-20,100,	20,100,		20,0]}};
		dic["跑步"]={"swf":"Role1","url":"mc_移动"};
        dic["跑步停"]={"swf":"Role1","url":"mc_移动停止"};
        dic["跳"]={"swf":"Role1","url起跳":"mc_起跳","url上升":"mc_上升","url下落":"mc_落下","url落地":"mc_落地"};
	}
		
		
		
		
}
}
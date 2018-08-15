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
		dic["碰撞"]=[30,15,100];
		dic["普攻"]=1;
		dic["拥有技能"]=[];
		dic["技能"]={"装备":{"A":2},"学习":"all"};
		dic["基础属性"]={"hp":800,"mp":50,"物攻":30,"魔攻":30,"物防":30,"魔防":30,"命中":0,"闪避":0,"暴击率":3,"暴击值":120,"移速":200
			,"重量":10,"硬直":0,"韧性":100};
		dic["站立"]={"swf":"Role1","url":"mc_站立"};
		dic["跑步"]={"swf":"Role1","url":"mc_移动","音效":{"Name":"runstep","frame":[0,12]}};
        dic["急停"]={"swf":"Role1","url":"mc_移动停止"};
        dic["跳"]={"swf":"Role1","url起跳":"mc_起跳","url上升":"mc_上升","url下落":"mc_落下","url落地":"mc_落地"};
        dic["挨打"]={"swf":"Role1","url":"mc_挨打"};
        dic["倒地"]={"swf":"Role1","url":"mc_倒地",	"被击范围":{"上":15,"下":15,"点":[-50,0,	-50,20,	50,20,		50,0]}};
	}
		
		
		
		
}
}
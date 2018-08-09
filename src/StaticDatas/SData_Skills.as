package StaticDatas{
import com.MyClass.VertionVo;

public class SData_Skills{
	public static const TypeSkill_Atk:String="攻击";
	public static const TypeSkill_Pure:String="辅助";
	public static const TypeSkill_Passive:String="被动";
	
	public static const TypeAtk_Physics:String="物理";
	public static const TypeAtk_Magic:String="魔法";
	
	public static const TypeAni_Nor:String="普通";
	public static const TypeAni_Fly:String="飞行";
	public static const TypeAni_movieClip:String="特效";
	
	public static const TypeArea_Single:String="单体";
	public static const TypeArea_Self:String="自身";
	
	private static var instance:SData_Skills;
	public static function getInstance():SData_Skills{
		if(instance==null){
			instance=new SData_Skills();
		}
		return instance;
	}
	
	public var Dic:*;
	public function SData_Skills(){
		Dic=VertionVo.getData(this);
		if(Dic==null){
            onLocalF();
		}else{
			trace("使用网络Skill");
		}
	}
	private function onLocalF():void{
		Dic={};
		var id:*;
		var dic:*;
		//==================
		id=1;dic={"ID":id};Dic[id]=dic;
		dic["Name"]="普攻";
		dic["Type"]="攻击";
		dic["cd"]=0;
		dic["step"]=[
			{"swf":"Role1_A1","url":"mc_轻1","帧":null,"类型":"穿刺","属性":"主","固定攻击":"攻击力","比例攻击":"攻击力P","削韧":50,"中心":{"x":0,"y":0}
				,"硬直":50,"上":0,"下":0,"左":0,"右":0,"升":0,"落":0
				,"光效":null,"音效":null
				,"伤害":{"帧":[3,4],"范围":{"上":20,"下":20,"对地":false,"点":[0,0,		0,100,		100,100,		100,0]}}	}
		];
		dic["升级"]={
			2:{"攻击力":110}
		};
		dic["攻击力"]=100;
		dic["攻击力P"]=10;
		dic["变速源"]="攻速";
		dic["霸体"]=false;
		dic["霸体帧"]=null;
        dic["无敌"]=false;
        dic["无敌帧"]=null;
        dic["位移"]=false;
        dic["音效"]=null;
        dic["残影"]=false;
        dic["震动"]=null;
	}
}
}
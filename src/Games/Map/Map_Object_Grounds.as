package Games.Map {
import Games.Map.Datas.MapData_Grip;

import com.MyClass.Config;
import com.MyClass.Tools.MyPools;

public class Map_Object_Grounds extends Map_Object {
	public static function getOne(data:MapData_Grip,    info:*):Map_Object_Grounds{
		if(MyPools.getInstance().hasPool("Map_G")==false){
			MyPools.getInstance().registF("Map_G");
		}
		var one:Map_Object_Grounds =MyPools.getInstance().getFromPool("Map_G");
		if(one==null){
			one=new Map_Object_Grounds();
		}
		one.x =info.x;
		one.y =info.y;
		one.index=info["层级"];
		one.initF(data);
		return one;
	}
	/*******************************************************************************/
	/*******************************************************************************/
	
	public function Map_Object_Grounds() {
		super();
	}
	
	public function initF(data:MapData_Grip):void{
		if(Role==null){
			Role=Map_ObjectView_Grounds.getOne(data.swf,data.Url);
		}
		Role.initF();
	}

	override public function get z():Number {return 0;}
	override public function set z(value:Number):void {Config.Log("地面不应该有z！");}
	override public function hitTestWith(obj:Map_Object):Boolean {Config.Log(" 地面不会有碰撞！");return false;}
	
	//地面的清理不会清理掉图片
	override public function removeF():void {
		if(Role){
			Role.removeF();
			Role=null;
		}
		MyPools.getInstance().returnToPool("Map_G",this);
	}
}
}

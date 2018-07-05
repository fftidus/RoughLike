package Games.Map {
import Games.Controller_Scene;
import Games.Map.Datas.MapData_Grip;

import com.MyClass.Config;
import com.MyClass.Tools.Tool_Function;

public class Map_Object_Grounds extends Map_Object {
	public function Map_Object_Grounds() {
		super();
	}
	
	override public function initF(_data:*,info:*):void{
		if(_data is MapData_Grip == false){
			Config.onThrowError("地面被传入错误的数据类型"+Tool_Function.getLastClassName(_data));
		}
		super.initF(_data,info);
	}

	override public function set z(value:Number):void {Config.Log("地面不应该有z！");}
	override protected function hitTestWith(obj:Map_Object):Boolean {Config.Log(" 地面不会有碰撞！");return false;}
	
	//地面的清理不会清理掉图片
	override public function removeF():void {
		if(Role){
			Role.removeF();
			Role=null;
		}
		if(Controller_Scene.getInstance().nowScene){
			Controller_Scene.getInstance().nowScene.pool.returnToPool(Map_Object.PoolName_Ground,this);
        }
	}
}
}

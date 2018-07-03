package Games.Map{
import Games.Controller_Scene;

import com.MyClass.Tools.MyHitArea;
import com.MyClass.Tools.MyPools;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Map.Datas.MapData_Grip;

import starling.display.Sprite;

/**
 * 地图上的所有物体
 * */
public class Map_Object extends Sprite{
	public static const PoolName_Ground:String="Map_G";
    public static function getOne(data:MapData_Grip,    info:*):Map_Object{
		if(info["层级"]<4) {
			var pool:MyPools;
			if(Controller_Scene.getInstance().nowScene){
				pool=Controller_Scene.getInstance().nowScene.pool;
			}
            if (pool && pool.hasPool(PoolName_Ground) == false) {
                pool.registF(PoolName_Ground);
            }
            var one:Map_Object;
			if(pool){
				one= pool.getFromPool(PoolName_Ground);
            }
            if (one == null) {
                one = new Map_Object_Grounds();
            }
            one.initF(data, info);
        }else{
			one =new Map_Object();
            one.initF(data, info);
		}
        return one;
    }
    /*******************************************************************************/
    /*******************************************************************************/
	public var Role:Map_ObjectView;
	private var _z:Number=0;
	public var index:int=1;
	public var hitArea:MyHitArea;
	
	public function Map_Object(){
	}
	protected function initData(data:*,	info:*):void{
        if(info) {
            if (info["x"] != null) this.x = info.x;
            if (info["y"] != null) this.y = info.y;
            if (info["层级"] != null) this.index = info["层级"];
        }
        if(data && data.hitRec)initHitArea(data.hitRec);
	}
	
	public function initF(data:*,	info:*):void{
		initData(data,info);
        if(Role==null){
            Role=Map_ObjectView.getOne(data.swf,data.Url);
            this.addChild(Role);
        }
        Role.initBaseMc(null,null);
	}

	public function initHitArea(dic:*):Boolean{
		var hitArea:MyHitArea = MyHitArea.getHitArea(dic);
		if(hitArea != null){
			this.hitArea = hitArea;
			return true;
		}
		return false;
	}

	override public function set x(value:Number):void {
		super.x=value;
	}
	override public function set y(value:Number):void {
		super.y = value;
	}
	public function set z(value:Number):void {
		_z = value;
	}
	
	/** 碰撞检测 */
	public function hitTestWith(obj:Map_Object):Boolean{
		if(this.hitArea==null || obj.hitArea==null){return false;}
		return hitArea.hitTest(obj.hitArea,this.x,this.y,this._z,obj.x,obj.y,obj._z);
	}

	/** 清理：人物等不缓存，直接清理。地面等地图素材缓存。 */
	public function removeF():void{
		destroyF();
	}
	public function destroyF():void{
		Tool_ObjUtils.destroyDisplayObj(this);
		Role=Tool_ObjUtils.destroyF_One(Role);
	}
}
}
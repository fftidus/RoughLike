package Games.Fuben.Datas {
/**
 * 地图上所有物体的默认格式
 * */
public class MAPData_Object {
	//显示用的坐标信息：左右x，上下y
	public var x:int;
	public var y:int;
	public var x2:int;
	public var y2:int;
	/** 层级：0表示地面层 */
	public var layerIndex:int;
	/** 是否需要计算碰撞其他物体 */
	public var needHittest:Boolean;
	//碰撞的坐标信息
	public var hitx:int;
	public var hitx2:int;
	public var hity:int;
	public var hity2:int;
	/** 组件信息 */
	public var comps:*;
	
	public function MAPData_Object() {
	}
	/** 初始化方法：考虑到可能重用，需要清理一些可能为null的数据为默认值 */
	public function initF(dic:*):void{
		needHittest=false;
		comps=null;
		for(var key:String in dic){
			this[key]=dic[key];
		}
	}
	
}
}

package Games.Fuben.Datas{
/**
 * 地图的整体数据
 * */
public class MAP_Data{
	/** 地图的名字 */
	public var Name:String;
	/** 格子大小 */
	public var size:int;
	/** 横向格子的数量 */
	public var numX:int;
	/** 纵向格子的数量 */
	public var numY:int;
	//
	/** 地面位置数据：key="G1"，value=[0,0   ,0,1  ,0,2  ,0,3] 每两位一个坐标，减少强转*/
	public var data_ground:*;
	public var data_item:*;//物体位置
	public var dicValue_item:*;//物体的基础属性
	
	public function MAP_Data(){
	}
	
		
		
}
}
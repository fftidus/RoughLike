package Games.Map {
import Games.Map.Datas.MapData_Grip;

import com.MyClass.Tools.Tool_ObjUtils;

/**
 * 地图区域显示图块控制
 * 数据排序为xy从小打大。取值范围是起点=x1在范围，终点x0在范围
 * */
public class Map_ShowAreaController {
	private var Map:MAP_Instance;
	private var minIndex:int=-1;
	private var maxIndex:int=-1;
	private var Dic_grips:* ={};//保存的所有图块
	
	public function Map_ShowAreaController(map:MAP_Instance) {
		this.Map=map;
	}
	/** 检测当前显示范围 */
	public function onCheckF():void{
		var newMin:int=-1;
		var newMax:int=-1;
		var i:int;
		var length:int =this.Map.data.Arr_grips.length;
		for(i=0;i<length;i++){
			var data:MapData_Grip=this.Map.data.Arr_grips[i][0];
			var can:Boolean=canShow_data(data);
			if (newMin == -1) {
				if (can == true) {
					newMin = i;
				}
			}
			else if (i > newMax) {
				if (can == true) {
					newMax = i;
				}else{
					break;
				}
			}
		}
		if(newMin!=minIndex || newMax != maxIndex){
			trace("区域改变：",newMin,newMax);
			onShowF(newMin,newMax);
			this.Map.needSort=true;
		}
	}
	/** 单个图块能否显示 */
	private function canShow_data(data:MapData_Grip):Boolean{
		if(data.rec.x1<=Map.nowMaxX && data.rec.x0>=Map.nowMinX && data.rec.y0 >= Map.nowMinY && data.rec.y1 <= Map.nowMaxY){
			return true;
		}
		return false;
	}
	/** 显示 */
	private function onShowF(newMin:int=-1,newMax:int=-1):void{
		var i:int;
		var objOne:Map_Object;
		if(newMin!=-1) {//先删除部分老数据
			if(newMin>minIndex){
				for(i=minIndex;i<newMin;i++){
					objOne=Dic_grips[i];
					if(objOne){
						delete Dic_grips[i];
						objOne.removeF();
					}
				}
			}
			if(newMax<maxIndex){
				for(i=maxIndex;i>newMax;i--){
					objOne=Dic_grips[i];
					if(objOne){
						delete Dic_grips[i];
						objOne.removeF();
					}
				}
			}
		}
		//添加新的部分
		minIndex = newMin;
		maxIndex = newMax;
		for(i=minIndex;i<=maxIndex;i++){
			if(Dic_grips[i]!=null){continue;}
			objOne=Map_Object_Grounds.getOne(this.Map.data.Arr_grips[i][0],this.Map.data.Arr_grips[i][1]);
			Dic_grips[i]=objOne;
			this.Map.addMapObjectToLayer(objOne,objOne.index);
		}
	}
	
	public function destroyF():void{
		this.Map=null;
		Dic_grips=Tool_ObjUtils.destroyF_One(Dic_grips);
	}
}
}

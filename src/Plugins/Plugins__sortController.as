package Plugins {
import com.MyClass.Config;

import starling.display.Sprite;

public class Plugins__sortController {
	/**
	 * 排序控制器
	 * @param v属性 用于排序的属性
	 * @param time 排序的间隔时间
	 */
	public var layer:Sprite;
	private var value_属性:String;
	public var arrSortKeys:Array;
	public var type:String="升序";//越小的排在越前面
	private var timeNeed:Number;
	//
	public var isArrayType:Boolean;
	public var countNeed:int;
	
	public function Plugins__sortController(_layer:Sprite, v属性:String, time:Number) {
		layer=_layer;
		value_属性=v属性;
		timeNeed=time;
	}
	
	public function enterF():void{
		if(countNeed-- <= 0){
			on排序F();
		}
	}
	public function on刷新冷却F():void{
		countNeed=0;
	}
	
	public function on排序F():void{
		countNeed=timeNeed * Config.playSpeedTrue;
		var l:int=layer.numChildren;
		if(l==0){return;}
		var arr:Array=[];
		var role0:*;
		var role1:*;
		for(var i:int=0;i<l;i++) {
			role0=layer.getChildAt(i);
			arr.push(role0);
		}
		l =arr.length;
		for(i=0;i<l-1;i++) {
			role0=arr[i];
			for(var j:int=i+1;j<l;j++){
				role1=arr[j];
				if(role0[value_属性] == role1[value_属性]){
					if(arrSortKeys!=null){
						for(var m:int=0;m<arrSortKeys.length;m++){
							var value_属性2:String =arrSortKeys[m];
							if(role0[value_属性2] == role1[value_属性2]){continue;}
							if((role0[value_属性2] < role1[value_属性2] && type=="降序") || (role0[value_属性2] > role1[value_属性2] && type=="升序") ){
								arr[j]=role0;
								arr[i]=role1;
								role0=role1;
							}
							break;
						}
					}
					continue;
				}
				if((role0[value_属性] < role1[value_属性] && type=="降序") || (role0[value_属性] > role1[value_属性] && type=="升序") ){
					arr[j]=role0;
					arr[i]=role1;
					role0=role1;
				}
			}
		}
		layer.removeChildren();
		for(i=0;i<l;i++){
			layer.addChild(arr[i]);
		}
	}
	
	public function destroyF():void{
	}
}
}

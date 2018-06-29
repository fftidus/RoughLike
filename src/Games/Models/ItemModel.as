package Games.Models {
import com.MyClass.Tools.MyCheaterNum;
import com.MyClass.Tools.Tool_ObjUtils;

import StaticDatas.SData_Item;

public class ItemModel {
	public var NetID:int;
	public var baseID:int;
	public var Name:String;
	public var _Num:int;
	private var safeNum:MyCheaterNum;
	private var urlIcon:String;
	public var Type:String;
	public var dicValues:*;
	//宝石属性
	public var nextid:int;
	
	public function ItemModel(nid:int,bid:int,num:int) {
		NetID=nid;
		baseID=bid;
		_Num=num;
		var dic:* =SData_Item.getInstance().Dic[baseID];
		if(dic){
			if(dic["名称"]!=null)Name= dic["名称"];
			if(dic["图标"]!=null)urlIcon=dic["图标"];
			if(dic["类型"]!=null)Type=dic["类型"];
			if(dic["效果"]!=null)dicValues=dic["效果"];
			if(dic["next"]!=null)nextid=dic["next"];
		}
	}
	public function needSafeNum():void{
		if(safeNum==null) {
			safeNum = new MyCheaterNum();
			safeNum.setValue("num",_Num);
		}
	}

	public function get 介绍():String {
		var dic:* =SData_Item.getInstance().Dic[baseID];
		if(dic){
			return dic["介绍"];
		}
		return null;
	}
	
	public function get Num():int {
		if(safeNum && safeNum.checkF("num",_Num) == false){
			trace("get道具数量错误！"+Name);
			return 0;
		}
		return _Num;
	}
	public function set Num(value:int):void {
		if(safeNum && safeNum.checkF("num",_Num) == false){
			trace("set道具数量错误！"+Name);
			return;
		}
		_Num = value;
		if(safeNum){
			safeNum.setValue("num",value);
		}
	}

	public function getURL():String{
		if(urlIcon!=null)return urlIcon;
		return "img_Mic_"+baseID;
	}
	
	public function toString():String{
		return "ItemModel："+Name+"(nid="+NetID+",baseid="+baseID+")x"+Num;
	}
	
	public function destroyF():void{
		safeNum=Tool_ObjUtils.getInstance().destroyF_One(safeNum);
	}
}
}

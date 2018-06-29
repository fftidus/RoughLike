package Games.Models{
	import com.MyClass.Tools.MyCheaterNum;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import StaticDatas.SData_Material;
	
	public class MaterialModel{
		public var NetID:int;
		public var baseID:int;
		public var Name:String;
		public var _Num:int;
		private var safeNum:MyCheaterNum;
		public function MaterialModel(nid:int,bid:int,num:int)
		{
			NetID=nid;
			baseID=bid;
			_Num=num;
			var dic:* =SData_Material.getInstance().Dic[baseID];
			if(dic){
				Name= dic["Name"];
			}
		}
		
		public function needSafeNum():void{
			if(safeNum==null) {
				safeNum = new MyCheaterNum();
				safeNum.setValue("num",_Num);
			}
		}
		
		public function get 介绍():String {
			var dic:* =SData_Material.getInstance().Dic[baseID];
			if(dic){
				return dic["介绍"];
			}
			return null;
		}
		
		public function get Num():int {
			if(safeNum && safeNum.checkF("num",_Num) == false){
				trace("get素材数量错误！"+Name);
				return 0;
			}
			return _Num;
		}
		public function set Num(value:int):void {
			if(safeNum && safeNum.checkF("num",_Num) == false){
				trace("set素材数量错误！"+Name);
				return;
			}
			_Num = value;
			if(safeNum){
				safeNum.setValue("num",value);
			}
		}
		
		public function getURL():String{
			return "img_IconMat"+baseID;
		}
		
		public function toString():String{
			return "MaterialModel："+Name+"(nid="+NetID+",baseid="+baseID+")x"+Num;
		}
		
		public function destroyF():void{
			safeNum=Tool_ObjUtils.getInstance().destroyF_One(safeNum);
		}
	}
}
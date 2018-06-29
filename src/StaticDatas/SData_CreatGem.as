package StaticDatas{
	import com.MyClass.VertionVo;

	public class SData_CreatGem{
		private static var instance:SData_CreatGem;
		public static function getInstance():SData_CreatGem{
			if(instance==null)instance=new  SData_CreatGem();
			return instance;
		}
		
		public var Dic:*;
		public function SData_CreatGem(){
			Dic=VertionVo.getData(this);
			if(Dic==null)onLocalF();
		}
		
		private function onLocalF():void{
			Dic={"宝石合成":{},"可镶嵌":{},"重置等级":1,"重置价格":1};
			var bid:int;
			var dic:*;
			//=============================
			bid=1;dic={};Dic["宝石合成"][bid]=dic;
			dic["数量消耗"]=3;
			dic["金币消耗"]=10000;
			dic["成功率"]=100;
		}
		
}
}
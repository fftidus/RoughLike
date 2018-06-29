package StaticDatas{
	import com.MyClass.VertionVo;

	public class SData_SmallMap{
		private static var instance:SData_SmallMap;
		public static function getInstance():SData_SmallMap{
			if(instance==null)instance=new  SData_SmallMap();
			return instance;
		}
		
		public var Dic:*;
		public function SData_SmallMap(){
			Dic=VertionVo.getData(this);
			if(Dic==null)onLocalF();
		}
		
		private function onLocalF():void{
			Dic={};
			Dic["可显示组件"]={"宝箱":true,"陷阱":true,"传送门":true
				,"Map_ItemComp_box":true,"Map_ItemComp_portal":true,"Map_ItemComp_trap":true};
		}
}
}
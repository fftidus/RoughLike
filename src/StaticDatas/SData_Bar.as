package StaticDatas{
	import com.MyClass.VertionVo;

	public class SData_Bar	{
		private static var instance:SData_Bar;
		public static function getInstance():SData_Bar{
			if(instance==null){
				instance=new  SData_Bar();
			}
			return instance;
		}
		// Dic【金币 || 钻石】= {  单抽：int，十连：int，间隔：int }
		public var Dic:*;
		public function SData_Bar(){
			Dic=VertionVo.getData(this);
			if(Dic==null){
				onLocalF();
			}
		}
		private function onLocalF():void{
			Dic={};
		}
		
		
}
}
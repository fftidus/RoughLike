package StaticDatas
{
	import com.MyClass.VertionVo;

	public class SData_Town
	{
		private static var instance:SData_Town;
		public static function getInstance():SData_Town{
			if(instance==null){
				instance=new  SData_Town();
			}
			return instance;
		}
		
		public var Dic:*;
		public function SData_Town()
		{
			Dic=VertionVo.getData(this);
			if(Dic==null)onLocalF();
		}
		
		
		private function onLocalF():void{
			Dic={};
			var dic:*;
			
			dic={};
			Dic["路径"]=dic;
			dic["主路"]=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];
			dic["支线"]={17:[18,19],2:[20],8:[21],10:[22,23,24],13:[25]};
		}
	}
}
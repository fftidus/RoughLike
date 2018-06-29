package StaticDatas
{
	import com.MyClass.VertionVo;

	public class SData_Material
	{
		private static var instance:SData_Material;
		public static function getInstance():SData_Material{
			if(instance==null){instance=new SData_Material();}
			return instance;
		}
		
		public var Dic:*;
		public function SData_Material()
		{
			Dic=VertionVo.getData(this);
			if(Dic==null){
				onLocalF();
			}
		}
		
		private function onLocalF():void{
			Dic={};
			Dic[1] = {
				"Name":"1号"
			};
		}
	}
}
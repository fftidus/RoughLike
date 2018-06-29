package StaticDatas{
	import com.MyClass.VertionVo;

	public class SData_PlayerJob{
		private static var instance:SData_PlayerJob;
		public static function getInstance():SData_PlayerJob{
			if(instance==null){
				instance=new  SData_PlayerJob();
			}
			return instance;
		}
		//id:{职业名，解锁等级，技能：{id：int（解锁等级）}}
		public var Dic:*;
		public function SData_PlayerJob()	{
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
package StaticDatas
{
	import com.MyClass.VertionVo;

	public class SData_viewAniConfig
	{
		private static var instance:SData_viewAniConfig;
		public static function getInstance():SData_viewAniConfig{
			if(instance==null){
				instance=new  SData_viewAniConfig();
			}
			return instance;
		}
		
		public var Dic:*;
		public function SData_viewAniConfig()
		{
			Dic=VertionVo.getData(this);
			if(Dic==null){
				on本地数据();
			}
		}
		//缓动：linear=null，easeOutBack：超过后回弹       easeInOut：加速        easeOut：减速
		private function on本地数据():void{
			Dic={};
			Dic["ViewClass_Tavern"]={
				"tmp1":{"x":-300,"缓动":"easeOutBack"}
				,"_nor":{"x":1000,"缓动":"easeOutBack"}
				,"_great":{"x":1100,"缓动":"easeOutBack"}
			};
			
			Dic["ViewClass_ItemShop"]={
				"_背包":{"x":500,"缓动":"easeOut"}
				,"mc1":{"x":-500,"缓动":"easeOut"}
				,"mc2":{"x":-500,"缓动":"easeOut"}
				,"mc3":{"x":-500,"缓动":"easeOut"}
				,"mc4":{"x":-500,"缓动":"easeOut"}
				,"mc5":{"x":-500,"缓动":"easeOut"}
				,"mc6":{"x":-500,"缓动":"easeOut"}
			};
		}
		
		
	}
}
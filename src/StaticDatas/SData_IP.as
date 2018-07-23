package StaticDatas
{
	import com.MyClass.Config;
	import com.MyClass.VertionVo;
	
	public class SData_IP
	{
		private static var instance:SData_IP;
		public static function getInstance():SData_IP
		{
			if(instance==null)instance=new SData_IP();
			return instance;
		}
		
		public var Dic:*;
		public function SData_IP()
		{
			if(VertionVo.instance && VertionVo.instance.getVertion("SData_IP") > 0)
			{
				Dic=VertionVo.instance.get数据资源("SData_IP");
			}
			if(Dic==null)	_本地数据();
			if(Config.MainDevice=="易接")
			{
				Dic["支付回调"]	= "http://"+Dic["ip"]+":"+Dic["端口2"]+"/1sdk_pay";
				Dic["登陆回调"]	= "http://"+Dic["ip"]+":"+Dic["端口2"]+"/1sdk_login";
			}
		}
		public function getNowPort():int{
			if(Config.MainDevice=="H5"){
				return Dic["端口3"];
			}
			return Dic["端口"];
		}
		
		private function _本地数据():void
		{
			Dic	= {};
			/**************************** 正式服务器 *************************************/
			Dic["Name"]="正式";
			Dic["ip"]="120.26.46.197";
			Dic["端口"]=5000;
			Dic["端口2"]=8080;
			Dic["端口3"]=5001;
			return;
			/**************************** 本地服务器 *************************************/
			Dic["Name"]="本地";
			Dic["ip"]="192.168.1.114";
			Dic["端口"]=5000;
			Dic["端口2"]=8080;
			Dic["端口3"]=5001;
			return;
		}
		
		
	}
}
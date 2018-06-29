package StaticDatas{
	import com.MyClass.VertionVo;

/**
 * 辨识价格
 * */
public class SData_Identify	{
	private static var instance:SData_Identify;
	public static function getInstance():SData_Identify{
		if(instance==null)instance=new  SData_Identify();
		return instance;
	}
	public static function getPrice(tar:*):int{
		var nowPrice:int=0;
		for(var i:int=1;i<=tar.lv;i++){
			if(getInstance().Dic[i]!=null){
				nowPrice =getInstance().Dic[i][tar.rank];
			}
		}
		return nowPrice;
	}
	
	public var Dic:*;
	public function SData_Identify(){
		Dic=VertionVo.getData(this);
		if(Dic==null){
			onLocalF();
		}
	}
	
	private function onLocalF():void{
		Dic={};
		Dic[5]={1:1000,2:2000,3:3000,4:4000,5:5000};
		Dic[10]={1:1100,2:2100,3:3100,4:4100,5:5100};
	}
	
	
}
}
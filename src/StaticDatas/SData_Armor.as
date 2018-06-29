package StaticDatas{
	import com.MyClass.VertionVo;
	
	import Games.Models.ArmorModel;

public class SData_Armor	{
	private static var instance:SData_Armor;
	public static function getInstance():SData_Armor{
		if(instance==null){
			instance=new  SData_Armor();
		}
		return instance;
	}
	public static function creatBaseArmor(bid:int):ArmorModel{
		var armor:ArmorModel=new  ArmorModel(0);
		var dic:* =getInstance().Dic[bid];
		if(dic){
			armor.setInfo(dic);
		}
		return armor;
	}
	
	
	public  var Dic:*;
	public function SData_Armor()	{
		Dic=VertionVo.getData(this);
		if(Dic==null){
			onLocalF();
		}
	}
	
	private function onLocalF():void{
		Dic={};
		var id:int;
		var dic:*;
		//======================
		id=1;dic={};Dic[id]=dic;
		dic["Name"]="防具1";
		dic["品质"]=1;
	}
}
}
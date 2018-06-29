package StaticDatas {
	import com.MyClass.VertionVo;
	
	import Games.Models.WeaponModel;

public class SData_Weapon {
	private static var instance:SData_Weapon;
	public static function getInstance():SData_Weapon{
		if(instance==null){instance=new SData_Weapon();}
		return instance;
	}
	public static function creatBaseWeaponModel(bid:int):WeaponModel{
		var wea:WeaponModel=new  WeaponModel(0);
		var dic:* =getInstance().Dic[bid];
		if(dic){
			dic["baseid"]=bid;
			wea.setInfo(dic);
		}
		return wea;
	}
	
	public var Dic:*;
	public function SData_Weapon() {
		Dic=VertionVo.getData(this);
		if(Dic==null){
			onLocalF();
		}
	}
	
	
	private function onLocalF():void{
		Dic={};
		var id:int;
		var dic:*;
		//1
		id=1;dic={};Dic[id]=dic;
		dic["Name"]="武器1";
		dic["品质"]=2;
	}
}
}

package Games.Models{
/**
 * 游戏中一个物品
 * */
public class GameObjectModel{
	public var Type:String;
	public var Num:int;
	public var baseID:int;
	public var wea:WeaponModel;
	public var arm:ArmorModel;
	public var item:ItemModel;
	public var mat:MaterialModel;
	
	public function GameObjectModel(dic:*)	{
		initF(dic);	
	}
	public function initF(dic:*):void{
		if(dic==null)return;
		Type=dic["类型"];
		if(Type=="武器"){
			Num=1;
			wea=new  WeaponModel(0);
			wea.setInfo(dic["属性"]);
		}
		else if(Type=="防具"){
			Num=1;
			arm=new  ArmorModel(0);
			arm.setInfo(dic["属性"]);
		}
		else if(Type=="道具"){
			Num=dic["数量"];
			baseID=dic["baseid"];
			item=new  ItemModel(0,baseID,Num);
		}
		else if(Type=="素材"){
			Num=dic["数量"];
			baseID=dic["baseid"];
			mat=new  MaterialModel(0,baseID,Num);
		}
		else if(Type=="随机武器" || Type=="随机防具"){
			baseID=dic["品质"];
		}
		else{
			Num=dic["数量"];
			baseID=dic["baseid"];
		}
	}
	
	public function getURL():String{
		if(Type=="武器"){
			return wea.getURL();
		}
		else if(Type=="防具"){
			return arm.getURL();
		}
		else if(Type=="道具"){
			return item.getURL();
		}
		else if(Type=="素材"){
			return mat.getURL();
		}
		else if(Type=="随机武器"){
			return "img_IconRadomW"+baseID;
		}
		else if(Type=="随机防具"){
			return "img_IconRadomA"+baseID
		}
		else if(Type=="金币"){
			return "spr_Icon金币";
		}
		else if(Type=="钻石"){
			return "spr_Icon钻石";
		}
		return null;
	}
	
	public function toString():String{
		return Type+":"+baseID+" x"+Num;
	}
}
}
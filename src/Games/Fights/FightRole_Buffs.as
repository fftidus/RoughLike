package Games.Fights{
import com.MyClass.Tools.Tool_ObjUtils;

import laya.utils.Handler;

public class FightRole_Buffs{
	private var Role:FightRole;
	private var Dic:* =Tool_ObjUtils.getNewObjectFromPool();
	public var infoEffect:*;
	
	public function FightRole_Buffs(_role:FightRole){
		Role=_role;
		Role.registEnterHandler("Buff",Handler.create(this,enterF,null,false));
	}
	
	public function enterF():void{
		if(Dic==null)return;
	}
	
	public function checkBuffActive(key:String,	value:* = null):void{
		if(Dic==null)return;
		if(infoEffect==null){
			infoEffect =Tool_ObjUtils.getNewObjectFromPool();
		}else{
			Tool_ObjUtils.onClearObj(infoEffect);
		}
		
	}
	
	public function addBuff():void{
		
	}
	public function removeBuff():void{
		
	}
	
	
	public function destroyF():void{
		Role=null;
		Dic=Tool_ObjUtils.destroyF_One(Dic);
		infoEffect=Tool_ObjUtils.destroyF_One(infoEffect);
	}
}
}
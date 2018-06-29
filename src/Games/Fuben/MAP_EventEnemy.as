package Games.Fuben{
	import com.MyClass.MainManager;
	
	import StaticDatas.SData_DungeonMonster;
	import StaticDatas.SData_EventNames;
	
public class MAP_EventEnemy extends MAP_Event{
	public function get FightID():int{return getValue("EID");}

	public function MAP_EventEnemy(){
	}
	/** 显示敌人队长形象 */
	override public function onShowMC():void{
		if(Mc || Flag!=null){return;}
		
		var fid:int =getValue("EID");
		if(fid==0){return;}
		var dicFight:* =SData_DungeonMonster.getInstance().Dic;
		if(dicFight[fid]==null){return;}
		var rid:int =dicFight[fid]["队长"];
		Mc=new MAP_Role(rid);
		this.addChild(Mc);
		Mc.x =map.SquareSize/2;
		Mc.y =map.SquareSize/2;
		(Mc as MAP_Role).onVisibleF(true);
		(Mc as MAP_Role).onStandF();
		(Mc as MAP_Role).roleMC.play();
	}
	
	override public function onAct_near():Boolean
	{
		if(Flag!=null){
			return false;
		}
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_StartFight,this);
		return true;
	}
	
	
		
		
}
}
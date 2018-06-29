package Games.Fights{
	import com.MyClass.MainManagerOne;
	import com.MyClass.MyEventManagerOne;
	import com.MyClass.MySourceManagerOne;
	import com.MyClass.MyView.LayerStarlingManager;
	import com.MyClass.Tools.Tool_ArrayUtils;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import starling.display.Sprite;

public class ViewClass_FightMain extends Sprite{
	private var mso:MySourceManagerOne=new  MySourceManagerOne();
	private var mmo:MainManagerOne=new  MainManagerOne();
	private var meo:MyEventManagerOne=new  MyEventManagerOne();
	private var fightInfo:*;
	private var sprView:Sprite;
	public var Dic_roles:* =Tool_ObjUtils.getNewObjectFromPool();
	
	private var Arr_hurtHp:Array=Tool_ArrayUtils.getNewArrayFromPool();
	public var Arr_flyObj:Array=Tool_ArrayUtils.getNewArrayFromPool();
	
	public function ViewClass_FightMain(){
		LayerStarlingManager.instance.LayerView.addChild(this);
	}
	
	public function addLightMc(mc:*, isG:Boolean=false):void{
		if(mc){
			if(isG==false){
				sprView.addChild(mc);
			}else{
				sprView.addChildAt(mc,0);
			}
		}
	}
	public function addHurtMc(hp:*):void{
		addLightMc(hp);
		Arr_hurtHp.push(hp);
	}
	public function addFlyObject(fly:*):void{
		addLightMc(fly);
		Arr_flyObj.push(fly);
	}
	
}
}
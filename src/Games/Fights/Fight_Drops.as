package Games.Fights
{
	import com.MyClass.Config;
	import com.MyClass.MainManagerOne;
	import com.MyClass.MySourceManagerOne;
	import com.MyClass.Effect.MyEffect_DropItem;
	import com.MyClass.Tools.MyTween;
	import com.MyClass.Tools.Tool_ObjUtils;
	import com.MyClass.Tools.Tool_Textfield;
	
	import Games.Models.GameObjectModel;
	
	import StaticDatas.SData_Default;
	import StaticDatas.SData_Strings;
	
	import laya.utils.Handler;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class Fight_Drops extends Sprite
	{
		public var Data:GameObjectModel;
		public	var ico:*;
		private var tx:TextField;
		private	var MSO:MySourceManagerOne	= new MySourceManagerOne();
		private	var EFF:MyEffect_DropItem;
		private	var Tween:MyTween;
		private var mmo:MainManagerOne;
		private var count:int=0;
		
		public function Fight_Drops(data:GameObjectModel,	sx:int,sy:int)
		{
			Data=data;
			tx=Tool_Textfield.newTextfield(150,20,data.Num+"金币",null,16,0xFFFFFF);
			tx.x =-150/2;
			tx.y =-18;
			if(Data.Type=="金币")
			{
				ico	= MSO.getImgFromSwf(SData_Strings.SWF_战斗界面,"img_金币");
				tx.text="x"+data.Num;
			}
			else if(Data.Type == "武器")
			{
				ico	= MSO.getImgFromSwf(SData_Strings.SWF_IconWea, data.wea.getURL());
				tx.text=data.wea.Name;
				tx.format.color=SData_Default.getInstance().Dic["品质色"][data.wea.rank];
			}
			else if(data.Type == "防具")
			{
				ico	= MSO.getImgFromSwf(SData_Strings.SWF_IconArm,data.arm.getURL());
				tx.text=data.arm.Name;
				tx.format.color=SData_Default.getInstance().Dic["品质色"][data.arm.rank];
			}
			else if(data.Type=="道具")
			{
				ico	= MSO.getImgFromSwf(SData_Strings.SWF_IconItem,data.item.getURL());
				tx.text=data.item.Name+" x"+data.Num;
			}
			if(ico==null){		return;		}
			ico.x	= -ico.width;
			this.addChild(ico);
			this.addChild(tx);
			this.x	= sx;
			EFF	= new MyEffect_DropItem();
			EFF.setTarget(this);
			var L:int	= Math.random() * 30 - 15;
			EFF.initialize(L,sy,0.5,0.8);
			Tween	= new MyTween(EFF,Handler.create(this,tOver));
			Tween.initMCChange(EFF.endOffsetX/Config.playSpeedTrue,EFF.endOffsetX,0,0,0,0,0,0);
		}
		
		private function tOver():void
		{
			if(Tween)
			{
				Tween.stopF(true);
				Tween=null;
			}
			if(EFF)
			{
				EFF.dispose();EFF=null;
			}
			if(mmo)return;
			mmo=new  MainManagerOne();
			mmo.addEnterFrameFun(Handler.create(this,enterF,null,false));
		}
		
		private function enterF():void{
			count++;
			if(count >= Config.playSpeedTrue * 2){
				destroyF();
			}
			else if(count>=Config.playSpeedTrue){
				this.alpha -= 1/Config.playSpeedTrue;
			}
		}
		
		public function destroyF():void
		{
			tOver();
			tx=Tool_ObjUtils.getInstance().destroyF_One(tx);
			MSO=Tool_ObjUtils.getInstance().destroyF_One(MSO);
			ico=Tool_ObjUtils.getInstance().destroyF_One(ico);
			mmo=Tool_ObjUtils.getInstance().destroyF_One(mmo);
			this.removeFromParent(true);
		}
	}
}

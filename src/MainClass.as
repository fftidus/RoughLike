package{
import Games.Fights.ViewClass_FightMain;

import com.MyClass.Config;
import com.MyClass.MainManager;
import com.MyClass.MySourceManager;
import com.MyClass.SoundManagerMy;
import com.MyClass.MyView.LayerManager;
import com.MyClass.MyView.TmpMovieClip_Ori;
import com.MyClass.NetTools.MgsSocket;
import com.MyClass.Tools.Tool_SpriteUtils;

import Games.Controller_Scene;
import Games.PlayerMain;

import StaticDatas.SData_Strings;

import laya.utils.Handler;

import lzm.starling.swf.display.SwfMovieClip;

public class MainClass
{
	public function MainClass()
	{
		SwfMovieClip.CacheNumBegin =0;
		Config.mainClassInstance=this;
		if(Config.FunRestart!=null){FunRestartOld=Config.FunRestart;};
		Config.FunRestart=Handler.create(this,on重启);
		if(Config.PF==null)
		{
			Config.Platform= "本地";
			startF();
		}
		else{
			Config.PF._登陆(startF);
		}
	}
	private var FunRestartOld:*;
	private function on重启():void
	{
		Controller_Main.destroyF();
		MainManager.getInstence().destroyF();
		MgsSocket.getInstance().destroyF();
		if(SoundManagerMy.instance){
			SoundManagerMy.instance.destroyF();
		}
		PlayerMain.getInstance().destroyF();
		Config.closeStarling();
		//------------------------------------------
		if(FunRestartOld){
			FunRestartOld();
			return;
		}
		startF(true);
	}
	private function startF(重启:Boolean=false):void
	{
		MainManager.getInstence().init(Config.mStage);
		MgsSocket.getInstance().CMDHeart=1;
		PlayerMain.getInstance();
		Controller_Main.getInstance();
		Controller_Scene.getInstance();
		//======================================
		Config.initStarling(Handler.create(this,LogoF));
	}
	
	private var isLoaded:Boolean=false;
	private var isAniend:Boolean=false;
	private function LogoF():void
	{
//			SData_数据输出.onCreatData(SData_数据输出.Type番);return;
		isLoaded=false;
		isAniend=false;
		var source:Array=[
			[SData_Strings.SWF_DefaultUI,"swf"]
		];
		MySourceManager.getInstance().addTexture(source,loadedF);
		
		var mc:*	= Tool_SpriteUtils.getORISprite("__MC_Logo");
		if(mc==null){
			titleF();
			return;
		}
		var tmpMC:TmpMovieClip_Ori=new TmpMovieClip_Ori(mc,titleF);
		LayerManager.getInstence().viewLayer.addChild(tmpMC);
		function titleF():void	{
			isAniend=true;
			onGameF();
		}
		function loadedF():void{
			isLoaded=true;
			onGameF();
		}
		function onGameF():void{
			if(isLoaded==true && isAniend==true){
				new ViewClass_FightMain(null);
			}
		}
	}
		
		
		
		
		
		
}
}
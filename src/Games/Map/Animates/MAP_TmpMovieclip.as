package Games.Map.Animates{
import Games.Map.Map_Object;

import com.MyClass.MyView.TmpMovieClip;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import laya.utils.Handler;

import lzm.starling.swf.display.SwfMovieClip;
	
public class MAP_TmpMovieclip extends Map_Object{
	private var FunEnd:*;
	public function MAP_TmpMovieclip(mc:SwfMovieClip,	fend:*){
		FunEnd=fend;
		var tmc:TmpMovieClip=new  TmpMovieClip(mc,Handler.create(this,onEndF));
		this.addChild(tmc);
	}
	
	private function onEndF():void{
		Tool_Function.onRunFunction(FunEnd);
        destroyF();
	}
	
	override  public function destroyF():void{
		super.destroyF();
		FunEnd=Tool_ObjUtils.destroyF_One(FunEnd);
	}
}
}
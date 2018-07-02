package Games.Map.Animates{
	import com.MyClass.MyView.TmpMovieClip;
	import com.MyClass.Tools.Tool_Function;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import laya.utils.Handler;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
	import starling.display.Sprite;

	public class MAP_TmpMovieclip extends Sprite{
		private var FunEnd:*;
		public var row:int;
		public var colum:int;
		public var renderIndex:int=1000;
		/** 地图上的动画，同tmpmc，但有用来排序的row属性 */
		public function MAP_TmpMovieclip(mc:SwfMovieClip,	fend:*){
			FunEnd=fend;
			var tmc:TmpMovieClip=new  TmpMovieClip(mc,Handler.create(this,onEndF));
			this.addChild(tmc);
		}
		
		private function onEndF():void{
			destroyF();
			if(FunEnd){
				Tool_Function.onRunFunction(FunEnd);
			}
		}
		
		public function destroyF():void{
			Tool_ObjUtils.getInstance().destroyDisplayObj(this);
		}
}
}
package Games.Map {
import com.MyClass.Config;

/**
 * 摄像机类
 * */
public class Map_Camera {
	private var Map:MAP_Instance;
	private var minX:int;
	private var maxX:int;
	private var minY:int;
	private var maxY:int;
	/** 摄像机的半径 */
	public var cameraW:int =Config.stageScaleInfo["屏幕w"]/2;
	public var cameraH:int =Config.stageScaleInfo["屏幕h"]/2;
	/** 当前摄像机的中心点 */
	public var nowX:Number=0;
	public var nowY:Number=0;
	
	public function Map_Camera(map:MAP_Instance) {
		this.Map=map;
		minX=this.Map.data.rec.x0+cameraW;
		maxX=this.Map.data.rec.x1-cameraW;
		minY=this.Map.data.rec.y0+cameraH;
		maxY=this.Map.data.rec.y1-cameraH;
		updataF();
	}
	/**
	 * 帧频，由map调用
	 * */
	public function enterF():void{
		updataF();
	}
	private function updataF():void{
		if(this.Map.mainRole==null){return;}
		nowX=this.Map.mainRole.x;
		nowY=this.Map.mainRole.y;
		if(nowX<minX){nowX=minX;}
		else if(nowX>maxX){nowX=maxX;}
		if(nowY<minY){nowY=minY;}
		else if(nowY>maxY){nowY>maxY;}
		this.Map.x =-nowX+cameraW;
		this.Map.y =-nowY+cameraH
	}
	
	public function destroyF():void{
		this.Map=null;
	}
}
}

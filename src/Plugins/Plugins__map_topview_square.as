package Plugins{
import com.MyClass.Config;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Fuben.MAP_Ground;
import Games.Fuben.MAP_Item;

import starling.display.Sprite;
	
public class Plugins__map_topview_square{
	/**
	 * 顶视图地图，方形地面，马斯卡卷轴显示
	 * @param _layerg 地面层
	 * @param _layerup 人物和物体层
	 * @param _showRec 显示区域的宽度和高度：width，height
	 * @param _infoMaps 地图的数据，w0=int(单个地面的宽度),h0=int(单个地面的高度)；行数=int，地面=Array(一维数组 || 二维数组)，地面资源。物品，物品资源
	 * @param _option 其他配置
	 */
	private var Map:*;
	private var LayerG:Sprite;
	private var LayerUp:Sprite;
	private var showRec:*;
	private var infoMaps:*;
	private var option:*;
	private var is二维数组:Boolean;
	public var allRow:int;
	public var allColumn:int;
	public var mainRole:*;//目标中心
	public var cameraTar:* ={"x":0,"y":0};//镜头中心，跟随目标中心
	public var dicGroundShowing:* ={};//正在显示的
	public var FunChanged:*;//移动后调用
	
	public var moveSpeed:Number=99999;//默认无延迟
	public var infoNull:*;//编辑器专用，用来显示NULL的地图
	
	public var dicGroundImg:* ={};
	public var dicItemImg:* ={};
	public var numShow行:int;//需要显示的基本行列数量，正式显示需要+-1
	public var numShow列:int;
	private var numShow行half:int;
	private var numShow列half:int;
	public var last行:int=-99;
	public var last列:int=-99;
	private var moveLimite:*;
	public var roleMoveLimite:*;
	private var forceRefresh:Boolean=false;
	public function Plugins__map_topview_square(_map:*,_layerg:Sprite,_layerup:Sprite,_showRec:*,_infoMaps:*,_option:*){
		Map=_map;
		LayerG=_layerg;
		LayerUp=_layerup;
		showRec=_showRec;
		infoMaps=_infoMaps;
		option=_option;
		numShow行=Tool_Function.on强制转换(showRec.height / infoMaps["h0"]);
		if(showRec.height % infoMaps["h0"] > 0){numShow行++;}
		numShow行half=Tool_Function.on强制转换(numShow行>>1);
		numShow列=Tool_Function.on强制转换(showRec.width / infoMaps["w0"]);
		if(showRec.width % infoMaps["w0"] > 0){numShow列++;}
		numShow列half=Tool_Function.on强制转换(numShow列>>1);

		onEditor_changeLimite();
	}
	/** 刷新宽高限制，仅在编辑器下使用 */
	public function onEditor_changeLimite():void{
		var widthAll:int;
		var heightAll:int;
		if(Tool_Function.isTypeOf(infoMaps["地面"][0],Array) == true){
			is二维数组=true;
			heightAll=infoMaps["地面"].length * infoMaps["h0"];
			widthAll=infoMaps["地面"][0].length * infoMaps["w0"];
			allRow =infoMaps["地面"].length;
			allColumn =infoMaps["地面"][0].length;
		}else{
			is二维数组=false;
			heightAll =infoMaps["行数"] * infoMaps["h0"];
			widthAll =infoMaps["地面"].length * infoMaps["w0"] / infoMaps["行数"];
			allRow =infoMaps["行数"];
			allColumn =infoMaps["地面"].length / infoMaps["行数"];
		}
		if(option && option["边缘限制"]==true){//视觉中心的范围不能让地图出现边缘
			moveLimite={};
			moveLimite["minx"]=showRec["width"]/2;
			moveLimite["maxx"]=widthAll-showRec["width"]/2;
			moveLimite["miny"]=showRec["height"]/2;
			moveLimite["maxy"]=heightAll-showRec["height"]/2;
		}else{//可以显示边缘
			moveLimite={};
			moveLimite["minx"]=0;
			moveLimite["maxx"]=widthAll;
			moveLimite["miny"]=0;
			moveLimite["maxy"]=heightAll;
		}
		roleMoveLimite={"minx":0,"maxx":widthAll,"miny":50,"maxy":heightAll};//miny：50，一般角色脚底为中心，为0则还是出屏幕了
		dicGroundImg=Tool_ObjUtils.getInstance().destroyF_One(dicGroundImg);
		dicGroundImg={};
		dicItemImg=Tool_ObjUtils.getInstance().destroyF_One(dicItemImg);
		dicItemImg={};
		last行=-9999;
	}
	/** 仅当在平移摄像机时才调用 */
	public function enterF():void{
		onCheckCameraPosition();
		on刷新F();
	}
	public function onLimiteRole(role:*):void{
		var mainx:int=role.x;
		var mainy:int=role.y;
		if(moveLimite && moveLimite["minx"]!=null && mainx < moveLimite["minx"]){
			role.x=moveLimite["minx"];
		}else if(moveLimite && moveLimite["maxx"]!=null && mainx > moveLimite["maxx"]){
			role.x=moveLimite["maxx"];
		}
		if(moveLimite && moveLimite["miny"]!=null && mainy < moveLimite["miny"]){
			role.y=moveLimite["miny"];
		}else 	if(moveLimite && moveLimite["maxy"]!=null && mainy > moveLimite["maxy"]){
			role.y=moveLimite["maxy"];
		}
	}
	private var maxCameraX:int =Config.stageScaleInfo["屏幕w"]/2;
	private var maxCameraY:int =Config.stageScaleInfo["屏幕h"]/2;
	private function onCheckCameraPosition():void{
		if(mainRole!=null && cameraTar!=null){
			//计算目标和镜头距离
			if(mainRole.x == cameraTar.x && mainRole.y==cameraTar.y){return;}
			var lx:Number = mainRole.x - cameraTar.x;
			var ly:Number =mainRole.y - cameraTar.y;
			if(lx > 0){
				if(lx > maxCameraX+moveSpeed){
					cameraTar.x +=lx-maxCameraX;
				}
				else if(lx>=moveSpeed){
					cameraTar.x += moveSpeed;
				}else{
					cameraTar.x =mainRole.x;
				}
			}else if(lx < 0){
				if(-lx > maxCameraX+moveSpeed){
					cameraTar.x -=(lx-maxCameraX);
				}
				else if(-lx >= moveSpeed){
					cameraTar.x -= moveSpeed;
				}else{
					cameraTar.x =mainRole.x;
				}
			}
			if(ly > 0){
				if(ly > maxCameraY+moveSpeed){
					cameraTar.y +=ly-maxCameraY;
				}
				else if(ly>=moveSpeed){
					cameraTar.y += moveSpeed;
				}else{
					cameraTar.y =mainRole.y;
				}
			}else if(ly < 0){
				if(-ly > maxCameraY+moveSpeed){
					cameraTar.y -=(ly-maxCameraY);
				}
				else if(-ly >= moveSpeed){
					cameraTar.y -= moveSpeed;
				}else{
					cameraTar.y =mainRole.y;
				}
			}
		}
	}
	
	public function on刷新F():void{
		if(cameraTar==null){return;}
		//计算行列
		var 行:int=0;
		var 列:int=0;
		var mainx:int=cameraTar.x;
		var mainy:int=cameraTar.y;
		if(moveLimite && moveLimite["minx"]!=null && mainx < moveLimite["minx"]){
			mainx=moveLimite["minx"];
		}else if(moveLimite && moveLimite["maxx"]!=null && mainx > moveLimite["maxx"]){
			mainx=moveLimite["maxx"];
		}
		if(moveLimite && moveLimite["miny"]!=null && mainy < moveLimite["miny"]){
			mainy=moveLimite["miny"];
		}else 	if(moveLimite && moveLimite["maxy"]!=null && mainy > moveLimite["maxy"]){
			mainy=moveLimite["maxy"];
		}
		LayerG.x =showRec["width"]/2 -mainx;
		LayerG.y =showRec["height"]/2-mainy;
		LayerUp.x =LayerG.x;
		LayerUp.y =LayerG.y;
		var row:int =Tool_Function.on强制转换(mainy / infoMaps["h0"]);
		var column:int=Tool_Function.on强制转换(mainx / infoMaps["w0"]);
		//根据视觉中心计算出左上角
		行=row - numShow行half;
		列=column - numShow列half;
		if(行==last行 && 列==last列){}
		else{
			onShowF(行,列);
		}
	}
	/** 手动改变某个位置的地面，编辑器使用 */
	public function onChangeOneGround(row:int,column:int, type:String):void{
		if(row>=last行-1 && row<=numShow行+1+last行 && column>=last列-1 && column<=numShow列+1+last列){
			var arr:Array =dicGroundImg[row];
			if(arr[column]!=null){
				removeOne(getGroundValueByRC(row,column),arr[column]);
				arr[column]=null;
			}
			infoMaps["地面"][row][column]=type;
			var gtype:* =type;
			arr[column]=getNewOneGround(gtype);
			if(arr[column]){
				arr[column].x =infoMaps["w0"] * column;
				arr[column].y =infoMaps["h0"] * row;
			}
		}
	}
	/** 手动改变某个位置的物品，编辑器使用 */
	public function onChangeOneItem(row:int,column:int, type:String):void{
		if(row>=last行-1 && row<=numShow行+1+last行 && column>=last列-1 && column<=numShow列+1+last列){
			var arr:Array =dicItemImg[row];
			if(arr[column]!=null){
				removeOneItem(getItemValueByRC(row,column),arr[column]);
				arr[column]=null;
			}
			infoMaps["物品"][row][column]=type;
			var gtype:* =type;
			arr[column]=getNewOneItem(gtype);
			if(arr[column]){
				arr[column].x =infoMaps["w0"] * column;
				arr[column].y =infoMaps["h0"] * row;
				arr[column].row =row;
				arr[column].col =column;
			}
		}
	}
	
	private function onShowF(new行:int,new列:int):void{
		Tool_ObjUtils.getInstance().onClearObj(dicGroundShowing);
		for(var i:int=0;i<numShow行+2;i++){
			var row:int =last行-1 + i;
			var arr:Array =dicGroundImg[row];
			if(arr){
				var arr2:Array =dicItemImg[row];
				for(var j:int=0;j<arr.length;j++){
					var column:int =last列-1 + j;
					if(row>=new行-1 && row<=numShow行+1+new行 && column>=new列-1 && column<=numShow列+1+new列){
						continue;
					}
					if(arr[column]!=null){
						removeOne(getGroundValueByRC(row,column),arr[column]);
						arr[column]=null;
						if(arr2 && arr2[column]!=null){
							removeOneItem(getItemValueByRC(row,column),arr2[column]);
							arr2[column]=null;
						}
					}
				}
			}
		}
		for(i=0;i<numShow行+2;i++){
			row =new行-1 + i;
			arr =dicGroundImg[row];
			if(arr==null){
				arr=[];
				dicGroundImg[row]=arr;
			}
			arr2=dicItemImg[row];
			if(arr2==null){
				arr2=[];
				dicItemImg[row]=arr2;
			}
			dicGroundShowing[row]=Tool_ObjUtils.getNewObjectFromPool();
			for(j=0;j<numShow列+2;j++){
				column =new列-1 + j;
				dicGroundShowing[row][column]=true;
				if(arr[column]==null){
					if(row<0 || column<0){	continue;	}
					if(row >= infoMaps["地面"].length){continue;}
					if(column>=infoMaps["地面"][row].length){continue;}
					var gtype:* =getGroundValueByRC(row,column);
					arr[column]=getNewOneGround(gtype);
					if(arr[column]){
						arr[column].x =infoMaps["w0"] * column;
						arr[column].y =infoMaps["h0"] * row;
					}
					if(arr2[column]==null){
						var itype:* =getItemValueByRC(row,column);
						arr2[column]=getNewOneItem(itype);
						if(arr2[column]){
							arr2[column].row =row;
							arr2[column].col =column;
							arr2[column].x =infoMaps["w0"] * column;
							arr2[column].y =infoMaps["h0"] * row;
							var tmpdic:* =infoMaps;
							if(infoMaps["组件"] && infoMaps["组件"][row+":"+column]){
								var info:* =infoMaps["组件"][row+":"+column];
								var zname:String =info["Name"];
								if(infoMaps["组件属性"] && infoMaps["组件属性"][zname]){
									info["默认数据"] = infoMaps["组件属性"][zname];
								}
								arr2[column].comp =info;
							}
						}
					}
				}
			}
		}
		last行=new行;
		last列=new列;
		if(FunChanged)Tool_Function.onRunFunction(FunChanged);
	}
	
	public function getGroundValueByRC(row:int,column:int):*{
		if(row<0 || column<0){return null;}
		if(is二维数组==true){
			if(row >= infoMaps["地面"].length){return null;}
			var arr:Array =infoMaps["地面"][row];
			if(column>=arr.length){return null;}
			return arr[column];
		}else{
			var index:int =row * infoMaps["行数"] + column;
			if(index>=infoMaps["地面"].length){return null;}
			return infoMaps["地面"][index];
		}
	}
	public function getGroundObjectByRC(row:int,col:int):MAP_Ground{
		var arr:Array =dicGroundImg[row];
		if(arr && arr[col]){
			return arr[col];
		}
		return null;
	}
	public function getItemValueByRC(row:int,column:int):*{
		if(row<0 || column<0){return null;}
		if(is二维数组==true){
			if(row >= infoMaps["物品"].length){return null;}
			var arr:Array =infoMaps["物品"][row];
			if(arr==null || column>=arr.length){return null;}
			return arr[column];
		}else{
			var index:int =row * infoMaps["行数"] + column;
			if(index>=infoMaps["物品"].length){return null;}
			return infoMaps["物品"][index];
		}
	}
	public function getItemObjectByRC(row:int,col:int):MAP_Item{
		var arr:Array =dicItemImg[row];
		if(arr && arr[col]){
			return arr[col];
		}
		return null;
	}
	private function getNewOneGround(value:*):*{
		if(value==null){
			return null;
		}
		var info:* =infoMaps["地面资源"][value];
		if(info==null){return null;}
		info=Tool_ObjUtils.getInstance().CopyF(info);
		for(var key:* in infoMaps["地面属性"]){
			if(info[key]==null) {
				info[key] = infoMaps["地面属性"][key];
			}
		}
		var one:MAP_Ground =MAP_Ground.getOne(info);
		LayerG.addChild(one);
		return one;
	}
	private function getNewOneItem(value:*):*{
		if(value==null){
			return null;
		}
		var info0:* =infoMaps["物品资源"][value];
		if(info0==null){return null;}
		var info:* =Tool_ObjUtils.getInstance().CopyF(info0);
		for(var key:* in infoMaps["物品属性"]){
			if(info[key]==null) {
				info[key] = infoMaps["物品属性"][key];
			}
		}
		var one:MAP_Item =MAP_Item.getOne(info);
		one.map=Map;
		if(one.getValue("底层")==false){
			LayerUp.addChild(one);
		}else{
			LayerG.addChild(one);
		}
		return one;
	}
	private function removeOne(value:*,img:*):void{
		if(img==null){return;}
		MAP_Ground.removeOne(img);
	}
	private function removeOneItem(value:*,img:*):void{
		if(img==null){return;}
		MAP_Item.removeOne(img);
	}
	
	//========================================
	public function destroyF():void{
		Map=null;
		LayerG=null;
		LayerUp=null;
		dicGroundImg=Tool_ObjUtils.getInstance().destroyF_One(dicGroundImg);
		MAP_Item.destroyF();
		MAP_Ground.destroyF();
	}
}
}
package  Games.Map.Datas {
import com.MyClass.Tools.Tool_SpriteUtils;

import lzm.starling.swf.display.SwfImage;

/**
 * 碰撞区域数据
 * */
public class MapData_HitArea {
    private static const Type_Muti:int=4;
    private static const Type_Rec:int=1;
    private static const Type_Cir:int=2;
    private static const Type_Ell:int=3;
    public var type:int;//矩形，圆，椭圆，多重
    //多重
    private var Arr_areas:Array;
    //椭圆：到两个中心点的距离之和为固定值2a，焦点坐标(-c,0),(c,0)，c²=a²-b²。x轴更长时：x²/a²+y²/b²=1
    private var E_a:Number;//长轴半径
    private var E_b:Number;//短轴半径
    private var E_middle:*;//中心点
    //圆
    private var P0:*;//中心点
    private var radius:int;//半径
    //矩形
    private var rec:*;//x0,x1,y0,y1
    
    public function MapData_HitArea() {
    }
    
    /** 从获得的碰撞元件rec来初始化 */
    public function initFromArr(arr:Array):void{
        if(arr.length>1){
            type=Type_Muti;
            Arr_areas=[];
            for(var i:int=0;i<arr.length;i++){
                Arr_areas[i]=new MapData_HitArea();
                Arr_areas[i].initFromArr([arr[i]]);
            }
        }else{
            var img:SwfImage =arr[0];
            if(img.classLink.indexOf("圆")!=-1){
                if(img.width==img.height) {
                    type=Type_Cir;
                    radius=img.width/2;
                    P0 ={x:int(radius + img.x),"y":int(radius+img.y)};
                }else {
                    type = Type_Ell;
                    E_middle={x:int(img.width/2 + img.x),y:int(img.height/2+img.y)};
                    if(img.width>img.height) {
                        E_a = img.width / 2;
                        E_b =img.height/2;
                    }else{
                        E_a=img.height/2;
                        E_b=img.width/2;
                    }
                    E_a=Number(E_a.toFixed(2));
                    E_b=Number(E_b.toFixed(2));
                }
            }
            else{
                type=Type_Rec;
                var rec2:* =Tool_SpriteUtils.getBounds(img,img.parent);
                rec={"x0":int(rec2.x),"x1":int(rec2.x+rec2.width),"y0":int(rec2.y),"y1":int(rec2.y+rec2.height)};
            }
        }
    }
    
    /** 导出数据 */
    public function getJson():String{
        var info:* ={"type":type};
        if(type==Type_Rec){
            info["rec"]=rec;
        }else if(type==Type_Cir){
            info["p"]=P0;
            info["r"]=radius;
        }else if(type==Type_Ell){
            info["a"]=E_a;
            info["b"]=E_b;
            info["p"]=E_middle;
        }else{
            var str:String='{"type":'+type+',"arr":[';
            for(var i:int=0;i<Arr_areas.length;i++){
                if(i>0)str+=",";
                str+=(Arr_areas[i]as MapData_HitArea).getJson();
            }
            str+="]}";
            return str;
        }
        return JSON.stringify(info);
    }
    
    /** 从导出的json格式初始化 */
    public function initFromDic(dic:*):void{
        type=dic["type"];
        if(type==Type_Rec){
            rec=dic["rec"];
        }else if(type==Type_Cir){
            P0=dic["p"];
            radius=dic["r"];
        }else if(type==Type_Ell){
            E_a=dic["a"];
            E_b=dic["b"];
            E_middle=dic["p"];
        }else{
            Arr_areas=[];
            for(var i:int=0;i<dic["arr"].length;i++){
                Arr_areas[i]=new MapData_HitArea();
                Arr_areas[i].initFromDic(dic["arr"][i]);
            }
        }
    }
    
}
}

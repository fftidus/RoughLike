package Games.Map.Datas {
/**
 * 图块的公用数据
 * */
public class MapData_Grip {
    /** 图块的as链接，等于classLink */
    public var Url:String;
    /** 所属swf的名字 */
    public var swf:String;
	/** 图块显示的外框 {"x0":rec.x,"x1":rec.x+rec.width,"y0":rec.y,"y1":rec.y+rec.height} */
	public var rec:*;
    /** 图块的碰撞区域 */
    public var hitRec:MapData_HitArea;
    
    public function MapData_Grip() {
    }
    public function initFromDic(dic:*):void{
        swf=dic["swf"];
        Url=dic["Url"];
        rec=dic["rec"];
        if(dic["hitRec"]) {
            hitRec=new MapData_HitArea();
            hitRec.initFromDic(dic["hitRec"]);
        }
    }
    public function initFromOther(other:MapData_Grip):void{
        swf=other["swf"];
        Url=other["Url"];
        rec=other["rec"];
        hitRec=other.hitRec;
    }
    public function getJsonStr():String{
        var str:String="{";
        str+='"swf":'+JSON.stringify(swf);
        str+=',"Url":'+JSON.stringify(Url);
        str+=',"rec":'+JSON.stringify(rec);
        if(hitRec!=null) str+=',"hitRec":'+hitRec.getJson();
        str+="}";
        return str;
    }
}
}

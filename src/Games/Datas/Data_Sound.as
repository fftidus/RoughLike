package Games.Datas {
import com.MyClass.Tools.MyPools;

/**
 * 一个要播放的音效
 * */
public class Data_Sound {
    public static function getNewData(_name:String, _x:Number,_y:Number):Data_Sound{
        if(MyPools.getInstance().hasPool("音效数据")==false){
            MyPools.getInstance().registF("音效数据",20);
        }
        var one:Data_Sound =MyPools.getInstance().getFromPool("音效数据");
        if(one==null){
            one=new Data_Sound();
        }
        one.Name=_name;
        one.x=_x;
        one.y=_y;
        return one;
    }
    
    public var Name:String;
    public var x:Number;
    public var y:Number;
    public function Data_Sound() {
    }
    
    public function destroyF():void{
        return MyPools.getInstance().returnToPool("音效数据",this);
    }
}
}

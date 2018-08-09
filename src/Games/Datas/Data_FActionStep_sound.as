package Games.Datas {
import com.MyClass.Tools.Tool_ObjUtils;

public class Data_FActionStep_sound {
    
    public var dicFrame:*;
    public function Data_FActionStep_sound() {
    }
    public function initF(dic:*):void{
        //{"Name":"runstep","frame":[0,12]}
        if(dic==null || dic["frame"]==null)return;
        dicFrame=Tool_ObjUtils.getNewObjectFromPool();
        if(dic["frame"][0] is Array){
            for(var i:int=0;i<dic["frame"].length;i++){
                for(var j:int=0;j<dic["frame"][i].length;j++) {
                    var Name:String;
                    if (dic["Name"] is Array) Name = dic["Name"][i];
                    else Name = dic["Name"];
                    dicFrame[dic["frame"][i][j]]=Name;
                }
            }
        }else{
            for(i=0;i<dic["frame"].length;i++){
                if (dic["Name"] is Array) Name = dic["Name"][i];
                else Name = dic["Name"];
                dicFrame[dic["frame"][i]]=Name;
            }
        }
    }
    
    public function destroyF():void{
        dicFrame=Tool_ObjUtils.destroyF_One(dicFrame);
    }
}
}

package Games.Datas {
import StaticDatas.SData_Skills;

public class Data_Skill {
    public var Name:String;
    public var SID:int;
    public var Type:String;//攻击，被动，辅助
    //被动
    public var buffPassive:Array;//被动buff
    public var isPassive:Boolean=false;
    //主动
    public var cd:int;
    public var costValue:String;
    public var costNum:int;
    public var buffTar:Array;//给作用目标添加的buff
    public var buffSelf:Array;//是施法者自身添加的buff
    //动作
    public var Step:Data_FActionStep;
    
    public function Data_Skill(id:int) {
        SID=id;
        var dic:* =SData_Skills.getInstance().Dic[SID];
        if(dic){
            Name =dic["Name"];
            Type=dic["Type"];
            isPassive=dic["Type"]=="被动";
            if(isPassive==false) {
                cd = dic["CD"];
                costValue = dic["costValue"];
                costNum = dic["cost"];
                Step=new Data_FActionStep(dic["step"]);
                
            }
            if(dic["buff被动"]!=null){
                buffPassive=[];
                for(var i:int =0 ;i<dic["buff被动"].length;i++){
                    buffPassive.push(new Data_Buff(dic["buff被动"][i]));
                }
            }
            if(dic["buff目标"]!=null){
                buffTar=[];
                for(var i:int =0 ;i<dic["buff目标"].length;i++){
                    buffTar.push(new Data_Buff(dic["buff目标"][i]));
                }
            }
            if(dic["buff自身"]!=null){
                buffSelf=[];
                for(var i:int =0 ;i<dic["buff自身"].length;i++){
                    buffSelf.push(new Data_Buff(dic["buff自身"][i]));
                }
            }
        }
    }
    
}
}

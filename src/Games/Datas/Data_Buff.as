package Games.Datas {
import com.MyClass.Tools.Tool_Function;

public class Data_Buff {
    public var ID:int;
    public var Name:String;
    public var strIntro:String;
    public var isBad:Boolean=false;
    public var TypeCreat:String;
    public var TypeLast:String;//持续
    public var TypeAct:String;//生效条件
    public var TypeActNeed:String;//生效判定对象
    public var TypeCheckTime:String;
    public var TypeEffect:String;
    
    public var lastRounds:int;
    public var TypeSuperpose:String;//buff叠加的方式：不叠加，叠加，不允许重复
    public var dicSpeValues:*;

    public var dic_values:*;
    
    public function Data_Buff(dic:*) {
        if(Tool_Function.isTypeOf(dic,Number)){
            
        }
    }
}
}

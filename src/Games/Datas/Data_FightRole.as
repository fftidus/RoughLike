package Games.Datas {
import com.MyClass.Config;
import com.MyClass.Tools.MyCheaterNumMultiple;
import com.MyClass.Tools.Tool_ObjUtils;

public class Data_FightRole {
    /** 注册一个新属性
     * @param type 属性的类型：血魔（第一次赋值会添加max），基础
     * */
    public static function registValue(vname:String,    type:String="基础"):void{
        if(DicNewValue==null)DicNewValue={};
        DicNewValue[vname]=type;
    }
    private static var DicNewValue:*;
    /****************************************************************************************/
    
    public var DicValue:* =Tool_ObjUtils.getNewObjectFromPool();
    public var DicOther:*;
    private var dicChanged:* =Tool_ObjUtils.getNewObjectFromPool();
    /** 防修改 */
    private var safeNum:MyCheaterNumMultiple=new MyCheaterNumMultiple(2);
    
    public function Data_FightRole() {
    }
    /**
     * 使用dic初始化
     * */
    public function initFromDic(dic:*):void{
        if(dic==null){return;}
        for(var key:String in dic){
            setValue(key,dic[key]);
        }
    }
    /**
     * 使用名字直接赋值
     * */
    public function setValue(key:String,value:int):void{
        switch (key){
            case "_hp":
            case "生命":
                hp=value;
                hpMax=value;
                break;
            case "_mp":
            case "魔法":
                mp=value;
                mpMax=value;
                break;
            case "怒气":
                anger=value;
                angerMax=value;
                break;
            case "物攻":  atkPhy=value;break;
            case "魔攻":  atkMag=value;break;
            case "物防":  defPhy=value;break;
            case "魔防":  defMag=value;break;
            case "命中":  hit=value;break;
            case "闪避":  miss=value;break;
            case "暴击率":  criticalPer=value;break;
            case "暴击值":  criticalNum=value;break;
            case "移速":  spdMove=value;break;
            case "攻击速度":  spdPhy=value;break;
            case "释放速度":  spdMag=value;break;
            case "硬直":  hitRecover=value;break;
            case "物攻加成":  perPhy=value;break;
            case "魔攻加成":  perMag=value;break;
            case "伤害加成":  perAtk=value;break;
            case "物理减免":  reliefPhy=value;break;
            case "魔法减免":  reliefMag=value;break;
            case "伤害减免":  reliefDamage=value;break;
            case "毒抗":      resistancePoison=value;break;
            case "眩晕抗性":  resistanceStun=value;break;
            default:
                    if(DicNewValue && DicNewValue[key]!=null) {
                        if (DicOther == null) DicOther = Tool_ObjUtils.getNewObjectFromPool();
                        DicOther[key] = value;
                        safeNum.setValue(key,value);
                        if(DicNewValue[key]!="基础"){
                            DicOther[key+"Max"]=value;
                            safeNum.setValue(key+"Max",value);
                        }
                    }else{
                        Config.Log("未注册的属性："+key);
                    }
                break;
        } 
    }
    
    public function getValueByName(vname:String):int{
        if(dicChanged[vname]==true && safeNum){
            if(safeNum.checkF(vname,DicValue[vname]) == false){
                Config.onThrowError(vname+"属性错误(get)！");
            }
            dicChanged[vname]=false;
        }
        return DicValue[vname];
    }
    public function setValueByName(vname:String,value:int):void{
        if(safeNum && safeNum.checkF(vname,DicValue[vname]) == false){
            Config.onThrowError(vname+"属性错误(set)！");
        }
        DicValue[vname] = value;
        if(safeNum){
            safeNum.setValue(vname,value);
            dicChanged[vname]=true;
        }
    }
    public function destroyF():void{
        DicValue=Tool_ObjUtils.destroyF_One(DicValue);
        DicOther=Tool_ObjUtils.destroyF_One(DicOther);
        safeNum=Tool_ObjUtils.destroyF_One(safeNum);
        dicChanged=Tool_ObjUtils.destroyF_One(dicChanged);
    }
    
    //消耗型数据
    public function get hp():int {  return getValueByName("hp");  }
    public function set hp(value:int):void {  setValueByName("hp",value); }
    public function get hpMax():int { return getValueByName("hpMax"); }
    public function set hpMax(value:int):void { setValueByName("hpMax",value); }
    public function get mp():int { return getValueByName("mp"); }
    public function set mp(value:int):void {  setValueByName("mp",value); }
    public function get mpMax():int { return getValueByName("mpMax"); }
    public function set mpMax(value:int):void {  setValueByName("mpMax",value); }
    public function get anger():int {  return getValueByName("anger");  }
    public function set anger(value:int):void { setValueByName("anger",value);  }
    public function get angerMax():int {  return getValueByName("angerMax");  }
    public function set angerMax(value:int):void { setValueByName("angerMax",value); }
    //基础型数据
    public function get atkPhy():int { return getValueByName("atkPhy"); }
    public function set atkPhy(value:int):void {  setValueByName("atkPhy",value); }
    public function get atkMag():int { return getValueByName("atkMag"); }
    public function set atkMag(value:int):void {  setValueByName("atkMag",value); }
    public function get defPhy():int {  return getValueByName("defPhy");  }
    public function set defPhy(value:int):void {  setValueByName("defPhy",value); }
    public function get defMag():int {  return getValueByName("defMag");  }
    public function set defMag(value:int):void {  setValueByName("defMag",value); }
    public function get hit():int { return getValueByName("hit"); }
    public function set hit(value:int):void { setValueByName("hit",value);  }
    public function get miss():int {  return getValueByName("miss"); }
    public function set miss(value:int):void { setValueByName("miss",value); }
    public function get criticalPer():int {  return getValueByName("暴击率"); }
    public function set criticalPer(value:int):void {  setValueByName("暴击率",value); }
    public function get criticalNum():int {  return getValueByName("暴击值"); }
    public function set criticalNum(value:int):void {  setValueByName("暴击值",value); }
    public function get spdMove():int {  return getValueByName("移速"); }
    public function set spdMove(value:int):void {  setValueByName("移速",value); }
    public function get spdPhy():int {  return getValueByName("攻速"); }
    public function set spdPhy(value:int):void {  setValueByName("攻速",value); }
    public function get spdMag():int {  return getValueByName("释放速度"); }
    public function set spdMag(value:int):void {  setValueByName("释放速度",value); }
    public function get hitRecover():int {  return getValueByName("硬直"); }
    public function set hitRecover(value:int):void {  setValueByName("硬直",value); }
    //加成型数据
    public function get perPhy():int {  return getValueByName("perPhy"); }
    public function set perPhy(value:int):void {  setValueByName("perPhy",value); }
    public function get perMag():int {  return getValueByName("perMag"); }
    public function set perMag(value:int):void {  setValueByName("perMag",value); }
    public function get perAtk():int {  return getValueByName("perAtk"); }
    public function set perAtk(value:int):void {  setValueByName("perAtk",value); }
    public function get reliefPhy():int { return getValueByName("物理减免"); }
    public function set reliefPhy(value:int):void { setValueByName("物理减免",value); }
    public function get reliefMag():int { return getValueByName("魔法减免"); }
    public function set reliefMag(value:int):void { setValueByName("魔法减免",value); }
    public function get reliefDamage():int { return getValueByName("伤害减免"); }
    public function set reliefDamage(value:int):void { setValueByName("伤害减免",value); }
    //抗性数据
    public function get resistancePoison():int { return getValueByName("毒抗"); }
    public function set resistancePoison(value:int):void { setValueByName("毒抗",value); }
    public function get resistanceStun():int {  return getValueByName("晕抗"); }
    public function set resistanceStun(value:int):void { setValueByName("晕抗",value); }
    
}
}

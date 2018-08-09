package Games.Models {
import com.MyClass.Config;
import com.MyClass.MySourceManager;
import com.MyClass.MyView.LayerStarlingManager;
import com.MyClass.MyView.LoadingSmall;
import com.MyClass.MyView.MyViewBtnController;
import com.MyClass.MyView.MyViewSlideMCs;
import com.MyClass.MyView.MyViewTXController;
import com.MyClass.MyView.TmpMovieClip;
import com.MyClass.Tools.AlertWindow;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import CMD.CMD500;

import StaticDatas.SData_Strings;

import laya.utils.Handler;

import lzm.starling.swf.display.SwfMovieClip;

import starling.display.Sprite;

/**
 * 邮件模块，本身就是一个页面
 * */
public class MailModel{
    //静态
    private static var Arr_mails:Array;
    private static var instance:MailModel;
    public static var info_AniGetMail:*;//获得邮件的动画
    private var C500:CMD500 =new CMD500();
    //显示
    public var busy:Boolean=false;
    private var Fun:*;
    private var sprBack:Sprite;
    private var mt:MyViewTXController;
    private var mbc:MyViewBtnController;
    private var ms:MyViewSlideMCs;
    private var Arr_one:Array=[];
    //附件
    private var sprGift:Sprite;
    private var imgGiftGet:*;//已领取
    private var mbcGift:MyViewBtnController;
    private var Arr_gift:Array;
    public var FunShowIcon:*;//显示附件图标的方法，默认初始化IconModel
    public var FunInitGiftObject:*;//生成附件物品的方法，默认初始化gameObject
    //操作
    private var nowID:* =null;

    public function MailModel() {
        if(instance!=null){
            Config.onThrowError("重复的邮件模块！");
            return;
        }
        instance=this;
        C500.funAddListener(Handler.create(this,netF,null,false),false);
    }
    private function netF(dic:*):void{
        for(var key:String in dic){
            if(key=="邮件"){//全部刷新
                Arr_mails=[];
                for(var uid:int in dic[key]){
                    if(dic[key][uid]==null){continue;}
                    var data:MailModelDataOne=new MailModelDataOne(dic[key][uid]);
                    getOne(data);
                }
                Arr_mails.sort(function (data1:MailModelDataOne,data2:MailModelDataOne):Number{
                    if(data1.ID>0 && data2.ID>0){
                        if(data1.ID>data2.ID)return -1;
                        return 1;
                    }else{
                        var sec:int =Tool_Function.onDate_getBetween(data1.dateSend,data2.dateSend,"秒");
                        if(sec<0)return 1;
                        return -1;
                    }
                });
                onRefreshF();
            }
            else if(key=="收到邮件"){
                for(uid in dic[key]){
                    if(dic[key][uid]==null){continue;}
                    data=new MailModelDataOne(dic[key][uid]);
                    getOne(data);
                }
                onRefreshF();
                if(info_AniGetMail){
                    var swf:String=SData_Strings.SWF_DefaultUI;
                    if(info_AniGetMail["swf"]){
                        swf=info_AniGetMail["swf"];
                    }
                    var mc:SwfMovieClip=MySourceManager.getInstance().getMcFromSwf(swf,info_AniGetMail["url"]);
                    if(mc){
                        var tmc:TmpMovieClip=new TmpMovieClip(mc);
                        LayerStarlingManager.instance.LayerTop.addChild(tmc);
                    }
                }
            }
            else if(key=="修改状态"){
                for(uid in dic[key]) {
                    if(dic[key][uid]==null){continue;}
                    data = getDataByNID(uid);
                    if(data!=null && data.Flag != dic[key][uid]){
                        data.Flag=dic[key][uid];
                        var one:MailModelOne=getOneByNID(uid);
                        if(one){
                            one.onShowFlag();
                            if(nowID==uid){
                                onClickOneMail(getDataIndexByNID(uid));
                            }
                        }
                    }
                }
            }
            else if(key=="邮件领取"){
                busy=false;
                LoadingSmall.removeF();
                if(dic[key]["结果"]==false){
                    Tool_Function.onShowNetBadWindow(dic[key],null);
                }else {
                    netReadF();
                }
            }
            else if(key=="邮件删除"){
                for(var i:int=0;i<dic[key].length;i++){
                    uid=dic[key][i];
                    if(nowID==uid){nowID=null;}
                    var po:int =getDataIndexByNID(uid);
                    if(po != -1){
                        Arr_mails.removeAt(po);
                    }
                }
                onRefreshF();
            }
        }
    }
    private function getOne(data:MailModelDataOne):void{
        if(Arr_mails==null){
            Arr_mails=[];
        }
        Arr_mails.push(data);
    }
    /** 根据id查找邮件数据Index */
    private function getDataIndexByNID(id:int):int{
        if(Arr_mails==null)return -1;
        for(var i:int=0;i<Arr_mails.length;i++){
            var data:MailModelDataOne=Arr_mails[i];
            if(data.ID == id){return i;}
        }
        return -1;
    }
    /** 根据id查找邮件数据 */
    private function getDataByNID(id:int):MailModelDataOne{
        if(Arr_mails==null)return null;
        for(var i:int=0;i<Arr_mails.length;i++){
            var data:MailModelDataOne=Arr_mails[i];
            if(data.ID == id){return data;}
        }
        return null;
    }
    /** 根据id查找邮件显示元件 */
    private function getOneByNID(id:int):MailModelOne{
        if(Arr_one==null){return null;}
        for(var i:int=0;i<Arr_one.length;i++){
            var one:MailModelOne=Arr_one[i];
            if(one.data.ID == id){return one;}
        }
        return null;
    }

    /**
     * 初始化显示界面！
     * */
    public function initView(fend:*):void{
        if(sprBack!=null){
            Config.onThrowError("重复的邮件显示界面！");return;
        }
        Fun=fend;
        sprBack=MySourceManager.getInstance().getSprFromSwf(SData_Strings.SWF_DefaultUI,"spr_邮件");
        if(sprBack==null){
            AlertWindow.showF("邮件界面错误！",null);
            onClickUIF("btn_exit")
            return;
        }
        LayerStarlingManager.instance.LayerView.addChild(sprBack);
        Tool_Function.onWindowFitScreen(sprBack,4);
        mbc=new MyViewBtnController(sprBack,Handler.create(this,onClickUIF,null,false));
        ms=new MyViewSlideMCs(sprBack);
        mt=new MyViewTXController(sprBack);
        sprGift=sprBack.getChildByName("附件")as Sprite;
        mbcGift=new MyViewBtnController(sprGift,Handler.create(this,onClickMailBtnF,null,false));
        imgGiftGet=sprGift.getChildByName("已领取");
        Arr_gift=[];
        while(true){
            var onespr:Sprite=sprGift.getChildByName("mc"+(Arr_gift.length+1))as Sprite;
            if(onespr==null){break;}
            if(FunShowIcon){
                Arr_gift.push(Tool_Function.onRunFunction(FunShowIcon,onespr));
            }else{
                var one:IconModel=new IconModel(null,onespr,null);
                Arr_gift.push(one);
            }
        }
        mt.setText("tx_mail","");
        mt.setText("tx_time","");
        sprGift.visible=false;
        onRefreshF();
    }
    /** 修改了邮件，刷新界面 */
    private function onRefreshF():void{
        if(sprBack==null){return;}
        Arr_one=Tool_ObjUtils.destroyF_One(Arr_one);
        if(Arr_mails==null){return;}
        Arr_one=[];
        for(var i:int=0;i<Arr_mails.length;i++){
            var spr:Sprite=MySourceManager.getInstance().getSprFromSwf(SData_Strings.SWF_DefaultUI,ms.getOneClass_ByName("邮件"));
            var one:MailModelOne=new MailModelOne(spr,Arr_mails[i]);
            Arr_one[i]=one;
        }
        var lastY:int =ms.getSlide("邮件").Layer.y;
        ms.add按钮集("邮件",[Arr_one,Handler.create(this,onClickOneMail,null,false)]);
        ms.getSlide("邮件").setValue("改变y",lastY);
        if(nowID!=null){
            var po:int =getDataIndexByNID(nowID);
            onClickOneMail(po);
        }
    }

    private function onClickOneMail(n:int):void{
        if(busy){return;}
        if(nowID!=null){
            var one2:MailModelOne=getOneByNID(nowID);
            if(one2){
                one2.onSelectF(false);
            }
        }
        var one:MailModelOne=Arr_one[n];
        if(one==null){
            nowID=null;
            return;
        }
        nowID=one.data.ID;
        one.onSelectF(true);
        //显示详情
        mt.setText("tx_mail",one.data.strMessage);
        mt.setText("tx_time","有效期："+one.data.getLastTime());
        if(one.data.Arr_gift==null){
            sprGift.visible=false;
            imgGiftGet.visible=false;
            if(one.data.Flag==0){
                one.data.Flag=1;
                one.onShowFlag();
                var c500:CMD500=new CMD500();
                c500.writeValue_Dic("修改状态",{"邮件id":nowID});
                c500.sendF(false);
            }
        }else{
            sprGift.visible=true;
            if(one.data.Arr_gift==null || one.data.Arr_gift.length==0){
                mbcGift.onVisible("btn_提取附件",false);
            }else{
                mbcGift.onVisible("btn_提取附件",true);
            }
            for(var i:int=0;i<Arr_gift.length;i++){
                var icon:IconModel =Arr_gift[i];
                if(one.data.Arr_gift==null || one.data.Arr_gift.length<=i){
                    icon.visible=false;
                }else{
                    icon.visible=true;
                    var obj:*;
                    if(FunInitGiftObject==null){
                        obj=new GameObjectModel(one.data.Arr_gift[i]);
                    }else{
                        obj=Tool_Function.onRunFunction(FunInitGiftObject,one.data.Arr_gift[i]);
                    }
                    icon.initF(obj);
                }
            }
            if(one.data.Flag==0){
                imgGiftGet.visible=false;
            }else{
                imgGiftGet.visible=true;
            }
        }
    }

    /**
     * 点击了邮件详情内的按钮
     * */
    public function onClickMailBtnF(btn:String):void{
        if(busy){return;}
        if(btn=="btn_提取附件"){
            var data:MailModelDataOne = getDataByNID(nowID);
            if(data==null || data.Arr_gift==null){
                return;
            }
            busy=true;
            LoadingSmall.showF();
            var s500:CMD500=new CMD500();
            s500.writeValue_Dic("邮件领取",{"id":nowID});
            s500.sendF();
        }

    }
    /** 领取奖励完成 */
    private function netReadF():void{
        //TODO 显示获得物品的弹窗
        var data:MailModelDataOne = getDataByNID(nowID);
        if(data!=null){
            data.Flag=1;
            var one:MailModelOne=getOneByNID(nowID);
            if(one){
                one.onShowFlag();
                onClickOneMail(getDataIndexByNID(nowID));
            }
        }
    }


    private function onClickUIF(btn:String):void{
        if(busy){return;}
        if(btn=="btn_exit"){
            Tool_Function.onRunFunction(this.Fun);
            clearView();
        }
    }

    public function clearView():void{
        sprBack=Tool_ObjUtils.destroyF_One(sprBack);
        mt=Tool_ObjUtils.destroyF_One(mt);
        mbc=Tool_ObjUtils.destroyF_One(mbc);
        ms=Tool_ObjUtils.destroyF_One(ms);
        Arr_one=Tool_ObjUtils.destroyF_One(Arr_one);
        sprGift=Tool_ObjUtils.destroyF_One(sprGift);
        Fun=Tool_ObjUtils.destroyF_One(Fun);
    }
    public function destroyF():void{
        clearView();
        instance=null;
        C500=Tool_ObjUtils.destroyF_One(C500);
        FunShowIcon=Tool_ObjUtils.destroyF_One(FunShowIcon);
        FunInitGiftObject=Tool_ObjUtils.destroyF_One(FunInitGiftObject);
    }
}
}

import com.MyClass.MyView.MyViewTXController;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;
import starling.display.Sprite;
class MailModelOne extends Sprite{
    private var sprBack:Sprite;
    public var data:MailModelDataOne;
    private var imgClose:*;
    private var imgOpen:*;
    private var mcSelect:*;
    private var mt:MyViewTXController;
    public function MailModelOne(spr:Sprite,_data:MailModelDataOne){
        sprBack=spr;
        this.addChild(sprBack);
        data=_data;
        imgOpen=sprBack.getChildByName("_icon_open");
        imgClose=sprBack.getChildByName("_icon_close")
        mcSelect=sprBack.getChildByName("_on");
        mt=new MyViewTXController(sprBack);
        mt.setText("tx_mail",data.Name+"\n"+data.timeSend);
        onSelectF(false);
        onShowFlag();
    }
    public function onSelectF(real:Boolean):void{
        mcSelect.visible=real;
    }
    public function onShowFlag():void{
        if(data.Flag==0){
            imgOpen.visible = false;
            imgClose.visible = true;
        }else {
            imgOpen.visible = true;
            imgClose.visible = false;
        }
    }
    public function destroyF():void{
        Tool_ObjUtils.destroyDisplayObj(this);
        sprBack=Tool_ObjUtils.destroyF_One(sprBack);
        imgOpen=Tool_ObjUtils.destroyF_One(imgOpen);
        imgClose=Tool_ObjUtils.destroyF_One(imgClose);
        mcSelect=Tool_ObjUtils.destroyF_One(mcSelect);
        mt=Tool_ObjUtils.destroyF_One(mt);
    }
}

class MailModelDataOne{
    public var ID:int;
    public var Name:String;
    public var strMessage:String;
    public var timeSend:String;//2018-01-01 00:00:00
    public var dateSend:Date;
    public var timeEnd:String;
    public var Flag:int;
    public var Arr_gift:Array;
    public var from:*;//uid,name
    public function MailModelDataOne(dic:*){
        this.ID=dic["id"];
        this.Name=dic["标题"];
        this.strMessage=dic["内容"];
        this.timeSend=dic["发送时间"];
        this.timeEnd=dic["过期时间"];
        this.from=dic["发件人"];
        this.Flag=dic["状态"];
        this.Arr_gift=dic["附件"];
        dateSend=Tool_Function.onDate_String_to_Date(timeSend);
        var str:String=Tool_Function.onDate_Data_to_String(dateSend);
        timeSend=str.slice(0,str.indexOf("时")+1);
    }
    /** 剩余时间 */
    public function getLastTime():String{
        var date:Date=Tool_Function.onDate_String_to_Date(timeEnd);
        var dateNow:Date=new Date();
        var sec:int =Tool_Function.onDate_getBetween(dateNow,date,"分");
        if(sec<=0){return "0分";}
        if(sec<60){return sec+"分";}
        var hour:int =Tool_Function.onForceConvertType(sec/60);
        if(hour>=24){
            var day:int =Tool_Function.onForceConvertType(hour/24);
            return day+"天";
        }
        return hour+"小时";
    }
}
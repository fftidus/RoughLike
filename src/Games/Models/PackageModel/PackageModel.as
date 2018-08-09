package Games.Models.PackageModel {
import CMD.CMD501;

import StaticDatas.SData_EventNames;

import com.MyClass.Config;
import com.MyClass.MyEventManagerOne;
import com.MyClass.Tools.Tool_ObjUtils;

import laya.utils.Handler;

import starling.display.Sprite;

public class PackageModel {
    private static var instance:PackageModel;

    private var C501:CMD501;
    private var meo:MyEventManagerOne = new MyEventManagerOne();
    private var data:LocalData_Package;//背包数据
    private var viewModel:PackageModel_View_Page;//显示模块


    public static function getInstance():PackageModel {
        if (instance == null) {
            instance = new PackageModel();
        }
        return instance;
    }

    public static function destroyF():void {
        if(instance){
            instance = Tool_ObjUtils.destroyF_One(instance);
        }
    }

    public function PackageModel() {
        C501 = new CMD501();
        C501.funAddListener(Handler.create(this,netChangeF,null,false),false);
    }

    public function setViewModel(viewModel:PackageModel_View_Page):void {
        if (viewModel == null) {
            Config.Log("无效的背包显示模块");
        } else {
            this.viewModel = viewModel;
        }
    }

    public function show(spr:Sprite):void{
        if(this.viewModel != null){
            destroyF();
            Config.Log("背包界面viewModel未清理");
        }
        this.viewModel = new PackageModel_View_Page(spr);
    }

    private function netChangeF(data:*):void {
        if (data == null) {
            Config.Log("netChangeF背包数据为空");
        } else {
            if(data["操作"] == "初始化"){
                this.data = new LocalData_Package(data["数据"]);
            }else if(data["操作"] == "修改背包"){
                this.data.change(data["数据"]);
            }else if(data["操作"] == "升级背包"){
                this.data.nowPage = data["当前页"];
            }
        }
    }

    public function destroyF():void {
        viewModel = Tool_ObjUtils.destroyF_One(viewModel);
    }
}
}

import Games.Models.ArmorModel;
import Games.Models.ItemModel;
import Games.Models.MaterialModel;
import Games.Models.WeaponModel;

import com.MyClass.Tools.Tool_ObjUtils;

class LocalData_Package{
    public var nowPage:int;
    public var maxPage:int;
    public var perNum:int;

    public var packageData:*;

    public function LocalData_Package(data:*){
        nowPage = data.nowPage;
        maxPage = data.maxPage;
        perNum = data.perNum;
        change(data.packageData);
    }

    public function change(data:*):void{
        for(var index:int in data){
            if(data[index] != null){
                if(data[index] == "删除"){
                    packageData[index] = Tool_ObjUtils.destroyF_One(packageData[index]);
                    delete packageData[index];
                }else{
                    packageData[index] = getObjByInfo(data.packageData[index]);
                }
            }
        }
    }

    public function getObjByInfo(dic:*):*{
        if(dic["类型"]==null){return null;}
        var type:String=dic["类型"];
        dic=dic["内容"];
        if(dic["netid"]!=null){dic["id"]=dic["netid"];}
        if(type == "道具"){
            var item:ItemModel=new ItemModel(dic["id"],dic["baseid"],dic["数量"]);
            item.needSafeNum();
            return item;
        }else if(type == "武器"){
            var wea:WeaponModel=new WeaponModel(dic["id"]);
            wea.setInfo(dic);
            return wea;
        }else if(type == "防具"){
            var arm:ArmorModel=new ArmorModel(dic["id"]);
            arm.setInfo(dic);
            return arm;
        }else if(type == "素材"){
            var mat:MaterialModel=new MaterialModel(dic["id"],dic["baseid"],dic["数量"]);
            mat.needSafeNum();
            return mat;
        }
    }
}

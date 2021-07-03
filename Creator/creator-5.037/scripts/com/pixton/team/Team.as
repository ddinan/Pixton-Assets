package com.pixton.team
{
   import com.adobe.serialization.json.JSON;
   import com.pixton.editor.AppSettings;
   import com.pixton.editor.Comic;
   import com.pixton.editor.DisplayManager;
   import com.pixton.editor.EditorButton;
   import com.pixton.editor.FeatureTrial;
   import com.pixton.editor.File;
   import com.pixton.editor.Filter;
   import com.pixton.editor.Globals;
   import com.pixton.editor.Help;
   import com.pixton.editor.L;
   import com.pixton.editor.Main;
   import com.pixton.editor.Palette;
   import com.pixton.editor.Panel;
   import com.pixton.editor.PixtonEvent;
   import com.pixton.editor.Platform;
   import com.pixton.editor.Template;
   import com.pixton.editor.Utils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public final class Team extends MovieClip
   {
      
      public static var DEBUGGING:Boolean = false;
      
      public static const NO_DATA:String = null;
      
      public static const P_PANEL_LIST:String = "panels";
      
      public static const P_PANEL_STATE:String = "state";
      
      public static const P_PANEL_V:String = "version";
      
      public static const P_PANEL_INDEX:String = "index";
      
      public static const P_PANEL_XY:String = "xy";
      
      public static const P_PANEL_SIZES:String = "sizes";
      
      public static const P_PANEL_LOCK:String = "lock";
      
      public static const P_PANEL_SAVED:String = "saved";
      
      public static const P_CHARACTER_LIST:String = "charList";
      
      public static const P_CHARACTER:String = "char";
      
      public static const P_PROPSET_LIST:String = "propsetList";
      
      public static const P_PROPSET:String = "propset";
      
      public static const P_PHOTO_LIST:String = "photoList";
      
      public static const P_PHOTO:String = "photo";
      
      public static const P_DRAWING_LIST:String = "drawingList";
      
      public static const P_DRAWING:String = "drawing";
      
      public static const P_COMIC:String = "comic";
      
      public static const PANEL_UNLOCKED:uint = 0;
      
      public static const PANEL_LOCKED:uint = 1;
      
      public static var TIMER_TOTAL:uint = 2500;
      
      public static const TIMER_COUNTDOWN:uint = 0;
      
      public static const TIMER_INTERVAL:uint = 500;
      
      private static const PADDING_X:Number = 15;
      
      public static var isVisible:Boolean = false;
      
      public static var isAllowed:Boolean = false;
      
      public static var isActive:Boolean = false;
      
      public static var interval:uint = 0;
      
      public static var countdown:uint;
      
      public static var keepLocked:Boolean = false;
      
      public static var self:Team;
       
      
      public var pixture:MovieClip;
      
      public var teamLogo:MovieClip;
      
      public var btnTeam:EditorButton;
      
      public var txtTitle:TextField;
      
      public var bkgd:MovieClip;
      
      private var comicTitle:String;
      
      private var comicAuthor:String;
      
      private var tfTitle:TextFormat;
      
      private var tfAuthor:TextFormat;
      
      private var editing:Boolean = false;
      
      private var _isRemix:Boolean = false;
      
      private var _allowedPixture:Boolean = false;
      
      private var txtTitleX:Number;
      
      private var _maxTitleLen:uint = 36;
      
      public function Team()
      {
         super();
         Main.displayManager.SET(this,DisplayManager.P_VIS,false);
         this.teamLogo.visible = false;
         this.pixture.imgContainer.visible = false;
         this.btnTeam.visible = false;
         this.txtTitleX = this.txtTitle.x;
         this.txtTitle.visible = false;
         this.tfTitle = new TextFormat();
         this.tfAuthor = new TextFormat();
         this.btnTeam.setHandler(this.onMakeTeam,false);
      }
      
      public static function titleHasFocus() : Boolean
      {
         return self.titleHasFocus();
      }
      
      public static function init(param1:Team) : void
      {
         self = param1;
      }
      
      public static function initSharing() : void
      {
         if(isActive)
         {
            startSharing();
         }
         else
         {
            Red5.init();
         }
      }
      
      public static function startSharing() : void
      {
         isActive = true;
         Red5.startSharing();
         self.update();
         AppSettings.update();
         Utils.javascript("Pixton.team.open");
      }
      
      public static function update() : void
      {
         self.update();
      }
      
      public static function isSaved() : Boolean
      {
         return self.isSaved();
      }
      
      public static function onChange(param1:String, param2:String, param3:String, param4:String, param5:*) : void
      {
         if(!isActive || !TeamRole.approved)
         {
            return;
         }
         if(param4 == null)
         {
            param4 = "value";
         }
         var _loc6_:Object = {
            "s":Main.sessionID,
            "v":param5
         };
         var _loc7_:String = com.adobe.serialization.json.JSON.encode(_loc6_);
         Red5.putObject(param1,param2,param3,param4,_loc7_);
         if(param3 == P_PANEL_STATE && param5 == Panel.STATE_DELETED)
         {
            Red5.stopTrackingPanel(param1,param2);
         }
      }
      
      public static function require(param1:String, param2:String, param3:String) : void
      {
         Red5.requireObject(param1,param2,param3);
      }
      
      public static function onPanelList(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            Red5.requireObject(Red5.comicKey,_loc2_,P_PANEL_STATE);
            Red5.requireObject(Red5.comicKey,_loc2_,P_PANEL_V);
            Red5.requireObject(Red5.comicKey,_loc2_,P_PANEL_INDEX);
            Red5.requireObject(Red5.comicKey,_loc2_,P_PANEL_XY);
            Red5.requireObject(Red5.comicKey,_loc2_,P_PANEL_LOCK);
            Red5.requireObject(Red5.comicKey,_loc2_,P_PANEL_SAVED);
         }
      }
      
      public static function triggerUpdate(param1:String, param2:String, param3:String, param4:String = null) : void
      {
      }
      
      public static function getData(param1:String, param2:String, param3:String, param4:String = null) : Object
      {
         var teamValueStr:String = null;
         var teamValue:Object = null;
         var mainScope:String = param1;
         var subScope:String = param2;
         var teamVar:String = param3;
         var property:String = param4;
         if(!isVisible || !isActive)
         {
            return null;
         }
         if(property == null)
         {
            property = "value";
         }
         teamValueStr = Red5.getData(mainScope,subScope,teamVar,property);
         if(teamValueStr != null && teamValueStr != "")
         {
            try
            {
               teamValue = com.adobe.serialization.json.JSON.decode(teamValueStr);
            }
            catch(e:*)
            {
               if(Main.isSuper())
               {
                  Utils.javascript("console.log","Error decoding JSON (2): " + mainScope + "/" + subScope + "/" + teamVar + "/" + property + "; " + teamValueStr);
               }
               return null;
            }
            if(teamValue.v != NO_DATA)
            {
               return teamValue.v;
            }
         }
         return null;
      }
      
      public static function log(param1:String) : void
      {
         if(!DEBUGGING)
         {
            return;
         }
         Utils.remote("teamLog",{"msg":param1});
      }
      
      public function titleHasFocus() : Boolean
      {
         return this.editing;
      }
      
      public function updateColor() : void
      {
         this.txtTitle.textColor = Palette.colorText;
         Utils.setColor(this.pixture.line,Palette.colorLine);
         Utils.setColor(this.bkgd,Palette.colorBkgd);
         this.btnTeam.updateColor();
      }
      
      public function disableTitle() : void
      {
         this.txtTitle.mouseEnabled = false;
      }
      
      private function setTitle(param1:String) : void
      {
         this.txtTitle.text = param1;
         this.txtTitle.setTextFormat(this.tfTitle);
      }
      
      public function getTitle() : String
      {
         return this.txtTitle.text;
      }
      
      private function update() : void
      {
         this.teamLogo.visible = isActive;
         this.pixture.visible = this._allowedPixture;
         this.pixture.imgContainer.visible = !isActive && this._allowedPixture;
         this.btnTeam.visible = isVisible && !isActive && AppSettings.isAdvanced && !Main.isCharCreate() && !Template.isActive();
         if(this.teamLogo.visible)
         {
            this.txtTitle.x = this.txtTitleX;
         }
         if(this.btnTeam.visible)
         {
            this.txtTitle.y = -2;
         }
         else
         {
            this.txtTitle.y = 12;
         }
      }
      
      public function getTitleData() : Object
      {
         return {"title":this.comicTitle};
      }
      
      public function updateTitle(param1:String = null) : void
      {
         if(param1 != null)
         {
            this.comicTitle = param1;
         }
         this.setTitle(this.comicTitle);
         if(!this._isRemix)
         {
         }
      }
      
      public function setTitleData(param1:Object) : void
      {
         this.updateTitle(param1.title);
      }
      
      public function loadData(param1:Object) : void
      {
         if(Main.isReadOnly())
         {
            return;
         }
         Utils.addListener(this.txtTitle,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.addListener(this.txtTitle,MouseEvent.ROLL_OUT,this.hideHelp);
         Utils.addListener(this.txtTitle,FocusEvent.FOCUS_IN,this.onTitleFocus);
         this.setTitle(L.text("untitled"));
         if(!Main.isCharCreate())
         {
            this.txtTitle.width = Math.round(Comic.maxWidth * 0.5);
         }
         this.comicTitle = param1.title;
         this.comicAuthor = param1.author;
         if(param1.maxTitleLen != null)
         {
            this._maxTitleLen = param1.maxTitleLen;
         }
         this.txtTitle.maxChars = this._maxTitleLen;
         this._allowedPixture = param1.pix;
         if(param1.pixture != null)
         {
            Utils.load(param1.pixture,this.onLoadPixture,false,File.BUCKET_STATIC);
         }
         else
         {
            this._allowedPixture = false;
         }
         if(param1.remix)
         {
            this._isRemix = true;
         }
         if(!this._allowedPixture)
         {
            this.txtTitle.x = -2;
         }
         this.btnTeam.label = L.text("make-team-comic");
         this.btnTeam.x = this.txtTitle.x + this.btnTeam.getWidth() * 0.5 + 2;
         this.update();
      }
      
      public function load() : void
      {
         if(Main.isReadOnly() || Main.isCharEdit() || Main.isPropPreview())
         {
            return;
         }
         if(this.comicTitle == null)
         {
            this.onTitleOut();
         }
         this.setTitle(this.comicTitle);
         this.txtTitle.visible = !Platform._get("anon") && !Main.DEMO_MODE;
         Main.displayManager.SET(this,DisplayManager.P_VIS,true);
         Main.displayManager.clear(this);
      }
      
      private function onTitleFocus(param1:FocusEvent) : void
      {
         this.editing = true;
         if(!Main.isCharCreate() && this.comicTitle == L.text("untitled") || Main.isCharCreate() && this.comicTitle == L.text("unnamed"))
         {
            this.txtTitle.text = "";
         }
         else
         {
            this.txtTitle.text = this.comicTitle;
         }
         Utils.addListener(this.txtTitle,FocusEvent.FOCUS_OUT,this.onTitleOut);
      }
      
      private function onMakeTeam(param1:MouseEvent) : void
      {
         if(!Globals.isFullVersion() || !isAllowed)
         {
            Main.promptUpgrade(FeatureTrial.TEAM_COMICS);
         }
         else
         {
            Utils.javascript("Pixton.team.invite",Comic.self.getIDData());
         }
      }
      
      private function onTitleOut(param1:FocusEvent = null) : void
      {
         this.editing = false;
         Utils.removeListener(this.txtTitle,FocusEvent.FOCUS_OUT,this.onTitleOut);
         this.txtTitle.text = Filter.filter(this.txtTitle.text);
         if(this.txtTitle.text == this.comicTitle)
         {
            return;
         }
         this.txtTitle.text = Utils.trim(this.txtTitle.text);
         if(this.txtTitle.text != "")
         {
            this.comicTitle = this.txtTitle.text;
         }
         this.updateTitle();
         if((!Main.isCharCreate() && this.comicTitle != L.text("untitled") || Main.isCharCreate() && this.comicTitle != L.text("unnamed")) && this.comicTitle != "" && !Platform._get("anon"))
         {
            dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE_COMIC,null));
         }
      }
      
      public function isSaved() : Boolean
      {
         return !visible || (!this.editing && this.txtTitle.text == this.comicTitle || this.txtTitle.text == "");
      }
      
      private function showHelp(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         switch(param1.currentTarget)
         {
            case this.txtTitle:
               _loc2_ = L.text(!!Main.isCharCreate() ? "edit-char-name" : "ctitle-edit").toLowerCase();
               _loc3_ = true;
         }
         Help.show(_loc2_,param1.currentTarget,_loc3_);
      }
      
      private function hideHelp(param1:MouseEvent = null) : void
      {
         Help.hide();
      }
      
      private function onLoadPixture(param1:Event) : void
      {
         var _loc2_:BitmapData = Bitmap(param1.target.loader.contentLoaderInfo.content).bitmapData;
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         _loc3_.smoothing = true;
         _loc3_.width = 48;
         _loc3_.height = 48;
         this.pixture.imgContainer.addChild(_loc3_);
      }
   }
}

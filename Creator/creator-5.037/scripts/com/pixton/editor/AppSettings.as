package com.pixton.editor
{
   import com.pixton.animate.Animation;
   import com.pixton.team.Team;
   import com.pixton.team.TeamRole;
   import fl.controls.CheckBox;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public final class AppSettings extends MovieClip
   {
      
      public static const MODE_BASIC:uint = 1;
      
      public static const MODE_ADVANCED:uint = 0;
      
      public static const MODE:uint = 0;
      
      public static const SHORTCUTS:uint = 1;
      
      public static const TOOLTIPS:uint = 2;
      
      public static const NUMBERS:uint = 3;
      
      public static const ZOOM:uint = 4;
      
      public static const ZOOM_DEF:uint = 5;
      
      public static const MORE:uint = 6;
      
      public static const ANIMATION:uint = 7;
      
      public static const BASIC:uint = 8;
      
      public static const PAGES:uint = 9;
      
      public static var isAdvanced:Boolean = false;
      
      public static var isBasic:Boolean = false;
      
      public static var allowNonBasic:Boolean = true;
      
      public static var allowNonBeginner:Boolean = false;
      
      private static const PADDING_X:Number = 8;
      
      public static var self:AppSettings;
       
      
      public var btnToggle:EditorButton;
      
      public var chkAdvanced:EditorButton;
      
      public var chkBasic:EditorButton;
      
      public var divider:MovieClip;
      
      public var btnClose:MovieClip;
      
      public var bkgd:MovieClip;
      
      public var chkTooltips:CheckBox;
      
      public var chkShortcuts:CheckBox;
      
      public var chkNumbers:CheckBox;
      
      public var chkMore:CheckBox;
      
      public var chkZoom:CheckBox;
      
      public var chkZoomDef:CheckBox;
      
      public var chkAnimation:CheckBox;
      
      public var chkPages:CheckBox;
      
      public var btnStyle:EditorButton;
      
      public var options:Array;
      
      private var _shown:Boolean;
      
      private var showTooltips:Boolean = true;
      
      private var showShortcuts:Boolean = true;
      
      private var showNumbers:Boolean = true;
      
      private var showMode:Boolean = true;
      
      private var editorSettings:uint = 0;
      
      public function AppSettings()
      {
         var _loc1_:uint = 0;
         super();
         self = this;
         this.options = [this.chkShortcuts,this.chkTooltips,this.chkNumbers,this.chkMore,this.chkZoom,this.chkZoomDef,this.chkAnimation,this.chkPages];
         var _loc2_:uint = this.options.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.options[_loc1_].visible = false;
            Utils.addListener(this.options[_loc1_],MouseEvent.CLICK,this.onOption);
            _loc1_++;
         }
         this.btnToggle.setHandler(this.toggleShown,false);
         this.btnToggle.showIcon("iconSettings");
         this.chkAdvanced.setHandler(this.togglePlus,false);
         this.chkBasic.setHandler(this.toggleBasic,false);
         this.btnStyle.setHandler(this.onChangeStyle,false);
         this.btnStyle.fixedWidth = 194;
         this.btnStyle.x = -108;
         this.btnStyle.makePriority();
         Utils.useHand(this.btnClose);
         Utils.addListener(this.btnClose,MouseEvent.CLICK,this.toggleShown);
         this.divider.visible = this.btnStyle.visible = false;
         this.shown = false;
         Main.displayManager.SET(this,DisplayManager.P_VIS,false);
      }
      
      public static function isVisible() : Boolean
      {
         return self.shown;
      }
      
      public static function toggleShown() : void
      {
         self.toggleShown();
      }
      
      public static function updateColor() : void
      {
         Utils.setColor(self.btnClose.icon,Palette.colorLink);
         Utils.setColor(self.bkgd.fill,Palette.colorBkgd);
         Utils.setColor(self.bkgd.line,Palette.colorLine);
         self.btnToggle.updateColor();
         self.chkAdvanced.updateColor();
         self.chkBasic.updateColor();
         Utils.setColor(self.divider,Palette.colorLine);
         self.btnStyle.updateColor();
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.color = Palette.colorText;
         self.chkShortcuts.setStyle("textFormat",_loc1_);
         self.chkTooltips.setStyle("textFormat",_loc1_);
         self.chkNumbers.setStyle("textFormat",_loc1_);
         self.chkMore.setStyle("textFormat",_loc1_);
         self.chkZoom.setStyle("textFormat",_loc1_);
         self.chkZoomDef.setStyle("textFormat",_loc1_);
         self.chkAnimation.setStyle("textFormat",_loc1_);
         self.chkPages.setStyle("textFormat",_loc1_);
      }
      
      public static function getActive(param1:uint) : Boolean
      {
         switch(param1)
         {
            case SHORTCUTS:
               return self.chkShortcuts.selected;
            case TOOLTIPS:
               return self.chkTooltips.selected;
            case NUMBERS:
               return self.chkNumbers.selected;
            case MORE:
               return self.chkMore.selected;
            case ZOOM:
               return self.chkZoom.selected;
            case ZOOM_DEF:
               return self.chkZoomDef.selected;
            case ANIMATION:
               return self.chkAnimation.selected;
            case PAGES:
               return self.chkPages.selected;
            default:
               return false;
         }
      }
      
      public static function setActive(param1:uint, param2:Boolean = true, param3:Boolean = false) : void
      {
         switch(param1)
         {
            case MODE:
               isAdvanced = param2;
               self.chkAdvanced.setChecked(param2);
               break;
            case BASIC:
               isBasic = param2;
               self.chkBasic.setChecked(param2);
               break;
            case SHORTCUTS:
               self.chkShortcuts.selected = param2;
               break;
            case TOOLTIPS:
               self.chkTooltips.selected = param2;
               break;
            case MORE:
               self.chkMore.selected = param2;
               break;
            case NUMBERS:
               self.chkNumbers.selected = param2;
               break;
            case ZOOM:
               self.chkZoom.selected = param2;
               break;
            case ZOOM_DEF:
               self.chkZoomDef.selected = param2;
               break;
            case ANIMATION:
               self.chkAnimation.selected = param2;
               break;
            case PAGES:
               self.chkPages.selected = param2;
         }
         if(param3)
         {
            self.saveOptionNum();
         }
      }
      
      public static function update() : void
      {
         self.update();
      }
      
      public function set shown(param1:Boolean) : void
      {
         this._shown = param1;
         this.btnClose.visible = param1;
         this.bkgd.visible = param1;
         this.update();
      }
      
      public function get shown() : Boolean
      {
         return this._shown;
      }
      
      function toggleShown(param1:MouseEvent = null) : void
      {
         this.shown = !this.shown;
      }
      
      function showFormat(param1:MouseEvent = null) : void
      {
         Confirm.open("Pixton.comic.format.showSelector",Comic.key);
      }
      
      public function setData(param1:Object) : void
      {
         this.editorSettings = param1.opts;
         this.chkTooltips.selected = !!(this.editorSettings & Math.pow(2,TOOLTIPS));
         this.chkShortcuts.selected = !!(this.editorSettings & Math.pow(2,SHORTCUTS));
         this.chkNumbers.selected = !!(this.editorSettings & Math.pow(2,NUMBERS));
         this.chkMore.selected = !!(this.editorSettings & Math.pow(2,MORE)) || Main.isCharCreate();
         this.chkZoom.selected = !!(this.editorSettings & Math.pow(2,ZOOM)) && !Main.isCharCreate();
         this.chkZoomDef.selected = !!(this.editorSettings & Math.pow(2,ZOOM_DEF));
         this.chkAnimation.selected = !!(this.editorSettings & Math.pow(2,ANIMATION));
         this.chkPages.selected = !!(this.editorSettings & Math.pow(2,PAGES));
         this.showTooltips = param1.otvis == 1;
         this.showShortcuts = param1.osvis == 1;
         this.showNumbers = param1.onvis == 1;
         this.showMode = param1.omvis == 1;
         allowNonBeginner = param1.obvis == 1;
         allowNonBasic = param1.bevis == 1;
         setActive(MODE,Main.isCharCreate() || !this.showMode);
         setActive(BASIC,Template.isActive());
         this.btnToggle.label = L.text("change-settings");
         this.chkAdvanced.label = L.text("editor-mode");
         this.chkBasic.label = L.text("editor-basic");
         this.btnStyle.label = L.text("change-style");
         this.chkShortcuts.label = L.text("shortcuts");
         this.chkTooltips.label = L.text("tooltips");
         this.chkNumbers.label = L.text("show-numbers");
         this.chkMore.label = L.text("show-more-options");
         this.chkZoom.label = L.text("show-zoom");
         this.chkZoomDef.label = L.text("zoom-def");
         this.chkAnimation.label = L.text("show-anim");
         this.chkPages.label = L.text("show-pages");
         this.btnToggle.visible = !Template.isActive();
         this.chkPages.enabled = !!param1.scm;
         this.update();
      }
      
      public function onReady(param1:Boolean) : void
      {
         if(Main.isReadOnly() || Main.isCharCreate())
         {
            Main.displayManager.SET(this,DisplayManager.P_VIS,false);
            return;
         }
         Main.displayManager.SET(this,DisplayManager.P_VIS,param1,true);
      }
      
      private function onChangeStyle(param1:MouseEvent) : void
      {
         Main.self.saveChanges("changeFormat");
         this.shown = false;
      }
      
      private function togglePlus(param1:MouseEvent) : void
      {
         setActive(MODE,!isAdvanced);
         this.saveOption("editorMode_int",!!isAdvanced ? uint(MODE_ADVANCED) : uint(MODE_BASIC));
         this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,MODE));
         this.update();
      }
      
      private function toggleBasic(param1:MouseEvent) : void
      {
         if(TeamRole.can(TeamRole.PANELS))
         {
            this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,BASIC));
         }
      }
      
      private function onOption(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this.chkShortcuts:
               this.saveOptionNum();
               break;
            case this.chkTooltips:
               this.saveOptionNum();
               break;
            case this.chkNumbers:
               this.saveOptionNum();
               this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,NUMBERS));
               break;
            case this.chkMore:
               this.saveOptionNum();
               this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,MORE));
               break;
            case this.chkZoom:
               this.saveOptionNum();
               this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,ZOOM));
               break;
            case this.chkZoomDef:
               this.saveOptionNum();
               this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,ZOOM_DEF));
               break;
            case this.chkAnimation:
               this.saveOptionNum();
               this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,ANIMATION));
               break;
            case this.chkPages:
               this.saveOptionNum();
               this.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,PAGES));
         }
         this.update();
      }
      
      private function update() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         MenuItem.update();
         var _loc1_:Number = 0;
         this.chkAdvanced.visible = this.showMode && !isAdvanced && !Template.isActive();
         this.chkBasic.visible = Template.isActive();
         if(this.btnToggle.visible)
         {
            _loc1_ += -Math.round(this.btnToggle.width * 0.5) - 5;
            this.btnToggle.x = _loc1_;
            _loc1_ += -Math.round(this.btnToggle.width * 0.5) - PADDING_X;
         }
         if(this.chkAdvanced.visible)
         {
            _loc1_ += -this.chkAdvanced.width;
            this.chkAdvanced.x = _loc1_;
         }
         if(this.chkBasic.visible)
         {
            _loc1_ += -this.chkBasic.width;
            this.chkBasic.x = _loc1_;
         }
         this.chkTooltips.visible = this.shown && this.showTooltips;
         this.chkShortcuts.visible = this.shown && this.showShortcuts;
         this.chkNumbers.visible = this.shown && this.showNumbers;
         this.chkMore.visible = this.shown;
         this.chkZoom.visible = this.shown;
         this.chkZoomDef.visible = this.shown;
         this.chkAnimation.visible = this.shown && Animation.optionVisible && !Team.isActive;
         this.chkPages.visible = this.shown;
         this.divider.visible = this.btnStyle.visible = this.shown && Main.hasNewFormats() && !Team.isActive && !Main.isPropPreview();
         if(this.shown)
         {
            _loc3_ = 8;
            _loc4_ = this.options.length;
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               if(this.options[_loc2_].visible)
               {
                  this.options[_loc2_].y = _loc3_;
                  _loc3_ += 21;
               }
               _loc2_++;
            }
            if(this.btnStyle.visible)
            {
               _loc3_ += 6;
               this.divider.y = _loc3_;
               _loc3_ += 10;
               this.btnStyle.y = _loc3_;
               _loc3_ += 21;
               _loc3_ += 10;
            }
            this.bkgd.height = _loc3_ + 6;
         }
      }
      
      private function saveOptionNum() : void
      {
         if(Platform._get("anon"))
         {
            return;
         }
         this.editorSettings = 0;
         if(this.chkShortcuts.selected)
         {
            this.editorSettings += Math.pow(2,SHORTCUTS);
         }
         if(this.chkTooltips.selected)
         {
            this.editorSettings += Math.pow(2,TOOLTIPS);
         }
         if(this.chkNumbers.selected)
         {
            this.editorSettings += Math.pow(2,NUMBERS);
         }
         if(this.chkMore.selected)
         {
            this.editorSettings += Math.pow(2,MORE);
         }
         if(this.chkZoom.selected)
         {
            this.editorSettings += Math.pow(2,ZOOM);
         }
         if(this.chkZoomDef.selected)
         {
            this.editorSettings += Math.pow(2,ZOOM_DEF);
         }
         if(this.chkAnimation.selected)
         {
            this.editorSettings += Math.pow(2,ANIMATION);
         }
         if(this.chkPages.selected)
         {
            this.editorSettings += Math.pow(2,PAGES);
         }
         Utils.remote("saveOption",{
            "key":"editor",
            "value":this.editorSettings
         });
      }
      
      private function saveOption(param1:String, param2:uint) : void
      {
         if(Platform._get("anon"))
         {
            return;
         }
         Utils.remote("saveOption",{
            "key":param1,
            "value":param2
         });
      }
   }
}

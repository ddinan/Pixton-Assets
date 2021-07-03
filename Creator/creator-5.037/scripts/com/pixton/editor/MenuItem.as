package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class MenuItem extends MovieClip
   {
      
      public static const SIZE:Number = 36;
      
      public static const GAP:Number = 3;
      
      private static var _active:Boolean = false;
      
      private static const ALPHA_DISABLED:Number = 0.25;
      
      private static const FACTOR_LIGHTEN:Number = 1.12;
      
      private static var shortcuts:Object = {};
       
      
      public var bkgd:MovieClip;
      
      public var bkgdOff:MovieClip;
      
      public var bkgdOver:MovieClip;
      
      public var disablable:Boolean = false;
      
      public var icon:MovieClip;
      
      public var border:MovieClip;
      
      public var iconActivate:MovieClip;
      
      public var iconDeactivate:MovieClip;
      
      private var shortcut:MovieClip;
      
      private var _enabled:Boolean;
      
      private var toggling:Boolean;
      
      private var _toggleState:Boolean = false;
      
      private var _rgb:Array;
      
      private var _rgbLight:Array;
      
      public function MenuItem()
      {
         super();
         this.toggling = this.iconActivate != null && this.iconDeactivate != null;
         Utils.useHand(this);
         this.enableState = true;
         Utils.addListener(this,MouseEvent.ROLL_OVER,this.onOver);
         Utils.addListener(this,MouseEvent.ROLL_OUT,this.onOut);
         if(this.bkgdOff != null && this.bkgdOver != null)
         {
            Utils.addListener(this,MouseEvent.MOUSE_DOWN,this.onDown);
            this.onUp();
         }
      }
      
      public static function addShortcut(param1:MenuItem, param2:String) : void
      {
         if(shortcuts[param2] == null)
         {
            shortcuts[param2] = [];
         }
         shortcuts[param2].push(param1);
         param1.setShortcut(param2);
      }
      
      public static function update() : void
      {
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _active = AppSettings.getActive(AppSettings.SHORTCUTS);
         for each(_loc1_ in shortcuts)
         {
            _loc3_ = _loc1_.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               MenuItem(_loc1_[_loc2_]).update();
               _loc2_++;
            }
         }
      }
      
      public static function triggerShortcut(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(shortcuts[param1] != null)
         {
            _loc3_ = shortcuts[param1].length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(MenuItem(shortcuts[param1][_loc2_]).visible && MenuItem(shortcuts[param1][_loc2_]).enableState)
               {
                  MenuItem(shortcuts[param1][_loc2_]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  break;
               }
               _loc2_++;
            }
         }
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.onUp);
         this.bkgdOff.visible = false;
         this.bkgdOver.visible = true;
      }
      
      private function onUp(param1:MouseEvent = null) : void
      {
         if(param1 != null)
         {
            Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.onUp);
         }
         this.bkgdOff.visible = true;
         this.bkgdOver.visible = false;
      }
      
      public function set enableState(param1:Boolean) : void
      {
         visible = param1 || this.disablable;
         mouseEnabled = param1;
         mouseChildren = param1;
         buttonMode = param1;
         useHandCursor = param1;
         alpha = !!param1 ? Number(1) : Number(ALPHA_DISABLED);
         this._enabled = param1;
      }
      
      public function set toggleState(param1:Boolean) : void
      {
         this._toggleState = param1;
         if(this._toggleState)
         {
            this.iconDeactivate.visible = true;
            this.iconActivate.visible = false;
            this.icon = this.iconDeactivate;
         }
         else
         {
            this.iconDeactivate.visible = false;
            this.iconActivate.visible = true;
            this.icon = this.iconActivate;
         }
      }
      
      public function update() : void
      {
         if(this.shortcut)
         {
            this.shortcut.visible = _active;
         }
      }
      
      public function get enableState() : Boolean
      {
         return mouseChildren;
      }
      
      public function disable() : void
      {
         buttonMode = false;
         useHandCursor = false;
      }
      
      public function setColor(param1:Array, param2:Array) : void
      {
         this._rgb = param1;
         this._rgbLight = param2;
         if(this.border)
         {
            Utils.setColor(this.border,this._rgb);
         }
         if(this.bkgd)
         {
            if(this.bkgd.fill)
            {
               Utils.setColor(this.bkgd.fill,this._rgb);
            }
            if(this.bkgd.fill2)
            {
               Utils.setColor(this.bkgd.fill2,Palette.colorBkgd);
            }
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(!this._enabled)
         {
            return;
         }
         if(this.bkgd && this.bkgd.fill)
         {
            Utils.setColor(this.bkgd.fill,this._rgbLight);
         }
         if(this.shortcut)
         {
            this.shortcut.alpha = 1;
         }
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         if(this.bkgd && this.bkgd.fill)
         {
            Utils.setColor(this.bkgd.fill,this._rgb);
         }
         if(this.shortcut)
         {
            this.shortcut.alpha = 0;
         }
      }
      
      private function setShortcut(param1:String) : void
      {
         if(!this.shortcut)
         {
            this.shortcut = new KeyboardShortcut();
            addChild(this.shortcut);
            this.shortcut.alpha = 0;
         }
         var _loc2_:TextField = this.shortcut.txtKey;
         _loc2_.mouseEnabled = false;
         _loc2_.multiline = false;
         _loc2_.wordWrap = false;
         _loc2_.text = param1.toUpperCase();
         if(this.bkgd)
         {
            this.shortcut.x = this.bkgd.x + SIZE / 2;
            this.shortcut.y = this.bkgd.y + SIZE / 2;
         }
         else
         {
            this.shortcut.x = SIZE / 2;
            this.shortcut.y = SIZE / 2;
         }
      }
   }
}

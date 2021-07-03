package com.pixton.designer
{
   import com.pixton.editor.Debug;
   import com.pixton.editor.Palette;
   import com.pixton.editor.Utils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class DesignerButton extends MovieClip
   {
      
      public static const WH_RATIO:Number = 0.75;
      
      public static const WIDTH:Number = 36;
      
      public static const HEIGHT:Number = 36;
      
      public static const GAP:Number = 3;
      
      private static const ICON_PADDING:Number = 3;
      
      private static const HIGHLIGHT_COLOR:Array = [255,224,0];
       
      
      public var num:uint;
      
      public var tier:uint;
      
      public var data:Object;
      
      public var bkgd:MovieClip;
      
      private var icon:MovieClip;
      
      private var _steps:MovieClip;
      
      private var _selected:Boolean;
      
      private var _highlighted:Boolean;
      
      private var _rgb:Array;
      
      private var _xO:Number = 0;
      
      private var iconName:String;
      
      public function DesignerButton()
      {
         super();
      }
      
      public function setData(param1:uint, param2:Object) : void
      {
         var _loc3_:Class = null;
         this.iconName = "icon";
         this.data = param2;
         if(param2.name != null)
         {
            this.iconName += Utils.ucFirst(param2.name);
         }
         else if(param2.part != null && !(param2.part is Array))
         {
            if(param2.stretch != null)
            {
               this.iconName += "Part" + Utils.ucFirst(param2.stretch);
            }
            else
            {
               this.iconName += Utils.ucFirst(param2.part.replace(/[0-9]/,"").replace(/(behind|lower|upper)/i,""));
            }
         }
         else if(param2.color != null)
         {
            this.iconName += "PartColor";
         }
         else if(param2.outfit != null)
         {
            this.iconName += "Outfit";
         }
         else if(param2.size != null)
         {
            this.iconName += Utils.ucFirst(param2.size);
         }
         this.num = param1;
         if(this.iconName != null)
         {
            if(!Utils.hasDefinition(this.iconName))
            {
               Debug.trace("missing icon: " + this.iconName);
               this.iconName = "iconNone";
            }
            _loc3_ = Utils.getDefinition(this.iconName);
            this.icon = new _loc3_();
            addChild(this.icon);
         }
         this.selected = false;
         if(this.icon != null)
         {
            Utils.fit(this.icon,this.bkgd,0,false,null,ICON_PADDING);
         }
         Utils.useHand(this);
         Utils.addListener(this,MouseEvent.ROLL_OVER,this.onOver);
         Utils.addListener(this,MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
         this.onOver();
         this.onOut();
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:DisplayObject = null;
         this._selected = param1;
         if(this.getSteps() != null)
         {
            this.getSteps().visible = param1;
            if(this.parent != null)
            {
               _loc3_ = this.parent.numChildren;
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  if((_loc4_ = this.parent.getChildAt(_loc2_)) is DesignerButton)
                  {
                     _loc4_.visible = _loc4_ == this || !param1;
                  }
                  _loc2_++;
               }
            }
            if(param1)
            {
               this.x = 0;
            }
            else
            {
               this.x = this._xO;
            }
         }
      }
      
      function setSteps(param1:MovieClip) : void
      {
         this._steps = param1;
         this._steps.visible = false;
      }
      
      function setOriginalX(param1:Number) : void
      {
         this._xO = param1;
         this.x = param1;
      }
      
      function getSteps() : MovieClip
      {
         return this._steps;
      }
      
      public function set rgb(param1:Array) : void
      {
         this._rgb = param1;
         Utils.setColor(this.bkgd,param1,0,true);
      }
      
      public function get rgb() : Array
      {
         return this._rgb;
      }
      
      private function onOver(param1:MouseEvent = null) : void
      {
         if(this.icon != null)
         {
            if(this.icon.highlight != null)
            {
               Utils.setColor(this.icon.highlight,HIGHLIGHT_COLOR);
            }
         }
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         if(this.icon != null)
         {
            if(this.icon.highlight != null && !this._highlighted)
            {
               Utils.setColor(this.icon.highlight,Palette.WHITE);
            }
         }
      }
   }
}

package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PixtonButton extends MovieClip
   {
       
      
      public var icon:MovieClip;
      
      public var symbol:MovieClip;
      
      public var symbolWhite:MovieClip;
      
      public var hideSymbol:Boolean = true;
      
      var isActive:Boolean;
      
      var isOver:Boolean;
      
      var clickTime:Number;
      
      public function PixtonButton()
      {
         super();
         Utils.useHand(this);
         this.active = false;
         this.over = false;
         Utils.addListener(this,MouseEvent.ROLL_OVER,this.onOver,true);
      }
      
      function onOver(param1:MouseEvent) : void
      {
         this.over = true;
         if(this.icon != null)
         {
            FX.glow(this.icon,6);
         }
         Utils.addListener(this,MouseEvent.ROLL_OUT,this.onOut);
         if(this.symbol == null || this.symbol.visible)
         {
            this.showHelp(param1);
         }
      }
      
      function onOut(param1:MouseEvent) : void
      {
         this.over = false;
         Utils.removeListener(this,MouseEvent.ROLL_OUT,this.onOut);
         if(this.icon != null)
         {
            FX.glow(this.icon,0);
         }
         this.hideHelp(param1);
      }
      
      public function set active(param1:Boolean) : void
      {
         this.isActive = param1;
         if(this.symbol != null && this.hideSymbol)
         {
            this.symbol.visible = !param1 && this.isOver;
            if(this.symbolWhite != null)
            {
               this.symbolWhite.visible = this.symbol.visible;
            }
         }
      }
      
      public function get active() : Boolean
      {
         return this.isActive;
      }
      
      public function set over(param1:Boolean) : void
      {
         this.isOver = param1;
         if(this.symbol != null && this.hideSymbol)
         {
            this.symbol.visible = !this.active && this.isOver;
            if(this.symbolWhite != null)
            {
               this.symbolWhite.visible = this.symbol.visible;
            }
         }
      }
      
      public function get over() : Boolean
      {
         return this.isOver;
      }
      
      function showHelp(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         switch(param1.currentTarget.name)
         {
            case "resizeN":
            case "resizeS":
            case "resizeE":
            case "resizeW":
               _loc2_ = L.text("dbl-resize");
               break;
            case "resizer":
            case "resizerH":
            case "resizerV":
               _loc2_ = L.text("drag-resize");
               break;
            case "turn1":
            case "turn2":
               _loc2_ = L.text("drag-turn");
               break;
            default:
               _loc2_ = L.text("dbl-rotate");
         }
         Help.show(_loc2_,param1.currentTarget);
      }
      
      function hideHelp(param1:MouseEvent) : void
      {
         Help.hide();
      }
   }
}

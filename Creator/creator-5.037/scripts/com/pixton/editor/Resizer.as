package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class Resizer extends Handle
   {
       
      
      public var bkgd:MovieClip;
      
      public var px:MovieClip;
      
      private var txtPixels:TextField;
      
      public function Resizer()
      {
         super();
         hideSymbol = false;
         symbol.visible = true;
         icon = symbol.icon;
         if(this.px != null)
         {
            this.txtPixels = this.px.txtValue;
            this.px.visible = false;
            this.txtPixels.mouseEnabled = false;
            this.txtPixels.multiline = false;
            this.txtPixels.wordWrap = false;
            if(rotation == 0)
            {
               this.txtPixels.autoSize = TextFieldAutoSize.NONE;
            }
            else
            {
               this.txtPixels.autoSize = TextFieldAutoSize.CENTER;
               this.px.x = 24;
               this.px.scaleY = -1;
               this.px.rotation = 90;
            }
         }
      }
      
      public function setColor(param1:Array) : void
      {
         Utils.setColor(icon.arrow1,param1);
         Utils.setColor(icon.arrow2,param1);
         if(this.px != null)
         {
            this.txtPixels.textColor = Palette.colorText;
         }
      }
      
      public function setHeight(param1:Number, param2:Number = 0.5) : void
      {
         if(param2 < 0)
         {
            this.bkgd.y = 0;
            this.bkgd.height = param1;
            symbol.y = Math.floor(param1 + param2);
         }
         else
         {
            if(param2 == 0.5)
            {
               this.bkgd.y = 0;
               this.bkgd.height = param1;
            }
            else
            {
               this.bkgd.y = param1 * (param2 - (1 - param2));
               this.bkgd.height = param1 * (1 - param2) * 2;
            }
            symbol.y = Math.floor(param1 * param2);
         }
         if(this.px != null)
         {
            if(rotation == 0)
            {
               this.px.y = symbol.y;
            }
            else
            {
               this.px.y = symbol.y - this.px.height * 0.5;
            }
         }
      }
      
      public function setPixels(param1:Number) : void
      {
         if(this.px != null)
         {
            this.txtPixels.text = Math.round(param1) + " px";
         }
      }
      
      override function onOver(param1:MouseEvent) : void
      {
         super.onOver(param1);
         if(this.px != null)
         {
            this.px.visible = true;
            FX.glow(this.px,6,Palette.colorBkgdHex,10);
         }
      }
      
      override function onOut(param1:MouseEvent) : void
      {
         super.onOut(param1);
         if(this.px != null)
         {
            this.px.visible = false;
            FX.glow(this.px,0);
         }
      }
   }
}

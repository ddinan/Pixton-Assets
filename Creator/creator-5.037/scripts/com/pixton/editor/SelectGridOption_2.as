package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public final class SelectGridOption extends MovieClip
   {
      
      private static const PADDING:Number = 0;
       
      
      public var txtLabel:TextField;
      
      public var bkgd:MovieClip;
      
      public var value:int;
      
      public var labelContainer:MovieClip;
      
      private var _selected:Boolean = false;
      
      private var icon:MovieClip;
      
      public function SelectGridOption()
      {
         super();
         Utils.useHand(this);
         this.labelContainer.mouseEnabled = false;
         this.labelContainer.mouseChildren = false;
         this.txtLabel = this.labelContainer.txtLabel;
         this.txtLabel.visible = false;
         Utils.addListener(this,MouseEvent.ROLL_OVER,this.onOver);
         Utils.addListener(this,MouseEvent.ROLL_OUT,this.onOut);
         this.bkgd.width = 44;
         this.bkgd.height = 44;
      }
      
      private function onOver(param1:MouseEvent = null) : void
      {
         Help.show(this.txtLabel.text,this,false,true);
         Utils.setColor(this.bkgd,Palette.colorLink);
         Utils.setColor(this.icon,Palette.WHITE,0,true);
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         Help.hide();
         if(this.selected)
         {
            return;
         }
         Utils.setColor(this.bkgd);
         Utils.setColor(this.icon,Palette.GRAY,0,true);
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this.onOver();
         this.onOut();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function setData(param1:int, param2:String) : void
      {
         this.value = param1;
         this.txtLabel.text = param2;
         this.icon = SkinManager.newInstance("prop.iconPack",this.value.toString());
         addChild(this.icon);
         Utils.fit(this.icon,this.bkgd,Utils.NO_SCALE,false,null,5);
         this.onOut();
      }
      
      public function getWidth() : Number
      {
         return this.bkgd.width;
      }
      
      public function getHeight() : Number
      {
         return this.bkgd.height;
      }
      
      public function cleanUp() : void
      {
         Utils.removeListener(this,MouseEvent.ROLL_OVER,this.onOver);
         Utils.removeListener(this,MouseEvent.ROLL_OUT,this.onOut);
      }
   }
}

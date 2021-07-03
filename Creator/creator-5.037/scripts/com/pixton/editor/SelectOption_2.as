package com.pixton.editor
{
   import flash.display.MovieClip;
   
   public final class SelectOption extends EditorButton
   {
      
      private static const EXTRA_PADDING:Number = 15;
       
      
      public var bkgd:MovieClip;
      
      public var value:int;
      
      private var _selected:Boolean = false;
      
      public function SelectOption()
      {
         super();
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         makePriority(param1);
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function setData(param1:int, param2:String) : void
      {
         this.value = param1;
         label = param2;
         this.bkgd.x = -Math.round(bkgdOn.width * 0.5);
         this.bkgd.y = 0;
         this.bkgd.width = bkgdOn.width;
         this.bkgd.height = bkgdOn.height;
      }
      
      override public function getHeight() : Number
      {
         return this.bkgd.height;
      }
   }
}

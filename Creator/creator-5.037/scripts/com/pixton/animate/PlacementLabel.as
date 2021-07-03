package com.pixton.animate
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class PlacementLabel extends MovieClip
   {
       
      
      public var txtName:TextField;
      
      public function PlacementLabel()
      {
         super();
         this.txtName.autoSize = TextFieldAutoSize.CENTER;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function setName(param1:String) : void
      {
         this.txtName.text = param1;
      }
   }
}

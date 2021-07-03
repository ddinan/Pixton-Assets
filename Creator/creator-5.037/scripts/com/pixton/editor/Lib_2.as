package com.pixton.editor
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   
   public final class Lib
   {
       
      
      public function Lib()
      {
         super();
      }
      
      static function drawPlaceHolder(param1:MovieClip, param2:Number, param3:Number, param4:Boolean = false) : void
      {
         var _loc5_:Number = !!param4 ? Number(0.3) : Number(1);
         var _loc6_:Graphics;
         (_loc6_ = param1.graphics).clear();
         if(param4)
         {
            _loc6_.beginFill(Palette.RGBtoHex(Palette.colorBkgd),_loc5_);
            _loc6_.moveTo(0,0);
            _loc6_.lineTo(param2,0);
            _loc6_.lineTo(param2,param3);
            _loc6_.lineTo(0,param3);
            _loc6_.lineTo(0,0);
            _loc6_.endFill();
         }
         _loc6_.lineStyle(1,Palette.colorText,_loc5_,false,"none");
         _loc6_.moveTo(0,0);
         _loc6_.lineTo(param2,0);
         _loc6_.lineTo(param2,param3);
         _loc6_.lineTo(0,param3);
         _loc6_.lineTo(0,0);
         if(param4)
         {
            _loc6_.lineStyle(1,Palette.colorText,_loc5_,false,"none");
            _loc6_.moveTo(0,0);
            _loc6_.lineTo(param2,param3);
            _loc6_.moveTo(param2,0);
            _loc6_.lineTo(0,param3);
         }
      }
   }
}

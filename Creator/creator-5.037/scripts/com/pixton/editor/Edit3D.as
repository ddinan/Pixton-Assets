package com.pixton.editor
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public final class Edit3D
   {
      
      private static const COLOR_MAX:uint = 192;
      
      private static const COLOR_LIGHTNESS:uint = 180;
      
      private static var active:Boolean = false;
      
      private static var editor:Editor;
      
      private static var container:MovieClip;
       
      
      public function Edit3D()
      {
         super();
      }
      
      public static function init(param1:Editor) : void
      {
         editor = param1;
         container = param1.getContainer();
      }
      
      public static function getActive() : Boolean
      {
         return active;
      }
      
      public static function setActive(param1:Boolean) : void
      {
         if(param1 == active)
         {
            return;
         }
         active = param1;
         update();
      }
      
      public static function update() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:DisplayObject = null;
         _loc2_ = container.numChildren;
         if(active)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc8_ = container.getChildAt(_loc1_);
               _loc7_ = Moveable(_loc8_).zIndex;
               _loc3_ = (_loc6_ = 1 - _loc7_ / Moveable.MAX_Z) * (COLOR_LIGHTNESS + (COLOR_MAX - COLOR_LIGHTNESS) * _loc6_);
               _loc4_ = _loc6_ * COLOR_LIGHTNESS;
               _loc5_ = _loc6_ * (COLOR_MAX - (COLOR_MAX - COLOR_LIGHTNESS) * _loc6_);
               Utils.setColor(_loc8_,[_loc3_,_loc4_,_loc5_,255]);
               _loc1_++;
            }
            editor.clearBackground();
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc8_ = container.getChildAt(_loc1_);
               Utils.setColor(_loc8_);
               _loc1_++;
            }
            editor.redraw();
         }
      }
   }
}

package com.pixton.editor
{
   import com.pixton.propSkin.PropPart;
   import com.pixton.propSkin.PropPosition;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class PropMovablePart
   {
       
      
      public var index:uint;
      
      public var target:PropPart;
      
      private var parts:Array;
      
      private var _value:uint = 0;
      
      public function PropMovablePart(param1:PropPart, param2:uint)
      {
         var _loc3_:uint = 0;
         var _loc5_:DisplayObject = null;
         this.parts = [];
         super();
         this.target = param1;
         this.index = param2;
         var _loc4_:uint = param1.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if((_loc5_ = param1.getChildAt(_loc3_)) is PropPosition)
            {
               this.parts.push(_loc5_);
            }
            _loc3_++;
         }
         this.value = 0;
      }
      
      public function set value(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc3_:uint = this.parts.length;
         param1 = Utils.limit(param1,0,_loc3_ - 1);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.parts[_loc2_].visible = _loc2_ == param1;
            _loc2_++;
         }
         this._value = param1;
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function get numPositions() : uint
      {
         return this.parts.length;
      }
   }
}

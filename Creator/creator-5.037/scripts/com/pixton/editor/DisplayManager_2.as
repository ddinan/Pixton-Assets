package com.pixton.editor
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   
   public final class DisplayManager
   {
      
      public static const P_X:String = "x";
      
      public static const P_Y:String = "y";
      
      public static const P_VIS:String = "visible";
       
      
      private var _displayList:Dictionary;
      
      public function DisplayManager()
      {
         super();
      }
      
      public function clear(param1:DisplayObject = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         if(this._displayList)
         {
            if(param1)
            {
               _loc2_ = this._displayList[param1];
               if(_loc2_)
               {
                  param1[P_X] = _loc2_[P_X];
                  param1[P_Y] = _loc2_[P_Y];
                  param1[P_VIS] = _loc2_[P_VIS];
                  delete this._displayList[param1];
               }
            }
            else
            {
               for(_loc3_ in this._displayList)
               {
                  _loc2_ = this._displayList[_loc3_];
                  DisplayObject(_loc3_)[P_X] = _loc2_[P_X];
                  DisplayObject(_loc3_)[P_Y] = _loc2_[P_Y];
                  DisplayObject(_loc3_)[P_VIS] = _loc2_[P_VIS];
               }
            }
         }
         if(!param1)
         {
            this._displayList = new Dictionary();
         }
      }
      
      public function GET(param1:DisplayObject, param2:String) : *
      {
         var _loc3_:Object = this.getItem(param1);
         if(_loc3_)
         {
            return _loc3_[param2];
         }
         return param1[param2];
      }
      
      public function SET(param1:DisplayObject, param2:String, param3:*, param4:Boolean = false) : void
      {
         var _loc5_:Object;
         if(_loc5_ = this.getItem(param1))
         {
            _loc5_[param2] = param3;
         }
         else
         {
            param1[param2] = param3;
         }
         if(param4 && param2 == P_VIS && param3 == true)
         {
            this.clear(param1);
         }
      }
      
      public function getItem(param1:DisplayObject) : Object
      {
         if(!this._displayList)
         {
            return null;
         }
         return this._displayList[param1];
      }
      
      public function addItem(param1:DisplayObject, param2:Number) : void
      {
         var _loc3_:Object = {};
         _loc3_[P_X] = param1[P_X];
         _loc3_[P_Y] = param1[P_Y];
         _loc3_[P_VIS] = param1[P_VIS];
         this._displayList[param1] = _loc3_;
         param1[P_Y] = param2;
         param1[P_VIS] = false;
      }
   }
}

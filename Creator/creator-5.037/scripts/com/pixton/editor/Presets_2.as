package com.pixton.editor
{
   public final class Presets
   {
      
      public static const BKGDS:String = "bkgds";
      
      public static const CHARS:String = "chars";
      
      private static var _maxFree:Object;
      
      private static var _freePresets:Object;
      
      private static var _checkLimits:Boolean = false;
       
      
      public function Presets()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         if(param1.check_presets != null)
         {
            _checkLimits = param1.check_presets == 1;
         }
         update(param1);
      }
      
      public static function update(param1:Object) : void
      {
         if(!_checkLimits)
         {
            return;
         }
         if(param1.max_free != null)
         {
            _maxFree = param1.max_free;
         }
         if(param1.free_presets != null && _maxFree != null)
         {
            _freePresets = param1.free_presets;
            if(_maxFree[BKGDS] == 0)
            {
               _freePresets[BKGDS] = [];
            }
            else if(_freePresets[BKGDS].length > _maxFree[BKGDS])
            {
               _freePresets[BKGDS] = _freePresets[BKGDS].slice(0,_maxFree[BKGDS]);
            }
            if(_maxFree[CHARS] == 0)
            {
               _freePresets[CHARS] = [];
            }
            else if(_freePresets[CHARS].length > _maxFree[CHARS])
            {
               _freePresets[CHARS] = _freePresets[CHARS].slice(0,_maxFree[CHARS]);
            }
         }
      }
      
      public static function isMaxed(param1:String, param2:int = -1) : Boolean
      {
         if(_freePresets != null && _maxFree != null)
         {
            return _freePresets[param1].length >= _maxFree[param1] && !Utils.inArray(param2,_freePresets[param1]);
         }
         return false;
      }
   }
}

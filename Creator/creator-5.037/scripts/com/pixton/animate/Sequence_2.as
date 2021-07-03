package com.pixton.animate
{
   import com.pixton.editor.Character;
   import com.pixton.editor.Pixton;
   import com.pixton.editor.Utils;
   
   public class Sequence
   {
      
      public static var unsaved:Array;
      
      private static var list:Array;
      
      private static var map:Object;
       
      
      public var id:int = 0;
      
      public var name:String;
      
      public var saved:Boolean;
      
      public var targetType:int = -1;
      
      public var targetSubtype:int = -1;
      
      private var timelineData:Array;
      
      private var numCells:uint = 0;
      
      public function Sequence()
      {
         super();
      }
      
      public static function setData(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Sequence = null;
         list = [];
         var _loc2_:Array = [];
         if(param1.userSequences is Array)
         {
            _loc2_[Pixton.POOL_MINE] = param1.userSequences as Array;
         }
         else
         {
            _loc2_[Pixton.POOL_MINE] = [];
         }
         if(param1.presetSequences is Array)
         {
            _loc2_[Pixton.POOL_COMMUNITY] = param1.presetSequences as Array;
         }
         else
         {
            _loc2_[Pixton.POOL_COMMUNITY] = [];
         }
         _loc3_ = Pixton.POOL_MINE;
         while(_loc3_ <= Pixton.POOL_COMMUNITY)
         {
            list[_loc3_] = [];
            _loc5_ = _loc2_[_loc3_].length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc2_[_loc3_][_loc4_].t1;
               _loc7_ = _loc2_[_loc3_][_loc4_].t2;
               require(_loc3_,_loc6_,_loc7_);
               (_loc8_ = new Sequence()).setData(_loc2_[_loc3_][_loc4_]);
               list[_loc3_][_loc6_][_loc7_].push(_loc8_);
               _loc4_++;
            }
            _loc3_++;
         }
         updateMap();
      }
      
      private static function require(param1:uint, param2:uint, param3:uint) : void
      {
         if(list[param1][param2] == null)
         {
            list[param1][param2] = [];
         }
         if(list[param1][param2][param3] == null)
         {
            list[param1][param2][param3] = [];
         }
      }
      
      private static function updateMap() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         map = {};
         _loc1_ = Pixton.POOL_MINE;
         while(_loc1_ <= Pixton.POOL_COMMUNITY)
         {
            _loc3_ = list[_loc1_].length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(list[_loc1_][_loc2_] != null)
               {
                  _loc5_ = list[_loc1_][_loc2_].length;
                  _loc4_ = 0;
                  while(_loc4_ < _loc5_)
                  {
                     if(list[_loc1_][_loc2_][_loc4_] != null)
                     {
                        _loc7_ = list[_loc1_][_loc2_][_loc4_].length;
                        _loc6_ = 0;
                        while(_loc6_ < _loc7_)
                        {
                           map[Sequence(list[_loc1_][_loc2_][_loc4_][_loc6_]).id.toString()] = [_loc1_,_loc2_,_loc4_,_loc6_];
                           _loc6_++;
                        }
                     }
                     _loc4_++;
                  }
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public static function getSequence(param1:uint) : Sequence
      {
         var _loc2_:Array = map[param1.toString()];
         if(_loc2_ == null)
         {
            return null;
         }
         return list[_loc2_[0]][_loc2_[1]][_loc2_[2]][_loc2_[3]] as Sequence;
      }
      
      public static function getInfo(param1:uint) : Object
      {
         var _loc2_:Sequence = getSequence(param1);
         var _loc3_:Array = _loc2_.getFirstPosition();
         return {
            "positionData":_loc3_,
            "name":_loc2_.name
         };
      }
      
      public static function hasType(param1:Object) : Boolean
      {
         var _loc4_:uint = 0;
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:uint = Animation.getTargetType(param1);
         var _loc3_:uint = param1 is Character ? uint(Character(param1).skinType) : uint(0);
         _loc4_ = Pixton.POOL_MINE;
         while(_loc4_ <= Pixton.POOL_COMMUNITY)
         {
            if(list[_loc4_][_loc2_] != null && list[_loc4_][_loc2_][_loc3_] != null)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public static function getList(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint) : Object
      {
         var _loc8_:* = undefined;
         require(param1,param2,param3);
         var _loc6_:Array = list[param1][param2][param3].slice(param4,Math.min(list[param1][param2][param3].length,param4 + param5));
         var _loc7_:Array = [];
         for each(_loc8_ in _loc6_)
         {
            _loc7_.push(_loc8_.id);
         }
         return {
            "array":_loc7_,
            "showPrev":param4 > 0,
            "showNext":param4 + param5 < list[param1][param2][param3].length
         };
      }
      
      public static function searchList(param1:uint, param2:uint, param3:uint, param4:String, param5:uint) : Object
      {
         var _loc7_:uint = 0;
         param4 = param4.toLowerCase();
         var _loc6_:Array = [];
         var _loc8_:uint = list[param1][param2][param3].length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(Sequence(list[param1][param2][param3][_loc7_]).name.toLowerCase().indexOf(param4) > -1)
            {
               _loc6_.push(Sequence(list[param1][param2][param3][_loc7_]).id);
               if(_loc6_.length == param5)
               {
                  break;
               }
            }
            _loc7_++;
         }
         return {
            "array":_loc6_,
            "showPrev":false,
            "showNext":false
         };
      }
      
      public static function addData(param1:Sequence) : void
      {
         var _loc2_:uint = param1.targetType;
         var _loc3_:uint = param1.targetSubtype;
         require(Pixton.POOL_MINE,_loc2_,_loc3_);
         list[Pixton.POOL_MINE][_loc2_][_loc3_].unshift(param1);
         updateMap();
      }
      
      public static function has(param1:uint, param2:uint, param3:uint) : Boolean
      {
         require(param1,param2,param3);
         return list[param1][param2][param3].length > 0;
      }
      
      public static function getPool(param1:uint) : uint
      {
         var _loc2_:Array = map[param1.toString()];
         return _loc2_[0];
      }
      
      public function setName(param1:String) : void
      {
         this.name = param1;
      }
      
      public function setTarget(param1:Object) : void
      {
         this.targetType = Animation.getTargetType(param1);
         if(param1 is Character)
         {
            this.targetSubtype = Character(param1).skinType;
         }
      }
      
      public function setTimelineData(param1:Array) : void
      {
         this.timelineData = param1;
      }
      
      public function getTimelineData() : Array
      {
         return this.timelineData;
      }
      
      public function getNumCells() : uint
      {
         return this.timelineData[0].d.data[0].n;
      }
      
      public function getNumRows() : uint
      {
         return this.timelineData.length;
      }
      
      public function getFirstPosition() : Array
      {
         var _loc1_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:uint = this.timelineData.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.timelineData[_loc1_].d.data.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(this.timelineData[_loc1_].d.data[_loc3_].m == Animation.MODE_EXPR)
               {
                  return this.timelineData[_loc1_].d.data[_loc3_].k[0].d.p;
               }
               _loc3_++;
            }
            _loc1_++;
         }
         return null;
      }
      
      public function getFirstMode() : uint
      {
         return this.timelineData[0].d.data[0].m;
      }
      
      public function includesMode(param1:int = -1) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param1 > -1)
         {
            _loc3_ = this.timelineData.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc5_ = this.timelineData[_loc2_].d.data.length;
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  if(this.timelineData[_loc2_].d.data[_loc4_].m == param1)
                  {
                     return true;
                  }
                  _loc4_++;
               }
               _loc2_++;
            }
            return false;
         }
         return true;
      }
      
      public function setData(param1:Object) : void
      {
         this.id = param1.id;
         this.targetType = param1.t1;
         this.targetSubtype = param1.t2;
         this.name = param1.nm;
         this.timelineData = Utils.decode(param1.d) as Array;
         this.timelineData[0].d.data[0].n = param1.n;
      }
      
      public function getData() : Object
      {
         return {
            "id":this.id,
            "t1":this.targetType,
            "t2":this.targetSubtype,
            "n":this.getNumCells(),
            "d":Utils.encode(this.timelineData),
            "nm":this.name
         };
      }
   }
}

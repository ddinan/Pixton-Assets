package com.pixton.editor
{
   public final class Pose
   {
      
      public static var unsaved:Array;
      
      public static var lastPoolPose:uint = 0;
      
      public static var lastPoolFace:uint = 0;
      
      private static var list:Object;
      
      private static var map:Object;
       
      
      public var id:int = 0;
      
      public var name:String = "";
      
      public var keywords:String = "";
      
      public var saved:Boolean;
      
      public var targetType:int = -1;
      
      public var targetSubtype:int = -1;
      
      public var targetMode:int = -1;
      
      public var isNew:Boolean = false;
      
      private var poseData:Object;
      
      private var numCells:uint = 0;
      
      public function Pose()
      {
         super();
      }
      
      static function init() : void
      {
         lastPoolPose = Pixton.POOL_PRESET;
         lastPoolFace = Pixton.POOL_PRESET;
      }
      
      public static function setData(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Pose = null;
         var _loc11_:Array = null;
         var _loc12_:Object = null;
         list = {};
         var _loc2_:Object = {};
         if(param1.userPoses is Array)
         {
            _loc2_[Pixton.POOL_MINE] = param1.userPoses as Array;
         }
         else
         {
            _loc2_[Pixton.POOL_MINE] = [];
         }
         _loc2_[Pixton.POOL_PRESET] = [];
         _loc2_[Pixton.POOL_NEW] = [];
         if(param1.presetPoses is Array)
         {
            _loc11_ = param1.presetPoses as Array;
            for each(_loc12_ in _loc11_)
            {
               if(_loc12_.nm == "default")
               {
                  _loc2_[Pixton.POOL_NEW].push(_loc12_);
               }
               else
               {
                  _loc2_[Pixton.POOL_PRESET].push(_loc12_);
               }
            }
         }
         var _loc4_:Array = [Pixton.POOL_MINE,Pixton.POOL_PRESET,Pixton.POOL_NEW];
         for each(_loc3_ in _loc4_)
         {
            list[_loc3_] = [];
            if(_loc2_[_loc3_] != null)
            {
               _loc6_ = _loc2_[_loc3_].length;
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  _loc7_ = _loc2_[_loc3_][_loc5_].t1;
                  _loc8_ = _loc2_[_loc3_][_loc5_].t2;
                  _loc9_ = _loc2_[_loc3_][_loc5_].n;
                  require(_loc3_,_loc7_,_loc8_,_loc9_);
                  (_loc10_ = new Pose()).setData(_loc2_[_loc3_][_loc5_]);
                  list[_loc3_][_loc7_][_loc8_][_loc9_].push(_loc10_);
                  _loc5_++;
               }
            }
         }
         updateMap();
      }
      
      private static function require(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         if(list[param1][param2] == null)
         {
            list[param1][param2] = [];
         }
         if(list[param1][param2][param3] == null)
         {
            list[param1][param2][param3] = [];
         }
         if(list[param1][param2][param3][param4] == null)
         {
            list[param1][param2][param3][param4] = [];
         }
      }
      
      private static function updateMap() : void
      {
         var _loc1_:* = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         map = {};
         for(_loc1_ in list)
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
                           if(list[_loc1_][_loc2_][_loc4_][_loc6_] != null)
                           {
                              _loc9_ = list[_loc1_][_loc2_][_loc4_][_loc6_].length;
                              _loc8_ = 0;
                              while(_loc8_ < _loc9_)
                              {
                                 map[Pose(list[_loc1_][_loc2_][_loc4_][_loc6_][_loc8_]).id.toString()] = [_loc1_,_loc2_,_loc4_,_loc6_,_loc8_];
                                 _loc8_++;
                              }
                           }
                           _loc6_++;
                        }
                     }
                     _loc4_++;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public static function getPose(param1:uint) : Pose
      {
         var _loc2_:Array = map[param1.toString()];
         if(_loc2_ == null)
         {
            return null;
         }
         return list[_loc2_[0]][_loc2_[1]][_loc2_[2]][_loc2_[3]][_loc2_[4]] as Pose;
      }
      
      public static function getRandom(param1:uint, param2:uint, param3:uint, param4:String = null, param5:int = -1) : Object
      {
         var _loc6_:Array = null;
         var _loc7_:Pose = null;
         var _loc8_:uint = 0;
         if(param5 == -1)
         {
            param5 = param2 == Globals.POSES ? int(lastPoolPose) : int(lastPoolFace);
         }
         require(param5,param1,param2,param3);
         if(param4 == null)
         {
            _loc6_ = list[param5][param1][param2][param3];
         }
         else
         {
            _loc6_ = [];
            for each(_loc7_ in list[param5][param1][param2][param3])
            {
               if(_loc7_.name.indexOf(param4) != -1)
               {
                  _loc6_.push(_loc7_);
               }
            }
         }
         if(_loc6_.length > 0)
         {
            _loc8_ = Math.floor(Math.random() * _loc6_.length);
            return Pose(_loc6_[_loc8_]).getPoseData();
         }
         return null;
      }
      
      private static function isBlank(param1:uint, param2:uint, param3:uint, param4:uint) : Boolean
      {
         require(param1,param2,param3,param4);
         return list[param1][param2][param3][param4].length <= 0;
      }
      
      public static function getInfo(param1:uint) : Object
      {
         var _loc2_:Pose = getPose(param1);
         var _loc3_:Object = _loc2_.getPoseData();
         return {
            "poseData":_loc3_,
            "name":_loc2_.name
         };
      }
      
      public static function hasType(param1:Object, param2:uint) : Boolean
      {
         var _loc5_:* = null;
         if(param1 == null)
         {
            return false;
         }
         var _loc3_:uint = Pixton.getTargetType(param1);
         var _loc4_:uint = param1 is Character ? uint(Character(param1).skinType) : uint(0);
         for(_loc5_ in list)
         {
            require(parseInt(_loc5_),_loc3_,_loc4_,param2);
            if(list[_loc5_][_loc3_][_loc4_][param2].length > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getList(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint) : Object
      {
         var _loc10_:Object = null;
         require(param1,param2,param3,param4);
         var _loc7_:Boolean = Main.isPosesUser() && Main.optionPressed && param1 == Pixton.POOL_PRESET;
         var _loc8_:Array = list[param1][param2][param3][param4].slice(param5,Math.min(list[param1][param2][param3][param4].length,param5 + param6));
         var _loc9_:Array = [];
         for each(_loc10_ in _loc8_)
         {
            if(!(_loc7_ && !Pose(_loc10_).isNew))
            {
               _loc9_.push(_loc10_.id);
            }
         }
         return {
            "array":_loc9_,
            "showPrev":param5 > 0,
            "showNext":param5 + param6 < list[param1][param2][param3][param4].length
         };
      }
      
      public static function searchList(param1:uint, param2:uint, param3:uint, param4:uint, param5:String, param6:uint, param7:uint) : Object
      {
         var _loc11_:Object = null;
         var _loc8_:Array = list[param1][param2][param3][param4];
         var _loc9_:Array = [];
         var _loc10_:Array = Keyword.prepareUserSearch(param5);
         for each(_loc11_ in _loc8_)
         {
            if(Keyword.matches(Pose(_loc11_).keywords,_loc10_))
            {
               _loc9_.push(Pose(_loc11_).id);
            }
         }
         return {
            "total":_loc9_.length,
            "array":_loc9_.slice(param6,Math.min(_loc9_.length,param6 + param7)),
            "showPrev":param6 > 0,
            "showNext":param6 + param7 < _loc9_.length,
            "search":_loc10_.join(" ")
         };
      }
      
      public static function has(param1:uint, param2:uint, param3:uint, param4:uint) : Boolean
      {
         require(param1,param2,param3,param4);
         return list[param1][param2][param3][param4].length > 0;
      }
      
      public static function addData(param1:Pose) : void
      {
         var _loc2_:uint = param1.targetType;
         var _loc3_:uint = param1.targetSubtype;
         var _loc4_:uint = param1.targetMode;
         require(Pixton.POOL_MINE,_loc2_,_loc3_,_loc4_);
         param1.isNew = true;
         list[!!Main.isPosesUser() ? Pixton.POOL_PRESET : Pixton.POOL_MINE][_loc2_][_loc3_][_loc4_].unshift(param1);
         updateMap();
      }
      
      public static function deleteData(param1:Pose) : void
      {
         var _loc6_:uint = 0;
         var _loc2_:uint = param1.targetType;
         var _loc3_:uint = param1.targetSubtype;
         var _loc4_:uint = param1.targetMode;
         var _loc5_:int = -1;
         var _loc7_:uint = list[Pixton.POOL_MINE][_loc2_][_loc3_][_loc4_].length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if(list[Pixton.POOL_MINE][_loc2_][_loc3_][_loc4_][_loc6_] == param1)
            {
               _loc5_ = _loc6_;
               break;
            }
            _loc6_++;
         }
         list[Pixton.POOL_MINE][_loc2_][_loc3_][_loc4_].splice(_loc5_,1);
         updateMap();
      }
      
      public static function deletePose(param1:uint) : Pose
      {
         var _loc2_:Pose = getPose(param1);
         deleteData(_loc2_);
         return _loc2_;
      }
      
      public static function getPool(param1:uint) : uint
      {
         var _loc2_:Array = map[param1.toString()];
         return _loc2_[0];
      }
      
      public static function getURL(param1:uint, param2:uint, param3:String, param4:int) : String
      {
         var _loc5_:String = null;
         switch(param1)
         {
            case Globals.EXPRESSION:
               _loc5_ = "expr";
               break;
            case Globals.LOOKS:
               _loc5_ = "look";
               break;
            default:
               _loc5_ = "pose";
         }
         return "web/" + _loc5_ + "/char-" + param2 + "/_" + (param3 == null ? "" : Character.normalizePartName(param3) + "-") + param4 + Utils.EXT_PNG;
      }
      
      public function setName(param1:String) : void
      {
         this.name = param1.toLowerCase();
      }
      
      public function setTarget(param1:Object) : void
      {
         this.targetType = Pixton.getTargetType(param1);
         if(param1 is Character)
         {
            this.targetSubtype = Character(param1).skinType;
         }
      }
      
      public function setMode(param1:uint) : void
      {
         this.targetMode = param1;
      }
      
      public function setPoseData(param1:Object) : void
      {
         this.poseData = param1;
      }
      
      public function getPoseData() : Object
      {
         return this.poseData;
      }
      
      public function setData(param1:Object) : void
      {
         this.id = param1.id;
         this.targetType = param1.t1;
         this.targetSubtype = param1.t2;
         this.targetMode = param1.n;
         var _loc2_:Array = [];
         if(param1.nm)
         {
            this.name = param1.nm.toLowerCase();
            _loc2_.push(param1.nm);
         }
         if(param1.k)
         {
            _loc2_.push(param1.k);
         }
         this.keywords = _loc2_.join(" ").toLowerCase();
         this.poseData = Utils.decode(param1.d);
      }
      
      public function getData() : Object
      {
         return {
            "id":this.id,
            "t1":this.targetType,
            "t2":this.targetSubtype,
            "n":this.targetMode,
            "d":Utils.encode(this.poseData),
            "nm":this.name
         };
      }
   }
}

package com.pixton.editor
{
   import com.pixton.team.Team;
   import flash.display.BitmapData;
   
   public class PropPhoto extends Photo
   {
      
      public static var defaultName:String = "";
      
      public static var thumbCache:Object = {};
      
      private static var propPhotoData:Array;
      
      private static var propPhotoDataVisible:Array;
      
      private static var map:Object;
       
      
      public function PropPhoto(param1:uint, param2:uint = 0)
      {
         var _loc3_:Object = null;
         var _loc4_:BitmapData = null;
         var _loc5_:String = null;
         super();
         cacheKey = "PropPhoto";
         if(Team.isActive && param1 > 0)
         {
            Team.require(param1.toString(),null,Team.P_PHOTO);
         }
         this.id = param1;
         _loc3_ = PropPhoto.getData(param1);
         if(_loc3_ != null)
         {
            propName = _loc3_.n;
            fileName = _loc3_.f;
            drawPlaceholderBox(_loc3_.w,_loc3_.h);
            if((_loc4_ = Cache.load(cacheKey,param1)) != null)
            {
               placeImage(_loc4_);
            }
            else
            {
               _loc5_ = getImagePath(param1,fileName);
               Utils.load(_loc5_,onLoadImage,false,File.BUCKET_DYNAMIC);
            }
            sendTeamUpdate(param1,_loc3_);
         }
         else
         {
            onLoadImage();
         }
      }
      
      public static function init(param1:Object) : void
      {
         defaultName = param1.defaultName;
      }
      
      public static function has(param1:uint) : Boolean
      {
         require(param1);
         return propPhotoDataVisible[param1].length > 0;
      }
      
      private static function require(param1:uint) : void
      {
         if(propPhotoData == null)
         {
            propPhotoData = [];
            propPhotoDataVisible = [];
         }
         if(propPhotoData[param1] == null)
         {
            propPhotoData[param1] = [];
            propPhotoDataVisible[param1] = [];
         }
      }
      
      public static function getList(param1:uint, param2:uint, param3:uint) : Object
      {
         var _loc6_:Object = null;
         var _loc4_:Array = propPhotoDataVisible[param1].slice(param2,Math.min(propPhotoDataVisible[param1].length,param2 + param3));
         var _loc5_:Array = [];
         for each(_loc6_ in _loc4_)
         {
            _loc5_.push(_loc6_.id);
         }
         return {
            "array":_loc5_,
            "showPrev":param2 > 0,
            "showNext":param2 + param3 < propPhotoDataVisible[param1].length
         };
      }
      
      public static function getCount(param1:uint) : uint
      {
         return propPhotoData[param1].length;
      }
      
      public static function searchList(param1:uint, param2:String, param3:uint, param4:uint) : Object
      {
         var _loc8_:Object = null;
         var _loc5_:Array = propPhotoDataVisible[param1];
         var _loc6_:Array = [];
         var _loc7_:Array = Keyword.prepareUserSearch(param2);
         for each(_loc8_ in _loc5_)
         {
            if(Keyword.matches(_loc8_.n,_loc7_))
            {
               _loc6_.push(_loc8_.id);
            }
         }
         return {
            "array":_loc6_.slice(param3,Math.min(_loc6_.length,param3 + param4)),
            "showPrev":param3 > 0,
            "showNext":param3 + param4 < _loc6_.length,
            "search":_loc7_.join(" ")
         };
      }
      
      public static function setData(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:uint = 0;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         if(!param2)
         {
            _loc3_ = param1.lockedPropPhotos as Array;
            if(_loc3_ != null && _loc3_.length > 0)
            {
               for each(_loc4_ in _loc3_)
               {
                  if(map[_loc4_.id.toString()] != null)
                  {
                     updateByID(_loc4_.id,_loc4_);
                  }
                  else
                  {
                     require(Pixton.POOL_LOCKED);
                     propPhotoData[Pixton.POOL_LOCKED].push(_loc4_);
                  }
               }
            }
         }
         else
         {
            if(propPhotoData != null && propPhotoData[Pixton.POOL_MINE] != null)
            {
               propPhotoData[Pixton.POOL_MINE] = null;
            }
            _loc9_ = [];
            _loc10_ = Pixton.POOL_LOCKED;
            _loc11_ = param1.userPropPhotos as Array;
            _loc9_[Pixton.POOL_MINE] = _loc11_;
            _loc9_[Pixton.POOL_PRESET] = [];
            if(param1.lockedPropPhotos != null)
            {
               _loc12_ = param1.lockedPropPhotos as Array;
               _loc9_[Pixton.POOL_LOCKED] = _loc12_;
               _loc10_ = Pixton.POOL_LOCKED;
            }
            _loc7_ = Pixton.POOL_MINE;
            while(_loc7_ <= _loc10_)
            {
               if(_loc9_[_loc7_] != null)
               {
                  require(_loc7_);
                  _loc6_ = _loc9_[_loc7_].length;
                  _loc5_ = 0;
                  while(_loc5_ < _loc6_)
                  {
                     propPhotoData[_loc7_].push(_loc9_[_loc7_][_loc5_]);
                     if(_loc9_[_loc7_][_loc5_].hd != 1)
                     {
                        propPhotoDataVisible[_loc7_].push(_loc9_[_loc7_][_loc5_]);
                     }
                     _loc5_++;
                  }
               }
               _loc7_++;
            }
         }
         updateMap();
      }
      
      public static function hide(param1:int) : void
      {
         Utils.remote("hidePropPhoto",{"prop":param1});
         remove(param1);
      }
      
      private static function remove(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = Pixton.POOL_MINE;
         _loc3_ = propPhotoDataVisible[_loc4_].length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(propPhotoDataVisible[_loc4_][_loc2_].id == param1)
            {
               propPhotoDataVisible[_loc4_].splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      private static function updateMap() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         map = {};
         var _loc3_:uint = propPhotoData.length;
         _loc1_ = Pixton.POOL_MINE;
         while(_loc1_ <= Pixton.POOL_LOCKED)
         {
            if(propPhotoData[_loc1_] != null)
            {
               _loc3_ = propPhotoData[_loc1_].length;
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  map[propPhotoData[_loc1_][_loc2_].id.toString()] = [_loc1_,_loc2_];
                  _loc2_++;
               }
            }
            _loc1_++;
         }
      }
      
      public static function hasData(param1:uint) : Boolean
      {
         return map[param1.toString()] != null;
      }
      
      public static function getData(param1:uint) : Object
      {
         var _loc2_:String = param1.toString();
         var _loc3_:Array = map[_loc2_];
         if(_loc3_ != null)
         {
            return propPhotoData[_loc3_[0]][_loc3_[1]];
         }
         return null;
      }
      
      private static function updateByID(param1:uint, param2:Object) : void
      {
         var _loc3_:Array = map[param1.toString()];
         propPhotoData[_loc3_[0]][_loc3_[1]] = param2;
      }
      
      public static function update(param1:PropPhoto) : void
      {
         updateByID(param1.id,param1.getPhotoData());
      }
      
      static function sendTeamUpdate(param1:int, param2:Object) : void
      {
         if(!Team.isActive)
         {
            return;
         }
         Team.onChange(Main.userID.toString(),null,Team.P_PHOTO_LIST,param1.toString(),1);
         Team.onChange(param1.toString(),null,Team.P_PHOTO,null,param2);
      }
      
      static function getImagePath(param1:int, param2:String = null) : String
      {
         return File.LOCAL_BUCKET + "photo/" + (param2 == null ? "_" : "") + param1 + (param2 == null ? PickerItem.IMAGE_EXT : param2);
      }
      
      private static function addData(param1:Object, param2:uint) : void
      {
         if(hasData(param1.id))
         {
            return;
         }
         require(param2);
         propPhotoData[param2].unshift(param1);
         if(param1.hd == null || param1.hd != 1)
         {
            propPhotoDataVisible[param2].unshift(param1);
         }
         updateMap();
      }
      
      static function onTeamUpdate(param1:int, param2:Object) : void
      {
         param2.hd = 1;
         addData(param2,Pixton.POOL_COMMUNITY);
      }
      
      function promptForName(param1:Function) : void
      {
         Popup.show(L.text("name-photo"),this.onName,param1,propName == defaultName ? "" : propName);
      }
      
      private function onName(param1:String = null, param2:Function = null) : void
      {
         if(param1 != null)
         {
            propName = param1;
         }
         param2(true);
      }
      
      function updateID(param1:uint) : void
      {
         this.id = param1;
      }
      
      function getPhotoData() : Object
      {
         return {
            "id":id,
            "n":propName
         };
      }
   }
}

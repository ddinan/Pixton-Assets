package com.pixton.editor
{
   import com.pixton.team.Team;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public final class PropSet extends Prop
   {
      
      public static const OBJECT:uint = 0;
      
      public static const BACKGROUND:uint = 1;
      
      public static var COMMUNITY_VISIBLE:Boolean = false;
      
      public static var COMMUNITY_LABEL:String;
      
      public static var defaultName:String = "";
      
      public static var lastPool:uint;
      
      public static var communityDisabled:Boolean = false;
      
      private static var propSetData:Object;
      
      private static var propSetDataVisible:Object;
      
      private static var propSetBySetting:Object;
      
      private static var propSetBySettingMap:Object;
      
      private static var map:Object;
      
      private static var searchCache:Object = {};
      
      private static var _communityLoaded:Object = {};
      
      private static var _allowedSettingNums:Array;
       
      
      public var saved:Boolean = false;
      
      public var zOrder:Array;
      
      public var bkgdColor:uint = 0;
      
      public var bkgdGradient:uint = 0;
      
      private var masker:MovieClip;
      
      private var maskerG:Graphics;
      
      private var propData:Array;
      
      private var dialogData:Array;
      
      private var modifiedDate:uint;
      
      private var sceneKey:String = "";
      
      private var parentID:uint;
      
      private var editable:Boolean = true;
      
      private var alwaysEditable:Boolean = false;
      
      private var _isReady:Boolean = false;
      
      private var _onReady:Function;
      
      private var borderData:Object;
      
      public function PropSet(param1:uint = 0, param2:uint = 0)
      {
         var data:Object = null;
         var thisPropSet:PropSet = null;
         var id:uint = param1;
         var mode:uint = param2;
         super();
         if(id > 0)
         {
            this.id = id;
            this.zOrder = [];
            data = PropSet.getData(id);
            if(data != null)
            {
               propName = data.n;
               this.sceneKey = data.scene;
               this.bkgdColor = data.k;
               if(data.bs != null)
               {
                  this.bkgdGradient = parseInt(data.bs);
               }
               else
               {
                  this.bkgdGradient = Palette.GRADIENT_NONE;
               }
               this.editable = !data.locked;
               this.alwaysEditable = data.edit;
               if(data.p != null)
               {
                  this._isReady = true;
                  Prop.load(this,data.p);
                  Dialog.load(this,data.d);
                  if(this.isBkgd() && data.b != null)
                  {
                     this.setBorderData(Utils.decode(data.b));
                  }
               }
               else
               {
                  this._isReady = false;
                  thisPropSet = this;
                  Asset.loadFromServer("loadPropsDyn",function(param1:Object):void
                  {
                     if(!Main.handleError(param1))
                     {
                        Debug.trace("FAILED to get propset inner data");
                        return;
                     }
                     PropSet.setData(param1,false);
                     data = PropSet.getData(id);
                     Prop.load(thisPropSet,data.p);
                     thisPropSet.reloadColors();
                     if(isBkgd() && data.b != null)
                     {
                        setBorderData(Utils.decode(data.b));
                     }
                     _isReady = true;
                     if(_onReady != null)
                     {
                        _onReady();
                        _onReady = null;
                     }
                     Editor.self.selector.updateIfMatches(thisPropSet);
                  },{
                     "id":id,
                     "single":true
                  });
               }
            }
            this.saved = true;
         }
         else
         {
            propName = defaultName;
         }
      }
      
      public static function init(param1:Object) : void
      {
         defaultName = param1.defaultName;
         lastPool = Pixton.POOL_PRESET;
         if(param1.tsa != null)
         {
            _allowedSettingNums = param1.tsa;
         }
         if(param1.comm == 0)
         {
            communityDisabled = true;
         }
      }
      
      public static function exist(param1:uint) : Boolean
      {
         return propSetDataVisible != null && (propSetDataVisible[Pixton.POOL_MINE][param1] != null || propSetDataVisible[Pixton.POOL_PRESET][param1] != null || propSetDataVisible[Pixton.POOL_COMMUNITY][param1] != null);
      }
      
      public static function has(param1:uint, param2:uint) : Boolean
      {
         require(param1,param2);
         return propSetDataVisible[param1].length > 0 && propSetDataVisible[param1][param2].length > 0;
      }
      
      private static function require(param1:uint, param2:uint) : void
      {
         if(propSetData == null)
         {
            propSetData = {};
            propSetDataVisible = {};
         }
         if(propSetData[param1] == null)
         {
            propSetData[param1] = [];
            propSetDataVisible[param1] = [];
         }
         if(propSetData[param1][param2] == null)
         {
            propSetData[param1][param2] = [];
            propSetDataVisible[param1][param2] = [];
         }
      }
      
      private static function customSort(param1:*, param2:*) : int
      {
         if(param1.settingNum == null)
         {
            param1.settingNum = parseInt(Template.extractSettingNum(param1.setting));
            param1.sceneNum = parseInt(Template.extractSettingScene(param1.setting));
         }
         if(param2.settingNum == null)
         {
            param2.settingNum = parseInt(Template.extractSettingNum(param2.setting));
            param2.sceneNum = parseInt(Template.extractSettingScene(param2.setting));
         }
         if(Template.getSetting() && param1.settingNum == parseInt(Template.getSetting()) && param2.settingNum != parseInt(Template.getSetting()))
         {
            return -1;
         }
         if(Template.getSetting() && param1.settingNum != parseInt(Template.getSetting()) && param2.settingNum == parseInt(Template.getSetting()))
         {
            return 1;
         }
         if(param1.settingNum < param2.settingNum)
         {
            return -1;
         }
         if(param1.settingNum > param2.settingNum)
         {
            return 1;
         }
         if(param1.sceneNum < param2.sceneNum)
         {
            return -1;
         }
         if(param1.sceneNum > param2.sceneNum)
         {
            return 1;
         }
         return 0;
      }
      
      public static function getList(param1:uint, param2:uint, param3:uint = 0, param4:int = -1, param5:String = null) : Object
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:* = null;
         if(propSetDataVisible == null || propSetDataVisible[param1] == null || propSetDataVisible[param1][param2] == null || propSetDataVisible[param1][param2].length == 0)
         {
            return {
               "array":[],
               "showPrev":false,
               "showNext":false
            };
         }
         var _loc6_:Array = propSetDataVisible[param1][param2];
         var _loc7_:Array = [];
         if(param1 == Pixton.POOL_PRESET && _loc6_.length > 0 || _loc6_[0].setting != null)
         {
            if(param5)
            {
               _loc6_ = propSetBySettingMap[param1][param2][param5];
            }
            else if(_loc6_.length > 0 && _loc6_[0].setting != null)
            {
               if(!propSetBySetting)
               {
                  propSetBySetting = {};
                  propSetBySettingMap = {};
               }
               if(!propSetBySetting[param1])
               {
                  propSetBySetting[param1] = {};
                  propSetBySettingMap[param1] = {};
               }
               if(!propSetBySetting[param1][param2])
               {
                  propSetBySetting[param1][param2] = [];
                  propSetBySettingMap[param1][param2] = {};
                  _loc9_ = _loc6_.length;
                  _loc8_ = 0;
                  while(_loc8_ < _loc9_)
                  {
                     _loc11_ = Template.extractSettingNum(_loc6_[_loc8_].setting);
                     if(!(_allowedSettingNums && _allowedSettingNums.length && !Utils.inArray(_loc11_,_allowedSettingNums)))
                     {
                        if(!propSetBySettingMap[param1][param2][_loc11_])
                        {
                           propSetBySettingMap[param1][param2][_loc11_] = [];
                        }
                        propSetBySettingMap[param1][param2][_loc11_].push(_loc6_[_loc8_]);
                     }
                     _loc8_++;
                  }
                  for(_loc12_ in propSetBySettingMap[param1][param2])
                  {
                     propSetBySettingMap[param1][param2][_loc12_].sort(customSort);
                     propSetBySetting[param1][param2].push(propSetBySettingMap[param1][param2][_loc12_][0]);
                  }
               }
               _loc6_ = propSetBySetting[param1][param2];
            }
         }
         if(param3 == 0 && param1 == Pixton.POOL_PRESET && Template.getSetting())
         {
            _loc6_.sort(customSort);
         }
         if(param4 == -1 && param3 == 0)
         {
            param4 = _loc6_.length;
         }
         var _loc10_:Array;
         _loc9_ = (_loc10_ = _loc6_.slice(param3,Math.min(_loc6_.length,param3 + param4))).length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc7_.push(_loc10_[_loc8_].id);
            _loc8_++;
         }
         return {
            "array":_loc7_,
            "showPrev":param3 > 0 || param1 == Pixton.POOL_PRESET && param5,
            "showNext":param3 + param4 < _loc6_.length
         };
      }
      
      public static function searchList(param1:uint, param2:uint, param3:String, param4:uint, param5:uint) : Object
      {
         var _loc9_:Object = null;
         var _loc6_:Array = propSetDataVisible[param1][param2];
         var _loc7_:Array = [];
         var _loc8_:Array = Keyword.prepareUserSearch(param3,param1 == Pixton.POOL_MINE);
         for each(_loc9_ in _loc6_)
         {
            if(Keyword.matches(_loc9_.kw,_loc8_))
            {
               _loc7_.push(_loc9_.id);
            }
         }
         return {
            "total":_loc7_.length,
            "array":_loc7_.slice(param4,Math.min(_loc7_.length,param4 + param5)),
            "showPrev":param4 > 0 || param1 == Pixton.POOL_COMMUNITY || param1 == Pixton.POOL_PRESET,
            "showNext":param4 + param5 < _loc7_.length,
            "search":_loc8_.join(" ")
         };
      }
      
      public static function setData(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Object = null;
         if(param2)
         {
            _loc8_ = [];
            _loc9_ = Pixton.POOL_LOCKED;
            _loc8_[Pixton.POOL_MINE] = param1.userPropSets as Array;
            _loc8_[Pixton.POOL_PRESET] = [];
            _loc8_[Pixton.POOL_LOCKED] = [];
            _loc8_[Pixton.POOL_COMMUNITY] = [];
            if(param1.presetPropSets != null)
            {
               _loc8_[Pixton.POOL_PRESET] = param1.presetPropSets as Array;
            }
            if(param1.lockedPropSets != null)
            {
               _loc8_[Pixton.POOL_LOCKED] = param1.lockedPropSets as Array;
            }
            _loc5_ = Pixton.POOL_MINE;
            while(_loc5_ <= _loc9_)
            {
               require(_loc5_,OBJECT);
               require(_loc5_,BACKGROUND);
               _loc4_ = _loc8_[_loc5_].length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  if(_loc5_ == Pixton.POOL_LOCKED && _loc8_[_loc5_][_loc3_].shared == 1)
                  {
                     COMMUNITY_VISIBLE = true;
                     _loc10_ = Pixton.POOL_COMMUNITY;
                     require(_loc10_,OBJECT);
                     require(_loc10_,BACKGROUND);
                  }
                  else
                  {
                     _loc10_ = _loc5_;
                  }
                  _loc7_ = _loc8_[_loc5_][_loc3_].k > 0 ? uint(BACKGROUND) : uint(OBJECT);
                  _loc11_ = [];
                  if(_loc8_[_loc5_][_loc3_].kw != null)
                  {
                     _loc11_.push(_loc8_[_loc5_][_loc3_].kw);
                  }
                  if(_loc8_[_loc5_][_loc3_].n != null)
                  {
                     _loc11_.push(_loc8_[_loc5_][_loc3_].n);
                  }
                  if(_loc8_[_loc5_][_loc3_].setting != null)
                  {
                     _loc11_.push(Template.getSettingName(_loc8_[_loc5_][_loc3_].setting));
                  }
                  _loc8_[_loc5_][_loc3_].kw = _loc11_.join(" ").toLowerCase();
                  propSetData[_loc10_][_loc7_].push(_loc8_[_loc5_][_loc3_]);
                  if(_loc8_[_loc5_][_loc3_].hd != 1)
                  {
                     propSetDataVisible[_loc10_][_loc7_].push(_loc8_[_loc5_][_loc3_]);
                  }
                  _loc3_++;
               }
               _loc5_++;
            }
         }
         else if(param1.propsetData != null)
         {
            _loc5_ = Pixton.POOL_LOCKED;
            require(_loc5_,OBJECT);
            require(_loc5_,BACKGROUND);
            if((_loc12_ = param1.propsetData as Array) != null && _loc12_.length > 0)
            {
               for each(_loc13_ in _loc12_)
               {
                  if(map[_loc13_.id.toString()] != null)
                  {
                     updateByID(_loc13_.id,_loc13_);
                     _loc5_ = map[_loc13_.id.toString()][0];
                     require(_loc5_,OBJECT);
                     require(_loc5_,BACKGROUND);
                  }
                  else
                  {
                     _loc7_ = _loc13_.k > 0 ? uint(BACKGROUND) : uint(OBJECT);
                     propSetData[_loc5_][_loc7_].push(_loc13_);
                  }
               }
            }
         }
         else if(param1.communityPropSets != null)
         {
            _loc5_ = Pixton.POOL_COMMUNITY;
            require(_loc5_,OBJECT);
            require(_loc5_,BACKGROUND);
            if((_loc12_ = param1.communityPropSets as Array).length > 0)
            {
               for each(_loc13_ in _loc12_)
               {
                  _loc11_ = [];
                  if(_loc13_.n != null)
                  {
                     _loc11_.push(_loc13_.n);
                  }
                  if(_loc13_.u != null)
                  {
                     _loc11_.push(_loc13_.u);
                  }
                  _loc13_.kw = _loc11_.join(" ").toLowerCase();
                  if(_loc13_.brief == null)
                  {
                     if(hasData(_loc13_.id,true))
                     {
                        updateByID(_loc13_.id,_loc13_);
                     }
                     else
                     {
                        _loc7_ = _loc13_.k > 0 ? uint(BACKGROUND) : uint(OBJECT);
                        propSetData[_loc5_][_loc7_].push(_loc13_);
                        if(_loc13_.hd != 1)
                        {
                           propSetDataVisible[_loc5_][_loc7_].push(_loc13_);
                        }
                     }
                  }
                  else if(!hasData(_loc13_.id,true))
                  {
                     _loc7_ = _loc13_.k > 0 ? uint(BACKGROUND) : uint(OBJECT);
                     propSetData[_loc5_][_loc7_].push(_loc13_);
                     if(_loc13_.hd != 1)
                     {
                        propSetDataVisible[_loc5_][_loc7_].push(_loc13_);
                     }
                  }
               }
            }
         }
         else
         {
            _loc5_ = Pixton.POOL_MINE;
            if((_loc12_ = param1.userPropSets as Array) != null && _loc12_.length > 0)
            {
               for each(_loc13_ in _loc12_)
               {
                  if(map[_loc13_.id.toString()] != null)
                  {
                     updateByID(_loc13_.id,_loc13_);
                  }
                  else
                  {
                     _loc7_ = _loc13_.k > 0 ? uint(BACKGROUND) : uint(OBJECT);
                     propSetData[_loc5_][_loc7_].push(_loc13_);
                  }
               }
            }
         }
         updateMap();
      }
      
      public static function add(param1:PropSet) : void
      {
         addData(param1.getSetData(),Pixton.POOL_MINE);
      }
      
      private static function addData(param1:Object, param2:uint) : void
      {
         if(hasData(param1.id))
         {
            return;
         }
         if(param1.kw == null)
         {
            if(param1.n == null)
            {
               param1.kw = "";
            }
            else
            {
               param1.kw = param1.n.toLowerCase();
            }
         }
         var _loc3_:uint = param1.k > 0 ? uint(BACKGROUND) : uint(OBJECT);
         require(param2,_loc3_);
         propSetData[param2][_loc3_].unshift(param1);
         if(param1.hd == null || param1.hd != 1)
         {
            propSetDataVisible[param2][_loc3_].unshift(param1);
         }
         updateMap();
      }
      
      public static function hide(param1:int) : void
      {
         Utils.remote("hidePropSet",{"prop":param1});
         remove(param1);
      }
      
      private static function remove(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = Pixton.POOL_MINE;
         _loc2_ = OBJECT;
         while(_loc2_ <= BACKGROUND)
         {
            if(propSetDataVisible[_loc5_][_loc2_] != null)
            {
               _loc4_ = propSetDataVisible[_loc5_][_loc2_].length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  if(propSetDataVisible[_loc5_][_loc2_][_loc3_].id == param1)
                  {
                     propSetDataVisible[_loc5_][_loc2_].splice(_loc3_,1);
                     updateMap();
                     return;
                  }
                  _loc3_++;
               }
            }
            _loc2_++;
         }
      }
      
      private static function updateMap() : void
      {
         var _loc1_:* = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         map = {};
         var _loc4_:uint = propSetData.length;
         for(_loc1_ in propSetData)
         {
            _loc2_ = OBJECT;
            while(_loc2_ <= BACKGROUND)
            {
               if(!(propSetData[_loc1_] == null || propSetData[_loc1_][_loc2_] == null))
               {
                  _loc4_ = propSetData[_loc1_][_loc2_].length;
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     _loc6_ = propSetData[_loc1_][_loc2_][_loc3_].id;
                     if(!(map[_loc6_.toString()] != null && getData(_loc6_).setting))
                     {
                        map[_loc6_.toString()] = [_loc1_,_loc2_,_loc3_];
                     }
                     _loc3_++;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public static function hasData(param1:uint, param2:Boolean = false) : Boolean
      {
         var _loc3_:Object = getData(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return param2 || _loc3_.brief == null;
      }
      
      public static function getData(param1:uint) : Object
      {
         var _loc2_:String = param1.toString();
         var _loc3_:Array = map[_loc2_];
         if(_loc3_ != null)
         {
            return propSetData[_loc3_[0]][_loc3_[1]][_loc3_[2]];
         }
         return null;
      }
      
      public static function updateByIDs(param1:Array) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            updateByID(_loc2_.id,_loc2_);
         }
      }
      
      private static function updateByID(param1:uint, param2:Object) : void
      {
         var _loc3_:Array = map[param1.toString()];
         var _loc4_:Object;
         if(_loc4_ = propSetData[_loc3_[0]][_loc3_[1]][_loc3_[2]])
         {
            if(_loc4_.u != null)
            {
               param2.u = _loc4_.u;
            }
            if(_loc4_.setting != null)
            {
               param2.setting = _loc4_.setting;
            }
         }
         propSetData[_loc3_[0]][_loc3_[1]][_loc3_[2]] = param2;
      }
      
      public static function updateValue(param1:uint, param2:String, param3:*) : void
      {
         var _loc4_:Array;
         if((_loc4_ = map[param1.toString()]) != null)
         {
            propSetData[_loc4_[0]][_loc4_[1]][_loc4_[2]][param2] = param3;
         }
         else
         {
            Debug.trace("FAILED to update value for non-existent propset " + param1);
         }
      }
      
      public static function getValue(param1:uint, param2:String) : *
      {
         var _loc3_:Array = map[param1.toString()];
         if(_loc3_ != null)
         {
            return propSetData[_loc3_[0]][_loc3_[1]][_loc3_[2]][param2];
         }
         return null;
      }
      
      public static function update(param1:PropSet) : void
      {
         updateByID(param1.id,param1.getSetData());
      }
      
      public static function getLock(param1:uint) : Object
      {
         var _loc2_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Object = null;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         addLockInfo(_loc3_,_loc4_,param1);
         if(_loc3_.length > 0)
         {
            _loc5_ = 1;
            _loc6_ = 1;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = 0;
            for each(_loc2_ in _loc3_)
            {
               if(_loc2_.platformFree_bool != 1)
               {
                  _loc6_ = 0;
               }
               if(_loc2_.plusFree_bool != 1)
               {
                  _loc5_ = 0;
               }
               if(_loc2_.plusOnly_bool == 1)
               {
                  _loc7_ = 1;
               }
               _loc8_ += parseInt(_loc2_.credits_int);
               _loc9_ += parseInt(_loc2_.promoCredits_int);
            }
            _loc10_ = PropSet.getData(param1);
            return {
               "type_int":"prop-set",
               "k":_loc10_.k,
               "plusOnly_bool":_loc7_,
               "plusFree_bool":_loc5_,
               "platformFree_bool":_loc6_,
               "credits_int":_loc8_,
               "promoCredits_int":_loc9_,
               "ids":_loc4_
            };
         }
         return null;
      }
      
      private static function addLockInfo(param1:Array, param2:Array, param3:uint) : void
      {
         var _loc5_:Object = null;
         var _loc7_:Object = null;
         var _loc4_:Object;
         if((_loc4_ = PropSet.getData(param3)) == null)
         {
            return;
         }
         var _loc6_:Array = _loc4_.p;
         for each(_loc5_ in _loc6_)
         {
            if(_loc5_.s == Prop.PROP_SET)
            {
               addLockInfo(param1,param2,_loc5_.id);
            }
            else if(!Utils.inArray(_loc5_.s,[Prop.PROP_PHOTO,Prop.PROP_WEB]))
            {
               if((_loc7_ = Prop.getLock(_loc5_.id)) != null && !Utils.inArray(_loc7_.id,param2))
               {
                  param2.push(_loc7_.id);
                  param1.push(_loc7_);
               }
            }
         }
      }
      
      static function sendTeamUpdate(param1:int, param2:Object) : void
      {
         if(!Team.isActive)
         {
            return;
         }
         Team.onChange(Main.userID.toString(),null,Team.P_PROPSET_LIST,param1.toString(),1);
         Team.onChange(param1.toString(),null,Team.P_PROPSET,null,param2);
      }
      
      static function getImagePath(param1:int) : String
      {
         var _loc2_:uint = getValue(param1,"v");
         return File.LOCAL_BUCKET + "propset/_" + param1 + (_loc2_ > 0 ? "_v" + _loc2_ + "_" : "") + PickerItem.IMAGE_EXT;
      }
      
      static function setSearched(param1:String, param2:String = null) : void
      {
         searchCache[param1] = param2 != null ? param2 : true;
      }
      
      static function searched(param1:String) : Boolean
      {
         return searchCache[param1] != null;
      }
      
      static function getSearchError(param1:String) : String
      {
         if(searchCache[param1] == null || searchCache[param1] === true)
         {
            return null;
         }
         return searchCache[param1];
      }
      
      static function setCommunityLoaded(param1:uint) : void
      {
         _communityLoaded[param1.toString()] = true;
      }
      
      static function getCommunityLoaded(param1:uint) : Boolean
      {
         return _communityLoaded[param1.toString()] != null;
      }
      
      static function onTeamUpdate(param1:int, param2:Object) : void
      {
         param2.hd = 1;
         addData(param2,Pixton.POOL_COMMUNITY);
      }
      
      function isEditable() : Boolean
      {
         return (this.alwaysEditable || this.editable && (Globals.isFullVersion() || FeatureTrial.can(FeatureTrial.PROP_GROUPING))) && !this.isSingleImage();
      }
      
      function promptForName(param1:Function) : void
      {
         drawSnapshot();
         Popup.show(L.text(!!this.isBkgd() ? "name-bkgd-set" : "name-set"),this.onName,param1,propName == defaultName ? "" : propName,snapShot);
      }
      
      public function setOnReady(param1:Function) : void
      {
         if(this._isReady)
         {
            param1();
         }
         else
         {
            this._onReady = param1;
         }
      }
      
      private function onName(param1:String = null, param2:Function = null) : void
      {
         if(param1 == null)
         {
            param2(false);
         }
         else
         {
            propName = param1;
            param2(true);
         }
      }
      
      function addProps(param1:Object, param2:MovieClip) : void
      {
         var _loc3_:Array = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:uint = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Rectangle = null;
         if(param1 is Array)
         {
            _loc3_ = param1 as Array;
         }
         else
         {
            _loc3_ = [param1];
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.parent;
            if(parent == null)
            {
               _loc6_ = _loc5_.getChildIndex(_loc4_);
               _loc5_.addChildAt(this,_loc6_);
            }
            _loc5_.removeChild(_loc4_);
            _loc7_ += _loc4_.x;
            _loc8_ += _loc4_.y;
            vector.addChild(_loc4_);
         }
         if(this.isBkgd())
         {
            _loc9_ = ((_loc11_ = param2.getBounds(this)).x + _loc11_.bottomRight.x) * 0.5;
            _loc10_ = (_loc11_.y + _loc11_.bottomRight.y) * 0.5;
         }
         else
         {
            _loc9_ = _loc7_ / _loc3_.length;
            _loc10_ = _loc8_ / _loc3_.length;
         }
         x = _loc9_;
         y = _loc10_;
         for each(_loc4_ in _loc3_)
         {
            _loc4_.x -= _loc9_;
            _loc4_.y -= _loc10_;
         }
      }
      
      function setBorderData(param1:Object) : void
      {
         this.borderData = param1;
         this.updateMask();
      }
      
      private function updateMask() : void
      {
         Debug.trace("updateMask: " + this.isBkgd() + "; " + this.borderData);
         if(!this.isBkgd() || this.borderData == null)
         {
            return;
         }
         if(this.masker == null)
         {
            this.masker = new MovieClip();
            this.addChild(this.masker);
            this.maskerG = this.masker.graphics;
            vector.mask = this.masker;
         }
         this.maskerG.clear();
         this.maskerG.beginFill(16711680,0.3);
         this.maskerG.moveTo(this.borderData.Ax,this.borderData.Ay);
         this.maskerG.lineTo(this.borderData.Bx,this.borderData.By);
         this.maskerG.lineTo(this.borderData.Cx,this.borderData.Cy);
         this.maskerG.lineTo(this.borderData.Dx,this.borderData.Dy);
         this.maskerG.lineTo(this.borderData.Ax,this.borderData.Ay);
         this.maskerG.endFill();
      }
      
      override function captureAll() : Boolean
      {
         return this.isBkgd();
      }
      
      override function hasFill(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc4_:DisplayObject = null;
         var _loc3_:uint = vector.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if((_loc4_ = vector.getChildAt(_loc2_)) is Prop && Prop(_loc4_).hasFill(param1))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      override function isAlphable() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc3_:DisplayObject = null;
         var _loc2_:uint = vector.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = vector.getChildAt(_loc1_);
            if(_loc3_ is Dialog || !Prop(_loc3_).isAlphable())
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      override function setColor(param1:int, param2:*, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:DisplayObject = null;
         if(param2 == null || param1 > 0 && param2 == 0)
         {
            return;
         }
         if(param2 == Palette.TRANSPARENT_ID)
         {
            param2 = 0;
         }
         if(param1 == -1)
         {
            this.setColor(0,param2[0],param3,param4);
            return;
         }
         if(!param3)
         {
            _colorID[param1] = param2;
         }
         if(param2 is Array)
         {
            _loc5_ = param2;
         }
         else
         {
            _loc5_ = [(_loc6_ = Palette.getColor(param2))[0],_loc6_[1],_loc6_[2]];
         }
         if(this.isAlphable())
         {
            _loc5_[Palette.A] = 255 * getAlpha() / 100;
         }
         if(silhouette)
         {
            Utils.setColor(vector,_loc5_,0,false);
         }
         else
         {
            Utils.setColor(vector);
            _loc8_ = vector.numChildren;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               if((_loc9_ = vector.getChildAt(_loc7_)) is Prop)
               {
                  if(param2 == 0)
                  {
                     Prop(_loc9_).setColor(-1,Prop(_loc9_).getColor());
                  }
                  else if(_loc9_ is PropPhoto)
                  {
                     PropPhoto(_loc9_).setColor(param1,param2,param3);
                  }
                  else
                  {
                     Prop(_loc9_).setColor(-2,_loc5_,true);
                  }
               }
               _loc7_++;
            }
         }
      }
      
      override function colorFills(param1:Array, param2:int = -1) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:DisplayObject = null;
         var _loc4_:uint = vector.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if((_loc5_ = vector.getChildAt(_loc3_)) is Prop)
            {
               Prop(_loc5_).colorFills(param1,param2);
            }
            _loc3_++;
         }
      }
      
      function updateID(param1:uint) : void
      {
         this.id = param1;
      }
      
      function updateSceneKey(param1:String) : void
      {
         this.sceneKey = param1;
      }
      
      function setSaved() : void
      {
         this.saved = true;
      }
      
      private function updateAssetData() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:DisplayObject = null;
         this.propData = [];
         this.dialogData = [];
         _loc2_ = vector.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = vector.getChildAt(_loc1_);
            if(_loc3_ is Prop)
            {
               this.propData.push(Prop(_loc3_).getData());
            }
            else
            {
               this.dialogData.push(Dialog(_loc3_).getData());
            }
            _loc1_++;
         }
      }
      
      function getSetData() : Object
      {
         this.updateAssetData();
         return {
            "w":width,
            "h":height,
            "p":this.propData,
            "d":this.dialogData,
            "id":id,
            "pid":this.parentID,
            "n":propName,
            "scene":this.sceneKey,
            "k":this.bkgdColor,
            "bs":this.bkgdGradient,
            "b":Utils.encode(this.borderData)
         };
      }
      
      function isBkgd() : Boolean
      {
         return this.bkgdColor > 0;
      }
      
      function explode(param1:MovieClip) : Array
      {
         var _loc5_:Matrix = null;
         var _loc7_:uint = 0;
         var _loc9_:DisplayObject = null;
         var _loc2_:Array = [];
         var _loc3_:MovieClip = param1 is Editor ? param1.containerC : param1.vector;
         var _loc4_:uint = this.parent.getChildIndex(this);
         var _loc6_:int = getColor(0);
         var _loc8_:uint = vector.numChildren;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = vector.getChildAt(vector.numChildren - 1);
            _loc2_.push(_loc9_);
            vector.removeChild(_loc9_);
            if(_loc9_ is Prop && _loc6_ > 0)
            {
               Prop(_loc9_).setColor(0,_loc6_);
            }
            (_loc5_ = _loc9_.transform.matrix).concat(this.transform.matrix);
            _loc9_.transform.matrix = _loc5_;
            if(_loc9_ is Prop)
            {
               Prop(_loc9_).updateScale();
            }
            _loc3_.addChildAt(_loc9_,_loc4_);
            if(param1 is Editor)
            {
               param1.activateTarget(_loc9_ as MovieClip);
            }
            _loc7_++;
         }
         return _loc2_;
      }
      
      override function canSilhouette() : Boolean
      {
         return !this.isSingleImage();
      }
      
      override public function getSelectableRect(param1:DisplayObject = null) : Rectangle
      {
         if(param1 == null)
         {
            param1 = this;
         }
         if(this.masker != null)
         {
            return this.masker.getBounds(param1);
         }
         return this.getBounds(param1);
      }
      
      function isSingleImage() : Boolean
      {
         var _loc1_:DisplayObject = null;
         if(vector.numChildren == 1)
         {
            _loc1_ = vector.getChildAt(0);
            if(_loc1_ is Prop && Prop(_loc1_).hasImages())
            {
               return true;
            }
         }
         return false;
      }
      
      override public function updateInners(param1:Number = 0) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:DisplayObject = null;
         var _loc3_:uint = vector.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if((_loc4_ = vector.getChildAt(_loc2_)) is Prop)
            {
               Prop(_loc4_).updateInners(param1);
            }
            _loc2_++;
         }
      }
   }
}

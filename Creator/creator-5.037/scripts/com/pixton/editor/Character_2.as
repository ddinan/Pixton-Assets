package com.pixton.editor
{
   import com.pixton.animate.Animation;
   import com.pixton.character.BodyPart;
   import com.pixton.character.BodyParts;
   import com.pixton.characterSkin.Expression;
   import com.pixton.characterSkin.Look;
   import com.pixton.characterSkin.Part;
   import com.pixton.designer.Designer;
   import com.pixton.team.Team;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public final class Character extends Asset
   {
      
      public static var skinMCs:Array = [];
      
      public static var COMMUNITY_VISIBLE:Boolean = false;
      
      public static var defaultName:String = "";
      
      public static var communityLoaded:Boolean = false;
      
      public static var lastPool:uint;
      
      private static const HOLD_TIMEOUT:Number = 500;
      
      public static var newIDs:Array = [];
      
      public static var SCALE_FACTOR_HEAD:Number = 1;
      
      public static var SCALE_FACTOR_NOSE:Number = 1;
      
      public static var SCALE_FACTOR_NECK_Y:Number = 1;
      
      public static var SCALE_FACTOR_BODY_X:Number = 1;
      
      public static var SCALE_FACTOR_BODY_Y:Number = 1;
      
      public static var SCALE_FACTOR_LIMBS:Number = 1;
      
      public static var SCALE_FACTOR_EYES:Number = 1;
      
      public static var SCALE_FACTOR_MOUTH:Number = 1;
      
      public static var SCALE_FACTOR_HEAD_THUMB:Number = 1;
      
      public static var SCALE_FACTOR_NOSE_THUMB:Number = 1;
      
      public static var SCALE_FACTOR_NECK_Y_THUMB:Number = 1;
      
      public static var SCALE_FACTOR_BODY_X_THUMB:Number = 1;
      
      public static var SCALE_FACTOR_BODY_Y_THUMB:Number = 1;
      
      public static var SCALE_FACTOR_LIMBS_THUMB:Number = 1;
      
      public static var SCALE_FACTOR_EYES_THUMB:Number = 1;
      
      public static var SCALE_FACTOR_MOUTH_THUMB:Number = 1;
      
      private static const BLINK_PROB:Number = 0.05;
      
      private static const SPEECH_PROB:Number = 0.8;
      
      public static var TURN_TOLERANCE:Number = 10;
      
      public static var ALLOW_FEMALE:Boolean = true;
      
      private static const NOT_TURNING:uint = 0;
      
      private static const TURNING:uint = 1;
      
      private static var cacheData:Object = {};
      
      private static var searchCache:Object = {};
      
      private static var _tempGenomes:Object = {};
      
      private static var characterFiles:Array;
      
      private static var skinTypes:Array;
      
      private static var characterData:Array;
      
      private static var characterDataVisible:Array;
      
      private static var map:Object = {};
      
      private static var posIndex:uint = 0;
      
      private static var numSkins:uint = 0;
      
      private static var relModTime:Object = {};
      
      private static var constrainMove:String;
      
      private static var _extraSkinTypes:Array = null;
      
      private static var targetClassMap:Object = {};
      
      public static var defGlow:uint = 0;
      
      public static var editingSkinType:uint = 0;
       
      
      public var saved:Boolean = false;
      
      public var bodyParts:BodyParts;
      
      public var skinType:uint;
      
      public var updateFromID:int = 0;
      
      public var pendingID:int = 0;
      
      public var clickData:Object;
      
      public var promptedForOverwrite:Boolean = false;
      
      private var _id:int = 0;
      
      private var characterName:String;
      
      private var _editMode:uint;
      
      private var timeout:uint;
      
      private var startPoint:Point;
      
      private var startCursor:Point;
      
      private var moveStart:Point;
      
      private var startA:Number;
      
      private var startD:Number;
      
      private var startYStretch:Number;
      
      private var turningState:uint;
      
      private var startT:int = 0;
      
      private var startR:Number;
      
      private var recentTargetOver:Object;
      
      private var currentTargetOver:Object;
      
      private var currentTargetDown:Object;
      
      private var lastSaved:Object;
      
      private var absModTime:uint;
      
      private var _z:Number = 1;
      
      private var clickTime:Number;
      
      private var needsNewName:Boolean = false;
      
      private var currentColorType:int = -1;
      
      private var _isDummy:Boolean;
      
      public function Character(param1:int = 0, param2:uint = 0, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false)
      {
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc15_:MovieClip = null;
         var _loc16_:DisplayObject = null;
         var _loc17_:DisplayObject = null;
         var _loc18_:String = null;
         super();
         if(!hasSkin(param2))
         {
            param2 = getFirstSkinType();
         }
         var _loc7_:Object;
         if((_loc7_ = Character.getData(param1)) == null)
         {
            if(param1 != 0)
            {
               this.pendingID = param1;
            }
            param1 = 0;
            _loc7_ = {"t":param2};
         }
         this.skinType = uint(_loc7_.t);
         this.dummy = param6;
         if(Main.isCharCreate())
         {
            editingSkinType = this.skinType;
            Debug.trace("editingSkinType: " + editingSkinType);
         }
         var _loc8_:MovieClip = Utils.getAsset(getSkinName(this.skinType));
         vector.addChild(_loc8_);
         var _loc13_:uint = 0;
         var _loc14_:uint = 3;
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            if((_loc15_ = Utils.getAsset(getSkinName(this.skinType,_loc13_ + 1))) != null)
            {
               _loc10_ = _loc15_.numChildren;
               _loc9_ = 0;
               while(_loc9_ < _loc10_)
               {
                  if((_loc16_ = _loc15_.getChildAt(_loc9_)) is Part)
                  {
                     _loc18_ = Part(_loc16_).name;
                     _loc12_ = Part(_loc16_).numChildren;
                     _loc11_ = 0;
                     while(_loc11_ < _loc12_)
                     {
                        if((_loc17_ = Part(_loc16_).getChildAt(_loc11_)) is Look)
                        {
                           if(_loc8_[_loc18_] != null && _loc8_[_loc18_] is Part)
                           {
                              if(targetClassMap[Object(_loc8_[_loc18_]).constructor.toString()] == null)
                              {
                                 targetClassMap[Object(_loc8_[_loc18_]).constructor.toString()] = Object(_loc16_).constructor;
                              }
                              Part(_loc8_[_loc18_]).addChild(_loc17_);
                              _loc11_--;
                              _loc12_--;
                           }
                        }
                        _loc11_++;
                     }
                  }
                  _loc9_++;
               }
            }
            _loc13_++;
         }
         this.bodyParts = new BodyParts(_loc8_,this.skinType,this);
         this.bodyParts.headOnly = param3;
         this.characterName = defaultName;
         if(!this.dummy)
         {
            this.setID(param1);
            this.setColor(Palette.SILHOUETTE_COLOR,!!this.isLockedLooks() ? Palette.TRANSPARENT_ID : Palette.getDefaultColor(Palette.SILHOUETTE_COLOR),false,false);
            if(param1 < 0)
            {
               if(!param4)
               {
                  this.setGenome(_loc7_);
               }
               param4 = false;
            }
            else if(param1 == 0)
            {
               this.bodyParts.setColor(Globals.SHOE_COLOR,null);
               this.bodyParts.setColor(Globals.HAT_COLOR,null);
               this.bodyParts.setColor(Globals.GLOVE_COLOR,null);
               this.bodyParts.setColor(Globals.SHIRT_COLOR,null);
               this.bodyParts.setColor(Globals.PANT_COLOR,null);
               this.bodyParts.setColor(Globals.ACCESSORY_COLOR,null);
               this.bodyParts.setColor(Globals.SOCK_COLOR,null);
               this.bodyParts.setColor(Globals.BELT_COLOR,null);
               this.bodyParts.setColor(Globals.EARRING_COLOR,null);
               this.bodyParts.setColor(Globals.EYEWEAR_COLOR,null);
               this.bodyParts.setColor(Globals.BUCKLE_COLOR,null);
               this.bodyParts.setColor(Globals.CAPE_COLOR,null);
               this.randomize(BodyParts.LOOKS,true);
               this.randomize(BodyParts.COLORS,true);
               this.saved = false;
            }
            else if(inPool(param1,Pixton.POOL_MINE) || this.isLockedLooks())
            {
               this.setGenome(_loc7_);
               this.saved = hasImage(param1);
               sendTeamUpdate(param1,_loc7_);
            }
            else
            {
               this.setGenome(_loc7_,false);
               this.makeNew();
            }
            if(param4)
            {
               if(Template.isActive())
               {
                  setGlowAmount(2);
               }
               else if(defGlow > 0)
               {
                  setGlowAmount(defGlow);
               }
            }
            if(OS.canInvalidate() && !Main.isHiResRender())
            {
               Utils.addListener(this,Event.RENDER,this.onRender);
            }
         }
      }
      
      static function captureMC(param1:MovieClip) : Object
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:uint = 0;
         var _loc2_:Object = {};
         if(!param1.name.match(/^instance/))
         {
            _loc2_["n"] = param1.name;
         }
         var _loc3_:String = Utils.getClassName(param1);
         if(param1 is Look)
         {
            _loc2_["l"] = 1;
         }
         else if(param1 is Part)
         {
            _loc2_["p"] = 1;
         }
         else if(param1 is Expression)
         {
            _loc2_["e"] = 1;
         }
         else if(_loc3_.match(/^com\.pixton\.character::Skin/))
         {
            _loc2_["c"] = _loc3_;
         }
         _loc2_["a"] = [];
         var _loc6_:uint = param1.numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if((_loc4_ = param1.getChildAt(_loc5_)) is MovieClip)
            {
               _loc2_["a"].push(captureMC(_loc4_ as MovieClip));
            }
            _loc5_++;
         }
         if(_loc2_["a"].length == 0)
         {
            delete _loc2_["a"];
         }
         return _loc2_;
      }
      
      private static function getSkinName(param1:uint, param2:uint = 0) : String
      {
         return "com.pixton.character.Skin" + String(param1) + (param2 > 0 ? "_Addon" + String(param2) : "");
      }
      
      public static function getIconClass(param1:uint) : Class
      {
         var _loc2_:String = Style._get("key").replace("-","_").toLowerCase();
         var _loc3_:* = "character." + _loc2_ + "IconSkin";
         return SkinManager.getDefinition(_loc3_,param1.toString());
      }
      
      public static function init(param1:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         lastPool = Pixton.POOL_MINE;
         defaultName = param1.defaultName;
         var _loc2_:Array = param1.fc;
         var _loc3_:Array = param1.fcs;
         skinTypes = [];
         characterFiles = _loc2_;
         var _loc8_:uint = _loc3_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            skinTypes.push(_loc3_[_loc7_]);
            _loc7_++;
         }
         ALLOW_FEMALE = param1.fem == 1;
         if(param1.defGlow != null)
         {
            defGlow = param1.defGlow;
         }
         if(param1.sf_h != null)
         {
            SCALE_FACTOR_HEAD = param1.sf_h;
         }
         if(param1.sf_n != null)
         {
            SCALE_FACTOR_NOSE = param1.sf_n;
         }
         if(param1.sf_ny != null)
         {
            SCALE_FACTOR_NECK_Y = param1.sf_ny;
         }
         if(param1.sf_bx != null)
         {
            SCALE_FACTOR_BODY_X = param1.sf_bx;
         }
         if(param1.sf_by != null)
         {
            SCALE_FACTOR_BODY_Y = param1.sf_by;
         }
         if(param1.sf_l != null)
         {
            SCALE_FACTOR_LIMBS = param1.sf_l;
         }
         if(param1.sf_e != null)
         {
            SCALE_FACTOR_EYES = param1.sf_e;
         }
         if(param1.sf_m != null)
         {
            SCALE_FACTOR_MOUTH = param1.sf_m;
         }
         if(param1.sf_ht != null)
         {
            SCALE_FACTOR_HEAD_THUMB = param1.sf_ht;
         }
         if(param1.sf_nt != null)
         {
            SCALE_FACTOR_NOSE_THUMB = param1.sf_nt;
         }
         if(param1.sf_nyt != null)
         {
            SCALE_FACTOR_NECK_Y_THUMB = param1.sf_nyt;
         }
         if(param1.sf_bxt != null)
         {
            SCALE_FACTOR_BODY_X_THUMB = param1.sf_bxt;
         }
         if(param1.sf_byt != null)
         {
            SCALE_FACTOR_BODY_Y_THUMB = param1.sf_byt;
         }
         if(param1.sf_lt != null)
         {
            SCALE_FACTOR_LIMBS_THUMB = param1.sf_lt;
         }
         if(param1.sf_et != null)
         {
            SCALE_FACTOR_EYES_THUMB = param1.sf_et;
         }
         if(param1.sf_mt != null)
         {
            SCALE_FACTOR_MOUTH_THUMB = param1.sf_mt;
         }
      }
      
      static function suggestName(param1:String) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:* = null;
         var _loc11_:Boolean = false;
         var _loc2_:Array = characterData[Pixton.POOL_MINE];
         var _loc5_:uint = _loc2_.length;
         var _loc6_:uint = 1;
         var _loc10_:Object;
         var _loc7_:RegExp;
         if((_loc10_ = (_loc7_ = /([^\(]+) \(\d+\)/i).exec(param1)) != null && _loc10_.length > 1)
         {
            _loc8_ = _loc10_[1];
         }
         else
         {
            _loc8_ = param1;
         }
         _loc4_ = 2;
         while(_loc4_ < 100)
         {
            _loc11_ = false;
            _loc9_ = _loc8_ + " (" + _loc4_.toString() + ")";
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               if(_loc2_[_loc3_].n == _loc9_)
               {
                  _loc11_ = true;
                  break;
               }
               _loc3_++;
            }
            if(!_loc11_)
            {
               break;
            }
            _loc4_++;
         }
         return _loc9_;
      }
      
      public static function setLock(param1:Array) : void
      {
         BodyParts.setLock(param1);
      }
      
      public static function getLock(param1:uint, param2:BodyPart, param3:uint, param4:uint) : Object
      {
         return BodyParts.getLock(param1,param2,param3,param4);
      }
      
      public static function getFile(param1:uint) : String
      {
         return characterFiles[param1];
      }
      
      public static function getNumSkins() : uint
      {
         return characterFiles.length;
      }
      
      public static function hasSkin(param1:uint) : Boolean
      {
         return Utils.inArray(param1,skinTypes);
      }
      
      public static function getSkinAt(param1:uint) : uint
      {
         if(skinTypes[param1] == null)
         {
            return 0;
         }
         return skinTypes[param1];
      }
      
      public static function getFirstSkinType() : uint
      {
         return getSkinAt(0);
      }
      
      public static function setData(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         if(param2)
         {
            characterData = [];
            characterData[Pixton.POOL_MINE] = param1.userCharacters as Array;
            if(param1.presetCharacters == null)
            {
               param1.presetCharacters = [];
            }
            if(param1.presetOutfits == null)
            {
               param1.presetOutfits = [];
            }
            characterData[Pixton.POOL_PRESET] = [];
            characterData[Pixton.POOL_PRESET_2] = [];
            characterData[Pixton.POOL_NEW] = [];
            characterData[Pixton.POOL_PRESET_OUTFIT] = [];
            _loc4_ = param1.presetCharacters as Array;
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.n.substr(0,1) == "*")
               {
                  _loc5_.n = _loc5_.n.substr(1);
                  characterData[Pixton.POOL_NEW].push(_loc5_);
               }
               else
               {
                  _loc5_.n = parseTemplateName(_loc5_);
                  characterData[Pixton.POOL_PRESET].push(_loc5_);
               }
            }
            if(param1.presetCharacters2 != null)
            {
               _loc4_ = param1.presetCharacters2 as Array;
               for each(_loc5_ in _loc4_)
               {
                  characterData[Pixton.POOL_PRESET_2].push(_loc5_);
               }
            }
            _loc4_ = param1.presetOutfits as Array;
            for each(_loc5_ in _loc4_)
            {
               characterData[Pixton.POOL_PRESET_OUTFIT].push(_loc5_);
            }
            characterDataVisible = [];
            characterDataVisible[Pixton.POOL_MINE] = [];
            for each(_loc6_ in characterData[Pixton.POOL_MINE])
            {
               if(_loc6_.hd == 0)
               {
                  characterDataVisible[Pixton.POOL_MINE].push(_loc6_);
               }
            }
            characterDataVisible[Pixton.POOL_PRESET] = characterData[Pixton.POOL_PRESET];
            characterDataVisible[Pixton.POOL_PRESET_2] = characterData[Pixton.POOL_PRESET_2];
            characterDataVisible[Pixton.POOL_PRESET_OUTFIT] = characterData[Pixton.POOL_PRESET_OUTFIT];
            characterDataVisible[Pixton.POOL_NEW] = characterData[Pixton.POOL_NEW];
            _loc3_ = Pixton.POOL_MINE;
            while(_loc3_ <= Pixton.POOL_PRESET_2)
            {
               if(characterDataVisible[_loc3_] != null)
               {
                  _loc7_ = characterDataVisible[_loc3_].length;
                  _loc9_ = 0;
                  while(_loc9_ < _loc7_)
                  {
                     _loc8_ = [];
                     if(characterDataVisible[_loc3_][_loc9_].k != null)
                     {
                        _loc8_.push(characterDataVisible[_loc3_][_loc9_].k);
                     }
                     if(characterDataVisible[_loc3_][_loc9_].n != null)
                     {
                        _loc8_.push(characterDataVisible[_loc3_][_loc9_].n);
                     }
                     characterDataVisible[_loc3_][_loc9_].k = _loc8_.join(" ").toLowerCase();
                     _loc9_++;
                  }
               }
               _loc3_++;
            }
         }
         else
         {
            if(param1.communityCharacters != null)
            {
               _loc10_ = param1.communityCharacters as Array;
               _loc3_ = Pixton.POOL_COMMUNITY;
            }
            else
            {
               _loc10_ = param1.userCharacters as Array;
               _loc3_ = Pixton.POOL_MINE;
            }
            if(_loc10_.length > 0)
            {
               require(_loc3_);
               for each(_loc11_ in _loc10_)
               {
                  if(map[_loc11_.id.toString()] != null)
                  {
                     updateByID(_loc11_.id,_loc11_,_loc3_);
                  }
                  else
                  {
                     characterData[_loc3_].push(_loc11_);
                     if(_loc11_.hd == 0)
                     {
                        characterDataVisible[_loc3_].push(_loc11_);
                     }
                  }
               }
            }
         }
         updateMap();
      }
      
      public static function update(param1:Character) : void
      {
         updateByID(param1.getID(),param1.getGenome(),Pixton.POOL_MINE);
      }
      
      private static function updateMap() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         map = {};
         var _loc2_:uint = characterData.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(characterData[_loc1_] != null)
            {
               _loc4_ = characterData[_loc1_].length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  if(map[characterData[_loc1_][_loc3_].id.toString()] == null)
                  {
                     map[characterData[_loc1_][_loc3_].id.toString()] = [];
                  }
                  map[characterData[_loc1_][_loc3_].id.toString()].push([_loc1_,_loc3_]);
                  _loc3_++;
               }
            }
            _loc1_++;
         }
      }
      
      public static function hasData(param1:int) : Boolean
      {
         if(param1 == 0)
         {
            return false;
         }
         if(param1 > 0)
         {
            return map[param1.toString()] != null;
         }
         return _tempGenomes[param1.toString()] != null;
      }
      
      public static function getData(param1:int) : Object
      {
         var _loc2_:Array = null;
         if(param1 == 0)
         {
            return null;
         }
         if(param1 > 0)
         {
            if(map[param1.toString()])
            {
               _loc2_ = map[param1.toString()];
               if(characterData[_loc2_[0][0]] != null)
               {
                  return characterData[_loc2_[0][0]][_loc2_[0][1]];
               }
            }
            return null;
         }
         return getTempGenome(param1);
      }
      
      private static function updateData(param1:int, param2:String, param3:*) : void
      {
         var _loc4_:Array = null;
         if(param1 > 0)
         {
            if((_loc4_ = map[param1.toString()]) != null)
            {
               characterData[_loc4_[0][0]][_loc4_[0][1]][param2] = param3;
            }
         }
         else
         {
            setTempGenomeValue(param1,param2,param3);
         }
      }
      
      static function getValue(param1:int, param2:String) : *
      {
         var _loc3_:Array = null;
         if(param1 > 0)
         {
            _loc3_ = map[param1.toString()];
            if(_loc3_ != null)
            {
               return characterData[_loc3_[0][0]][_loc3_[0][1]][param2];
            }
            return null;
         }
         return getTempGenomeValue(param1,param2);
      }
      
      public static function getRelModTime(param1:int) : Number
      {
         if(param1 == 0)
         {
            return -1;
         }
         if(relModTime[param1.toString()] == null)
         {
            return -1;
         }
         return relModTime[param1.toString()];
      }
      
      public static function setRelModTime(param1:int) : void
      {
         if(param1 > 0)
         {
            relModTime[param1.toString()] = getTimer();
         }
      }
      
      public static function has(param1:uint, param2:int = -1) : Boolean
      {
         require(param1);
         if(param2 == -1)
         {
            return characterDataVisible[param1].length > 0;
         }
         return getRandomID(param2,param1) != -1;
      }
      
      private static function require(param1:uint) : void
      {
         if(characterData[param1] == null)
         {
            characterData[param1] = [];
         }
         if(characterDataVisible[param1] == null)
         {
            characterDataVisible[param1] = [];
         }
      }
      
      private static function getRandomID(param1:uint, param2:uint) : int
      {
         var _loc5_:uint = 0;
         var _loc3_:Object = getList(param2,0,1000,param1);
         var _loc4_:Array;
         if((_loc4_ = _loc3_.array).length == 0)
         {
            return -1;
         }
         _loc5_ = Math.floor(Math.random() * _loc4_.length);
         return uint(_loc4_[_loc5_]);
      }
      
      public static function getList(param1:uint, param2:uint, param3:uint, param4:int = -1, param5:Array = null) : Object
      {
         var _loc7_:Object = null;
         var _loc8_:* = false;
         var _loc6_:Array = [];
         for each(_loc7_ in characterDataVisible[param1])
         {
            if(!(param4 != -1 && _loc7_.t != param4))
            {
               if(!(param5 && Utils.inArray(_loc7_.id,param5)))
               {
                  _loc6_.push(_loc7_.id);
               }
            }
         }
         _loc8_ = param2 + param3 < _loc6_.length;
         _loc6_ = _loc6_.slice(param2,Math.min(_loc6_.length,param2 + param3));
         return {
            "array":_loc6_,
            "showPrev":param2 > 0,
            "showNext":_loc8_
         };
      }
      
      public static function searchList(param1:uint, param2:String, param3:uint, param4:uint, param5:int = -1) : Object
      {
         var _loc9_:Object = null;
         var _loc6_:Array = characterDataVisible[param1];
         var _loc7_:Array = [];
         var _loc8_:Array = Keyword.prepareUserSearch(param2,param1 == Pixton.POOL_MINE);
         for each(_loc9_ in _loc6_)
         {
            if(!(param5 != -1 && _loc9_.t != param5))
            {
               if(Keyword.matches(_loc9_.k,_loc8_))
               {
                  _loc7_.push(_loc9_.id);
               }
            }
         }
         return {
            "total":_loc7_.length,
            "array":_loc7_.slice(param3,Math.min(_loc7_.length,param3 + param4)),
            "showPrev":param3 > 0,
            "showNext":param3 + param4 < _loc7_.length,
            "search":_loc8_.join(" ")
         };
      }
      
      public static function add(param1:Character) : void
      {
         var _loc2_:Object = param1.getGenome();
         addGenome(_loc2_,Pixton.POOL_MINE);
         sendTeamUpdate(_loc2_.id,_loc2_);
      }
      
      private static function addGenome(param1:Object, param2:uint) : void
      {
         require(param2);
         characterData[param2].unshift(param1);
         characterDataVisible[param2].unshift(param1);
         if(param1.id > 0)
         {
            newIDs.push(param1.id);
         }
         if(param1.k == null)
         {
            if(param1.n != null)
            {
               param1.k = param1.n.toLowerCase();
            }
            else
            {
               param1.k = "";
            }
         }
         updateMap();
      }
      
      public static function isNewThisSession(param1:int) : Boolean
      {
         return Utils.inArray(param1,newIDs);
      }
      
      public static function updateByID(param1:int, param2:Object, param3:uint) : void
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         if(param1 < 0)
         {
            setTempGenome(param1,param2);
         }
         else
         {
            if(!hasData(param1))
            {
               addGenome(param2,param3);
            }
            if(param2.k == null)
            {
               if(param2.n != null)
               {
                  param2.k = param2.n.toLowerCase();
               }
               else
               {
                  param2.k = "";
               }
            }
            _loc6_ = (_loc4_ = map[param1.toString()]).length;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc8_ = characterDataVisible[_loc4_[_loc5_][0]].length;
               _loc7_ = 0;
               while(_loc7_ < _loc8_)
               {
                  if(characterDataVisible[_loc4_[_loc5_][0]][_loc7_].id == characterData[_loc4_[_loc5_][0]][_loc4_[_loc5_][1]].id)
                  {
                     if(characterDataVisible[_loc4_[_loc5_][0]][_loc7_].u != null)
                     {
                        param2.u = characterDataVisible[_loc4_[_loc5_][0]][_loc7_].u;
                     }
                     characterDataVisible[_loc4_[_loc5_][0]][_loc7_] = param2;
                     break;
                  }
                  _loc7_++;
               }
               if(characterData[_loc4_[_loc5_][0]][_loc4_[_loc5_][1]] != null && characterData[_loc4_[_loc5_][0]][_loc4_[_loc5_][1]].u != null)
               {
                  param2.u = characterData[_loc4_[_loc5_][0]][_loc4_[_loc5_][1]].u;
               }
               characterData[_loc4_[_loc5_][0]][_loc4_[_loc5_][1]] = param2;
               _loc5_++;
            }
         }
      }
      
      private static function inPool(param1:int, param2:uint) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc3_:Array = map[param1.toString()];
         var _loc5_:uint = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc3_[_loc4_][0] == param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public static function addSkin() : void
      {
         ++numSkins;
      }
      
      static function hasCacheData(param1:uint, param2:int, param3:uint = 0) : Boolean
      {
         return cacheData[param2.toString()] != null && cacheData[param2.toString()][param1.toString()] != null && cacheData[param2.toString()][param1.toString()][param3.toString()] != null;
      }
      
      static function getCacheData(param1:uint, param2:int, param3:uint = 0) : Object
      {
         if(hasCacheData(param1,param2,param3))
         {
            return cacheData[param2.toString()][param1.toString()][param3.toString()];
         }
         return null;
      }
      
      static function saveCacheData(param1:uint, param2:int, param3:uint, param4:BitmapData, param5:String, param6:Boolean = false, param7:Function = null) : void
      {
         var _loc8_:Object = null;
         var _loc9_:Boolean;
         if(!(_loc9_ = param1 == Globals.LOOKS || param1 == Globals.EXPRESSION))
         {
            if(cacheData[param2.toString()] == null)
            {
               cacheData[param2.toString()] = {};
            }
            if(cacheData[param2.toString()][param1.toString()] == null)
            {
               cacheData[param2.toString()][param1.toString()] = {};
            }
            cacheData[param2.toString()][param1.toString()][param3.toString()] = {
               "bmd":param4,
               "name":param5
            };
         }
         if(Main.isSavingPoses() || Main.isSavingPosesWeb())
         {
            if(param1 == Globals.POSES || param1 == Globals.FACES)
            {
               _loc8_ = {
                  "type":param1,
                  "poseID":param2,
                  "skinType":param3
               };
            }
            else
            {
               if(!(param1 == Globals.LOOKS || param1 == Globals.EXPRESSION))
               {
                  return;
               }
               _loc8_ = {
                  "type":param1,
                  "value":param2,
                  "skinType":param3,
                  "name":param5
               };
            }
            if(Main.isSavingPosesWeb())
            {
               _loc8_.isWeb = true;
            }
            Utils.remote("saveSnapShot",Utils.mergeObjects(_loc8_,Pixton.encodeBMD(param4,0.5)),param7);
         }
         else if(param2 > 0 && param6)
         {
            _loc8_ = {
               "cid":param2,
               "v":getValue(param2,"v")
            };
            Utils.remote("saveSnapShot",Utils.mergeObjects(_loc8_,Pixton.encodeBMD(param4,0.5)),param7);
            updateData(param2,"img",1);
         }
      }
      
      private static function clearCache(param1:int) : void
      {
         cacheData[param1.toString()] = null;
         updateData(param1,"img",0);
      }
      
      static function updateCache(param1:int, param2:int) : void
      {
         cacheData[param2.toString()] = cacheData[param1.toString()];
      }
      
      static function hasImage(param1:int) : Boolean
      {
         var _loc2_:Object = null;
         if(param1 > 0)
         {
            if(inPool(param1,Pixton.POOL_MINE))
            {
               _loc2_ = getData(param1);
               return _loc2_.img == 1;
            }
            return true;
         }
         return false;
      }
      
      public static function getName(param1:int) : String
      {
         var _loc2_:Object = getData(param1);
         if(_loc2_.u != null && _loc2_.u != Main.userName)
         {
            return _loc2_.n + " " + L.text("by",_loc2_.u);
         }
         return _loc2_.n;
      }
      
      public static function getType(param1:int) : uint
      {
         var _loc2_:Object = getData(param1);
         return _loc2_.t;
      }
      
      static function getImagePath(param1:int) : String
      {
         var _loc2_:uint = getValue(param1,"v");
         return File.LOCAL_BUCKET + "character/_" + param1 + (_loc2_ > 0 ? "_v" + _loc2_ + "_" : "") + PickerItem.IMAGE_EXT;
      }
      
      static function saveImage(param1:int, param2:uint, param3:Function) : void
      {
         updateData(param1,"v",param2);
         clearCache(param1);
         var _loc4_:uint = Pixton.POOL_MINE;
         var _loc5_:uint = Globals.CHARACTERS;
         var _loc6_:Number = Picker.ITEM_HEIGHT_3;
         if(Main.isOutfitsAdmin())
         {
            _loc4_ = Pixton.POOL_PRESET_OUTFIT;
            _loc5_ = Globals.OUTFITS;
         }
         new PickerItem({
            "w":Picker.ITEM_WIDTH,
            "h":_loc6_,
            "index":0,
            "subType":-1,
            "type":_loc5_,
            "pool":_loc4_,
            "value":param1,
            "onComplete":param3
         });
      }
      
      public static function deleteData(param1:int) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:int = -1;
         var _loc4_:uint = characterDataVisible[Pixton.POOL_MINE].length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(characterDataVisible[Pixton.POOL_MINE][_loc3_].id == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         characterDataVisible[Pixton.POOL_MINE].splice(_loc2_,1);
         updateMap();
      }
      
      public static function deleteCharacter(param1:int) : uint
      {
         deleteData(param1);
         return param1;
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
      
      static function setEditor(param1:Array) : void
      {
         _extraSkinTypes = param1;
      }
      
      static function isEditor() : Boolean
      {
         return !Utils.empty(_extraSkinTypes);
      }
      
      static function getExtraSkinTypes() : Array
      {
         return _extraSkinTypes;
      }
      
      static function stopSharing(param1:int) : void
      {
         sendTeamUpdate(param1,null);
      }
      
      static function sendTeamUpdate(param1:int, param2:Object) : void
      {
         if(!Team.isActive)
         {
            return;
         }
         Team.onChange(Main.userID.toString(),null,Team.P_CHARACTER_LIST,param1.toString(),param2 == null ? null : 1);
         Team.onChange(param1.toString(),null,Team.P_CHARACTER,null,param2);
      }
      
      static function onTeamUpdate(param1:int, param2:Object) : void
      {
         if(param2 != null)
         {
            param2.hd = 1;
            updateByID(param1,param2,Pixton.POOL_MINE);
         }
      }
      
      private static function setTempGenome(param1:int, param2:Object, param3:Boolean = false) : void
      {
         _tempGenomes[param1.toString()] = param2;
         if(param3)
         {
            sendTeamUpdate(param1,param2);
         }
      }
      
      private static function setTempGenomeValue(param1:int, param2:String, param3:*) : void
      {
         if(_tempGenomes[param1.toString()] == null)
         {
            _tempGenomes[param1.toString()] = {};
         }
         _tempGenomes[param1.toString()][param2] = param3;
      }
      
      private static function getTempGenome(param1:int) : Object
      {
         return _tempGenomes[param1.toString()];
      }
      
      private static function getTempGenomeValue(param1:int, param2:String) : *
      {
         return _tempGenomes[param1.toString()][param2];
      }
      
      static function getTargetClass(param1:MovieClip) : Class
      {
         if(targetClassMap[Object(param1).constructor.toString()] != null)
         {
            return targetClassMap[Object(param1).constructor.toString()];
         }
         return Object(param1).constructor;
      }
      
      private static function parseTemplateName(param1:Object) : String
      {
         var _loc2_:Array = param1.n.match(/^Template\.([0-9]+)\./);
         if(_loc2_ && _loc2_.length == 2)
         {
            return Template.getSettingNameFromNum(_loc2_[1]);
         }
         return param1.n;
      }
      
      public static function normalizePartName(param1:String, param2:Boolean = false) : String
      {
         var _loc3_:* = "(behind" + (!!param2 ? "" : "|upper|lower|[0-9]") + ")";
         return param1.replace(new RegExp(_loc3_,"gi"),"").toLowerCase();
      }
      
      private function makeNew(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(param1)
         {
            this.updateFromID = this.getID();
         }
         this.saved = false;
         if(!param2 && !param3)
         {
            this.characterName = defaultName;
         }
         this.setID(0);
      }
      
      function promptOverwrite(param1:Boolean = false, param2:Boolean = false) : void
      {
         var target:Character = null;
         var isOutfitChange:Boolean = param1;
         var isContextMenu:Boolean = param2;
         if(!isContextMenu && (this.promptedForOverwrite || !this.hasID() || !AppSettings.isAdvanced || Main.isCharCreate() || Template.isActive()))
         {
            Editor.self.updateAllCharacters(this.getID(),this.getGenome(),this);
            return;
         }
         Editor.startLock();
         target = this;
         this.promptedForOverwrite = true;
         Confirm.open("Pixton.comic.overwriteCharacter",!!isContextMenu ? 0 : 1,function(param1:*):*
         {
            Editor.endLock();
            if(param1 is uint && param1 == 0 || param1 is Boolean && !param1)
            {
               makeNew(false,isOutfitChange,isContextMenu);
            }
            else if(param1 is uint && param1 == 1)
            {
               makeNew(true,isOutfitChange);
               needsNewName = true;
            }
            else
            {
               target.onOverwrite();
            }
         },this.getName());
      }
      
      function onOverwrite() : void
      {
         Editor.self.updateAllCharacters(this.getID(),this.getGenome(),this);
      }
      
      function promptForName(param1:Function = null) : void
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            this.needsNewName = true;
            _loc2_ = this.characterName;
            param1 = this.onNameChange;
         }
         else
         {
            _loc2_ = this.characterName == defaultName ? "" : suggestName(this.characterName);
         }
         drawSnapshot();
         if(this.characterName == defaultName || this.needsNewName)
         {
            Popup.show(L.text("name-char"),this.onName,param1,_loc2_,snapShot,true,false,true);
         }
         else
         {
            param1();
         }
      }
      
      private function onNameChange() : void
      {
         this.setSaved(false);
         Editor.self.refreshMenu();
      }
      
      private function onName(param1:String, param2:Function) : void
      {
         if(!Utils.empty(param1))
         {
            this.characterName = param1;
         }
         param2();
      }
      
      public function resetPose() : void
      {
         this.setPose(Pose.getRandom(Pixton.getTargetType(this),this.skinType,Globals.POSES,null,Pixton.POOL_NEW),Globals.POSES,true);
         this.setPose(Pose.getRandom(Pixton.getTargetType(this),this.skinType,Globals.FACES,null,Pixton.POOL_NEW),Globals.FACES,true);
      }
      
      public function randomPose(param1:uint, param2:String = null, param3:int = -1) : void
      {
         this.setPose(Pose.getRandom(Pixton.getTargetType(this),this.skinType,param1,param2,param3),param1,true);
      }
      
      public function getMode() : uint
      {
         return this._editMode;
      }
      
      public function setMode(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         if(param1 == this.getMode() && !param2)
         {
            return;
         }
         onSetMode(param1);
         if(!Comic.presetPosesOnly)
         {
            _loc4_ = this.bodyParts.getParts(!!param2 ? uint(BodyParts.ALL_TURNS) : uint(BodyParts.ALL));
            for each(_loc3_ in _loc4_)
            {
               Utils.removeListener(_loc3_,MouseEvent.ROLL_OVER,this.onOverPart);
               Utils.useHand(_loc3_ as MovieClip,false);
               _loc3_.mouseEnabled = Utils.inArray(param1,[Editor.MODE_MOVE,Editor.MODE_LOOKS]);
               _loc3_.mouseChildren = _loc3_.mouseEnabled;
               Utils.removeListener(_loc3_,MouseEvent.MOUSE_DOWN,this.startRotate);
               Utils.removeListener(_loc3_,MouseEvent.ROLL_OVER,this.showHelp);
               Utils.removeListener(_loc3_,MouseEvent.ROLL_OUT,this.hideHelp);
               this.highlightPart(_loc3_,false);
            }
            if(param1 == Editor.MODE_EXPR)
            {
               _loc4_ = this.bodyParts.getParts(BodyParts.REPOSITIONABLE);
               for each(_loc3_ in _loc4_)
               {
                  Utils.addListener(_loc3_,MouseEvent.MOUSE_DOWN,this.startRotate);
                  Utils.addListener(_loc3_,MouseEvent.ROLL_OVER,this.onOverPart);
                  Utils.addListener(_loc3_,MouseEvent.ROLL_OVER,this.showHelp);
                  Utils.addListener(_loc3_,MouseEvent.ROLL_OUT,this.hideHelp);
                  Utils.useHand(_loc3_ as MovieClip,true);
                  _loc3_.mouseEnabled = true;
                  _loc3_.mouseChildren = _loc3_.mouseEnabled;
               }
            }
         }
         _loc4_ = null;
         switch(param1)
         {
            case Editor.MODE_EXPR:
               _loc4_ = this.bodyParts.getParts(BodyParts.EXPRESSION);
               break;
            case Editor.MODE_LOOKS:
               _loc4_ = this.bodyParts.getParts(BodyParts.LOOKS);
               break;
            case Editor.MODE_SCALE:
               _loc4_ = this.bodyParts.getParts(BodyParts.SCALABLE);
               break;
            case Editor.MODE_COLORS:
               _loc4_ = this.bodyParts.getParts(BodyParts.COLORS);
         }
         if(_loc4_ != null && param1 != Editor.MODE_MAIN)
         {
            for each(_loc3_ in _loc4_)
            {
               if(!(param1 != Editor.MODE_LOOKS && this.bodyParts.getPart(this.bodyParts.normalizePartName(_loc3_)).blankPart()))
               {
                  if(!(!ALLOW_FEMALE && this.bodyParts.normalizePartName(_loc3_) == "breasts"))
                  {
                     Utils.addListener(_loc3_,MouseEvent.ROLL_OVER,this.onOverPart);
                     Utils.useHand(_loc3_ as MovieClip,true);
                     _loc3_.mouseEnabled = true;
                     _loc3_.mouseChildren = _loc3_.mouseEnabled;
                  }
               }
            }
         }
         if(!param2)
         {
            Cursor.show(null);
         }
         this._editMode = param1;
      }
      
      function drillUp(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:MovieClip = param1.target as MovieClip;
         if(_loc3_ == null)
         {
            return;
         }
         if(this.getMode() == Editor.MODE_EXPR)
         {
            _loc2_ = Utils.mergeArrays(this.bodyParts.getParts(BodyParts.REPOSITIONABLE),this.bodyParts.getParts(BodyParts.EXPRESSION));
         }
         else if(this.getMode() == Editor.MODE_LOOKS)
         {
            _loc2_ = this.bodyParts.getParts(BodyParts.LOOKS);
         }
         else if(this.getMode() == Editor.MODE_SCALE)
         {
            _loc2_ = this.bodyParts.getParts(BodyParts.SCALABLE);
         }
         else if(this.getMode() == Editor.MODE_COLORS)
         {
            _loc2_ = this.bodyParts.getParts(BodyParts.COLORS);
         }
         else
         {
            _loc2_ = this.bodyParts.getParts(BodyParts.ALL);
         }
         while(!(_loc3_ is Editor || _loc3_ is Main || _loc3_ is Panel || _loc3_ is Comic || _loc3_ is Character) && _loc3_.parent != null)
         {
            if(Utils.inArray(_loc3_,_loc2_))
            {
               _loc3_.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER,true,false,0,0));
               break;
            }
            _loc3_ = _loc3_.parent as MovieClip;
         }
      }
      
      function isTurnable(param1:String) : Boolean
      {
         return this.bodyParts.isHuman() && this.bodyParts.isTurnable(param1);
      }
      
      function hasColor(param1:uint) : Boolean
      {
         return this.bodyParts.hasColor(param1);
      }
      
      function getActiveColorType(param1:int) : int
      {
         if(this.currentColorType == -1)
         {
            return param1;
         }
         return this.currentColorType;
      }
      
      private function onOverPart(param1:MouseEvent) : void
      {
         if(this.currentTargetOver != null || Picker.isVisible())
         {
            return;
         }
         this.currentTargetOver = param1.currentTarget;
         this.recentTargetOver = this.currentTargetOver;
         this.highlightPart(this.currentTargetOver);
         Utils.addListener(this.currentTargetOver,MouseEvent.ROLL_OUT,this.onOutPart);
         if(this.getMode() != Editor.MODE_EXPR || this.bodyParts.hasExpressions(this.currentTargetOver.name))
         {
            this.activatePart(this.currentTargetOver);
         }
         this.showHelp(this.currentTargetOver);
         if(this.getMode() == Editor.MODE_EXPR && this.bodyParts.hasHidables() || this.getMode() == Editor.MODE_COLORS)
         {
            Utils.addListener(this.currentTargetOver,MouseEvent.MOUSE_MOVE,this.onMoveOver);
            this.onMoveOver(param1);
         }
      }
      
      private function activatePart(param1:Object) : void
      {
         Utils.addListener(param1,MouseEvent.MOUSE_DOWN,this.startPart);
      }
      
      private function deactivatePart(param1:Object) : void
      {
         Utils.removeListener(param1,MouseEvent.MOUSE_DOWN,this.startPart);
      }
      
      private function onMoveOver(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc2_:String = param1.currentTarget.name;
         if(this.getMode() == Editor.MODE_COLORS)
         {
            _loc3_ = this.bodyParts.normalizePartName(param1.currentTarget);
            _loc6_ = (_loc5_ = (_loc4_ = param1.target is Look ? "fill" : param1.target.name).substr(4)) == null ? uint(0) : uint(parseInt(_loc5_) - 1);
            this.currentColorType = this.bodyParts.getColorType(_loc3_,_loc6_);
         }
         else if(this.getMode() == Editor.MODE_EXPR && !this.bodyParts.isMovableExpression(_loc2_) && !this.bodyParts.hasExpressions(_loc2_))
         {
            _loc7_ = this.getDependent(_loc2_,param1.currentTarget);
            _loc8_ = this.bodyParts.normalizePartName(_loc7_);
            _loc9_ = this.bodyParts.shouldTurn(_loc8_,new Point(param1.stageX,param1.stageY));
            Cursor.show(!!_loc9_ ? Cursor.TURN : null);
         }
      }
      
      private function highlightPart(param1:Object, param2:Boolean = true) : void
      {
         if(param2)
         {
            this.bodyParts.revealHotspot(param1.name,Editor.COLOR[this.getMode()]);
         }
         else
         {
            this.bodyParts.concealHotspot(param1.name);
         }
      }
      
      private function onOutPart(param1:MouseEvent, param2:Boolean = false) : void
      {
         if(this.currentTargetOver == null || this.currentTargetDown != null && !param2)
         {
            return;
         }
         this.highlightPart(param1.currentTarget,false);
         this.currentTargetOver = null;
         Utils.removeListener(param1.currentTarget,MouseEvent.ROLL_OUT,this.onOutPart);
         this.deactivatePart(param1.currentTarget);
         this.hideHelp();
         Cursor.show(null);
         if(this.getMode() == Editor.MODE_EXPR && this.bodyParts.hasHidables() || this.getMode() == Editor.MODE_COLORS)
         {
            Utils.removeListener(param1.currentTarget,MouseEvent.MOUSE_MOVE,this.onMoveOver);
         }
      }
      
      function getHandPosition(param1:uint) : Point
      {
         var _loc2_:BodyPart = this.bodyParts.getPart("hand" + param1);
         return _loc2_.target.parent.localToGlobal(new Point(_loc2_.target.x,_loc2_.target.y));
      }
      
      private function startPart(param1:MouseEvent) : void
      {
         this.currentTargetDown = param1.currentTarget;
         this.startCursor = new Point(param1.stageX,param1.stageY);
         this.selectPart(param1.currentTarget as MovieClip,this.bodyParts.getPickerPosition(param1.currentTarget.name));
         if(this.getMode() == Editor.MODE_EXPR && this.bodyParts.isMovablePart(param1.currentTarget.name) && this.bodyParts.hasExpressions(param1.currentTarget.name))
         {
            this.timeout = setTimeout(this.showPicker,HOLD_TIMEOUT);
         }
         else if(this.getMode() == Editor.MODE_SCALE)
         {
            if(this.bodyParts.canScale(param1.currentTarget.name))
            {
               this.moveStart = new Point(param1.stageX,param1.stageY);
            }
            else
            {
               this.moveStart = null;
            }
            Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateMove);
            Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopMove);
         }
         else
         {
            this.showPicker();
         }
      }
      
      public function selectPart(param1:MovieClip, param2:Object = null) : void
      {
         this.clickData = {
            "basePart":BodyParts.getBasePartName(this.bodyParts.normalizePartName(param1)),
            "bodyPart":this.bodyParts.getPart(param1)
         };
         if(param2 != null)
         {
            this.clickData.x = param2.x;
            this.clickData.y = param2.y;
            this.clickData.r = param2.r;
         }
         var _loc3_:String = this.bodyParts.normalizePartName(param1);
         if(_loc3_ == "hair")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("hairBehind");
         }
         else if(_loc3_ == "hairBehind")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("hair");
         }
         else if(_loc3_ == "collar")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("collarBehind");
         }
         else if(_loc3_ == "collarBehind")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("collar");
         }
         else if(_loc3_ == "cape")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("capeBehind");
         }
         else if(_loc3_ == "capeBehind")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("cape");
         }
         else if(_loc3_ == "upperArm1")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("lowerArm1");
         }
         else if(_loc3_ == "upperArm2")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("lowerArm2");
         }
         else if(_loc3_ == "lowerArm1")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("upperArm1");
         }
         else if(_loc3_ == "lowerArm2")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("upperArm2");
         }
         else if(_loc3_ == "upperLeg1")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("lowerLeg1");
         }
         else if(_loc3_ == "upperLeg2")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("lowerLeg2");
         }
         else if(_loc3_ == "lowerLeg1")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("upperLeg1");
         }
         else if(_loc3_ == "lowerLeg2")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("upperLeg2");
         }
         else if(_loc3_ == "sock1")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("foot1");
         }
         else if(_loc3_ == "sock2")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("foot2");
         }
         else if(_loc3_ == "foot1")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("sock1");
         }
         else if(_loc3_ == "foot2")
         {
            this.clickData.bodyPart2 = this.bodyParts.getPart("sock2");
         }
      }
      
      private function updateMove(param1:MouseEvent) : void
      {
         this.stopTimeout();
         if(this.moveStart == null)
         {
            return;
         }
         var _loc2_:Number = 0.5;
         var _loc3_:Number = (param1.stageX - this.moveStart.x) * _loc2_;
         var _loc4_:Number = (param1.stageY - this.moveStart.y) * _loc2_;
         var _loc5_:Number = 0.5;
         if(Math.abs(_loc3_) > _loc5_ || Math.abs(_loc4_) > _loc5_ || constrainMove != null)
         {
            if(constrainMove == null)
            {
               if(Math.abs(_loc3_) > Math.abs(_loc4_))
               {
                  constrainMove = "x";
               }
               else
               {
                  constrainMove = "y";
               }
            }
            if(Main.controlPressed)
            {
               this.bodyParts.moveLook(this.currentTargetOver.name,0,0,(_loc3_ + _loc4_) * 0.5 * _loc2_);
            }
            else if(constrainMove == "x")
            {
               this.bodyParts.moveLook(this.currentTargetOver.name,_loc3_,0);
            }
            else
            {
               this.bodyParts.moveLook(this.currentTargetOver.name,0,_loc4_);
            }
            this.onChange(Editor.MODE_SCALE);
         }
      }
      
      private function stopMove(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(this.currentTargetDown != null)
         {
            _loc2_ = this.currentTargetDown;
            this.currentTargetDown = null;
            _loc2_.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
         }
         if(this.currentTargetOver != null)
         {
            this.bodyParts.updateLook(this.currentTargetOver.name);
         }
         this.stopTimeout();
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateMove);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopMove);
         if(param1 != null && this.moveStart != null && (param1.stageX != this.moveStart.x || param1.stageY != this.moveStart.y))
         {
            this.dispatchStateChange();
         }
         constrainMove = null;
         this.drillUp(param1);
      }
      
      private function dispatchStateChange() : void
      {
         dispatchEvent(new PixtonEvent(PixtonEvent.STATE_CHANGE,this.currentTargetOver));
      }
      
      public function showPicker(param1:MouseEvent = null) : void
      {
         var _loc2_:uint = 0;
         this.hideHelp();
         if(this.getMode() == Editor.MODE_COLORS)
         {
            _loc2_ = this.bodyParts.getPickerColor(this.bodyParts.normalizePartName(this.currentTargetOver));
         }
         else
         {
            _loc2_ = !!Utils.inArray(this.getMode(),[Editor.MODE_LOOKS,Editor.MODE_SCALE]) ? uint(Globals.LOOKS) : uint(Globals.EXPRESSION);
         }
         Picker.load(_loc2_,this.clickData,this,true);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
         this.stopRotate(null);
         this.stopMove(null);
      }
      
      private function stopTimeout() : void
      {
         if(!isNaN(this.timeout) && this.timeout > 0)
         {
            clearTimeout(this.timeout);
            this.timeout = 0;
         }
      }
      
      private function hidePicker(param1:MouseEvent) : void
      {
         Picker.hide();
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.hidePicker);
         this.currentColorType = -1;
         this.dispatchStateChange();
         this.drillUp(param1);
         if(Main.isCharCreate())
         {
            Designer.getInstance().navigate(1);
         }
      }
      
      private function getDependent(param1:String, param2:Object = null) : Object
      {
         param1 = this.bodyParts.normalizePartName(param1);
         if(this.bodyParts.isHuman() && Utils.inArray(param1,this.bodyParts.getMovableDependents("head")))
         {
            return this.bodyParts.target["head"];
         }
         if(this.bodyParts.isHuman() && Utils.inArray(param1,this.bodyParts.getMovableDependents("torso")))
         {
            return this.bodyParts.target["torso"];
         }
         if(this.bodyParts.isHuman() && Utils.inArray(param1,this.bodyParts.getMovableDependents("ribs")))
         {
            return this.bodyParts.target["ribs"];
         }
         if(param2 != null)
         {
            return param2;
         }
         return this.currentTargetOver;
      }
      
      private function checkForDoubleClick(param1:MouseEvent) : void
      {
         var _loc2_:* = getTimer();
         if(!isNaN(this.clickTime) && _loc2_ - this.clickTime < Pixton.CLICK_TIME)
         {
            dispatchEvent(new PixtonEvent(PixtonEvent.DOUBLE_CLICK,this,param1));
         }
         this.clickTime = _loc2_;
      }
      
      private function startRotate(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         if(this.currentTargetOver == null)
         {
            return;
         }
         this.currentTargetDown = param1.currentTarget;
         this.checkForDoubleClick(param1);
         this.startCursor = new Point(param1.stageX,param1.stageY);
         if(this.bodyParts.isMovableExpression(this.currentTargetOver.name))
         {
            this.bodyParts.saveMovablePos(this.currentTargetOver.name);
            this.startPoint = null;
         }
         else
         {
            _loc2_ = this.getDependent(this.currentTargetOver.name);
            _loc3_ = this.bodyParts.normalizePartName(_loc2_);
            this.startR = this.bodyParts.getRotation(_loc2_);
            if(this.bodyParts.shouldTurn(_loc3_,new Point(param1.stageX,param1.stageY)))
            {
               this.turningState = TURNING;
               this.startT = this.bodyParts.getTurn(_loc3_);
            }
            else
            {
               this.turningState = NOT_TURNING;
               this.startPoint = _loc2_.parent.localToGlobal(new Point(_loc2_.x,_loc2_.y));
               this.startA = Math.atan2(param1.stageY - this.startPoint.y,param1.stageX - this.startPoint.x);
            }
         }
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateRotate);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopRotate);
      }
      
      private function updateRotate(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         this.stopTimeout();
         if(this.bodyParts.isMovableExpression(this.currentTargetOver.name))
         {
            this.bodyParts.updateMovable(this.currentTargetOver.name,this.startCursor,new Point(param1.stageX,param1.stageY),Main.controlPressed);
         }
         else
         {
            _loc2_ = this.getDependent(this.currentTargetOver.name);
            if(this.turningState == TURNING)
            {
               _loc3_ = Utils.d2r(-this.startR - rotation - Editor.self.sceneRotation);
               _loc4_ = param1.stageX - this.startCursor.x;
               _loc5_ = param1.stageY - this.startCursor.y;
               _loc6_ = _loc4_ * Math.cos(_loc3_) - _loc5_ * Math.sin(_loc3_);
               _loc7_ = Math.round(_loc6_ / TURN_TOLERANCE);
               this.highlightPart(this.currentTargetOver,false);
               if(this.bodyParts.setTurn(this.bodyParts.normalizePartName(_loc2_),this.startT + _loc7_,true,true))
               {
                  this.refreshParts();
               }
            }
            else
            {
               _loc8_ = Math.atan2(param1.stageY - this.startPoint.y,param1.stageX - this.startPoint.x);
               this.bodyParts.setRotation(_loc2_,this.startR + Utils.r2d(_loc8_ - this.startA) * flipX,true);
            }
            this.redraw(this.bodyParts.hasRotationConstraints(this.currentTargetOver.name));
         }
         this.onChange(Editor.MODE_EXPR);
         param1.updateAfterEvent();
      }
      
      public function refreshParts() : void
      {
         this.setMode(this.getMode(),true);
      }
      
      private function stopRotate(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Number = NaN;
         if(this.currentTargetDown != null)
         {
            _loc2_ = this.currentTargetDown;
            this.currentTargetDown = null;
            _loc2_.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
         }
         this.stopTimeout();
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateRotate);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopRotate);
         this.onChange(Editor.MODE_EXPR);
         if(param1 != null)
         {
            if(this.startPoint == null)
            {
               if(param1.stageX != this.startCursor.x || param1.stageY != this.startCursor.y)
               {
                  this.dispatchStateChange();
               }
            }
            else
            {
               _loc3_ = Math.atan2(param1.stageY - this.startPoint.y,param1.stageX - this.startPoint.x);
               if(_loc3_ != this.startA)
               {
                  this.dispatchStateChange();
               }
            }
         }
         this.drillUp(param1);
      }
      
      override public function redraw(param1:Boolean = false) : void
      {
         Utils.monitorMemory("character");
         dirty = true;
         if(param1 || !OS.canInvalidate() || Main.isHiResRender())
         {
            this.onRender();
         }
         else
         {
            Utils.invalidate(this);
         }
      }
      
      function onRender(param1:Event = null, param2:Boolean = false) : void
      {
         if(!dirty && !param2)
         {
            return;
         }
         dirty = false;
         this.bodyParts.render();
         if(Animation.isPlaying() && Animation.hasChannel(this,Animation.MODE_EXPR))
         {
            if(Math.random() < BLINK_PROB)
            {
               this.bodyParts.blink();
            }
         }
      }
      
      public function speak(param1:Boolean = true) : void
      {
         this.bodyParts.speak(param1);
      }
      
      public function isSpeaking(param1:Boolean = true) : Boolean
      {
         return this.bodyParts.isSpeaking(param1);
      }
      
      function randomize(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         if(param1 == BodyParts.LOOKS)
         {
            _loc4_ = this.bodyParts.getParts(param1,true);
            _loc6_ = this.bodyParts.getNewRandomParts(param1);
            _loc7_ = this.bodyParts.getDefaultLooks(param1);
            for each(_loc3_ in _loc4_)
            {
               _loc5_ = this.bodyParts.normalizePartName(_loc3_.target);
               if(!Utils.inArray(_loc5_,["cape","capeBehind"]))
               {
                  BodyPart(_loc3_).randomize(param1,param2 && !Utils.inArray(_loc5_,_loc6_),_loc7_[_loc5_]);
               }
            }
            if(FeatureTrial.can(FeatureTrial.CHARACTER_STRETCH) && this.bodyParts.getTurn("head") == BodyParts.TURN_DEFAULT)
            {
               this.bodyParts.randomize(param1,param2);
            }
            this.bodyParts.doSymmetryLooks(param1);
            this.bodyParts.adjustForSex();
            this.onChange(Editor.MODE_LOOKS);
         }
         else if(param1 == BodyParts.COLORS)
         {
            this.bodyParts.randomize(param1,param2);
            this.onChange(Editor.MODE_COLORS);
         }
      }
      
      function rerandomize(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1 == Editor.MODE_LOOKS)
         {
            _loc2_ = this.bodyHeight;
            _loc3_ = this.bodyWidth;
            this.randomize(BodyParts.LOOKS);
            this.bodyParts.doSymmetryLooks(BodyParts.LOOKS);
            this.bodyParts.adjustForSex();
            this.setBodyHeight(_loc2_);
            this.setBodyWidth(_loc3_);
         }
         else if(param1 == Editor.MODE_COLORS)
         {
            this.randomize(BodyParts.COLORS);
         }
         this.dispatchStateChange();
      }
      
      override public function getAttachPos() : Point
      {
         return this.bodyParts.getMouthPos();
      }
      
      function getData(param1:Boolean = false, param2:Boolean = false) : Object
      {
         var _loc3_:Object = {
            "z":zIndex,
            "sz":size,
            "sx":flipX,
            "p":Utils.encode(this.bodyParts.getPositionData()),
            "e":Utils.encode(this.bodyParts.getExpressionData()),
            "px":Utils.encode(this.bodyParts.getExtraPositionData()),
            "ex":Utils.encode(getExtraData()),
            "sh":(!!silhouette ? 1 : 0),
            "k":this.getColor(),
            "skinType":this.skinType,
            "x":x,
            "y":y,
            "s":zIndex,
            "r":rotation
         };
         if(!param1)
         {
            _loc3_ = Utils.mergeObjects(_loc3_,{"id":this.getID()});
         }
         if(param2)
         {
            _loc3_ = Utils.mergeObjects(_loc3_,{"genome":this.getGenome()});
         }
         return _loc3_;
      }
      
      function setData(param1:Object, param2:Boolean = false) : void
      {
         if(param1.z != null)
         {
            zIndex = param1.z;
         }
         this.bodyParts.setPositionData(Utils.decode(param1.p) as Array);
         if(param1.px != null)
         {
            this.bodyParts.setExtraPositionData(Utils.decode(param1.px));
         }
         var _loc3_:Array = Utils.decode(param1.e) as Array;
         this.bodyParts.setExpressionData(_loc3_);
         if(param1.x != null && !param2)
         {
            this.setPositionData(param1);
            flipX = param1.sx;
         }
         if(param1.genome != null)
         {
            this.setGenome(param1.genome);
         }
         setSilhouette(param1.sh == 1,false);
         this.setColor(Palette.SILHOUETTE_COLOR,param1.k,false,false);
         if(param1.ex)
         {
            setExtraData(Utils.decode(param1.ex));
         }
         else
         {
            setExtraData();
         }
      }
      
      private function setPositionData(param1:Object) : void
      {
         x = param1.x;
         y = param1.y;
         rotation = param1.r;
         size = param1.sz;
      }
      
      function getGenome() : Object
      {
         var _loc1_:Object = this.bodyParts.getExtraLooksData();
         _loc1_["c"] = this.getColorData();
         return {
            "id":this.getID(),
            "t":this.skinType,
            "w":this.bodyWidth,
            "h":this.bodyHeight,
            "n":this.characterName,
            "d":Utils.encode(this.bodyParts.getLooksData()),
            "ex":Utils.encode(_loc1_)
         };
      }
      
      private function getColorData() : Object
      {
         var _loc1_:Array = [];
         var _loc2_:uint = Globals.SKIN_COLOR;
         while(_loc2_ <= Globals.MAX_COLOR)
         {
            _loc1_[_loc2_] = this.bodyParts.getColor(_loc2_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      function setGenome(param1:Object, param2:Boolean = true, param3:Boolean = false) : void
      {
         var _loc5_:Object = (_loc4_ = Utils.decode(param1.ex)) == null || _loc4_.c == null ? null : _loc4_.c;
         if(!param3)
         {
            if(param2)
            {
               this.setID(param1.id);
            }
            this.skinType = param1.t;
            this.bodyParts.setExtraLooksData(_loc4_);
            if(param1.lc == 0)
            {
               param1.lc = param1.sc;
            }
            this.bodyParts.setColor(Globals.SKIN_COLOR,!!_loc5_ ? _loc5_[Globals.SKIN_COLOR] : param1.sc);
            this.bodyParts.setColor(Globals.HAIR_COLOR,!!_loc5_ ? _loc5_[Globals.HAIR_COLOR] : param1.hc);
            this.bodyParts.setColor(Globals.IRIS_COLOR,!!_loc5_ ? _loc5_[Globals.IRIS_COLOR] : param1.ic);
            this.bodyParts.setColor(Globals.EYELID_COLOR,!!_loc5_ ? _loc5_[Globals.EYELID_COLOR] : param1.ec);
            this.bodyParts.setColor(Globals.LIP_COLOR,!!_loc5_ ? _loc5_[Globals.LIP_COLOR] : param1.lc);
            this.setBodyHeight(param1.h,false);
            this.setBodyWidth(param1.w,false);
            this.characterName = param1.n;
            this.absModTime = param1.m;
         }
         this.bodyParts.setLooksData(Utils.decode(param1.d) as Array,param3);
         if(this.bodyParts.isHuman(true) && (_loc4_ == null || _loc4_.v < 3))
         {
            if(this.bodyParts.getPart("eye2").look == 3 || this.bodyParts.getPart("eye2").look == 7)
            {
               if(this.bodyParts.getPart("eye2").look == 3)
               {
                  this.bodyParts.getPart("eye2").look = 0;
               }
               else
               {
                  this.bodyParts.getPart("eye2").look = 6;
               }
               if(this.bodyParts.getPart("eyeShadow2").look == 0)
               {
                  this.bodyParts.getPart("eyeShadow2").look = 4;
               }
               else
               {
                  this.bodyParts.getPart("eyeShadow2").look = 3;
               }
               this.bodyParts.doSymmetryLooks(BodyParts.LOOKS);
            }
         }
         this.bodyParts.setColor(Globals.SHIRT_COLOR,!!_loc5_ ? _loc5_[Globals.SHIRT_COLOR] : param1.uc);
         this.bodyParts.setColor(Globals.PANT_COLOR,!!_loc5_ ? _loc5_[Globals.PANT_COLOR] : param1.pc);
         this.bodyParts.setColor(Globals.SHOE_COLOR,!!_loc5_ ? _loc5_[Globals.SHOE_COLOR] : param1.fc);
         this.bodyParts.setColor(Globals.HAT_COLOR,!!_loc5_ ? _loc5_[Globals.HAT_COLOR] : param1.tc);
         this.bodyParts.setColor(Globals.GLOVE_COLOR,!!_loc5_ ? _loc5_[Globals.GLOVE_COLOR] : param1.gc);
         this.bodyParts.setColor(Globals.ACCESSORY_COLOR,!!_loc5_ ? _loc5_[Globals.ACCESSORY_COLOR] : param1.ac);
         this.bodyParts.setColor(Globals.SOCK_COLOR,!!_loc5_ ? _loc5_[Globals.SOCK_COLOR] : param1.zc);
         this.bodyParts.setColor(Globals.BELT_COLOR,!!_loc5_ ? _loc5_[Globals.BELT_COLOR] : param1.fc);
         this.bodyParts.setColor(Globals.EARRING_COLOR,!!_loc5_ ? _loc5_[Globals.EARRING_COLOR] : param1.ac);
         this.bodyParts.setColor(Globals.EYEWEAR_COLOR,!!_loc5_ ? _loc5_[Globals.EYEWEAR_COLOR] : param1.fc);
         this.bodyParts.setColor(Globals.BUCKLE_COLOR,!!_loc5_ ? _loc5_[Globals.BUCKLE_COLOR] : param1.ac);
         this.bodyParts.setColor(Globals.CAPE_COLOR,!!_loc5_ ? _loc5_[Globals.CAPE_COLOR] : param1.pc);
         this.lastSaved = this.getGenome();
      }
      
      function revert() : void
      {
         this.setGenome(this.lastSaved);
         this.redraw();
         this.onChange(Editor.MODE_LOOKS,false);
      }
      
      function updateID(param1:int) : void
      {
         var _loc2_:int = this.getID();
         if(param1 == _loc2_)
         {
            return;
         }
         var _loc3_:Object = this.getGenome();
         setTempGenome(_loc2_,null);
         this.setID(param1);
      }
      
      function setID(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:int = this.getID();
         this._id = param1;
         if(this.hasID())
         {
            if(_loc3_ < 0)
            {
               updateCache(_loc3_,param1);
            }
         }
         else
         {
            this.saved = param2;
            if(param1 == 0)
            {
               do
               {
                  param1 = -Math.floor(Math.random() * int.MAX_VALUE);
               }
               while(getTempGenome(param1) != null);
               
               this._id = param1;
               setTempGenome(param1,this.getGenome(),this.pendingID == 0);
            }
            else if(param1 > 0)
            {
               this.pendingID = 0;
            }
         }
      }
      
      function getID() : int
      {
         return this._id;
      }
      
      function getSaved() : Boolean
      {
         return this.saved && this.hasID();
      }
      
      function hasID() : Boolean
      {
         return this.getID() > 0;
      }
      
      function setSaved(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.lastSaved = this.getGenome();
            this.onChange(Editor.MODE_LOOKS,false);
            if(this.updateFromID > 0)
            {
               Comic.resetCache();
               this.updateFromID = 0;
            }
            this.saved = true;
            setRelModTime(this.getID());
         }
         else
         {
            this.saved = false;
         }
      }
      
      function onChange(param1:uint, param2:Boolean = true) : void
      {
         if(Utils.inArray(param1,[Editor.MODE_LOOKS,Editor.MODE_SCALE,Editor.MODE_COLORS]))
         {
            if(this.isLockedLooks())
            {
               return;
            }
            if(this.hasID() && !inPool(this.getID(),Pixton.POOL_MINE))
            {
               this.setID(0);
            }
            if(param2 || !this.hasID())
            {
               this.saved = false;
               setRelModTime(this.getID());
               clearCache(this.getID());
            }
            dispatchEvent(new PixtonEvent(PixtonEvent.EDIT_CHARACTER,this,param2));
         }
         else
         {
            dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE_CHARACTER,this,param2));
         }
      }
      
      override function getColor(param1:int = -1) : *
      {
         return _colorID[0];
      }
      
      override function setColor(param1:int, param2:*, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc5_:Array = null;
         if(param1 == Palette.SILHOUETTE_COLOR)
         {
            if(param2 == 0)
            {
               param2 = Palette.getDefaultColor(Palette.SILHOUETTE_COLOR);
            }
            if(!param3)
            {
               _colorID[0] = param2;
            }
            _loc5_ = Palette.getColor(param2);
            if(silhouette)
            {
               Palette.setTint(this.bodyParts.target);
               Utils.setColor(this.bodyParts.target,_loc5_,0,true);
            }
            else if(param2 == Palette.TRANSPARENT_ID || !this.isLockedLooks())
            {
               Palette.setTint(this.bodyParts.target);
            }
            else
            {
               Palette.setTint(this.bodyParts.target,_loc5_);
            }
            setGlowAmount(getGlowAmount());
         }
         else
         {
            this.bodyParts.setColor(param1,param2);
         }
         if(param4)
         {
            this.onChange(Editor.MODE_LOOKS,param4);
         }
      }
      
      function setName(param1:String) : void
      {
         this.characterName = param1;
         this.onChange(Editor.MODE_LOOKS);
      }
      
      public function getName() : String
      {
         return this.characterName;
      }
      
      public function get bodyWidth() : Number
      {
         return this.bodyParts.widthScale;
      }
      
      public function setBodyWidth(param1:Number, param2:Boolean = true) : void
      {
         this.bodyParts.widthScale = param1;
         if(this.skinType == Globals.HORSE)
         {
            this.bodyParts.heightScale = param1;
         }
         this.onChange(Editor.MODE_LOOKS,param2);
      }
      
      public function get bodyHeight() : Number
      {
         return this.bodyParts.heightScale;
      }
      
      public function setBodyHeight(param1:Number, param2:Boolean = true) : void
      {
         this.bodyParts.heightScale = param1;
         if(this.skinType == Globals.HORSE || this.skinType == Globals.BIRD)
         {
            this.bodyParts.widthScale = param1;
         }
         this.onChange(Editor.MODE_LOOKS,param2);
      }
      
      function isResizable() : Boolean
      {
         return !Utils.inArray(this.skinType,[Globals.REDNOSE,Globals.GAIA]);
      }
      
      function newerThan(param1:int) : Boolean
      {
         var _loc2_:Number = Character.getRelModTime(this.getID());
         var _loc3_:Number = Comic.getRelModTime();
         return isNaN(_loc3_) || _loc2_ > _loc3_ || param1 > -1 && this.absModTime > param1;
      }
      
      private function showHelp(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         if(Picker.isVisible())
         {
            return;
         }
         if(param1 is MouseEvent)
         {
            _loc3_ = param1.currentTarget;
         }
         else
         {
            _loc3_ = param1 as MovieClip;
         }
         if(param1 is MouseEvent)
         {
            _loc2_ = L.text("drag-move");
         }
         else
         {
            _loc2_ = L.text("click-hold");
         }
         if(this.getMode() == Editor.MODE_EXPR && this.bodyParts.hasExpressions(_loc3_.name))
         {
            _loc2_ = L.text("drag-hold");
         }
         else if(this.getMode() == Editor.MODE_SCALE)
         {
            if(this.bodyParts.getTurn("head") == BodyParts.TURN_DEFAULT)
            {
               _loc2_ = L.text("click-drag");
            }
            else
            {
               _loc2_ = L.text("turn-head");
            }
         }
         Help.show(_loc2_,_loc3_);
      }
      
      private function hideHelp(param1:MouseEvent = null) : void
      {
         Help.hide();
      }
      
      function getPoseData(param1:uint) : Object
      {
         return this.getAnimationData(Pixton.MODE_EXPR);
      }
      
      function setPose(param1:Object, param2:uint, param3:Boolean = false) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param2 == Globals.POSES)
         {
            this.bodyParts.setPositionData(param1.p,false,true);
            this.bodyParts.setExtraPositionData(param1.px);
            this.bodyParts.setExpressionData(param1.e,false,true);
         }
         else
         {
            this.bodyParts.setPositionData(param1.p,true,false);
            this.bodyParts.setExpressionData(param1.e,true,false);
         }
         this.redraw(param3);
      }
      
      function setOutfit(param1:Object = null, param2:Boolean = true) : void
      {
         this.setGenome(param1,false,true);
         this.onChange(Editor.MODE_LOOKS);
         this.redraw();
         if(param2)
         {
            this.onOverwrite();
         }
      }
      
      function getHead() : MovieClip
      {
         return this.bodyParts.target["head"] as MovieClip;
      }
      
      function getHeadParts(param1:Array = null) : Array
      {
         if(param1 == null)
         {
            if(this.skinType == Globals.REDNOSE)
            {
               param1 = ["eye1","eye2"];
            }
            else if(this.skinType == Globals.BIRD)
            {
               param1 = ["head","mouth","neck"];
            }
            else if(this.bodyParts.target["chin"] != null)
            {
               param1 = ["head","chin"];
            }
            else if(this.bodyParts.target["head"] != null)
            {
               param1 = ["head"];
            }
            else if(this.bodyParts.target["framer"] != null)
            {
               param1 = ["framer"];
            }
            else
            {
               param1 = ["torso"];
            }
         }
         var _loc2_:Array = [];
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.push(this.bodyParts.target[param1[_loc4_]]);
            _loc4_++;
         }
         return _loc2_;
      }
      
      function hasHiddenPart() : Boolean
      {
         return this.bodyParts.hasHiddenPart();
      }
      
      function partIsHidable() : Boolean
      {
         if(this.getMode() != Editor.MODE_EXPR)
         {
            return false;
         }
         return this.currentTargetOver != null && this.bodyParts.isHidable(this.currentTargetOver);
      }
      
      function hideActive() : void
      {
         if(this.recentTargetOver == null)
         {
            return;
         }
         this.bodyParts.hidePart(this.recentTargetOver);
         this.redraw();
      }
      
      function showAll() : void
      {
         this.bodyParts.showAllParts();
         this.redraw();
      }
      
      function hasPhoto(param1:String = null) : Boolean
      {
         return this.bodyParts.hasPhoto(param1);
      }
      
      function setLineAlpha(param1:Number) : void
      {
         var _loc2_:BodyPart = null;
         var _loc3_:Array = this.bodyParts.getParts(BodyParts.ALL,true);
         for each(_loc2_ in _loc3_)
         {
            _loc2_.setLineAlpha(param1);
         }
         this.redraw();
      }
      
      public function getAnimationData(param1:uint) : Object
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc2_:Object = {};
         switch(param1)
         {
            case Pixton.MODE_DEFAULT:
               _loc2_.hh = 0;
               _loc2_.p = this.getAnimationPositionData();
               break;
            case Pixton.MODE_EXPR:
               _loc3_ = this.bodyParts.getPositionData();
               _loc4_ = this.bodyParts.getExpressionData();
               _loc5_ = this.bodyParts.getExtraPositionData();
               _loc2_.p = _loc3_;
               _loc2_.e = _loc4_;
               _loc2_.px = _loc5_;
               break;
            case Pixton.MODE_LOOKS:
               _loc2_.w = this.bodyWidth;
               _loc2_.h = this.bodyHeight;
         }
         return _loc2_;
      }
      
      public function getInterpolatedPositionData(param1:Array, param2:Number) : Object
      {
         return this.interpolatePositionData(param1,"p",param2,true);
      }
      
      public function setAnimationData(param1:uint, param2:Array, param3:Number) : void
      {
         switch(param1)
         {
            case Pixton.MODE_DEFAULT:
               setHidden(Animation.interpolate(param2[0].hh,param2[1].hh,param2[2].hh,param2[3].hh,param3,0,false,Animation.INTERPOLATE_BINARY_ONKEY) == 1);
               if(!getHidden())
               {
                  this.interpolatePositionData(param2,"p",param3);
               }
               break;
            case Pixton.MODE_EXPR:
               if(!getHidden())
               {
                  this.bodyParts.interpolatePositionData(param2,"p",param3);
                  this.bodyParts.interpolateExpressionData(param2,"e",param3);
                  this.bodyParts.interpolateExtraPositionData(param2,"px",param3);
               }
               break;
            case Pixton.MODE_LOOKS:
               this.setBodyWidth(Animation.interpolate(param2[0].w,param2[1].w,param2[2].w,param2[3].w,param3),true);
               this.setBodyHeight(Animation.interpolate(param2[0].h,param2[1].h,param2[2].h,param2[3].h,param3),true);
         }
         if(!getHidden())
         {
            this.redraw();
         }
      }
      
      public function getAlignData() : Object
      {
         var _loc1_:Object = {};
         var _loc2_:MovieClip = this.bodyParts.getPart("foot1").target;
         var _loc3_:MovieClip = this.bodyParts.getPart("foot2").target;
         var _loc4_:Rectangle = _loc2_.getRect(parent);
         var _loc5_:Rectangle = _loc3_.getRect(parent);
         _loc1_.foot1 = {
            "x":_loc4_.x,
            "y":_loc4_.bottom,
            "rotation":_loc2_.rotation
         };
         _loc1_.foot2 = {
            "x":_loc5_.x,
            "y":_loc5_.bottom,
            "rotation":_loc3_.rotation
         };
         return _loc1_;
      }
      
      private function interpolatePositionData(param1:Array, param2:String, param3:Number, param4:Boolean = false) : Object
      {
         var _loc5_:Object;
         (_loc5_ = {}).x = Animation.interpolate(param1[0][param2].x,param1[1][param2].x,param1[2][param2].x,param1[3][param2].x,param3);
         _loc5_.y = Animation.interpolate(param1[0][param2].y,param1[1][param2].y,param1[2][param2].y,param1[3][param2].y,param3);
         _loc5_.r = Animation.interpolate(param1[0][param2].r,param1[1][param2].r,param1[2][param2].r,param1[3][param2].r,param3,Utils.WRAP_360);
         _loc5_.sz = Animation.interpolate(param1[0][param2].sz,param1[1][param2].sz,param1[2][param2].sz,param1[3][param2].sz,param3,0,false,Animation.INTERPOLATE_CONTINUOUS,Animation.INTERPOLATE_COSINE);
         if(param4)
         {
            return _loc5_;
         }
         this.setPositionData(_loc5_);
         return null;
      }
      
      public function getAnimationPositionData() : Object
      {
         var _loc1_:Object = {};
         _loc1_.x = x;
         _loc1_.y = y;
         _loc1_.r = rotation;
         _loc1_.sz = size;
         return _loc1_;
      }
      
      public function set dummy(param1:Boolean) : void
      {
         this._isDummy = param1;
      }
      
      public function get dummy() : Boolean
      {
         return this._isDummy;
      }
      
      public function getPartValue(param1:String, param2:uint, param3:uint) : uint
      {
         return this.bodyParts.getPartValue(param1,param2,param3);
      }
      
      public function isLockedLooks() : Boolean
      {
         return this.bodyParts.isLocked() && !isEditor();
      }
   }
}

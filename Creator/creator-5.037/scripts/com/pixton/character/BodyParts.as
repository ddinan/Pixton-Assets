package com.pixton.character
{
   import com.pixton.animate.Animation;
   import com.pixton.editor.Asset;
   import com.pixton.editor.Character;
   import com.pixton.editor.Debug;
   import com.pixton.editor.FeatureTrial;
   import com.pixton.editor.Globals;
   import com.pixton.editor.Main;
   import com.pixton.editor.Palette;
   import com.pixton.editor.SkinManager;
   import com.pixton.editor.Utils;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public final class BodyParts
   {
      
      private static const VERBOSE:Boolean = false;
      
      private static const VERBOSE_DRAWING:Boolean = false;
      
      private static const TESTING_JOINTS:Boolean = false;
      
      private static const DRAWING_DISABLED:Boolean = false;
      
      private static const TESTING_SKIRT:Boolean = false;
      
      private static const DRAW_ONE_SIDE:Boolean = false;
      
      private static const DRAW_ELBOW_KNEE_ONLY:Boolean = false;
      
      private static const DRAW_HAND_FOOT_ONLY:Boolean = false;
      
      private static const DRAW_SHOULDER_ONLY:Boolean = false;
      
      private static const DRAW_ARMS:Boolean = true;
      
      private static const DRAW_LEGS:Boolean = true;
      
      private static const DRAW_TORSO:Boolean = true;
      
      private static const CONNECT_TORSO:Boolean = true;
      
      private static const DRAW_HEAD:Boolean = true;
      
      private static const DRAW_NECK:Boolean = true;
      
      private static const GENDER_MALE:uint = 0;
      
      private static const GENDER_FEMALE:uint = 1;
      
      private static const GENDER_UNKNOWN:uint = 2;
      
      public static const ALL:uint = 0;
      
      public static const EXPRESSION:uint = 1;
      
      public static const LOOKS:uint = 2;
      
      public static const COLORS:uint = 3;
      
      public static const REPOSITIONABLE:uint = 4;
      
      public static const SCALABLE:uint = 5;
      
      public static const ALL_TURNS:uint = 6;
      
      public static const TURN_INCR:uint = 4;
      
      public static const TURN_DEFAULT:uint = 0;
      
      private static const BLINK_EXPRESSION:uint = 4;
      
      public static const TURNED_TOWARD:uint = 0;
      
      public static const TURNED_AWAY:uint = 3;
      
      public static const BOOT_OFFSET_Y:Number = 71.1 - 8;
      
      private static const BACK:String = "BACK";
      
      private static const FRONT:String = "FRONT";
      
      private static const MAX_FOOT_RATIO:Number = 1.5;
      
      private static const LIMB_GIRTH_FACTOR:Number = 0.6;
      
      private static const ANKLE_GIRTH_FACTOR:Number = 0.5;
      
      private static const SHIRT_SHORT:uint = 2;
      
      private static const SHIRT_SANTA:uint = 6;
      
      private static const PANTS_SANTA:uint = 6;
      
      private static const SKIRT_SHORT:uint = 7;
      
      private static const GLOVES_NONE:uint = 0;
      
      private static const BELT_NONE:uint = 0;
      
      private static const BELT_SANTA:uint = 1;
      
      private static const HAND:String = "hand";
      
      private static const FOOT:String = "foot";
      
      private static const LIMB_GIRTH:Array = [8,3];
      
      private static const LEG_FLARE_1:Array = [1.4,2];
      
      private static const LEG_FLARE_2:Array = [1.4,1];
      
      private static const LEG_FLARE_3:Array = [0,1.4];
      
      private static const BELL_BOTTOM_FACTOR:Number = 2;
      
      private static const NECK_GIRTH:Array = [4,6];
      
      private static const NECK_FLARE:Array = [1,1.4];
      
      private static var pivotNames:Object = {};
      
      private static var anchors:Object = {};
      
      private static var map:Object = {};
      
      private static var bodyPartsMap:Object = {};
      
      private static var turningMap:Object = {};
      
      private static var colorPrimaryMap:Object = {};
      
      private static var colorAllMap:Object = {};
      
      private static var lookGroupMap:Object = {};
      
      private static var groupedLooks:Object = {};
      
      private static var partMap:Object;
      
      private static var partIDMap:Object = {
         "2028":"accessory",
         "2009":"beard",
         "2034":"belt",
         "2033":"breasts",
         "2003":"brow1",
         "2004":"brow2",
         "2008":"chin",
         "2038":"collar",
         "2039":"collarBehind",
         "2036":"ear1",
         "2037":"ear2",
         "2001":"eye1",
         "2002":"eye2",
         "2007":"eyewear",
         "2026":"foot1",
         "2027":"foot2",
         "2006":"hair",
         "2030":"hairBehind",
         "2022":"hand1",
         "2023":"hand2",
         "2029":"hat",
         "2041":"head",
         "2012":"hip1",
         "2013":"hip2",
         "2018":"lowerArm1",
         "2019":"lowerArm2",
         "2020":"lowerLeg1",
         "2021":"lowerLeg2",
         "2010":"moustache",
         "2005":"mouth",
         "2031":"neck",
         "2035":"nose",
         "2040":"ribs",
         "2024":"shoulder1",
         "2025":"shoulder2",
         "2032":"tail",
         "2011":"torso",
         "2014":"upperArm1",
         "2015":"upperArm2",
         "2016":"upperLeg1",
         "2017":"upperLeg2",
         "2100":"eye",
         "2101":"brow",
         "2102":"hip",
         "2103":"upperArm",
         "2104":"upperLeg",
         "2105":"lowerArm",
         "2106":"lowerLeg",
         "2107":"hand",
         "2108":"shoulder",
         "2109":"foot",
         "2110":"ear",
         "2111":"detail",
         "2112":"arm",
         "2113":"leg",
         "2114":"earring",
         "2115":"eyeShadow",
         "2116":"sock",
         "2117":"cape",
         "2118":"capeBehind"
      };
      
      private static var lockInfo:Object;
      
      public static const VERSION:uint = 3;
       
      
      public var target:MovieClip;
      
      public var headOnly:Boolean;
      
      public var skinType:uint;
      
      public var sizableLookData:Object;
      
      private var version:uint;
      
      private var scaleW:Number = 1;
      
      private var scaleH:Number = 1;
      
      private var bodyParts:Array;
      
      private var colors:Array;
      
      private var minWidth:Number = 0.4;
      
      private var maxWidth:Number = 1.5;
      
      private var biped:Boolean;
      
      private var turnData:Object;
      
      private var turningMapMC:Object;
      
      private var armBehind:uint = 0;
      
      private var legBehind:uint = 0;
      
      private var skinInfo:Object;
      
      private var movableLookData:Object;
      
      private var props:Array;
      
      private var _selected:Boolean;
      
      private var hiddenPartData:Object;
      
      private var _char:Character;
      
      public function BodyParts(param1:MovieClip, param2:uint, param3:Character)
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:* = null;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:BodyPart = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:MovieClip = null;
         this.sizableLookData = {};
         this.turningMapMC = {};
         this.movableLookData = {};
         this.props = [];
         this.hiddenPartData = {};
         super();
         this.target = param1;
         this.skinType = param2;
         this._char = param3;
         if(param1.drawing == null)
         {
            (_loc17_ = new MovieClip()).mouseEnabled = false;
            param1.addChild(_loc17_);
            param1.drawing = _loc17_;
         }
         this.skinInfo = SkinManager.getInfo(param2);
         this.skinInfo.movableLookNames = [];
         this.skinInfo.movableLookMap = {};
         this.skinInfo.scalableParts = [];
         this.skinInfo.scalableExprs = [];
         this.skinInfo.photoParts = [];
         if(this.skinInfo.lineSize == null)
         {
            this.skinInfo.lineSize = 1;
         }
         if(this.skinInfo.lineAlpha == null)
         {
            this.skinInfo.lineAlpha = 1;
         }
         if(this.skinInfo.curviness == null)
         {
            this.skinInfo.curviness = 1;
         }
         if(this.skinInfo.lineScaleMode == null)
         {
            this.skinInfo.lineScaleMode = LineScaleMode.NONE;
         }
         if(this.skinInfo.minHeight == null)
         {
            this.skinInfo.minHeight = 1;
         }
         if(this.skinInfo.maxHeight == null)
         {
            this.skinInfo.maxHeight = 1;
         }
         if(this.skinInfo.curveParts == null)
         {
            this.skinInfo.curveParts = [];
         }
         if(this.skinInfo.bodyScale != null)
         {
            param1.scaleX = this.skinInfo.bodyScale;
            param1.scaleY = param1.scaleX;
         }
         if(this.skinInfo.movableLooks != null)
         {
            _loc8_ = this.skinInfo.movableLooks.length;
            _loc4_ = 0;
            while(_loc4_ < _loc8_)
            {
               this.skinInfo.movableLookNames.push(this.skinInfo.movableLooks[_loc4_].name);
               this.skinInfo.movableLookMap[this.skinInfo.movableLooks[_loc4_].name] = this.skinInfo.movableLooks[_loc4_];
               this.skinInfo.scalableParts.push(this.skinInfo.movableLooks[_loc4_].name);
               _loc4_++;
            }
         }
         this.biped = this.isHuman();
         this.turnData = {};
         if(this.skinInfo.defTurn == null)
         {
            this.skinInfo.defTurn = TURN_DEFAULT;
         }
         if(map[param2] == null)
         {
            if(VERBOSE)
            {
               Debug.trace("init skin " + param2);
            }
            turningMap[param2] = {};
            colorPrimaryMap[param2] = {};
            colorAllMap[param2] = {};
            _loc8_ = this.skinInfo.parts.length;
            if(this.skinInfo.turningParts != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc8_)
               {
                  if(this.skinInfo.parts[_loc4_] != null)
                  {
                     _loc13_ = this.skinInfo.parts[_loc4_];
                     if(this.skinInfo.turningParts[_loc13_] != null)
                     {
                        turningMap[param2][_loc13_] = [];
                        _loc7_ = this.skinInfo.turningParts[_loc13_].length;
                        _loc5_ = 0;
                        while(_loc5_ < _loc7_)
                        {
                           turningMap[param2][_loc13_][_loc5_] = _loc13_ + "_" + Math.abs(this.skinInfo.turningParts[_loc13_][_loc5_]);
                           if(VERBOSE)
                           {
                              Debug.trace("added turn to " + _loc13_ + ": " + _loc13_ + "_" + Math.abs(this.skinInfo.turningParts[_loc13_][_loc5_]));
                           }
                           _loc5_++;
                        }
                        param1[_loc13_] = param1[turningMap[param2][_loc13_][this.skinInfo.defTurn]];
                        if(VERBOSE)
                        {
                           Debug.trace("target[\"" + _loc13_ + "\"] <= target[\"" + turningMap[param2][_loc13_][this.skinInfo.defTurn] + "\"]");
                        }
                     }
                  }
                  _loc4_++;
               }
            }
            map[param2] = {};
            anchors[param2] = {};
            pivotNames[param2] = {};
            bodyPartsMap[param2] = {};
            _loc4_ = 0;
            while(_loc4_ < _loc8_)
            {
               if(this.skinInfo.parts[_loc4_] != null)
               {
                  _loc13_ = this.skinInfo.parts[_loc4_];
                  map[param2][_loc13_] = _loc4_;
                  if(VERBOSE)
                  {
                     Debug.trace("part: " + _loc13_);
                  }
                  _loc12_ = param1[_loc13_] as MovieClip;
                  if(this.skinInfo.pivots != null && this.skinInfo.pivots[_loc13_] != null)
                  {
                     if(VERBOSE)
                     {
                        Debug.trace("pivot key: " + this.skinInfo.pivots[_loc13_]);
                     }
                     if(this.skinInfo.pivots[_loc13_] is Array)
                     {
                        if(VERBOSE)
                        {
                           Debug.trace("pivotNames[skinType][" + _loc13_ + "] = " + this.skinInfo.pivots[_loc13_]);
                        }
                        pivotNames[param2][_loc13_] = this.skinInfo.pivots[_loc13_];
                     }
                     else if(param1[this.skinInfo.pivots[_loc13_]] == null)
                     {
                        Debug.trace("Missing body part: " + _loc13_);
                     }
                     else if(param1[this.skinInfo.pivots[_loc13_]][removeSuffix(_loc13_)] != null)
                     {
                        if(VERBOSE)
                        {
                           Debug.trace("pivotNames[skinType][" + _loc13_ + "] = " + removeSuffix(_loc13_));
                        }
                        pivotNames[param2][_loc13_] = removeSuffix(_loc13_);
                     }
                     else if(param1[this.skinInfo.pivots[_loc13_]][_loc13_] == null)
                     {
                        if(VERBOSE)
                        {
                           Debug.trace("pivotNames[skinType][" + _loc13_ + "] = pivot");
                        }
                        pivotNames[param2][_loc13_] = "pivot";
                     }
                     else
                     {
                        if(VERBOSE)
                        {
                           Debug.trace("pivotNames[skinType][" + _loc13_ + "] = " + _loc13_);
                        }
                        pivotNames[param2][_loc13_] = _loc13_;
                     }
                     if(VERBOSE)
                     {
                        Debug.trace("pivot: " + pivotNames[param2][_loc13_]);
                     }
                     if(this.skinInfo.pivots[_loc13_] is Array)
                     {
                        _loc15_ = this.skinInfo.pivots[_loc13_][0];
                     }
                     else
                     {
                        _loc15_ = this.skinInfo.pivots[_loc13_];
                     }
                     if(VERBOSE)
                     {
                        Debug.trace("anchorIndex: " + _loc15_);
                     }
                     if(anchors[param2][_loc15_] == null)
                     {
                        anchors[param2][_loc15_] = [];
                     }
                     anchors[param2][_loc15_].push(_loc13_);
                  }
               }
               _loc4_++;
            }
            if(this.skinInfo.colorMap != null)
            {
               _loc8_ = this.skinInfo.colorMap.length;
               _loc4_ = 0;
               while(_loc4_ < _loc8_)
               {
                  if(this.skinInfo.colorMap[_loc4_] != null)
                  {
                     _loc9_ = this.skinInfo.colorMap[_loc4_].length;
                     _loc5_ = 0;
                     while(_loc5_ < _loc9_)
                     {
                        if(this.skinInfo.colorMap[_loc4_][_loc5_] != null)
                        {
                           colorPrimaryMap[param2][this.skinInfo.colorMap[_loc4_][_loc5_]] = _loc4_;
                        }
                        _loc5_++;
                     }
                  }
                  _loc4_++;
               }
            }
            if(this.skinInfo.colorParts != null)
            {
               _loc8_ = this.skinInfo.colorParts.length;
               _loc4_ = 0;
               while(_loc4_ < _loc8_)
               {
                  if(this.skinInfo.colorParts[_loc4_] != null)
                  {
                     _loc9_ = this.skinInfo.colorParts[_loc4_].length;
                     _loc5_ = 0;
                     while(_loc5_ < _loc9_)
                     {
                        if(this.skinInfo.colorParts[_loc4_][_loc5_] != null)
                        {
                           _loc10_ = this.skinInfo.colorParts[_loc4_][_loc5_].length;
                           _loc6_ = 0;
                           while(_loc6_ < _loc10_)
                           {
                              _loc13_ = this.skinInfo.colorParts[_loc4_][_loc5_][_loc6_];
                              if(colorAllMap[param2][_loc13_] == null)
                              {
                                 colorAllMap[param2][_loc13_] = {};
                              }
                              colorAllMap[param2][_loc13_][_loc5_] = _loc4_;
                              _loc6_++;
                           }
                        }
                        _loc5_++;
                     }
                  }
                  _loc4_++;
               }
            }
            lookGroupMap[param2] = {};
            groupedLooks[param2] = [];
            if(this.skinInfo.lookGroups != null)
            {
               _loc8_ = this.skinInfo.lookGroups.length;
               _loc4_ = 0;
               while(_loc4_ < _loc8_)
               {
                  _loc9_ = this.skinInfo.lookGroups[_loc4_].length;
                  _loc5_ = 0;
                  while(_loc5_ < _loc9_)
                  {
                     _loc13_ = this.skinInfo.lookGroups[_loc4_][_loc5_];
                     if(!Utils.inArray(_loc13_,groupedLooks[param2]))
                     {
                        groupedLooks[param2].push(_loc13_);
                     }
                     if(lookGroupMap[param2][_loc13_] == null)
                     {
                        lookGroupMap[param2][_loc13_] = [];
                     }
                     lookGroupMap[param2][_loc13_].push(_loc4_);
                     _loc5_++;
                  }
                  _loc4_++;
               }
            }
         }
         this.turningMapMC[param2] = {};
         for each(_loc13_ in this.skinInfo.parts)
         {
            if(_loc13_ != null)
            {
               this.turningMapMC[param2][_loc13_] = [];
               if(VERBOSE)
               {
                  Debug.trace("turningMap[" + param2 + "][" + _loc13_ + "]: " + turningMap[param2][_loc13_]);
               }
               if(turningMap[param2][_loc13_] == null)
               {
                  if(VERBOSE)
                  {
                     Debug.trace("target[" + _loc13_ + "]: " + param1[_loc13_]);
                  }
                  param1[_loc13_].__name = _loc13_;
                  if(VERBOSE)
                  {
                     Debug.trace("target[" + _loc13_ + "].__name = " + _loc13_);
                  }
               }
               else
               {
                  _loc7_ = turningMap[param2][_loc13_].length;
                  _loc5_ = 0;
                  while(_loc5_ < _loc7_)
                  {
                     if(VERBOSE)
                     {
                        Debug.trace("turningMapMC[" + param2 + "][" + _loc13_ + "][" + _loc5_ + "]: " + turningMap[param2][_loc13_][_loc5_]);
                        Debug.trace("target[" + turningMap[param2][_loc13_][_loc5_] + "]: " + param1[turningMap[param2][_loc13_][_loc5_]]);
                     }
                     this.turningMapMC[param2][_loc13_][_loc5_] = param1[turningMap[param2][_loc13_][_loc5_]];
                     this.turningMapMC[param2][_loc13_][_loc5_].__name = _loc13_;
                     _loc5_++;
                  }
                  param1[_loc13_] = this.turningMapMC[param2][_loc13_][this.skinInfo.defTurn];
               }
            }
         }
         if(this.skinInfo.turningParts != null)
         {
            for(_loc11_ in this.skinInfo.turningParts)
            {
               this.setTurn(_loc11_,this.skinInfo.defTurn,false);
            }
         }
         this.bodyParts = [];
         for each(_loc16_ in this.skinInfo.parts)
         {
            if(_loc16_ != null)
            {
               _loc12_ = param1[_loc16_];
               _loc14_ = new BodyPart(_loc12_ as MovieClip,param2,this.getTurn(_loc16_),null,this._char);
               this.saveLook(_loc16_,_loc14_);
               if(_loc14_.hasPhoto())
               {
                  this.skinInfo.photoParts.push(_loc16_);
               }
               bodyPartsMap[param2][_loc16_] = map[param2][_loc16_];
            }
         }
         if(param1["framer"] != null)
         {
            MovieClip(param1["framer"]).visible = false;
         }
         this.colors = [];
      }
      
      public static function getFootFromSock(param1:uint, param2:int) : uint
      {
         var _loc3_:Object = SkinManager.getInfo(param1);
         return _loc3_.sockToFoot[param2];
      }
      
      public static function getSockFromFoot(param1:uint, param2:int) : uint
      {
         var _loc3_:Object = SkinManager.getInfo(param1);
         return _loc3_.footToSock[param2];
      }
      
      public static function isBootSock(param1:uint, param2:int) : Boolean
      {
         var _loc3_:Object = SkinManager.getInfo(param1);
         return _loc3_.sockToFoot && _loc3_.sockToFoot[param2] != null;
      }
      
      public static function isBootShoe(param1:uint, param2:int) : Boolean
      {
         var _loc3_:Object = SkinManager.getInfo(param1);
         return _loc3_.footToSock && _loc3_.footToSock[param2] != null;
      }
      
      private static function removeSuffix(param1:String) : String
      {
         var _loc2_:String = param1.substr(param1.length - 1,1);
         if(_loc2_ == "L" || _loc2_ == "R")
         {
            return param1.substr(0,param1.length - 1);
         }
         return param1;
      }
      
      public static function getSuffix(param1:String, param2:Boolean = false) : String
      {
         var _loc4_:String = null;
         var _loc3_:uint = parseInt(param1.substr(param1.length - 1,1));
         if(_loc3_ > 0)
         {
            return _loc3_.toString();
         }
         if((_loc4_ = param1.substr(param1.length - 1,1)) == "L")
         {
            return !!param2 ? _loc4_ : "1";
         }
         if(_loc4_ == "R")
         {
            return !!param2 ? _loc4_ : "2";
         }
         return null;
      }
      
      public static function _get(param1:uint, param2:String) : *
      {
         var _loc3_:Object = SkinManager.getInfo(param1);
         return _loc3_[param2];
      }
      
      public static function setLock(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:Object = null;
         lockInfo = {};
         var _loc3_:uint = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            Utils.initObject(lockInfo,_loc4_.subtype_int,_loc4_.id_int,_loc4_.mode_int,_loc4_.value_int);
            lockInfo[_loc4_.subtype_int][_loc4_.id_int][_loc4_.mode_int][_loc4_.value_int] = _loc4_;
            _loc2_++;
         }
      }
      
      public static function getLock(param1:uint, param2:BodyPart, param3:uint, param4:uint) : Object
      {
         var _loc5_:String;
         if((_loc5_ = getIDByPart(param2,param3)) == null)
         {
            return null;
         }
         var _loc6_:String = (param1 + 1).toString();
         var _loc7_:String = param3.toString();
         var _loc8_:String = param4.toString();
         if(lockInfo != null && lockInfo[_loc6_] != null && lockInfo[_loc6_][_loc5_] != null && lockInfo[_loc6_][_loc5_][_loc7_] != null && lockInfo[_loc6_][_loc5_][_loc7_][_loc8_] != null)
         {
            return lockInfo[_loc6_][_loc5_][_loc7_][_loc8_];
         }
         return null;
      }
      
      static function simplifyPartName(param1:String) : String
      {
         var _loc2_:String = null;
         if(Utils.inArray(param1.substr(param1.length - 1,1),["1","2"]))
         {
            _loc2_ = param1.substr(0,param1.length - 1);
         }
         else
         {
            _loc2_ = param1;
         }
         if(Utils.inArray(_loc2_.substr(0,5),["upper","lower"]))
         {
            return _loc2_.substr(5).toLowerCase();
         }
         return _loc2_;
      }
      
      static function getIDByPart(param1:BodyPart, param2:uint) : String
      {
         var _loc3_:String = null;
         if(partMap == null)
         {
            partMap = {};
            for(partMap[partIDMap[_loc3_]] in partIDMap)
            {
            }
         }
         if(param1.getTargetName() == null)
         {
            return null;
         }
         return partMap[getBasePartName(param1.getTargetName())];
      }
      
      public static function getBasePartName(param1:String) : String
      {
         param1 = param1.replace(/[0-9]/,"");
         if(param1 == "hairBehind")
         {
            param1 = "hair";
         }
         else if(param1 == "collarBehind")
         {
            param1 = "collar";
         }
         else if(param1 == "capeBehind")
         {
            param1 = "cape";
         }
         else if(Utils.inArray(param1,["upperArm","lowerArm"]))
         {
            param1 = "arm";
         }
         else if(Utils.inArray(param1,["upperLeg","lowerLeg"]))
         {
            param1 = "leg";
         }
         return param1;
      }
      
      public static function alert() : void
      {
      }
      
      public function getBodyParts() : Array
      {
         return this.bodyParts;
      }
      
      public function resetHeadTurn() : void
      {
         if(this.skinInfo.turningParts != null)
         {
            this.setTurn(this.skinInfo.rootHeadPart,this.skinInfo.defTurn);
         }
      }
      
      private function saveLook(param1:String, param2:BodyPart) : void
      {
         if(VERBOSE)
         {
            Debug.trace("saveLook: " + param1 + ", " + param2);
         }
         this.bodyParts[map[this.skinType][param1]] = param2;
      }
      
      public function setTurn(param1:String, param2:int, param3:Boolean = true, param4:Boolean = false) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Number = NaN;
         var _loc10_:MovieClip = null;
         var _loc11_:* = undefined;
         var _loc6_:uint = this.skinInfo.numTurns;
         var _loc7_:* = false;
         if(this.skinInfo.turningParts[param1] != null)
         {
            _loc8_ = this.getTurn(param1);
            param2 = Utils.wrap(param2,_loc6_);
            _loc7_ = param2 != _loc8_;
            if(!(param3 && _loc8_ == param2))
            {
               _loc9_ = this.getRotation(this.target[param1]);
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  if((_loc10_ = this.turningMapMC[this.skinType][param1][_loc5_] as MovieClip).parent != null)
                  {
                     this.target.removeChild(_loc10_);
                  }
                  _loc5_++;
               }
               if(!this.isHidden(param1))
               {
                  this.target.addChild(MovieClip(this.turningMapMC[this.skinType][param1][param2]));
               }
               this.turnData[param1] = param2;
               this.target[param1] = this.turningMapMC[this.skinType][param1][param2];
               if(param3)
               {
                  this.saveLook(param1,new BodyPart(this.target[param1],this.skinType,this.getTurn(param1),this.getPart(param1),this._char));
               }
               this.setRotation(this.target[param1],_loc9_);
               this.target[param1].visible = true;
               if(param4)
               {
                  if(param1 == this.skinInfo.rootBodyPart)
                  {
                     this.setTurn("torso",param2);
                     this.setTurn(this.skinInfo.rootHeadPart,this.getTurn(this.skinInfo.rootHeadPart) + (param2 - _loc8_));
                  }
               }
            }
         }
         if(param3)
         {
            for each(_loc11_ in anchors[this.skinType][param1])
            {
               if(_loc11_ != this.skinInfo.rootHeadPart)
               {
                  this.setTurn(_loc11_,param2);
               }
            }
            if(param1 == this.skinInfo.rootHeadPart)
            {
               this.renderExtraLooksData();
               this.updateHairMask();
            }
         }
         return _loc7_;
      }
      
      public function getTurn(param1:String) : int
      {
         return this.turnData[param1];
      }
      
      public function shouldTurn(param1:String, param2:Point) : Boolean
      {
         var _loc3_:BodyPart = null;
         if(!this.isTurnable(param1))
         {
            return false;
         }
         _loc3_ = this.getPart(param1);
         return _loc3_.shouldTurn(param2);
      }
      
      public function isTurnable(param1:String) : Boolean
      {
         return turningMap[this.skinType] != null && turningMap[this.skinType][param1] != null && turningMap[this.skinType][param1].length > 1;
      }
      
      private function createEmpty(param1:MovieClip, param2:String = null) : MovieClip
      {
         var _loc3_:MovieClip = new MovieClip();
         param1.addChild(_loc3_);
         if(param2 != null)
         {
            param1.setChildIndex(_loc3_,param1.getChildIndex(param1[param2]));
         }
         return _loc3_;
      }
      
      public function updatePosition() : void
      {
         this.reposition(this.skinInfo.rootBodyPart);
      }
      
      private function updateYPosition() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         if(Main.isPregen)
         {
            return;
         }
         if(!Utils.inArray(this.skinType,[Globals.REDNOSE,Globals.GAIA]))
         {
            _loc1_ = this.target.getBounds(this.target);
            _loc2_ = -(_loc1_.y + _loc1_.height);
            for each(_loc3_ in this.skinInfo.parts)
            {
               if(!(_loc3_ == null || this.target[_loc3_].parent == null))
               {
                  this.target[_loc3_].y += _loc2_;
               }
            }
            if(this.target.drawing != null)
            {
               this.target.drawing.y += _loc2_;
            }
         }
      }
      
      public function hasColor(param1:uint) : Boolean
      {
         var _loc2_:String = null;
         if(this.skinInfo.colorParts == null || this.skinInfo.colorParts[param1] == null || this.skinInfo.colorParts[param1][0] == null)
         {
            return false;
         }
         if(param1 == Globals.GLOVE_COLOR)
         {
            return this.getGlovesType() != GLOVES_NONE || this.getShirtType() == SHIRT_SANTA || this.getPantsType() == PANTS_SANTA || this.getBeltType() == BELT_SANTA;
         }
         for each(_loc2_ in this.skinInfo.colorParts[param1][0])
         {
            if(!this.getPart(_loc2_).invisible)
            {
               return true;
            }
         }
         return false;
      }
      
      public function render() : void
      {
         var _loc1_:* = null;
         var _loc2_:Boolean = false;
         this.updateDepths();
         this.updateForeshortening(this.skinInfo.rootBodyPart,"torso");
         this.updateScale();
         if(this.headOnly)
         {
            this.reposition("neck");
         }
         else
         {
            this.updatePosition();
            this.setColor(Globals.SKIN_COLOR,this.colors[Globals.SKIN_COLOR]);
            this.setColor(Globals.SHIRT_COLOR,this.colors[Globals.SHIRT_COLOR]);
            this.setColor(Globals.SOCK_COLOR,this.colors[Globals.SOCK_COLOR]);
            this.setColor(Globals.ACCESSORY_COLOR,this.colors[Globals.ACCESSORY_COLOR]);
            if(Utils.inArray(this.skinType,[Globals.REDNOSE,Globals.GAIA]))
            {
               return;
            }
            if(!DRAWING_DISABLED)
            {
               if(this.biped)
               {
                  this.drawTorso(this.skinInfo.rootBodyPart);
               }
               else
               {
                  this.drawNeck();
               }
               this.drawArms();
               this.drawLegs();
            }
            if(this.skinInfo.lineParts != null)
            {
               for(_loc1_ in this.skinInfo.lineParts)
               {
                  _loc2_ = this.skinInfo.lineParts[_loc1_] == 1 ? true : false;
                  if(this.skinInfo.looksShirtsNone && Utils.inArray(this.getShirtType(),this.skinInfo.looksShirtsNone))
                  {
                     this.getPart(_loc1_).showSpecial(_loc2_);
                  }
                  else
                  {
                     this.getPart(_loc1_).showSpecial(!_loc2_);
                  }
               }
            }
         }
         this.drawHead();
         this.drawTextures();
         this.updateYPosition();
      }
      
      private function canConnectTorso() : Boolean
      {
         return CONNECT_TORSO && this.skinInfo.connectTorso == null;
      }
      
      private function canDrawOn(param1:String) : Boolean
      {
         switch(param1)
         {
            case "head":
               return this.skinInfo.drawHead == null;
            case "legs":
               return this.skinInfo.drawLegs == null;
            case "arms":
               return this.skinInfo.drawArms == null;
            case "neck":
               return this.skinInfo.drawNeck == null;
            case "torso":
         }
         return this.skinType != Globals.NICK_SB;
      }
      
      private function drawingDisabled() : Boolean
      {
         return DRAWING_DISABLED || this.skinInfo.drawing != null && this.skinInfo.drawing == false;
      }
      
      public function reposition(param1:String, param2:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:* = false;
         var _loc10_:* = undefined;
         var _loc11_:Number = NaN;
         var _loc12_:MovieClip = null;
         var _loc13_:MovieClip = null;
         var _loc3_:BodyPart = this.getPart(param1);
         if(Utils.startsWith(param1,"upper") || Utils.startsWith(param1,"lower"))
         {
            if(param2)
            {
               this.updateDepths();
            }
         }
         else if(Utils.startsWith(param1,"sock"))
         {
            this.setRotation(this.target[param1],this.getRotation(this.target["lowerLeg" + getSuffix(param1,true)]));
         }
         else if(param1 == "hairBehind")
         {
            if(_loc3_.isFixed())
            {
               this.setRotation(this.target[param1],this.getRotation(this.target["hair"]));
            }
         }
         if(!(param1 == "accessory" || param1 == this.skinInfo.rootHeadPart && Utils.inArray(this.skinType,[Globals.CARNIVORE,Globals.HOT_DOG,Globals.HORSE]) || Utils.startsWith(param1,"upperLeg") && this.biped && !Utils.inArray(this.getPantsType(),[SKIRT_SHORT]) || Utils.startsWith(param1,"lowerLeg") && this.biped && !Utils.inArray(this.getPantsType(),[])))
         {
            if(this.hasRotationConstraints(param1))
            {
               if(this.skinInfo.range[param1][0] is Array)
               {
                  _loc5_ = this.skinInfo.range[param1][1];
                  _loc6_ = this.skinInfo.range[param1][0][this.getTurn(param1) % this.skinInfo.range[param1][0].length][0];
                  _loc7_ = this.skinInfo.range[param1][0][this.getTurn(param1) % this.skinInfo.range[param1][0].length][1];
               }
               else if(this.skinInfo.range[param1].length > 2)
               {
                  _loc5_ = this.skinInfo.range[param1][2];
                  _loc6_ = this.skinInfo.range[param1][0];
                  _loc7_ = this.skinInfo.range[param1][1];
               }
               else
               {
                  _loc5_ = this.skinInfo.pivots[param1];
                  _loc6_ = this.skinInfo.range[param1][0];
                  _loc7_ = this.skinInfo.range[param1][1];
               }
               _loc8_ = Utils.normalizeAngle(this.getRotation(this.target[param1]) - this.getRotation(this.target[_loc5_]));
               if(_loc9_ = _loc6_ > _loc7_)
               {
                  _loc8_ = Utils.wrap(_loc8_);
                  _loc6_ = Utils.wrap(_loc6_);
                  _loc7_ = Utils.wrap(_loc7_);
               }
               if(_loc8_ < _loc6_)
               {
                  this.setRotation(this.target[param1],this.getRotation(this.target[_loc5_]) + _loc6_);
               }
               else if(_loc8_ > _loc7_)
               {
                  this.setRotation(this.target[param1],this.getRotation(this.target[_loc5_]) + _loc7_);
               }
            }
         }
         if(this.skinInfo.movableDependents != null && this.skinInfo.movableDependents[param1] != null)
         {
            for each(_loc10_ in this.skinInfo.movableDependents[param1])
            {
               if(!(getSuffix(_loc10_) == "2" && getSuffix(param1) != "2"))
               {
                  this.setRotation(this.target[_loc10_],this.getRotation(this.target[param1]));
                  if(this.skinInfo.flippedParts != null && this.skinInfo.flippedParts[_loc10_] != null)
                  {
                     this.setRotation(this.target[this.skinInfo.flippedParts[_loc10_]],this.getRotation(this.target[_loc10_]) + 180);
                  }
               }
            }
         }
         if(this.skinInfo.yOffset != null && this.skinInfo.yOffset[param1] != null && !(param1 == "beard" && this.isFullBeard()))
         {
            _loc3_.setYOff(this.getPart(this.skinInfo.yOffset[param1]).getYOffset());
         }
         if(anchors[this.skinType][param1] == null)
         {
            return;
         }
         for each(_loc4_ in anchors[this.skinType][param1])
         {
            if(pivotNames[this.skinType][_loc4_] is Array)
            {
               Utils.matchPosition(this.target[_loc4_],this.getPart(pivotNames[this.skinType][_loc4_][0]).getAnchor(pivotNames[this.skinType][_loc4_][1],true));
            }
            else
            {
               _loc11_ = 0;
               Utils.matchPosition(this.target[_loc4_],this.getPivot(param1,_loc4_));
               if(_loc4_.match(/^eyeShadow/))
               {
                  if((_loc12_ = this.getPart("eye" + getSuffix(_loc4_,true)).getAnchor("anchor0")) != null)
                  {
                     if((_loc13_ = this.getPart(_loc4_).getAnchor("movable")) != null)
                     {
                        _loc13_.y = _loc12_.y + 1.4;
                     }
                  }
               }
            }
            this.reposition(_loc4_);
         }
      }
      
      public function hasRotationConstraints(param1:String) : Boolean
      {
         return this.skinInfo.range != null && this.skinInfo.range[param1] != null;
      }
      
      private function getPivot(param1:String, param2:String) : DisplayObject
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:String = pivotNames[this.skinType][param2];
         if(this.target[param1][_loc3_] != null)
         {
            return this.target[param1][_loc3_];
         }
         if((_loc4_ = BodyPart(this.bodyParts[map[this.skinType][param1]]).getPivot(param2)) == null)
         {
            Debug.trace("MISSING pivot " + param2 + " on " + param1);
         }
         return _loc4_;
      }
      
      public function getMovableDependents(param1:String) : Array
      {
         if(this.skinInfo.movableDependents != null)
         {
            return this.skinInfo.movableDependents[param1];
         }
         return [];
      }
      
      public function blink() : void
      {
         var _loc1_:BodyPart = null;
         _loc1_ = this.getPart("eye1");
         if(_loc1_ != null)
         {
            _loc1_.expression = BLINK_EXPRESSION;
         }
         _loc1_ = this.getPart("eye2");
         if(_loc1_ != null)
         {
            _loc1_.expression = BLINK_EXPRESSION;
         }
      }
      
      public function speak(param1:Boolean = true) : void
      {
         var _loc2_:BodyPart = null;
         _loc2_ = this.getPart("mouth");
         if(_loc2_ != null)
         {
            if(param1)
            {
               if(this.skinInfo.speechExpressions == null)
               {
                  return;
               }
               _loc2_.expression = this.skinInfo.speechExpressions[Math.floor(Math.random() * this.skinInfo.speechExpressions.length)];
            }
            else
            {
               if(this.skinInfo.nonSpeechExpressions == null)
               {
                  return;
               }
               _loc2_.expression = this.skinInfo.nonSpeechExpressions[Math.floor(Math.random() * this.skinInfo.nonSpeechExpressions.length)];
            }
         }
      }
      
      public function isSpeaking(param1:Boolean = true) : Boolean
      {
         var _loc2_:BodyPart = null;
         _loc2_ = this.getPart("mouth");
         if(_loc2_ != null)
         {
            if(param1)
            {
               if(this.skinInfo.speechExpressions != null)
               {
                  if(Utils.inArray(_loc2_.expression,this.skinInfo.speechExpressions))
                  {
                     return true;
                  }
                  if(this.skinInfo.nonSpeechExpressions != null && !Utils.inArray(_loc2_.expression,this.skinInfo.nonSpeechExpressions))
                  {
                     return true;
                  }
               }
               return false;
            }
            if(this.skinInfo.nonSpeechExpressions != null)
            {
               if(Utils.inArray(_loc2_.expression,this.skinInfo.nonSpeechExpressions))
               {
                  return true;
               }
            }
            else if(this.skinInfo.speechExpressions != null && !Utils.inArray(_loc2_.expression,this.skinInfo.speechExpressions))
            {
               return true;
            }
            return false;
         }
         return true;
      }
      
      private function getFootFromSock(param1:int) : uint
      {
         return this.skinInfo.sockToFoot[param1];
      }
      
      private function getSockFromFoot(param1:int) : uint
      {
         return this.skinInfo.footToSock[param1];
      }
      
      private function isBootSock(param1:int) : Boolean
      {
         return this.skinInfo.sockToFoot && this.skinInfo.sockToFoot[param1] != null;
      }
      
      private function isBootShoe(param1:int) : Boolean
      {
         return this.skinInfo.footToSock && this.skinInfo.footToSock[param1] != null;
      }
      
      private function getShirtType() : int
      {
         var _loc1_:BodyPart = this.getPart("upperArm1");
         if(_loc1_ == null)
         {
            return -1;
         }
         return _loc1_.look;
      }
      
      private function getPantsType() : int
      {
         var _loc1_:BodyPart = this.getPart("upperLeg1");
         if(_loc1_ == null)
         {
            return -1;
         }
         return _loc1_.look;
      }
      
      private function getSocksType() : int
      {
         var _loc1_:BodyPart = this.getPart("sock1");
         if(_loc1_ == null)
         {
            return -1;
         }
         return _loc1_.look;
      }
      
      private function getGlovesType() : int
      {
         var _loc1_:BodyPart = this.getPart("hand1");
         if(_loc1_ == null)
         {
            return -1;
         }
         return _loc1_.look;
      }
      
      private function getBeltType() : int
      {
         var _loc1_:BodyPart = this.getPart("belt");
         if(_loc1_ == null)
         {
            return -1;
         }
         return _loc1_.look;
      }
      
      private function getShoesType() : int
      {
         var _loc1_:BodyPart = this.getPart("foot1");
         if(_loc1_ == null)
         {
            return -1;
         }
         return _loc1_.look;
      }
      
      private function drawTorso(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc11_:Boolean = false;
         var _loc12_:Graphics = null;
         var _loc13_:uint = 0;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Array = null;
         var _loc17_:uint = 0;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:DisplayObject = null;
         if(!this.canDrawOn("torso"))
         {
            return;
         }
         var _loc4_:String = "torso";
         var _loc5_:uint = this.getTurn(_loc4_);
         var _loc6_:Boolean = param1 != _loc4_ && this.canConnectTorso();
         var _loc10_:Object = {};
         _loc7_ = ["1","2"];
         if(this.legBehind == 2)
         {
            _loc7_.reverse();
         }
         if(DRAW_TORSO && !this.isSkirt() && this.canDrawOn("legs"))
         {
            for each(_loc9_ in _loc7_)
            {
               if(!this.isHidden("upperLeg" + _loc9_))
               {
                  this.drawJoint(_loc4_,"upperLeg",_loc9_,null,_loc10_[_loc4_ + "drawing"] == null,4);
                  _loc10_[_loc4_ + "drawing"] = true;
               }
            }
         }
         if(_loc10_[_loc4_ + "drawing"] == null)
         {
            this.getDrawing(_loc4_).graphics.clear();
         }
         _loc7_ = ["1","2"];
         _loc5_ = this.getTurn(param1);
         if(DRAW_TORSO)
         {
            for each(_loc9_ in _loc7_)
            {
               if(!this.isHidden("upperArm" + _loc9_))
               {
                  _loc8_ = this.skinType == Globals.MARVEL2 && _loc9_ == "2" ? uint(2) : uint(0);
                  this.drawJoint(param1,"upperArm",_loc9_,null,_loc10_[param1 + "drawing" + (_loc8_ == 0 ? "" : _loc8_)] == null,0,_loc8_);
                  _loc10_[param1 + "drawing"] = true;
               }
            }
         }
         this.getPart("upperArm" + this.normalizeSuffix("1")).showSpecial(false);
         this.getPart("upperArm" + this.normalizeSuffix("2")).showSpecial(false);
         if(_loc6_)
         {
            _loc11_ = this.isConnectingBelt();
            _loc12_ = this.getDrawing(param1).graphics;
            if(this.skinInfo.torsoColor != null)
            {
               _loc13_ = this.skinInfo.torsoColor;
            }
            else if(this.skinType == Globals.MARVEL)
            {
               _loc13_ = Globals.ACCESSORY_COLOR;
            }
            else if(this.skinType == Globals.MARVEL2)
            {
               _loc13_ = Globals.PANT_COLOR;
            }
            else if(this.skinInfo.looksShirtsNone && Utils.inArray(this.getShirtType(),this.skinInfo.looksShirtsNone))
            {
               _loc13_ = Globals.SKIN_COLOR;
            }
            else
            {
               _loc13_ = Globals.SHIRT_COLOR;
            }
            _loc14_ = !!TESTING_JOINTS ? Number(65280) : Number(Palette.rgb2hex(Palette.getColor(this.colors[_loc13_])));
            _loc15_ = !!TESTING_JOINTS ? Number(Globals.HIGHLIGHTING_ALPHA) : Number(1);
            _loc16_ = [];
            _loc17_ = this.getTurn(param1);
            if(_loc10_[param1 + "drawing"] == null)
            {
               _loc12_.clear();
            }
            _loc12_.beginFill(_loc14_,_loc15_);
            if(_loc11_)
            {
               _loc16_[0] = this.getAnchor("belt","anchor" + (_loc17_ == TURNED_AWAY ? "1" : "0"),param1);
               _loc16_[1] = this.getAnchor("belt","anchor" + (_loc17_ == TURNED_AWAY ? "0" : "1"),param1);
               _loc16_[2] = this.getAnchor(param1,"anchor4");
               _loc16_[3] = this.getAnchor(param1,"anchor5");
               this.setLine(_loc12_,0);
               this.drawLine(_loc12_,_loc16_[0],false);
               this.drawLine(_loc12_,_loc16_[2],true);
               this.setLine(_loc12_);
               this.drawLine(_loc12_,_loc16_[3]);
               this.setLine(_loc12_,0);
               this.drawLine(_loc12_,_loc16_[1]);
               this.setLine(_loc12_);
               this.drawLine(_loc12_,_loc16_[0]);
            }
            else
            {
               _loc16_[0] = this.getAnchor(_loc4_,"anchor0",param1);
               _loc16_[1] = this.getAnchor(_loc4_,"anchor1",param1);
               _loc18_ = this.angleBetween(param1,_loc4_);
               if(_loc17_ > TURNED_AWAY)
               {
                  _loc18_ *= -1;
               }
               if(_loc18_ == 0)
               {
                  _loc16_[2] = this.getAnchor(param1,"anchor6");
                  _loc16_[3] = this.getAnchor(param1,"anchor7");
               }
               else if(_loc18_ > 0)
               {
                  _loc16_[2] = this.getAnchor(_loc4_,"anchor2",param1);
                  _loc16_[3] = this.getAnchor(param1,"anchor7");
               }
               else
               {
                  _loc16_[2] = this.getAnchor(param1,"anchor6");
                  _loc16_[3] = this.getAnchor(_loc4_,"anchor3",param1);
               }
               _loc16_[4] = this.getAnchor(param1,"anchor4");
               _loc16_[5] = this.getAnchor(param1,"anchor5");
               _loc16_[6] = this.getAnchor(_loc4_,"anchor6",param1);
               this.setLine(_loc12_,0);
               this.drawLine(_loc12_,_loc16_[0],false);
               this.drawLine(_loc12_,_loc16_[4],true,_loc16_[2]);
               this.setLine(_loc12_);
               this.drawLine(_loc12_,_loc16_[5]);
               this.setLine(_loc12_,0);
               this.drawLine(_loc12_,_loc16_[1],true,_loc16_[3]);
               if(_loc16_[6] != null)
               {
                  this.drawLine(_loc12_,_loc16_[6]);
               }
               this.setLine(_loc12_);
               this.drawLine(_loc12_,_loc16_[0]);
            }
            _loc12_.endFill();
            if(this.skinType == Globals.MARVEL2)
            {
               _loc13_ = Globals.SHIRT_COLOR;
               _loc14_ = Palette.rgb2hex(Palette.getColor(this.colors[_loc13_]));
               _loc19_ = 0.5;
               (_loc20_ = this.getDrawing(param1,3)).scaleX = _loc19_;
               _loc20_.scaleY = _loc20_.scaleX;
               (_loc12_ = MovieClip(_loc20_).graphics).clear();
               _loc12_.beginFill(_loc14_);
               _loc16_[0] = this.getAnchor(param1,"anchor0_2");
               _loc16_[1] = this.getAnchor(param1,"anchor1_2");
               _loc16_[2] = this.getAnchor(_loc4_,"anchor1_2",param1);
               _loc16_[3] = this.getAnchor(_loc4_,"anchor0_2",param1);
               this.setLine(_loc12_,0,1);
               this.drawLine(_loc12_,_loc16_[0],false,null,_loc19_);
               this.drawLine(_loc12_,_loc16_[3],true,null,_loc19_);
               this.setLine(_loc12_);
               this.drawLine(_loc12_,_loc16_[2],true,null,_loc19_);
               this.setLine(_loc12_,0,1);
               this.drawLine(_loc12_,_loc16_[1],true,null,_loc19_);
               this.setLine(_loc12_);
               this.drawLine(_loc12_,_loc16_[0],true,null,_loc19_);
               _loc12_.endFill();
            }
         }
      }
      
      private function setLine(param1:Graphics, param2:* = null, param3:Number = 1, param4:Number = -1) : void
      {
         if(param3 == 1)
         {
            param3 = this.skinInfo.lineAlpha;
         }
         if(param4 == -1)
         {
            param4 = this.skinInfo.lineSize;
         }
         if(param2 == null)
         {
            param1.lineStyle();
         }
         else
         {
            param1.lineStyle(param4,param2,param3 * Asset.lineAlpha,false,this.skinInfo.lineScaleMode);
         }
      }
      
      private function getAnchor(param1:String, param2:String, param3:* = null) : Object
      {
         var _loc4_:Object = null;
         if(param3 == null)
         {
            param3 = param1;
         }
         var _loc5_:MovieClip;
         if((_loc5_ = this.getPart(param1).getAnchor(param2)) != null)
         {
            if(param3 is MovieClip)
            {
               _loc4_ = Utils.getPosition(_loc5_,param3);
            }
            else
            {
               _loc4_ = Utils.getPosition(_loc5_,this.target[param3]);
            }
         }
         if(VERBOSE)
         {
            Debug.trace("getAnchor: " + param1 + ", " + param2 + ": " + _loc4_);
         }
         return _loc4_;
      }
      
      private function isLongBelt() : Boolean
      {
         return this.partExists("belt") && Utils.inArray(this.getPart("belt").look,this.skinInfo.looksBeltsLong);
      }
      
      private function isBeltExt() : Boolean
      {
         return this.partExists("belt") && Utils.inArray(this.getPart("belt").look,this.skinInfo.looksBeltsExt);
      }
      
      private function isConnectingBelt() : Boolean
      {
         return this.partExists("belt") && this.getPart("belt").getAnchor("anchor0") != null;
      }
      
      private function isFullBeard() : Boolean
      {
         var _loc1_:BodyPart = this.getPart("beard");
         if(_loc1_ == null)
         {
            return false;
         }
         return Utils.inArray(_loc1_.look,this.skinInfo.looksBeardsFull);
      }
      
      private function drawHead() : void
      {
         if(!DRAW_HEAD || DRAWING_DISABLED || !this.canDrawOn("head"))
         {
            return;
         }
         if(this.isHuman())
         {
            if(this.partExists("neck") && !this.isHidden("neck"))
            {
               this.drawConnection("neck","head","neck");
            }
            if(this.partExists("chin"))
            {
               this.drawConnection("head","chin","chin");
            }
            if(this.partExists("neck") && this.partExists("collar"))
            {
               this.drawCollarNeck();
            }
         }
      }
      
      private function drawConnection(param1:String, param2:String, param3:String) : void
      {
         var _loc9_:Object = null;
         var _loc4_:Graphics = this.getDrawing(param3).graphics;
         var _loc5_:uint = param1 == "neck" && this.skinType == Globals.MARVEL || this.skinType == Globals.MARVEL2 ? uint(Globals.SHIRT_COLOR) : uint(Globals.SKIN_COLOR);
         var _loc6_:Number = Palette.rgb2hex(Palette.getColor(this.colors[_loc5_]));
         var _loc7_:Array = [];
         var _loc8_:uint = this.getTurn(this.skinInfo.rootHeadPart);
         _loc4_.clear();
         _loc7_[0] = this.getAnchor(param2,"anchor4",param3);
         _loc7_[1] = this.getAnchor(param2,"anchor5",param3);
         if(_loc7_[0] == null)
         {
            return;
         }
         _loc7_[2] = this.getAnchor(param1,"anchor0",param3);
         _loc7_[3] = this.getAnchor(param1,"anchor1",param3);
         if(param1 == "neck" && _loc8_ >= TURNED_AWAY || param1 == "head" && _loc8_ == TURNED_AWAY)
         {
            _loc9_ = _loc7_[2];
            _loc7_[2] = _loc7_[3];
            _loc7_[3] = _loc9_;
         }
         _loc4_.beginFill(_loc6_);
         this.drawLine(_loc4_,_loc7_[0],false);
         if(param1 == "head" && Utils.inArray(_loc8_,[1,2,4,5]))
         {
            this.setLine(_loc4_);
         }
         else
         {
            this.setLine(_loc4_,0);
         }
         this.drawLine(_loc4_,_loc7_[2]);
         this.setLine(_loc4_);
         this.drawLine(_loc4_,_loc7_[3]);
         this.setLine(_loc4_,0);
         this.drawLine(_loc4_,_loc7_[1]);
         this.setLine(_loc4_);
         this.drawLine(_loc4_,_loc7_[0]);
         _loc4_.endFill();
      }
      
      private function drawCollarNeck() : void
      {
         var _loc6_:uint = 0;
         if(!DRAW_NECK || !this.partExists("collar"))
         {
            return;
         }
         var _loc1_:String = "collar";
         var _loc2_:String = "neck";
         var _loc3_:Graphics = this.getDrawing(_loc1_).graphics;
         var _loc4_:Array = [];
         if(this.target[_loc1_] && this.target[_loc1_]["drawing"])
         {
            this.target[_loc1_]["drawing"].graphics.clear();
         }
         _loc3_.clear();
         var _loc5_:Number = Palette.rgb2hex(Palette.getColor(this.colors[Globals.SKIN_COLOR]));
         _loc4_[0] = this.getAnchor(_loc1_,"anchor0");
         if(_loc4_[0] != null)
         {
            _loc4_[1] = this.getAnchor(_loc1_,"anchor1");
            _loc4_[2] = this.getAnchor(_loc2_,"anchor2",_loc1_);
            _loc4_[3] = this.getAnchor(_loc2_,"anchor3",_loc1_);
            if((_loc6_ = this.getTurn(this.skinInfo.rootBodyPart)) > TURNED_AWAY)
            {
               _loc4_[4] = _loc4_[2];
               _loc4_[2] = _loc4_[3];
               _loc4_[3] = _loc4_[4];
            }
            _loc3_.beginFill(_loc5_);
            this.setLine(_loc3_,0);
            this.drawLine(_loc3_,_loc4_[0],false);
            this.drawLine(_loc3_,_loc4_[2]);
            this.setLine(_loc3_);
            this.drawLine(_loc3_,_loc4_[3]);
            this.setLine(_loc3_,0);
            this.drawLine(_loc3_,_loc4_[1]);
            this.setLine(_loc3_);
            this.drawLine(_loc3_,_loc4_[0]);
            _loc3_.endFill();
         }
         _loc2_ = "torso";
         _loc4_[4] = this.getAnchor(_loc1_,"anchor9");
         _loc4_[5] = this.getAnchor(_loc2_,"anchor9",_loc1_);
         if(_loc4_[4] != null && _loc4_[5] != null)
         {
            this.setLine(_loc3_,0,0.4);
            this.drawLine(_loc3_,_loc4_[4],false);
            this.drawLine(_loc3_,_loc4_[5]);
            if(this.isConnectingBelt())
            {
               _loc2_ = "belt";
               _loc4_[6] = this.getAnchor(_loc2_,"anchor2",_loc1_);
               if(_loc4_[6] != null)
               {
                  this.drawLine(_loc3_,_loc4_[6]);
               }
            }
         }
      }
      
      private function drawArms() : void
      {
         if(!DRAW_ARMS || !this.canDrawOn("arms"))
         {
            return;
         }
         if(!DRAW_ONE_SIDE)
         {
            this.drawArm("1");
         }
         this.drawArm("2");
      }
      
      private function drawArm(param1:String) : void
      {
         if(this.isHidden("upperArm" + param1))
         {
            return;
         }
         if(this.isCurve("upperArm" + param1))
         {
            this.drawCurve("upperArm" + param1);
         }
         else
         {
            if(!DRAW_HAND_FOOT_ONLY)
            {
               this.drawJoint("upperArm","lowerArm",param1);
            }
            if(!DRAW_ELBOW_KNEE_ONLY)
            {
               this.drawJoint("lowerArm","hand",param1);
            }
         }
      }
      
      private function drawCurve(param1:String) : void
      {
         var _loc2_:Array = this.skinInfo.bendy.parts[param1];
         var _loc3_:BodyPart = this.getPart(param1);
         if(_loc3_ == null || _loc3_.target == null)
         {
            return;
         }
         var _loc4_:MovieClip;
         var _loc5_:Graphics = (_loc4_ = _loc3_.target).graphics;
         var _loc6_:Number;
         var _loc7_:Number = (_loc6_ = Math.abs(this.angleBetween(param1,_loc2_[0]))) / 180;
         var _loc8_:Array;
         (_loc8_ = [])[0] = new Point(0,0);
         _loc8_[2] = Utils.getLocation(this.getPart(_loc2_[0]).target,_loc4_);
         _loc8_[4] = Utils.getLocation(this.getPart(_loc2_[1]).target,_loc4_);
         _loc8_[1] = new Point(_loc8_[0].x + (_loc8_[2].x - _loc8_[0].x) * (1 - _loc7_),_loc8_[0].y + (_loc8_[2].y - _loc8_[0].y) * (1 - _loc7_));
         _loc8_[3] = new Point(_loc8_[2].x + (_loc8_[4].x - _loc8_[2].x) * (1 - _loc7_),_loc8_[2].y + (_loc8_[4].y - _loc8_[2].y) * (1 - _loc7_));
         _loc5_.clear();
         _loc5_.lineStyle(this.skinInfo.bendy.thickness,0,1,false,this.skinInfo.lineScaleMode);
         _loc5_.moveTo(_loc8_[0].x,_loc8_[0].y);
         _loc5_.lineTo(_loc8_[1].x,_loc8_[1].y);
         _loc5_.curveTo(_loc8_[2].x,_loc8_[2].y,_loc8_[3].x,_loc8_[3].y);
         _loc5_.lineTo(_loc8_[4].x,_loc8_[4].y);
      }
      
      private function drawJoint(param1:String, param2:String, param3:String = "", param4:String = null, param5:Boolean = true, param6:uint = 0, param7:uint = 0) : void
      {
         var _loc13_:Graphics = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:* = false;
         var _loc19_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:String = null;
         var _loc25_:Object = null;
         var _loc26_:uint = 0;
         var _loc27_:Boolean = false;
         var _loc28_:* = false;
         var _loc29_:Number = NaN;
         var _loc30_:Object = null;
         var _loc31_:Object = null;
         var _loc32_:Object = null;
         var _loc33_:Object = null;
         var _loc34_:Object = null;
         var _loc35_:Boolean = false;
         var _loc36_:Boolean = false;
         var _loc37_:Object = null;
         param3 = this.normalizeSuffix(param3);
         if(VERBOSE)
         {
            Debug.trace(param1 + " -> " + param2 + param3 + "; " + param4 + "; " + param5 + "; " + param6 + "; " + param7);
         }
         var _loc8_:Boolean = param1 == "torso" || param1 == "ribs";
         var _loc9_:* = param1 == "neck";
         var _loc10_:String = !!_loc8_ ? param1 : param1 + param3;
         var _loc11_:String = param2 + param3;
         if(param4 == null)
         {
            param4 = _loc10_;
         }
         if(this.target[param4] == null)
         {
            if(VERBOSE)
            {
               Debug.trace("no drawing");
            }
            return;
         }
         var _loc12_:Array = [];
         var _loc14_:Number = !!TESTING_JOINTS ? Number(Globals.HIGHLIGHTING_ALPHA) : Number(1);
         var _loc20_:Number = Math.pow(this.skinInfo.curveParts[param2] == null ? Number(this.skinInfo.curviness) : Number(this.skinInfo.curveParts[param2]),2);
         var _loc21_:Number = 0.5 * _loc20_;
         var _loc22_:Number = 0.5 * _loc20_;
         _loc13_ = this.getDrawing(param4,param7).graphics;
         if(param5)
         {
            _loc24_ = "drawing" + (param7 == 0 ? "" : param7);
            if(this.target[param4] && this.target[param4][_loc24_])
            {
               this.target[param4][_loc24_].graphics.clear();
            }
            _loc13_.clear();
         }
         if(param2 == "sock")
         {
            if(!this.isBootSock(this.getSocksType()))
            {
               return;
            }
         }
         _loc23_ = this.getTurn(_loc10_);
         if(this.biped)
         {
            if(this.skinType == Globals.MARVEL2)
            {
               if(param2 == "lowerLeg" || param2 == "upperLeg" || param2 == "lowerArm")
               {
                  _loc19_ = Globals.PANT_COLOR;
               }
               else
               {
                  _loc19_ = Globals.SHIRT_COLOR;
               }
            }
            else if(param2 == "upperArm" && this.skinInfo.looksShirtsNone && Utils.inArray(this.getShirtType(),this.skinInfo.looksShirtsNone) || param2 == "lowerArm" && !this.hasLongSleeves() || param2 == "hand" || param2 == "lowerLeg" && this.bareKnees())
            {
               if(param2 == "hand" && (this.skinType == Globals.MARVEL || this.getPart("hand1").look != GLOVES_NONE && !this.bareWrists()))
               {
                  _loc19_ = Globals.GLOVE_COLOR;
               }
               else
               {
                  _loc19_ = Globals.SKIN_COLOR;
               }
            }
            else if(param2 == "upperLeg" || param2 == "lowerLeg")
            {
               if(param2 == "lowerLeg" && this.skinInfo.looksPantsKneeColor && this.skinInfo.looksPantsKneeColor[this.getPantsType()] != null)
               {
                  _loc19_ = this.skinInfo.looksPantsKneeColor[this.getPantsType()];
               }
               else
               {
                  _loc19_ = Globals.PANT_COLOR;
               }
            }
            else if(param2 == "foot")
            {
               if(this.skinType == Globals.MARVEL)
               {
                  _loc19_ = Globals.SHOE_COLOR;
               }
               else if(this.skinType == Globals.MARVEL2)
               {
                  _loc19_ = Globals.SHIRT_COLOR;
               }
               else if(this.skinType == Globals.KINECTION)
               {
                  _loc19_ = Globals.SHOE_COLOR;
               }
               else
               {
                  _loc19_ = this.getFootColor();
               }
            }
            else if(param2 == "sock")
            {
               _loc19_ = Globals.SHOE_COLOR;
            }
            else if(param2 == "lowerArm" && this.skinType == Globals.MARVEL)
            {
               _loc19_ = Globals.ACCESSORY_COLOR;
            }
            else if(this.skinType == Globals.MARVEL2)
            {
               _loc19_ = Globals.SHIRT_COLOR;
            }
            else if(param2 == "lowerArm" && this.skinInfo.looksShirtsElbowColor && this.skinInfo.looksShirtsElbowColor[this.getShirtType()] != null)
            {
               _loc19_ = this.skinInfo.looksShirtsElbowColor[this.getShirtType()];
            }
            else
            {
               _loc19_ = Globals.SHIRT_COLOR;
            }
         }
         else if(Utils.inArray(this.skinType,[Globals.CARNIVORE,Globals.HOT_DOG]))
         {
            _loc19_ = Globals.HAIR_COLOR;
         }
         else if(this.skinType == Globals.BIRD)
         {
            if(param2 == "lowerLeg" || param2 == "foot")
            {
               _loc19_ = Globals.SHOE_COLOR;
            }
            else
            {
               _loc19_ = Globals.SKIN_COLOR;
            }
         }
         else
         {
            _loc19_ = Globals.SKIN_COLOR;
         }
         if(TESTING_JOINTS)
         {
            _loc15_ = 65280;
            this.target[_loc10_].alpha = Globals.HIGHLIGHTING_ALPHA;
            this.target[_loc11_].alpha = Globals.HIGHLIGHTING_ALPHA;
         }
         else
         {
            _loc15_ = Palette.rgb2hex(Palette.getColor(this.colors[_loc19_]));
         }
         if(VERBOSE_DRAWING)
         {
            Debug.trace(this.skinType + " drawJoint " + param1 + " -> " + param2 + param3 + ": color=" + _loc19_ + ", offset=" + param6);
         }
         _loc12_[0] = this.getAnchor(_loc10_,"anchor" + (0 + param6),param4);
         _loc12_[1] = this.getAnchor(_loc10_,"anchor" + (1 + param6),param4);
         _loc12_[2] = this.getAnchor(_loc10_,"anchor" + (2 + param6),param4);
         _loc12_[3] = this.getAnchor(_loc10_,"anchor" + (3 + param6),param4);
         _loc12_[4] = this.getAnchor(_loc11_,"anchor0",param4);
         _loc12_[5] = this.getAnchor(_loc11_,"anchor1",param4);
         _loc12_[6] = this.getAnchor(_loc11_,"anchor2",param4);
         _loc12_[7] = this.getAnchor(_loc11_,"anchor3",param4);
         _loc12_[8] = this.getAnchor(_loc10_,"anchor" + (4 + param6),param4);
         _loc12_[9] = this.getAnchor(_loc10_,"anchor" + (5 + param6),param4);
         _loc16_ = this.angleBetween(_loc10_,param2,param3);
         if(VERBOSE_DRAWING)
         {
            Debug.trace("angle: " + _loc16_);
         }
         _loc17_ = Utils.wrap(_loc16_);
         if(VERBOSE_DRAWING)
         {
            Debug.trace(_loc12_.join(", "));
         }
         if(_loc12_[4] != null && _loc12_[5] != null)
         {
            if(VERBOSE_DRAWING)
            {
               Debug.trace("1");
            }
            _loc13_.beginFill(_loc15_,_loc14_);
            this.setLine(_loc13_);
            if(_loc8_ || _loc9_)
            {
               if(VERBOSE_DRAWING)
               {
                  Debug.trace("1a");
               }
               _loc26_ = 0;
               if(_loc8_)
               {
                  _loc26_ = Number(param3) - 1;
                  if(_loc23_ >= TURNED_AWAY)
                  {
                     _loc26_ = 1 - _loc26_;
                  }
               }
               _loc27_ = false;
               _loc28_ = true;
               _loc29_ = 0.5 * _loc20_;
               if(this.biped && param2 == "upperLeg")
               {
                  _loc18_ = Boolean(this.getPart(_loc11_).flippedX);
                  _loc29_ = (0.2 + (this.scaleW - this.minWidth) / (this.maxWidth - this.minWidth) * 0.4) * _loc20_;
                  _loc21_ = Math.pow((90 - _loc16_) / 180,2) * 0.25 * _loc20_;
                  _loc22_ = Math.abs(_loc16_ / 90) * 0.25 * _loc20_;
               }
               else if(this.biped && param2 == "upperArm")
               {
                  if(VERBOSE_DRAWING)
                  {
                     Debug.trace("1a1");
                  }
                  _loc37_ = Utils.getIntersection2(_loc12_[_loc26_],_loc12_[5],_loc12_[4],_loc12_[2 + _loc26_]);
                  if(VERBOSE_DRAWING)
                  {
                     Debug.trace("crossed: Utils.getIntersection2(" + this.tracePoint(_loc12_[_loc26_]) + ", " + this.tracePoint(_loc12_[5]) + ", " + this.tracePoint(_loc12_[4]) + ", " + this.tracePoint(_loc12_[2 + _loc26_]) + " -> " + _loc37_);
                  }
                  _loc27_ = _loc18_ = _loc37_ != null;
                  _loc28_ = true;
                  if(this.minWidth == this.maxWidth)
                  {
                     _loc21_ = 0.6 * _loc20_;
                     _loc22_ = 0;
                  }
                  else
                  {
                     _loc21_ = (0.2 + (this.scaleW - this.minWidth) / (this.maxWidth - this.minWidth) * 0.3) * _loc20_;
                     if(_loc17_ < 45)
                     {
                        _loc22_ = 0;
                     }
                     else if(_loc17_ < 135)
                     {
                        _loc22_ = (-Math.abs(_loc17_ - 90) + 45) / 45 * -0.3 * _loc20_;
                     }
                     else
                     {
                        _loc22_ = (-Math.abs(_loc17_ - 225) + 90) / 90 * 0.6 * _loc20_;
                        if(_loc17_ > 225)
                        {
                           _loc21_ = (0.3 + (360 - _loc17_) / (360 - 225) * 0.4) * _loc20_;
                        }
                     }
                  }
               }
               else if(_loc9_)
               {
                  _loc22_ = _loc21_ = 0.3 * _loc20_;
               }
               if(_loc18_)
               {
                  _loc31_ = _loc12_[4];
                  _loc32_ = _loc12_[5];
                  _loc33_ = _loc12_[6];
                  _loc34_ = _loc12_[7];
               }
               else
               {
                  _loc31_ = _loc12_[5];
                  _loc32_ = _loc12_[4];
                  _loc33_ = _loc12_[7];
                  _loc34_ = _loc12_[6];
               }
               if(VERBOSE_DRAWING)
               {
                  Debug.trace("points (inverted=" + _loc18_ + ": " + this.tracePoint(_loc31_) + ", " + this.tracePoint(_loc32_) + ", " + this.tracePoint(_loc33_) + ", " + this.tracePoint(_loc34_));
               }
               if(_loc9_)
               {
                  if(this.biped)
                  {
                     _loc35_ = false;
                     _loc36_ = false;
                  }
                  else
                  {
                     _loc12_[8] = this.getAnchor(_loc10_,"anchor0",_loc11_);
                     _loc12_[9] = this.getAnchor(_loc10_,"anchor2",_loc11_);
                     _loc35_ = this.pointInside(_loc12_[8],_loc11_);
                     _loc36_ = this.pointInside(_loc12_[9],_loc11_);
                  }
               }
               else
               {
                  if(VERBOSE_DRAWING)
                  {
                     Debug.trace("1b");
                  }
                  _loc35_ = this.pointInside(_loc31_,_loc10_);
                  _loc36_ = this.pointInside(_loc32_,_loc10_);
                  if(VERBOSE_DRAWING)
                  {
                     Debug.trace("inside2: " + _loc36_ + " = pointInside(" + this.tracePoint(_loc32_) + ", " + _loc10_ + ")");
                  }
               }
               if(this.biped && param2 == "upperLeg")
               {
                  _loc28_ = !(_loc27_ = !_loc35_ && !_loc36_ && param2 == "upperLeg" && _loc16_ < -120);
               }
               if(_loc27_)
               {
                  if(VERBOSE_DRAWING)
                  {
                     Debug.trace("1c");
                  }
                  _loc25_ = Utils.getControlPoint(_loc31_,_loc32_,_loc12_[_loc26_],_loc29_);
                  this.drawLine(_loc13_,_loc31_,false);
                  this.setLine(_loc13_,0);
                  this.drawLine(_loc13_,_loc32_,true,_loc25_);
                  this.setLine(_loc13_);
                  this.drawLine(_loc13_,_loc31_);
               }
               if(_loc28_)
               {
                  if(VERBOSE_DRAWING)
                  {
                     Debug.trace("1d");
                  }
                  if(_loc35_)
                  {
                     if(VERBOSE_DRAWING)
                     {
                        Debug.trace("1d1");
                     }
                     _loc30_ = _loc31_;
                     this.drawLine(_loc13_,_loc31_,false);
                  }
                  else
                  {
                     _loc30_ = _loc12_[_loc26_];
                     this.drawLine(_loc13_,_loc12_[_loc26_],false);
                     this.setLine(_loc13_,0);
                     _loc25_ = Utils.getControlPoint(_loc12_[_loc26_],_loc31_,_loc12_[2 + _loc26_],_loc21_);
                     if(VERBOSE_DRAWING)
                     {
                        Debug.trace("1d2: a[" + _loc26_ + "]=" + this.tracePoint(_loc12_[_loc26_]) + ", p1=" + this.tracePoint(_loc31_) + ", a[2+" + _loc26_ + "]=" + this.tracePoint(_loc12_[2 + _loc26_]) + ", curveFactor1=" + _loc21_ + ", cp=" + this.tracePoint(_loc25_));
                     }
                     this.drawLine(_loc13_,_loc31_,true,_loc25_);
                  }
                  this.setLine(_loc13_);
                  this.drawLine(_loc13_,_loc32_);
                  _loc25_ = Utils.getControlPoint(_loc32_,_loc12_[2 + _loc26_],_loc12_[_loc26_],_loc22_);
                  if(_loc36_)
                  {
                     if(VERBOSE_DRAWING)
                     {
                        Debug.trace("1d3");
                     }
                     this.drawLine(_loc13_,_loc30_);
                  }
                  else
                  {
                     this.setLine(_loc13_,0);
                     this.drawLine(_loc13_,_loc12_[2 + _loc26_],true,_loc25_);
                     if(VERBOSE_DRAWING)
                     {
                        Debug.trace("1d4: a[2+" + _loc26_ + "]=" + this.tracePoint(_loc12_[2 + _loc26_]) + ", " + this.tracePoint(_loc25_));
                     }
                     this.setLine(_loc13_);
                     this.drawLine(_loc13_,_loc30_);
                  }
               }
            }
            else if(_loc12_[3] != null)
            {
               if((_loc18_ = this.getPart(_loc10_).flippedX != this.getPart(_loc11_).flippedX) && param2 != FOOT || param2 == "sock")
               {
                  _loc31_ = _loc12_[4];
                  _loc32_ = _loc12_[5];
                  _loc33_ = _loc12_[6];
                  _loc34_ = _loc12_[7];
               }
               else
               {
                  _loc31_ = _loc12_[5];
                  _loc32_ = _loc12_[4];
                  _loc33_ = _loc12_[7];
                  _loc34_ = _loc12_[6];
               }
               if(VERBOSE_DRAWING)
               {
                  Debug.trace("2");
               }
               this.drawLine(_loc13_,_loc12_[3],false);
               if(_loc12_[8] != null)
               {
                  if(VERBOSE_DRAWING)
                  {
                     Debug.trace("2a");
                  }
                  this.drawLine(_loc13_,_loc12_[2]);
                  this.setLine(_loc13_,0);
                  if(this.biped && param2 == "hand" && this.getPart(_loc11_).expression % 2 == 0)
                  {
                     _loc12_[10] = _loc32_;
                     _loc12_[11] = _loc31_;
                  }
                  else
                  {
                     _loc12_[10] = _loc31_;
                     _loc12_[11] = _loc32_;
                  }
                  if(_loc16_ < 0)
                  {
                     this.drawLine(_loc13_,_loc12_[10],true,_loc12_[8]);
                  }
                  else
                  {
                     this.drawLine(_loc13_,_loc12_[10]);
                  }
                  if(this.skinType == Globals.HUMAN && param2 == "hand" && this.bareWrists() && this.getGlovesType() != GLOVES_NONE)
                  {
                     this.setLine(_loc13_,0);
                  }
                  else
                  {
                     this.setLine(_loc13_);
                  }
                  this.drawLine(_loc13_,_loc12_[11]);
                  this.setLine(_loc13_,0);
                  if(_loc16_ < 0)
                  {
                     this.drawLine(_loc13_,_loc12_[3]);
                  }
                  else
                  {
                     this.drawLine(_loc13_,_loc12_[3],true,_loc12_[9]);
                  }
               }
               else if(_loc34_ == null)
               {
                  if(VERBOSE_DRAWING)
                  {
                     Debug.trace("2b");
                  }
                  this.drawLine(_loc13_,_loc12_[2]);
                  this.setLine(_loc13_,0);
                  _loc21_ = 0.1 * _loc20_;
                  if(_loc18_ = Boolean(this.biped && param2 == "hand" && this.getPart(_loc11_).expression % 2 == 0))
                  {
                     _loc25_ = Utils.getControlPoint(_loc12_[2],_loc32_,_loc12_[3],_loc21_);
                     this.drawLine(_loc13_,_loc32_,true,_loc25_);
                     if(param2 == "hand" && this.bareWrists() && this.getGlovesType() != GLOVES_NONE)
                     {
                        this.setLine(_loc13_,0);
                     }
                     else
                     {
                        this.setLine(_loc13_);
                     }
                     this.drawLine(_loc13_,_loc31_);
                     _loc25_ = Utils.getControlPoint(_loc31_,_loc12_[3],_loc12_[2],_loc21_);
                  }
                  else
                  {
                     _loc25_ = Utils.getControlPoint(_loc12_[2],_loc31_,_loc12_[3],_loc21_);
                     this.drawLine(_loc13_,_loc31_,true,_loc25_);
                     if(param2 == "hand" && this.bareWrists() && this.getGlovesType() != GLOVES_NONE)
                     {
                        this.setLine(_loc13_,0);
                     }
                     else
                     {
                        this.setLine(_loc13_);
                     }
                     this.drawLine(_loc13_,_loc32_);
                     _loc25_ = Utils.getControlPoint(_loc32_,_loc12_[3],_loc12_[2],_loc21_);
                  }
                  this.setLine(_loc13_,0);
                  this.drawLine(_loc13_,_loc12_[3],true,_loc25_);
               }
               else if(_loc12_[0] != null)
               {
                  if(VERBOSE_DRAWING)
                  {
                     Debug.trace("2c");
                  }
                  if(_loc16_ > 0 && !this.getPart(_loc10_).flippedX)
                  {
                     if(VERBOSE_DRAWING)
                     {
                        Debug.trace("2c1: " + _loc18_);
                     }
                     this.setLine(_loc13_,0);
                     if(_loc16_ < 90 && _loc16_ > -90)
                     {
                        if(VERBOSE_DRAWING)
                        {
                           Debug.trace("2c1a");
                        }
                        _loc25_ = Utils.getIntersection(_loc12_[0],_loc12_[3],_loc32_,_loc33_);
                     }
                     else
                     {
                        if(VERBOSE_DRAWING)
                        {
                           Debug.trace("2c1b");
                        }
                        _loc25_ = Utils.getControlPoint(_loc12_[3],_loc32_,_loc12_[2]);
                     }
                     this.drawLine(_loc13_,_loc32_,true,_loc25_);
                     this.setLine(_loc13_);
                     this.drawLine(_loc13_,_loc12_[2]);
                     this.drawLine(_loc13_,_loc12_[3]);
                  }
                  else
                  {
                     if(VERBOSE_DRAWING)
                     {
                        Debug.trace("2c2: " + _loc18_);
                     }
                     this.drawLine(_loc13_,_loc12_[2]);
                     this.setLine(_loc13_,0);
                     if(_loc16_ < 90 && _loc16_ > -90)
                     {
                        if(VERBOSE_DRAWING)
                        {
                           Debug.trace("2c2a");
                        }
                        _loc25_ = Utils.getIntersection(_loc12_[1],_loc12_[2],_loc31_,_loc34_);
                     }
                     else
                     {
                        if(VERBOSE_DRAWING)
                        {
                           Debug.trace("2c2b");
                        }
                        _loc25_ = Utils.getControlPoint(_loc12_[2],_loc31_,_loc12_[3]);
                     }
                     this.drawLine(_loc13_,_loc31_,true,_loc25_);
                     this.setLine(_loc13_);
                     this.drawLine(_loc13_,_loc12_[3]);
                  }
               }
            }
            _loc13_.endFill();
         }
      }
      
      private function drawTextures() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc5_:BodyPart = null;
         var _loc6_:BodyPart = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:DisplayObject = null;
         var _loc10_:DisplayObject = null;
         var _loc11_:* = null;
         if(this.skinInfo.textureParts == null)
         {
            return;
         }
         var _loc4_:uint = 4;
         for(_loc11_ in this.skinInfo.textureParts)
         {
            _loc2_ = this.skinInfo.textureParts[_loc11_][0];
            _loc9_ = this.getDrawing(_loc2_,_loc4_);
            _loc10_ = this.getDrawing(_loc11_,_loc4_);
            MovieClip(_loc9_).graphics.clear();
            MovieClip(_loc10_).graphics.clear();
         }
         for(_loc11_ in this.skinInfo.textureParts)
         {
            _loc2_ = this.skinInfo.textureParts[_loc11_][0];
            _loc1_ = this.skinInfo.textureParts[_loc11_][1];
            _loc3_ = getSuffix(_loc11_);
            _loc5_ = this.getPart(_loc2_);
            _loc6_ = this.getPart(_loc11_);
            _loc7_ = _loc5_.getTexture();
            _loc8_ = _loc6_.getTexture();
            if(_loc7_ != null && _loc8_ != null)
            {
               _loc9_ = this.getDrawing(_loc2_,_loc4_);
               _loc10_ = this.getDrawing(_loc11_,_loc4_);
               this.drawTexture(Utils.getIndex(_loc5_.target) > Utils.getIndex(_loc6_.target) ? _loc9_ : _loc10_,_loc7_,_loc8_,_loc3_,_loc1_);
            }
         }
      }
      
      private function drawTexture(param1:DisplayObject, param2:DisplayObject, param3:DisplayObject, param4:String, param5:Boolean) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         var _loc10_:uint = 0;
         _loc6_ = 0;
         while(_loc6_ < 100)
         {
            if(param3["a" + _loc6_ + "a"] != null)
            {
               _loc10_ = _loc6_;
               break;
            }
            _loc6_ += 10;
         }
         _loc6_ = 0;
         while(_loc6_ < 10)
         {
            if(param3["a" + (_loc6_ + _loc10_) + "a"] == null)
            {
               break;
            }
            if(param2["a" + (_loc6_ + _loc10_) + "a" + param4] != null)
            {
               _loc8_.push([Utils.getPosition(param2["a" + (_loc6_ + _loc10_) + "a" + param4],param1),Utils.getPosition(param2["a" + (_loc6_ + _loc10_) + "b" + param4],param1)]);
            }
            else
            {
               _loc8_.push([Utils.getPosition(param2["a" + (_loc6_ + _loc10_) + "a"],param1),Utils.getPosition(param2["a" + (_loc6_ + _loc10_) + "b"],param1)]);
            }
            _loc9_.push([Utils.getPosition(param3["a" + (_loc6_ + _loc10_) + "a"],param1),Utils.getPosition(param3["a" + (_loc6_ + _loc10_) + "b"],param1)]);
            _loc6_++;
         }
         if((_loc7_ = _loc8_.length) == 0)
         {
            return;
         }
         var _loc16_:Graphics = MovieClip(param1).graphics;
         _loc11_ = Utils.distanceBetween(_loc8_[0][0],_loc9_[0][0]);
         _loc12_ = Utils.distanceBetween(_loc8_[0][0],_loc9_[_loc7_ - 1][0]);
         _loc13_ = Utils.distanceBetween(_loc8_[_loc7_ - 1][0],_loc9_[0][0]);
         _loc14_ = Utils.distanceBetween(_loc8_[_loc7_ - 1][0],_loc9_[_loc7_ - 1][0]);
         if(((_loc15_ = Math.min(_loc11_,_loc12_,_loc13_,_loc14_)) == _loc12_ || _loc15_ == _loc13_) && param5)
         {
            _loc9_.reverse();
         }
         this.setLine(_loc16_);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc16_.beginFill(0,this.skinInfo.textureAlpha);
            _loc16_.moveTo(_loc8_[_loc6_][0].x,_loc8_[_loc6_][0].y);
            _loc16_.lineTo(_loc8_[_loc6_][1].x,_loc8_[_loc6_][1].y);
            if(Utils.getIntersection2(_loc8_[_loc6_][1],_loc9_[_loc6_][1],_loc9_[_loc6_][0],_loc8_[_loc6_][0]) == null)
            {
               _loc16_.lineTo(_loc9_[_loc6_][1].x,_loc9_[_loc6_][1].y);
               _loc16_.lineTo(_loc9_[_loc6_][0].x,_loc9_[_loc6_][0].y);
            }
            else
            {
               _loc16_.lineTo(_loc9_[_loc6_][0].x,_loc9_[_loc6_][0].y);
               _loc16_.lineTo(_loc9_[_loc6_][1].x,_loc9_[_loc6_][1].y);
            }
            _loc16_.lineTo(_loc8_[_loc6_][0].x,_loc8_[_loc6_][0].y);
            _loc16_.endFill();
            _loc6_++;
         }
      }
      
      private function hasLongSleeves() : Boolean
      {
         if(this.skinType == Globals.MARVEL)
         {
            return true;
         }
         if(this.skinType == Globals.MARVEL2)
         {
            return false;
         }
         if(this.skinType == Globals.KINECTION)
         {
            return false;
         }
         if(this.skinType == Globals.NICK_SB)
         {
            return false;
         }
         return Utils.inArray(this.getShirtType(),this.skinInfo.looksShirtsLongSleeved);
      }
      
      private function tracePoint(param1:Object) : String
      {
         var _loc3_:* = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc2_.push(_loc3_ + "=" + param1[_loc3_]);
         }
         return _loc2_.join(";");
      }
      
      private function pointInside(param1:Object, param2:String, param3:Boolean = false) : Boolean
      {
         return Utils.pointInside(param1,this.target[param2],param3);
      }
      
      private function angleBetween(param1:String, param2:String, param3:String = "") : Number
      {
         var _loc4_:String = param2 + param3;
         var _loc5_:Number = Utils.normalizeAngle(this.getRotation(this.target[param1]) - this.getRotation(this.target[_loc4_]));
         if(this.biped)
         {
            if((param1 == "torso" || param1 == "ribs") && (param2 == "upperArm" || param2 == "upperLeg"))
            {
               if(param3 == "1")
               {
                  _loc5_ = Utils.normalizeAngle(180 - _loc5_);
               }
            }
            else if(param3 == "1")
            {
               _loc5_ = Utils.normalizeAngle(-_loc5_);
            }
         }
         return _loc5_;
      }
      
      private function drawLine(param1:Graphics, param2:Object, param3:Boolean = true, param4:Object = null, param5:Number = 1) : void
      {
         if(param2 == null)
         {
            return;
         }
         var _loc6_:Number = param2.x / param5;
         var _loc7_:Number = param2.y / param5;
         if(param3)
         {
            if(param4 == null)
            {
               param1.lineTo(_loc6_,_loc7_);
            }
            else
            {
               param1.curveTo(param4.x,param4.y,_loc6_,_loc7_);
            }
         }
         else
         {
            param1.moveTo(_loc6_,_loc7_);
         }
      }
      
      private function getPosition(param1:String, param2:String, param3:String, param4:String, param5:Number, param6:String) : Object
      {
         var _loc7_:Number = this.getRotation(this.target[param3 + param4]);
         if(param2 == "2")
         {
            _loc7_ = 180 - _loc7_;
         }
         var _loc8_:Number = param2 == "2" ? Number(1) : Number(-1);
         var _loc9_:Number = Math.sin(Utils.d2r(_loc7_ - 90)) * param5 * _loc8_;
         var _loc10_:Number = Math.cos(Utils.d2r(_loc7_ - 90)) * param5;
         return this.getPosition2(this.target[param1 + param2],param6,_loc9_,_loc10_);
      }
      
      private function getPosition2(param1:DisplayObject, param2:String, param3:Number, param4:Number) : Object
      {
         return Utils.getPosition(param1,this.target[param2],param3,param4);
      }
      
      private function bareAnkles() : Boolean
      {
         if(!this.biped)
         {
            return false;
         }
         if(this.skinType == Globals.MARVEL || this.skinType == Globals.NICK_SB)
         {
            return false;
         }
         if(this.skinType == Globals.MARVEL2)
         {
            return true;
         }
         if(this.skinType == Globals.KINECTION)
         {
            return false;
         }
         return Utils.inArray(this.getPantsType(),this.skinInfo.looksPantsShortish);
      }
      
      private function bareKnees() : Boolean
      {
         if(!this.biped)
         {
            return false;
         }
         if(this.skinType == Globals.MARVEL)
         {
            return false;
         }
         if(this.skinType == Globals.MARVEL2)
         {
            return true;
         }
         if(this.skinType == Globals.KINECTION)
         {
            return false;
         }
         if(this.skinType == Globals.NICK_SB)
         {
            return true;
         }
         return Utils.inArray(this.getPantsType(),this.skinInfo.looksPantsShort);
      }
      
      private function bareWrists() : Boolean
      {
         return this.biped && !this.hasLongSleeves();
      }
      
      private function drawLegs() : void
      {
         if(!DRAW_LEGS || !this.canDrawOn("legs"))
         {
            return;
         }
         if(!DRAW_ONE_SIDE)
         {
            this.drawLeg("1");
         }
         this.drawLeg("2");
         this.drawSkirt(this.isSkirt());
      }
      
      private function isSkirt() : Boolean
      {
         return Utils.inArray(this.getPantsType(),[SKIRT_SHORT]);
      }
      
      private function drawSkirt(param1:Boolean) : void
      {
         var _loc6_:Graphics = null;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc13_:MovieClip = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc9_:Number = !!TESTING_SKIRT ? Number(0.4) : Number(1);
         var _loc11_:String = (_loc10_ = "1") == "1" ? "2" : "1";
         var _loc12_:String = "upperLeg";
         var _loc18_:uint = this.getTurn("ribs");
         (_loc6_ = (_loc13_ = this.target.drawing).graphics).clear();
         if(!param1)
         {
            return;
         }
         _loc2_[0] = this.getAnchor(_loc12_ + _loc10_,"anchor2",_loc13_);
         _loc2_[1] = this.getAnchor(_loc12_ + _loc10_,"anchor3",_loc13_);
         _loc2_[2] = this.getAnchor(_loc12_ + _loc11_,"anchor2",_loc13_);
         _loc2_[3] = this.getAnchor(_loc12_ + _loc11_,"anchor3",_loc13_);
         _loc15_ = this.angleBetween("torso","upperLeg","1");
         _loc16_ = this.angleBetween("torso","upperLeg","2");
         _loc4_[0] = Utils.getDistance(_loc2_[0],_loc2_[2]);
         _loc4_[1] = Utils.getDistance(_loc2_[0],_loc2_[3]);
         _loc4_[2] = Utils.getDistance(_loc2_[1],_loc2_[2]);
         _loc4_[3] = Utils.getDistance(_loc2_[1],_loc2_[3]);
         _loc19_ = Math.max(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]);
         _loc5_[0] = this.getAnchor("torso","anchor4",_loc13_);
         _loc5_[3] = this.getAnchor("torso","anchor5",_loc13_);
         _loc2_[4] = this.getAnchor("torso","anchor2",_loc13_);
         _loc2_[5] = this.getAnchor("torso","anchor3",_loc13_);
         if(_loc18_ >= TURNED_AWAY)
         {
            Utils.swap(_loc5_,0,3);
            Utils.swap(_loc2_,4,5);
         }
         if(_loc19_ == _loc4_[0] || _loc19_ == _loc4_[1])
         {
            _loc5_[1] = _loc2_[0];
            _loc2_[12] = this.getAnchor(_loc12_ + _loc10_,"anchor1",_loc13_);
         }
         else
         {
            _loc5_[1] = _loc2_[1];
            _loc2_[12] = this.getAnchor(_loc12_ + _loc10_,"anchor0",_loc13_);
         }
         if(_loc19_ == _loc4_[0] || _loc19_ == _loc4_[2])
         {
            _loc5_[2] = _loc2_[2];
            _loc2_[13] = this.getAnchor(_loc12_ + _loc11_,"anchor1",_loc13_);
         }
         else
         {
            _loc5_[2] = _loc2_[3];
            _loc2_[13] = this.getAnchor(_loc12_ + _loc11_,"anchor0",_loc13_);
         }
         if((_loc20_ = Utils.getIntersection2(_loc2_[4],_loc5_[1],_loc5_[2],_loc2_[5])) != null)
         {
            Utils.swap(_loc5_,1,2);
         }
         if(_loc19_ == _loc4_[0] || _loc19_ == _loc4_[1])
         {
            _loc3_[0] = this.getAnchor(_loc12_ + _loc10_,"anchor" + (_loc20_ != null ? "7" : "6"),_loc13_);
         }
         else
         {
            _loc3_[0] = this.getAnchor(_loc12_ + _loc10_,"anchor" + (_loc20_ != null ? "6" : "7"),_loc13_);
         }
         if(_loc19_ == _loc4_[0] || _loc19_ == _loc4_[2])
         {
            _loc3_[2] = this.getAnchor(_loc12_ + _loc11_,"anchor" + (_loc20_ != null ? "7" : "6"),_loc13_);
         }
         else
         {
            _loc3_[2] = this.getAnchor(_loc12_ + _loc11_,"anchor" + (_loc20_ != null ? "6" : "7"),_loc13_);
         }
         _loc2_[6] = Utils.getMidPoint(_loc5_[1],_loc5_[2]);
         _loc2_[7] = this.getAnchor("lowerLeg1","anchor2",_loc13_);
         _loc2_[8] = this.getAnchor("lowerLeg2","anchor2",_loc13_);
         _loc2_[9] = {
            "x":(_loc2_[7].x + _loc2_[8].x) * 0.5,
            "y":Math.max(_loc2_[7].y,_loc2_[8].y)
         };
         _loc2_[10] = Utils.getIntersection2(_loc5_[0],_loc5_[1],_loc3_[0],_loc5_[3]);
         _loc2_[11] = Utils.getIntersection2(_loc5_[2],_loc5_[3],_loc3_[2],_loc5_[0]);
         _loc17_ = (_loc14_ = Math.abs(_loc15_ + _loc16_)) / 180;
         if(_loc2_[9].y > _loc2_[6].y)
         {
            _loc3_[1] = {
               "x":_loc2_[6].x + (_loc2_[9].x - _loc2_[6].x) * _loc17_,
               "y":_loc2_[6].y + (_loc2_[9].y - _loc2_[6].y) * _loc17_
            };
         }
         else
         {
            _loc3_[1] = {
               "x":_loc2_[6].x + (_loc2_[9].x - _loc2_[6].x) * _loc17_,
               "y":_loc2_[6].y
            };
         }
         _loc7_ = Globals.PANT_COLOR;
         if(TESTING_SKIRT)
         {
            _loc8_ = 16711680;
         }
         else
         {
            _loc8_ = Palette.rgb2hex(Palette.getColor(this.colors[_loc7_]));
         }
         _loc6_.beginFill(_loc8_,_loc9_);
         this.drawLine(_loc6_,_loc5_[0],false);
         this.setLine(_loc6_,0);
         if(_loc2_[10] != null)
         {
            if(_loc20_ == null && _loc15_ < -25)
            {
               _loc21_ = Utils.getControlPoint(_loc5_[0],_loc2_[12],_loc2_[13],0.2);
               this.drawLine(_loc6_,_loc2_[12],true,_loc21_);
               this.drawLine(_loc6_,_loc5_[1]);
            }
            else
            {
               this.drawLine(_loc6_,_loc5_[1],true,_loc3_[0]);
            }
         }
         else
         {
            this.drawLine(_loc6_,_loc5_[1]);
         }
         this.drawLine(_loc6_,_loc5_[2],true,_loc3_[1]);
         this.setLine(_loc6_,0);
         if(_loc2_[11] != null)
         {
            if(_loc20_ == null && _loc16_ < -25)
            {
               _loc21_ = Utils.getControlPoint(_loc5_[2],_loc2_[13],_loc2_[12],0.2);
               this.drawLine(_loc6_,_loc2_[13],true,_loc21_);
               this.drawLine(_loc6_,_loc5_[3]);
            }
            else
            {
               this.drawLine(_loc6_,_loc5_[3],true,_loc3_[2]);
            }
         }
         else
         {
            this.drawLine(_loc6_,_loc5_[3]);
         }
         this.setLine(_loc6_);
         this.drawLine(_loc6_,_loc5_[0]);
         _loc6_.endFill();
      }
      
      private function drawLeg(param1:String) : void
      {
         if(this.isHidden("upperLeg" + param1))
         {
            return;
         }
         if(this.isCurve("upperLeg" + param1))
         {
            this.drawCurve("upperLeg" + param1);
         }
         else
         {
            this.drawJoint("upperLeg","lowerLeg",param1);
            if(!DRAW_ELBOW_KNEE_ONLY)
            {
               this.drawJoint("lowerLeg","foot",param1);
               if(!DRAW_HAND_FOOT_ONLY)
               {
                  this.drawJoint("foot","sock",param1);
               }
            }
         }
      }
      
      private function drawNeck() : void
      {
         if(!DRAW_NECK)
         {
            return;
         }
         this.drawJoint("neck",this.skinInfo.rootBodyPart);
         if(this.skinType == Globals.BIRD)
         {
         }
         this.updateScale();
         this.reposition(this.skinInfo.rootHeadPart);
      }
      
      public function getNewRandomParts(param1:uint) : Array
      {
         switch(param1)
         {
            case LOOKS:
               return this.skinInfo.newRandomParts == null ? [] : this.skinInfo.newRandomParts;
            default:
               return [];
         }
      }
      
      public function getDefaultLooks(param1:uint) : Object
      {
         if(param1 == LOOKS && this.skinInfo.defaultLooks != null)
         {
            return this.skinInfo.defaultLooks;
         }
         return {};
      }
      
      public function getParts(param1:uint, param2:Boolean = false) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc5_:Array = [];
         switch(param1)
         {
            case ALL:
               if(param2)
               {
                  for each(_loc4_ in this.bodyParts)
                  {
                     _loc5_.push(_loc4_);
                  }
               }
               else
               {
                  for each(_loc3_ in this.skinInfo.parts)
                  {
                     if(_loc3_ != null)
                     {
                        _loc5_.push(this.target[_loc3_]);
                     }
                  }
               }
               break;
            case ALL_TURNS:
               _loc7_ = this.target.numChildren;
               for each(_loc3_ in this.skinInfo.parts)
               {
                  if(_loc3_ != null)
                  {
                     if(this.turningMapMC[this.skinType][_loc3_] == null || this.turningMapMC[this.skinType][_loc3_].length == 0)
                     {
                        _loc5_.push(this.target[_loc3_]);
                     }
                     else
                     {
                        _loc7_ = this.turningMapMC[this.skinType][_loc3_].length;
                        _loc6_ = 0;
                        while(_loc6_ < _loc7_)
                        {
                           if(!Utils.inArray(this.turningMapMC[this.skinType][_loc3_][_loc6_],_loc5_))
                           {
                              _loc5_.push(this.turningMapMC[this.skinType][_loc3_][_loc6_]);
                           }
                           _loc6_++;
                        }
                     }
                  }
               }
               break;
            case EXPRESSION:
               for each(_loc4_ in this.bodyParts)
               {
                  if(_loc4_.isExpressive())
                  {
                     if(param2)
                     {
                        if(this.skinInfo.faceParts != null && Utils.inArray(_loc4_.getTargetName(),this.skinInfo.faceParts))
                        {
                           _loc5_.push(_loc4_);
                        }
                     }
                     else
                     {
                        _loc5_.push(_loc4_.target);
                     }
                  }
               }
               break;
            case LOOKS:
               for each(_loc4_ in this.bodyParts)
               {
                  if(_loc4_.isVariable() && !(this.isHuman() && (_loc4_.getTargetName() == "head" || _loc4_.getTargetName() == "neck")))
                  {
                     if(param2)
                     {
                        _loc5_.push(_loc4_);
                     }
                     else
                     {
                        _loc5_.push(_loc4_.target);
                     }
                  }
                  _loc4_.target.visible = true;
               }
               break;
            case SCALABLE:
               if(this.skinInfo.scalableParts != null)
               {
                  for each(_loc3_ in this.skinInfo.scalableParts)
                  {
                     _loc4_ = this.getPart(_loc3_);
                     if(param2)
                     {
                        _loc5_.push(_loc4_);
                     }
                     else
                     {
                        _loc5_.push(_loc4_.target);
                     }
                     _loc4_.target.visible = true;
                  }
               }
               break;
            case COLORS:
               if(this.skinInfo.colorParts != null)
               {
                  _loc7_ = this.skinInfo.colorParts.length;
                  _loc6_ = 0;
                  while(_loc6_ < _loc7_)
                  {
                     if(this.skinType == 101)
                     {
                        if(this.skinInfo.colorParts[_loc6_] != null)
                        {
                           for each(_loc3_ in this.skinInfo.colorParts[_loc6_][_loc6_])
                           {
                              _loc5_.push(this.target[_loc3_]);
                           }
                        }
                     }
                     else if(!(this.skinInfo.colorParts[_loc6_] == null || this.skinInfo.colorParts[_loc6_][0] == null))
                     {
                        for each(_loc3_ in this.skinInfo.colorParts[_loc6_][0])
                        {
                           _loc5_.push(this.target[_loc3_]);
                        }
                     }
                     _loc6_++;
                  }
               }
               break;
            case REPOSITIONABLE:
               if(this.skinInfo.movableParts != null)
               {
                  for each(_loc3_ in this.skinInfo.movableParts)
                  {
                     if(this.getPart(String(_loc3_)).blankPart())
                     {
                        this.target[_loc3_].visible = false;
                     }
                     else
                     {
                        _loc5_.push(this.target[_loc3_]);
                     }
                  }
               }
               if(this.isHuman())
               {
                  _loc8_ = ["moustache","beard","eyewear"];
                  for each(_loc3_ in _loc8_)
                  {
                     if(this.partExists(String(_loc3_)) && this.getPart(String(_loc3_)).invisible)
                     {
                        this.target[_loc3_].visible = false;
                     }
                  }
               }
         }
         return _loc5_;
      }
      
      public function doSymmetryLooks(param1:uint) : void
      {
         var _loc2_:String = null;
         if(this.skinInfo.symmetrical == null)
         {
            return;
         }
         for each(_loc2_ in this.skinInfo.symmetrical)
         {
            if(param1 == EXPRESSION)
            {
               this.getPart(_loc2_ + "1").expression = this.getPart(_loc2_ + "2").expression;
            }
            else if(param1 == LOOKS)
            {
               this.getPart(_loc2_ + "1").look = this.getPart(_loc2_ + "2").look;
            }
         }
         this.updateHairMask();
      }
      
      public function enforceLooks(param1:BodyPart) : void
      {
         var _loc4_:BodyPart = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:int = 0;
         var _loc2_:String = param1.getTargetName();
         var _loc3_:String = this.getBaseName(_loc2_);
         if(this.biped)
         {
            _loc14_ = !(_loc13_ = Utils.inArray(_loc2_,["foot" + this.normalizeSuffix("1"),"foot" + this.normalizeSuffix("2")])) && Utils.inArray(_loc2_,["sock" + this.normalizeSuffix("1"),"sock" + this.normalizeSuffix("2")]);
            _loc15_ = !_loc13_ && !_loc15_ && this.skinInfo.legParts != null && Utils.inArray(_loc2_,this.skinInfo.legParts);
            _loc16_ = Utils.inArray(_loc2_,this.skinInfo.armParts);
            if(_loc14_ || _loc13_ || _loc15_)
            {
               if(_loc14_)
               {
                  _loc9_ = param1.look;
               }
               else
               {
                  _loc9_ = this.getSocksType();
               }
               if(_loc13_)
               {
                  _loc10_ = param1.look;
               }
               else
               {
                  _loc10_ = this.getPart("foot" + this.normalizeSuffix("1")).look;
               }
               if(_loc15_)
               {
                  _loc7_ = param1.look;
               }
               else
               {
                  _loc7_ = this.getPantsType();
               }
               if(this.isBootShoe(_loc10_) || this.isBootSock(_loc9_))
               {
                  if(!Utils.inArray(_loc7_,this.skinInfo.looksPantsBoots))
                  {
                     if(_loc15_)
                     {
                        this.getPart("foot1").look = 0;
                        this.getPart("foot2").look = 0;
                        this.getPart("sock1").look = 0;
                        this.getPart("sock2").look = 0;
                        _loc10_ = this.getPart("foot1").look;
                        _loc9_ = this.getSocksType();
                     }
                     else
                     {
                        _loc17_ = 14;
                        this.getPart("upperLeg1").look = _loc17_;
                        this.getPart("upperLeg2").look = _loc17_;
                        this.getPart("lowerLeg1").look = _loc17_;
                        this.getPart("lowerLeg2").look = _loc17_;
                        _loc7_ = this.getPantsType();
                     }
                  }
                  if(_loc14_)
                  {
                     if(this.isBootSock(_loc9_))
                     {
                        this.getPart("foot1").look = this.getPart("foot2").look = this.getFootFromSock(_loc9_);
                        _loc10_ = this.getShoesType();
                     }
                     else if(this.isBootShoe(_loc10_))
                     {
                        this.getPart("foot1").look = this.getPart("foot2").look = 0;
                        _loc10_ = this.getShoesType();
                     }
                  }
                  else if(_loc13_)
                  {
                     if(this.isBootShoe(_loc10_))
                     {
                        this.getPart("sock1").look = this.skinInfo.footToSock[_loc10_];
                        this.getPart("sock2").look = this.skinInfo.footToSock[_loc10_];
                        _loc9_ = this.getSocksType();
                     }
                     else if(this.isBootSock(_loc9_))
                     {
                        this.getPart("sock1").look = 0;
                        this.getPart("sock2").look = 0;
                        _loc9_ = this.getSocksType();
                     }
                  }
               }
               _loc6_ = Utils.inArray(_loc7_,this.skinInfo.looksPantsShortish);
               this.getPart("sock" + this.normalizeSuffix("1")).show(!this.isHuman(true) || _loc6_ || this.isBootSock(_loc9_));
               this.getPart("sock" + this.normalizeSuffix("2")).show(!this.isHuman(true) || _loc6_ || this.isBootSock(_loc9_));
               if(this.isHuman(true) && (Utils.inArray(_loc7_,this.skinInfo.looksPantsSocked) && !this.isBootSock(_loc9_) || _loc6_ && !Utils.inArray(_loc7_,this.skinInfo.looksPantsShort) && !Utils.inArray(_loc9_,this.skinInfo.looksSocksShort)) && !Utils.inArray(_loc7_,this.skinInfo.looksPantsAllSocks))
               {
                  this.getPart("sock" + this.normalizeSuffix("1")).look = 0;
                  this.getPart("sock" + this.normalizeSuffix("2")).look = 0;
               }
            }
         }
         _loc4_ = null;
         if(this.isBeltExt())
         {
            if(_loc15_)
            {
               if((_loc7_ = this.getPantsType()) == SKIRT_SHORT)
               {
                  this.getPart("belt").look = 0;
               }
            }
            else if(_loc16_)
            {
               _loc8_ = this.getShirtType();
               if(this.skinInfo.looksShirtsNone && Utils.inArray(_loc8_,this.skinInfo.looksShirtsNone))
               {
                  this.getPart("belt").look = 0;
               }
            }
            else if(_loc2_ == "belt" && this.isBeltExt())
            {
               _loc8_ = this.getShirtType();
               if(this.skinInfo.looksShirtsNone && Utils.inArray(_loc8_,this.skinInfo.looksShirtsNone))
               {
                  this.getPart("upperArm1").look = 0;
                  this.getPart("lowerArm1").look = 0;
                  this.getPart("upperArm2").look = 0;
                  this.getPart("lowerArm2").look = 0;
               }
            }
         }
         if(_loc16_ && this.skinInfo.looksShirtsNone && Utils.inArray(this.getShirtType(),this.skinInfo.looksShirtsNone))
         {
            if(!Character.ALLOW_FEMALE)
            {
               param1.look = SHIRT_SHORT;
            }
            else
            {
               if(this.partExists("detail"))
               {
                  this.getPart("detail").look = 0;
               }
               if(this.partExists("collar") && (!this.skinInfo.looksCollarsLong || !Utils.inArray(this.getPart("collar").look,this.skinInfo.looksCollarsLong)))
               {
                  this.getPart("collar").look = 0;
                  this.getPart("collarBehind").look = 0;
               }
            }
         }
         if(lookGroupMap[this.skinType][_loc2_] != null && this.skinInfo.lookGroups != null)
         {
            for each(_loc11_ in lookGroupMap[this.skinType][_loc2_])
            {
               for each(_loc5_ in this.skinInfo.lookGroups[_loc11_])
               {
                  if(_loc5_ != _loc2_)
                  {
                     (_loc4_ = this.getPart(_loc5_)).look = param1.look;
                  }
               }
            }
         }
         else if(this.skinInfo.armParts != null && Utils.inArray(_loc2_,this.skinInfo.armParts))
         {
            for each(_loc5_ in this.skinInfo.armParts)
            {
               if(_loc5_ != _loc2_)
               {
                  (_loc4_ = this.getPart(_loc5_)).look = param1.look;
               }
            }
         }
         else if(this.skinInfo.legParts != null && Utils.inArray(_loc2_,this.skinInfo.legParts))
         {
            for each(_loc5_ in this.skinInfo.legParts)
            {
               if(_loc5_ != _loc2_)
               {
                  (_loc4_ = this.getPart(_loc5_)).look = param1.look;
               }
            }
         }
         else if(this.skinInfo.torsoParts != null && Utils.inArray(_loc2_,this.skinInfo.torsoParts))
         {
            for each(_loc5_ in this.skinInfo.torsoParts)
            {
               if(_loc5_ != _loc2_)
               {
                  (_loc4_ = this.getPart(_loc5_)).look = param1.look;
               }
            }
         }
         else if(this.skinInfo.neckParts != null && Utils.inArray(_loc2_,this.skinInfo.neckParts))
         {
            for each(_loc5_ in this.skinInfo.neckParts)
            {
               if(_loc5_ != _loc2_)
               {
                  (_loc4_ = this.getPart(_loc5_)).look = param1.look;
               }
            }
         }
         else
         {
            if(this.skinInfo.symmetrical != null && Utils.inArray(_loc3_,this.skinInfo.symmetrical))
            {
               _loc4_ = this.getPart(this.getOppositePartName(_loc2_));
            }
            else
            {
               switch(_loc2_)
               {
                  case "eye1":
                     _loc4_ = this.getPart("eye2");
                     break;
                  case "eye2":
                     _loc4_ = this.getPart("eye1");
                     break;
                  case "eyeShadow1":
                     _loc4_ = this.getPart("eyeShadow2");
                     break;
                  case "eyeShadow2":
                     _loc4_ = this.getPart("eyeShadow1");
                     break;
                  case "ear1":
                     _loc4_ = this.getPart("ear2");
                     break;
                  case "ear2":
                     _loc4_ = this.getPart("ear1");
                     break;
                  case "earring1":
                     _loc4_ = this.getPart("earring2");
                     break;
                  case "earring2":
                     _loc4_ = this.getPart("earring1");
                     break;
                  case "brow1":
                     _loc4_ = this.getPart("brow2");
                     break;
                  case "brow2":
                     _loc4_ = this.getPart("brow1");
                     break;
                  case "sock1":
                     _loc4_ = this.getPart("sock2");
                     break;
                  case "sock2":
                     _loc4_ = this.getPart("sock1");
                     break;
                  case "foot1":
                     _loc4_ = this.getPart("foot2");
                     break;
                  case "foot2":
                     _loc4_ = this.getPart("foot1");
                     break;
                  case "hand1":
                     _loc4_ = this.getPart("hand2");
                     break;
                  case "hand2":
                     _loc4_ = this.getPart("hand1");
                     break;
                  case "hair":
                     _loc4_ = this.getPart("hairBehind");
                     break;
                  case "hairBehind":
                     _loc4_ = this.getPart("hair");
                     break;
                  case "collar":
                     _loc4_ = this.getPart("collarBehind");
                     break;
                  case "collarBehind":
                     _loc4_ = this.getPart("collar");
                     break;
                  case "cape":
                     _loc4_ = this.getPart("capeBehind");
                     break;
                  case "capeBehind":
                     _loc4_ = this.getPart("cape");
               }
            }
            if(_loc4_ != null)
            {
               _loc4_.look = param1.look;
            }
            this.updateHairMask();
         }
         if(DRAWING_DISABLED)
         {
         }
      }
      
      public function doSymmetryPivots(param1:String) : void
      {
         var _loc6_:* = null;
         if(!this.isHuman())
         {
            return;
         }
         var _loc2_:String = this.skinInfo.pivots[param1];
         var _loc3_:BodyPart = this.getPart(_loc2_);
         var _loc4_:MovieClip = this.target[_loc2_];
         var _loc5_:Object = {};
         var _loc7_:Boolean = false;
         switch(param1)
         {
            case "eye1":
               _loc5_ = {
                  "eye1":1,
                  "eye2":-1,
                  "brow1":1,
                  "brow2":-1
               };
               if(this.partExists("eyeShadow1"))
               {
                  _loc5_["eyeShadow1"] = 1;
                  _loc5_["eyeShadow2"] = -1;
               }
               break;
            case "eye2":
               _loc5_ = {
                  "eye1":-1,
                  "eye2":1,
                  "brow1":-1,
                  "brow2":1
               };
               if(this.partExists("eyeShadow1"))
               {
                  _loc5_["eyeShadow1"] = -1;
                  _loc5_["eyeShadow2"] = 1;
               }
               break;
            case "brow1":
               _loc7_ = true;
               _loc5_ = {"brow2":1};
               break;
            case "brow2":
               _loc7_ = true;
               _loc5_ = {"brow1":1};
               break;
            case "mouth":
               _loc7_ = true;
               break;
            case "moustache":
            case "nose":
               _loc5_ = {
                  "moustache":1,
                  "nose":1
               };
               _loc7_ = true;
         }
         for(_loc6_ in _loc5_)
         {
            if(!(_loc6_ == param1 || !this.partExists(_loc6_)))
            {
               if(_loc7_)
               {
                  _loc3_.setPivotData(_loc6_,[_loc4_[_loc6_].x,_loc4_[param1].y],false);
               }
               else
               {
                  _loc3_.setPivotData(_loc6_,[_loc4_[param1].x * _loc5_[_loc6_],_loc4_[_loc6_].y],false);
               }
            }
         }
         this.reposition(_loc2_,true);
      }
      
      private function isOppositePart(param1:String, param2:String) : Boolean
      {
         return getSuffix(param1) != getSuffix(param2);
      }
      
      private function doSymmetryScalables(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:* = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         _loc5_ = param1.substr(param1.length - 1,1);
         _loc4_ = this.skinInfo.pivots[param1];
         this.reposition(_loc4_);
         if(Utils.inArray(_loc5_,["1","2"]))
         {
            _loc7_ = param1.substr(0,param1.length - 1);
            _loc8_ = _loc5_ == "1" ? "2" : "1";
            _loc9_ = _loc7_ + _loc8_;
            this.sizableLookData[_loc9_] = this.sizableLookData[param1];
            _loc4_ = this.skinInfo.pivots[_loc9_];
            this.reposition(_loc4_);
         }
         if(this.skinInfo.movableLooksGroups != null)
         {
            for each(_loc10_ in this.skinInfo.movableLooksGroups)
            {
               for(_loc11_ in _loc10_)
               {
                  if(!(Utils.inArray(_loc11_,["x","y"]) || !Utils.inArray(param1,_loc10_[_loc11_])))
                  {
                     for each(_loc6_ in _loc10_[_loc11_])
                     {
                        if(_loc6_ != param1)
                        {
                           if(this.sizableLookData[_loc6_] == null)
                           {
                              this.sizableLookData[_loc6_] = {};
                           }
                           this.sizableLookData[_loc6_][_loc11_] = this.sizableLookData[param1][_loc11_];
                           if(_loc6_ == "neck")
                           {
                              _loc2_ = true;
                           }
                           else if(_loc6_ == "head")
                           {
                              _loc3_ = true;
                           }
                        }
                     }
                  }
               }
            }
            this.updateScaleParts();
            this.renderExtraLooksData();
         }
         if(param1 == "neck")
         {
            _loc2_ = true;
         }
         else if(param1 == "head")
         {
            _loc3_ = true;
         }
         if(_loc2_)
         {
            if(this.sizableLookData[param1].scaleX < 1.2)
            {
               this.getPart("head").look = 0;
               this.getPart("neck").look = 0;
            }
            else if(this.sizableLookData[param1].scaleX >= 1.4)
            {
               this.getPart("head").look = 2;
               this.getPart("neck").look = 2;
            }
            else
            {
               this.getPart("head").look = 1;
               this.getPart("neck").look = 1;
            }
         }
         if(_loc2_ || _loc3_)
         {
            this.render();
         }
      }
      
      private function isPivotRelative() : Boolean
      {
         return this.version > 0;
      }
      
      public function adjustForSex() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         if(!this.isHuman())
         {
            for each(_loc1_ in groupedLooks[this.skinType])
            {
               this.enforceLooks(this.getPart(_loc1_));
            }
         }
         else if(this.target["breasts"] != null)
         {
            _loc2_ = this.getPart("hat").look;
            _loc3_ = this.getPart("hair").look;
            _loc4_ = this.getPart("chin").look;
            _loc5_ = this.getPart("ribs").look;
            _loc6_ = this.getPart("brow1").look;
            _loc7_ = this.getPart("accessory").look;
            _loc8_ = this.getPart("breasts").look;
            if(_loc9_ = Utils.inArray(_loc3_,this.skinInfo.looksHairFemale) || Utils.inArray(_loc5_,this.skinInfo.looksRibsFemale))
            {
               this.getPart("beard").look = 0;
               this.getPart("moustache").look = 0;
            }
            _loc10_ = this.getPart("beard").look > 0 || this.getPart("moustache").look > 0 || Utils.inArray(_loc3_,this.skinInfo.looksHairMale);
            if(!_loc9_ && Utils.inArray(_loc2_,this.skinInfo.looksHatsFemale))
            {
               this.getPart("hat").look = 0;
            }
            if(Utils.inArray(_loc4_,this.skinInfo.looksChinsMale) && _loc9_)
            {
               this.getPart(this.skinInfo.rootHeadPart).look = 0;
            }
            if(Utils.inArray(_loc5_,this.skinInfo.looksRibsMale) && _loc9_)
            {
               this.getPart("ribs").look = this.skinInfo.looksRibsFemale[Math.floor(Math.random() * this.skinInfo.looksRibsFemale.length)];
            }
            else if(Utils.inArray(_loc5_,this.skinInfo.looksRibsFemale) && _loc10_)
            {
               this.getPart("ribs").look = this.skinInfo.looksRibsMale[Math.floor(Math.random() * this.skinInfo.looksRibsMale.length)];
            }
            if(_loc10_ && _loc8_ > 0)
            {
               this.getPart("breasts").look = 0;
            }
            else if(_loc9_ && _loc8_ > 0)
            {
               this.getPart("ribs").look = 2;
               this.getPart("torso").look = 2;
            }
            if(Utils.inArray(_loc6_,this.skinInfo.looksBrowsMale) && _loc9_)
            {
               this.getPart("brow1").look = 0;
               this.getPart("brow2").look = 0;
            }
            if(Utils.inArray(_loc7_,this.skinInfo.looksAccessoriesMale) && _loc9_ || Utils.inArray(_loc7_,this.skinInfo.looksAccessoriesFemale) && _loc10_)
            {
               this.getPart("accessory").look = 0;
            }
            this.enforceLooks(this.getPart("hair"));
            this.enforceLooks(this.getPart("cape"));
            this.enforceLooks(this.getPart("collar"));
            this.enforceLooks(this.getPart("upperArm1"));
            this.enforceLooks(this.getPart("upperLeg1"));
            this.updateHairMask();
         }
      }
      
      private function updateHairMask() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         if(!this.isHuman() || !this.partExists("hair"))
         {
            return;
         }
         if(this.partExists("hat"))
         {
            _loc1_ = this.getPart("hair").look;
            _loc3_ = this.getPart("hat").getMasks();
         }
         if(_loc3_ == null || Utils.inArray(_loc1_,this.skinInfo.looksHairBig))
         {
            this.target["hair"].mask = null;
            if(this.partExists("hairBehind"))
            {
               this.target["hairBehind"].mask = null;
            }
         }
         else
         {
            this.target["hair"].mask = _loc3_[0];
            if(this.partExists("hairBehind"))
            {
               this.target["hairBehind"].mask = _loc3_[1];
            }
         }
      }
      
      public function setColor(param1:uint, param2:*) : void
      {
         var _loc4_:BodyPart = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc3_:Array = this.skinInfo.colorParts[param1];
         if(_loc3_ == null)
         {
            return;
         }
         if(param2 == null || param2 == 0)
         {
            param2 = this.getDefaultColor(param1,this.skinType);
         }
         this.colors[param1] = param2;
         var _loc7_:uint = _loc3_.length;
         var _loc8_:Array = Palette.getColor(param2);
         if(param2 == Palette.TRANSPARENT_ID || DRAWING_DISABLED)
         {
            _loc8_[Palette.A] = 0;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if(_loc3_[_loc6_] != null)
            {
               for each(_loc5_ in _loc3_[_loc6_])
               {
                  if(!((_loc5_ == "torso" || _loc5_ == "ribs") && this.skinType == Globals.HUMAN && (param1 == Globals.SHIRT_COLOR && this.skinInfo.looksShirtsNone && Utils.inArray(this.getShirtType(),this.skinInfo.looksShirtsNone) || param1 == Globals.SKIN_COLOR && (!this.skinInfo.looksShirtsNone || !Utils.inArray(this.getShirtType(),this.skinInfo.looksShirtsNone)))))
                  {
                     if(this.isHuman() && _loc5_.match(/^foot/))
                     {
                        if(param1 == Globals.SKIN_COLOR && (this.hasSocks() || this.hasSockPants()) || param1 == Globals.SOCK_COLOR && !this.hasSocks() || param1 == Globals.GLOVE_COLOR && !this.hasSockPants())
                        {
                           continue;
                        }
                     }
                     (_loc4_ = this.getPart(_loc5_)).setColor(_loc8_,_loc6_);
                  }
               }
            }
            _loc6_++;
         }
         if(Main.isCharCreate() && param1 == Globals.SKIN_COLOR && param2 is uint)
         {
            this.setColor(Globals.LIP_COLOR,param2 + 1);
         }
      }
      
      private function getFootColor() : uint
      {
         if(this.hasSocks())
         {
            return Globals.SOCK_COLOR;
         }
         if(this.hasSockPants())
         {
            return Globals.GLOVE_COLOR;
         }
         return Globals.SKIN_COLOR;
      }
      
      private function hasSockPants() : Boolean
      {
         return this.partExists("lowerLeg1") && Utils.inArray(this.getPantsType(),this.skinInfo.looksPantsSocked);
      }
      
      private function hasSocks() : Boolean
      {
         if(this.partExists("sock1"))
         {
            return !Utils.inArray(this.getPart("sock1").look,this.skinInfo.looksSocksNone);
         }
         return false;
      }
      
      private function getOppositePartName(param1:String) : String
      {
         var _loc2_:String = getSuffix(param1);
         var _loc3_:String = this.getBaseName(param1);
         if(_loc2_ == "1")
         {
            return _loc3_ + "2";
         }
         if(_loc2_ == "2")
         {
            return _loc3_ + "1";
         }
         return null;
      }
      
      private function getBaseName(param1:String) : String
      {
         var _loc2_:String = getSuffix(param1);
         if(_loc2_ == "1" || _loc2_ == "2")
         {
            return param1.substr(0,param1.length - 1);
         }
         return param1;
      }
      
      public function getPart(param1:*) : BodyPart
      {
         if(param1 == null || this.normalizePartName(param1) == null)
         {
            return null;
         }
         if(!(param1 is String))
         {
            param1 = param1.name;
         }
         return this.bodyParts[map[this.skinType][this.normalizePartName(param1)]] as BodyPart;
      }
      
      public function getPickerColor(param1:String) : uint
      {
         return colorPrimaryMap[this.skinType][param1];
      }
      
      public function getColor(param1:uint) : uint
      {
         return this.colors[param1];
      }
      
      public function getColorType(param1:String, param2:uint) : int
      {
         if(colorAllMap[this.skinType] == null || colorAllMap[this.skinType][param1] == null || colorAllMap[this.skinType][param1][param2] == null)
         {
            return -1;
         }
         return colorAllMap[this.skinType][param1][param2];
      }
      
      public function randomize(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:BodyPart = null;
         switch(param1)
         {
            case LOOKS:
               this.heightScale = Utils.normalize(this.skinInfo.minHeight,this.skinInfo.maxHeight);
               if(!param2)
               {
                  this.widthScale = Utils.normalize(this.minWidth,this.maxWidth,1);
               }
               else
               {
                  this.widthScale = 1;
               }
               if(!param2 && this.isHuman())
               {
                  (_loc7_ = this.getPart(this.skinInfo.pivots["mouth"])).randomizePivot("eye1",this.skinInfo.movableLookMap["eye1"],false);
                  _loc7_.randomizePivot("mouth",this.skinInfo.movableLookMap["mouth"],false);
                  for each(_loc4_ in this.skinInfo.movableLookNames)
                  {
                     if(!(_loc4_.indexOf("Arm") != -1 || _loc4_.indexOf("Leg") != -1))
                     {
                        _loc5_ = this.getMovableConstraints(_loc4_);
                        this.sizableLookData[_loc4_] = {
                           "scaleX":Utils.normalize(_loc5_.xMin,_loc5_.xMax),
                           "scaleY":Utils.normalize(_loc5_.yMin,_loc5_.yMax),
                           "rotation":Utils.normalize(_loc5_.rMin,_loc5_.rMax)
                        };
                        if(_loc5_.linkXY)
                        {
                           this.sizableLookData[_loc4_].scaleY = this.sizableLookData[_loc4_].scaleX;
                        }
                        this.doSymmetryScalables(_loc4_);
                     }
                  }
                  this.updateScale();
               }
               this.doSymmetryPivots("eye1");
               this.doSymmetryPivots("mouth");
               break;
            case COLORS:
               _loc6_ = [Globals.SKIN_COLOR,Globals.HAIR_COLOR,Globals.LIP_COLOR,Globals.SHIRT_COLOR,Globals.PANT_COLOR,Globals.SHOE_COLOR,Globals.HAT_COLOR,Globals.GLOVE_COLOR,Globals.ACCESSORY_COLOR,Globals.IRIS_COLOR,Globals.EYELID_COLOR,Globals.SOCK_COLOR];
               if(!param2)
               {
                  for each(_loc3_ in _loc6_)
                  {
                     this.setColor(_loc3_,Palette.getRandomColor(param1,this.skinType));
                  }
               }
               else
               {
                  for each(_loc3_ in _loc6_)
                  {
                     if(_loc3_ == Globals.SKIN_COLOR && this.isHuman())
                     {
                        this.setColor(_loc3_,2 + Math.floor(Math.random() * 7));
                     }
                     else
                     {
                        this.setColor(_loc3_,this.getDefaultColor(param1,this.skinType));
                     }
                  }
               }
               break;
            case EXPRESSION:
         }
      }
      
      private function getDefaultColor(param1:int, param2:int) : uint
      {
         if(this.skinInfo.defaultColor != null && this.skinInfo.defaultColor[param1] != null)
         {
            return this.skinInfo.defaultColor[param1];
         }
         return Palette.getDefaultColor(param1,param2);
      }
      
      private function getMovableConstraints(param1:String) : Object
      {
         var _loc2_:Object = {"linkXY":true};
         var _loc3_:Object = this.skinInfo.movableLookMap[param1];
         if(this.skinInfo.movableLookMap[param1].sxy1 != null)
         {
            _loc2_.xMin = _loc3_.sxy1;
            _loc2_.xMax = _loc3_.sxy2;
            _loc2_.yMin = _loc2_.xMin;
            _loc2_.yMax = _loc2_.xMax;
         }
         else if(this.skinInfo.movableLookMap[param1].sx1 == null)
         {
            _loc2_.xMin = 1;
            _loc2_.xMax = 1;
            _loc2_.yMin = _loc3_.sy1;
            _loc2_.yMax = _loc3_.sy2;
         }
         else if(this.skinInfo.movableLookMap[param1].sy1 == null)
         {
            _loc2_.xMin = _loc3_.sx1;
            _loc2_.xMax = _loc3_.sx2;
            _loc2_.yMin = 1;
            _loc2_.yMax = 1;
         }
         else
         {
            _loc2_.xMin = _loc3_.sx1;
            _loc2_.xMax = _loc3_.sx2;
            _loc2_.yMin = _loc3_.sy1;
            _loc2_.yMax = _loc3_.sy2;
            _loc2_.linkXY = false;
         }
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         _loc2_.rMin = _loc3_.r == null ? 0 : -_loc3_.r;
         _loc2_.rMax = _loc3_.r == null ? 0 : _loc3_.r;
         return _loc2_;
      }
      
      public function getMouthPos() : Point
      {
         var _loc1_:String = null;
         var _loc2_:MovieClip = null;
         if(this.partExists("mouth"))
         {
            _loc1_ = "mouth";
         }
         else if(this.partExists("head"))
         {
            _loc1_ = "head";
         }
         if(_loc1_ == null)
         {
            return _loc2_.localToGlobal(new Point(0,0));
         }
         _loc2_ = this.getPart(_loc1_).target;
         return _loc2_.parent.localToGlobal(new Point(_loc2_.x,_loc2_.y));
      }
      
      public function revealHotspot(param1:String, param2:Array) : void
      {
         this.getPart(param1).revealHotspot(param2);
      }
      
      public function concealHotspot(param1:String) : void
      {
         this.getPart(param1).concealHotspot();
      }
      
      private function updateForeshortening(param1:String, param2:String) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(this.target[param2] == null)
         {
            return;
         }
         if(this.getDrawing(param2,2) != null && this.target[param2].parent != null && this.target["upperLeg2"].parent != null)
         {
            _loc3_ = this.target.getChildIndex(this.target[param2]);
            if((_loc4_ = this.target.getChildIndex(this.target["upperLeg2"])) < _loc3_)
            {
               this.legBehind = 2;
            }
            else
            {
               this.legBehind = 1;
            }
         }
         else
         {
            this.legBehind = 0;
         }
         if(this.getDrawing(param1,2) != null && this.target[param1].parent != null && this.target["upperArm2"].parent != null)
         {
            _loc3_ = this.target.getChildIndex(this.target[param1]);
            if((_loc4_ = this.target.getChildIndex(this.target["upperArm2"])) < _loc3_)
            {
               this.armBehind = 2;
            }
            else
            {
               this.armBehind = 1;
            }
         }
         else
         {
            this.armBehind = 0;
         }
      }
      
      private function updateDepths() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:* = false;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:DisplayObject = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:DisplayObject = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:uint = 0;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:String = null;
         var _loc24_:String = null;
         var _loc25_:String = null;
         var _loc32_:String = null;
         var _loc36_:BodyPart = null;
         var _loc37_:Boolean = false;
         var _loc38_:uint = 0;
         var _loc39_:uint = 0;
         var _loc40_:uint = 0;
         var _loc41_:int = 0;
         var _loc42_:Number = NaN;
         if(!this.isHuman() || this.target["lowerArm" + this.normalizeSuffix("1")] == null)
         {
            return;
         }
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         _loc17_ = 0;
         while(_loc17_ < 2)
         {
            _loc1_ = _loc17_ == 0 ? FOOT : HAND;
            _loc2_ = _loc1_ == FOOT ? "Leg" : "Arm";
            _loc20_ = _loc1_ == FOOT || !this.partExists("ribs") ? "torso" : "ribs";
            _loc7_ = 0;
            while(_loc7_ < 2)
            {
               _loc9_ = (_loc7_ + 1).toString();
               _loc10_ = this.target["upper" + _loc2_ + this.normalizeSuffix(_loc9_)];
               _loc11_ = this.target["lower" + _loc2_ + this.normalizeSuffix(_loc9_)];
               _loc12_ = this.target[_loc1_ + this.normalizeSuffix(_loc9_)];
               _loc13_ = Utils.normalizeAngle(this.getRotation(_loc10_) - this.getRotation(this.target[_loc20_]));
               _loc14_ = Utils.normalizeAngle(this.getRotation(_loc11_) - this.getRotation(_loc10_));
               _loc15_ = Utils.normalizeAngle(this.getRotation(_loc12_) - this.getRotation(_loc11_));
               _loc16_ = Utils.normalizeAngle(this.getRotation(_loc11_) - this.getRotation(this.target[_loc20_]));
               if(_loc1_ == FOOT)
               {
                  _loc3_ = Utils.wrap(_loc14_) > 180 ? Number(-1) : Number(1);
                  if(_loc9_ == "1")
                  {
                     _loc3_ *= -1;
                  }
                  _loc4_ = _loc3_ == -1;
                  this.getPart(_loc1_ + this.normalizeSuffix(_loc9_)).flippedY = _loc4_;
                  this.getPart("lowerLeg" + this.normalizeSuffix(_loc9_)).flippedX = _loc4_;
                  this.getPart("upperLeg" + this.normalizeSuffix(_loc9_)).flippedX = _loc4_;
                  if(this.partExists("sock1"))
                  {
                     this.getPart("sock" + this.normalizeSuffix(_loc9_)).flippedX = _loc4_;
                  }
                  if(this.getPart(_loc1_ + this.normalizeSuffix(_loc9_)).flippedY && (_loc13_ > 0 && _loc13_ < 180))
                  {
                     _loc5_[_loc17_] = _loc9_;
                     _loc6_[_loc17_] = true;
                  }
                  _loc18_ = _loc9_ == "1" ? Number(45) : Number(-135);
                  _loc19_ = _loc9_ == "1" ? Number(135) : Number(-45);
                  if(_loc15_ < _loc18_)
                  {
                     this.setRotation(_loc12_,this.getRotation(_loc11_) + _loc18_);
                  }
                  else if(_loc15_ > _loc19_)
                  {
                     this.setRotation(_loc12_,this.getRotation(_loc11_) + _loc19_);
                  }
               }
               else
               {
                  _loc3_ = Utils.wrap(_loc14_) > 180 ? Number(-1) : Number(1);
                  if(_loc9_ == "1")
                  {
                     _loc3_ *= -1;
                  }
                  _loc4_ = _loc3_ == -1;
                  this.getPart("lowerArm" + this.normalizeSuffix(_loc9_)).flippedX = _loc4_;
                  _loc18_ = _loc9_ == "2" ? Number(0) : Number(-180);
                  _loc19_ = _loc9_ == "2" ? Number(180) : Number(0);
                  if(_loc13_ > 0 && _loc13_ < 180)
                  {
                     if(_loc14_ > _loc18_ && _loc14_ < _loc19_)
                     {
                        _loc5_[_loc17_] = _loc9_;
                        _loc6_[_loc17_] = true;
                     }
                     else if(_loc9_ == "1" && _loc13_ > 120 || _loc9_ == "2" && _loc13_ < 60)
                     {
                        _loc5_[_loc17_] = _loc9_;
                        _loc6_[_loc17_] = false;
                     }
                  }
                  if(this.skinInfo.range != null && this.skinInfo.range.hand1 != null)
                  {
                     _loc18_ = this.skinInfo.range.hand1[0];
                     _loc19_ = this.skinInfo.range.hand1[1];
                  }
               }
               _loc7_++;
            }
            _loc17_++;
         }
         var _loc26_:Boolean = false;
         var _loc27_:uint = this.getTurn("ribs");
         if(this.partExists("accessory"))
         {
            _loc26_ = Utils.inArray(this.getPart("accessory").look,this.skinInfo.looksAccessoriesUnder);
         }
         if((_loc27_ == TURNED_TOWARD || _loc27_ == TURNED_AWAY) && this.skinType != Globals.NICK_SB)
         {
            if(_loc5_[0] != null)
            {
               if(_loc6_[0])
               {
                  _loc22_ = _loc5_[0];
               }
               else
               {
                  _loc22_ = this.oppositeSide(_loc5_[0]);
               }
            }
            else
            {
               _loc22_ = "1";
            }
            if(_loc5_[1] != null)
            {
               if(_loc6_[1])
               {
                  _loc24_ = _loc5_[1];
               }
               else
               {
                  _loc24_ = this.oppositeSide(_loc5_[1]);
               }
            }
            else
            {
               _loc24_ = "1";
            }
         }
         else
         {
            _loc24_ = _loc22_ = _loc27_ > TURNED_AWAY ? "2" : "1";
         }
         _loc23_ = this.oppositeSide(_loc22_);
         _loc25_ = this.oppositeSide(_loc24_);
         var _loc28_:Boolean = false;
         var _loc29_:Array = ["headBack","headFront"];
         if(this.isFacingAway(_loc27_))
         {
            _loc29_.reverse();
         }
         var _loc30_:Array = [];
         if(this.skinInfo.orderParts != null)
         {
            _loc30_ = this.skinInfo.orderParts;
         }
         else
         {
            _loc30_.push(_loc29_[0]);
            if(this.partExists("capeBehind"))
            {
               _loc30_.push("capeBehind");
            }
            if(_loc27_ == TURNED_TOWARD || _loc27_ == TURNED_AWAY)
            {
               if(_loc6_[1] == false)
               {
                  _loc30_.push([HAND,_loc25_]);
               }
            }
            else
            {
               _loc30_.push([HAND,_loc25_]);
               if(this.isLongBelt())
               {
                  if(!this.isFacingAway(_loc27_))
                  {
                     _loc30_.push([FOOT,_loc23_],[FOOT,_loc22_]);
                  }
               }
               else
               {
                  _loc30_.push([FOOT,_loc23_]);
               }
            }
            _loc37_ = Utils.inArray(this.getPart("collar").look,this.skinInfo.looksCollarsLong);
            if(this.isFacingAway(_loc27_))
            {
               if(this.partExists("belt"))
               {
                  _loc30_.push("belt");
               }
               if(this.partExists("detail"))
               {
                  _loc30_.push("detail");
               }
               if(_loc37_ && this.partExists("collarBehind"))
               {
                  _loc30_.push("collarBehind");
               }
               _loc30_.push("torso");
               if(this.partExists("ribs"))
               {
                  _loc30_.push("ribs");
               }
            }
            else
            {
               if(this.partExists("ribs"))
               {
                  _loc30_.push("ribs");
               }
               _loc30_.push("torso");
            }
            if(this.partExists("breasts"))
            {
               _loc30_.push("breasts");
            }
            if(this.partExists("detail") && !this.isFacingAway(_loc27_))
            {
               _loc30_.push("detail");
            }
            if(this.partExists("collarBehind") && (!_loc37_ || !this.isFacingAway(_loc27_)))
            {
               _loc30_.push("collarBehind");
            }
            if(this.partExists("neck"))
            {
               _loc30_.push("neck");
            }
            if(this.partExists("collar") && !this.isBeltExt())
            {
               _loc30_.push("collar");
            }
            if(this.partExists("belt") && !this.isFacingAway(_loc27_))
            {
               _loc30_.push("belt");
            }
            if(this.partExists("collar") && this.isBeltExt())
            {
               _loc30_.push("collar");
            }
            if(this.partExists("cape"))
            {
               _loc30_.push("cape");
            }
            _loc30_.push(_loc29_[1]);
            if(this.partExists("accessory"))
            {
               _loc30_.push("accessory");
            }
            if(_loc27_ == TURNED_TOWARD || _loc27_ == TURNED_AWAY)
            {
               _loc30_.push([FOOT,_loc23_],[FOOT,_loc22_]);
               if(this.isLongBelt())
               {
                  _loc30_.push("belt");
               }
               if(this.skinType == Globals.HUMAN && this.partExists("accessory"))
               {
                  _loc30_.push("accessory2");
               }
               if(_loc6_[1] == false)
               {
                  _loc30_.push([HAND,_loc24_]);
               }
               else
               {
                  _loc30_.push([HAND,_loc25_],[HAND,_loc24_]);
               }
            }
            else
            {
               if(this.skinType == Globals.HUMAN && this.partExists("accessory"))
               {
                  _loc30_.push("accessory2");
               }
               if(this.isLongBelt() && this.isFacingAway(_loc27_))
               {
                  _loc30_.push([FOOT,_loc23_]);
               }
               if(!this.isLongBelt())
               {
                  _loc30_.push([FOOT,_loc22_]);
               }
               if(this.isLongBelt() && !this.isFacingAway(_loc27_))
               {
                  _loc30_.push("belt");
               }
               if(!_loc28_)
               {
                  _loc30_.push([HAND,_loc24_]);
               }
            }
            if(this.isFacingAway(_loc27_))
            {
               _loc30_.reverse();
            }
         }
         var _loc31_:Object = this.getHeadParts(this.skinType);
         _loc8_ = _loc30_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(typeof _loc30_[_loc7_] == "string")
            {
               if(_loc30_[_loc7_] == "headBack")
               {
                  if(_loc31_[BACK] != null)
                  {
                     for each(_loc32_ in _loc31_[BACK])
                     {
                        this.bringPartToFront(_loc32_);
                     }
                  }
               }
               else if(_loc30_[_loc7_] == "headFront")
               {
                  if(_loc31_[FRONT] != null)
                  {
                     for each(_loc32_ in _loc31_[FRONT])
                     {
                        this.bringPartToFront(_loc32_);
                     }
                  }
               }
               else if(_loc30_[_loc7_] == "legBack")
               {
                  this.bringPartToFront(FOOT,_loc23_);
               }
               else if(_loc30_[_loc7_] == "legFront")
               {
                  this.bringPartToFront(FOOT,_loc22_);
               }
               else if(_loc30_[_loc7_] == "armBack")
               {
                  this.bringPartToFront(HAND,_loc25_);
               }
               else if(_loc30_[_loc7_] == "armFront")
               {
                  this.bringPartToFront(HAND,_loc24_);
               }
               else if(_loc30_[_loc7_] == "accessory2")
               {
                  if(!_loc26_)
                  {
                     this.bringPartToFront("accessory");
                  }
               }
               else
               {
                  this.bringPartToFront(_loc30_[_loc7_]);
               }
            }
            else
            {
               this.bringPartToFront(_loc30_[_loc7_][0],_loc30_[_loc7_][1]);
            }
            _loc7_++;
         }
         var _loc33_:BodyPart = this.getPart("hair");
         var _loc34_:BodyPart = this.getPart("upperArm" + _loc24_);
         var _loc35_:BodyPart = this.getPart("upperArm" + _loc25_);
         if(_loc33_ != null && _loc33_.isLong && _loc34_ != null && _loc35_ != null && _loc34_.target != null && _loc35_.target != null && _loc34_.target.parent != null && _loc35_.target.parent != null)
         {
            _loc38_ = _loc33_.target.parent.getChildIndex(_loc33_.target);
            _loc39_ = _loc34_.target.parent.getChildIndex(_loc34_.target);
            _loc40_ = _loc35_.target.parent.getChildIndex(_loc35_.target);
            _loc41_ = this.getTurn("torso");
            _loc13_ = Utils.normalizeAngle(_loc34_.target.rotation - _loc33_.target.rotation);
            _loc14_ = Utils.normalizeAngle(_loc35_.target.rotation - _loc33_.target.rotation);
            if(getSuffix(_loc24_) == "1")
            {
               _loc18_ = 0;
               _loc19_ = 90;
            }
            else
            {
               _loc18_ = 90;
               _loc19_ = 180;
            }
            if(_loc13_ < _loc18_ || _loc13_ > _loc19_)
            {
               if(_loc41_ == 0)
               {
                  _loc34_.target.parent.setChildIndex(_loc34_.target,_loc38_);
               }
               else if(_loc41_ == 1 || _loc41_ == 5)
               {
                  _loc34_.target.parent.setChildIndex(_loc34_.target,_loc38_);
               }
            }
            if(_loc41_ == 0)
            {
               if(getSuffix(_loc25_) == "1")
               {
                  _loc18_ = 0;
                  _loc19_ = 90;
               }
               else
               {
                  _loc18_ = 90;
                  _loc19_ = 180;
               }
               if(_loc14_ < _loc18_ || _loc13_ > _loc19_)
               {
                  _loc35_.target.parent.setChildIndex(_loc35_.target,_loc38_);
               }
            }
         }
         if(this.skinType == Globals.HUMAN && _loc27_ == TURNED_TOWARD && this.partExists("accessory"))
         {
            _loc42_ = this.getRotation(this.target["accessory"]) - this.getRotation(this.target["ribs"]);
            if(this.skinInfo.range != null && (this.skinInfo.range.accessory == null || !(_loc42_ > this.skinInfo.range.accessory[0] && _loc42_ < this.skinInfo.range.accessory[1])))
            {
               this.bringPartToFront("accessory");
            }
         }
         _loc8_ = this.props.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc36_ = this.getPart(this.props[_loc7_].part);
            this.target.setChildIndex(this.props[_loc7_].target,this.target.getChildIndex(_loc36_.target));
            _loc7_++;
         }
      }
      
      private function isFacingAway(param1:uint) : Boolean
      {
         return Utils.inArray(param1,[2,3,4]);
      }
      
      private function getHeadParts(param1:uint, param2:Boolean = false) : *
      {
         var _loc3_:Object = null;
         if(param2)
         {
            if(this.skinInfo.turningParts == null || this.skinInfo.turningParts[this.skinInfo.rootHeadPart] == null)
            {
               return this.skinInfo.headParts as Array;
            }
            _loc3_ = this.skinInfo.headParts[this.getTurn(this.skinInfo.rootHeadPart)];
            return _loc3_[BACK].concat(_loc3_[FRONT]);
         }
         if(this.skinInfo.turningParts == null || this.skinInfo.turningParts[this.skinInfo.rootHeadPart] == null)
         {
            return {"FRONT":this.skinInfo.headParts};
         }
         if(this.skinInfo.headParts != null)
         {
            return Utils.clone(this.skinInfo.headParts[this.getTurn(this.skinInfo.rootHeadPart)]);
         }
         return [];
      }
      
      private function oppositeSide(param1:String) : String
      {
         return param1 == "1" ? "2" : "1";
      }
      
      private function bringPartToFront(param1:String, param2:String = null) : void
      {
         var _loc3_:DisplayObject = null;
         if(VERBOSE)
         {
            Debug.trace("to front: " + Utils.toString(param1) + "; " + param2);
         }
         if(param1.charAt(0) == "/")
         {
            if(!this.getPart(param1.substr(1)).onTop)
            {
               return;
            }
            param1 = param1.substr(1);
         }
         if(param1 == HAND || param1 == FOOT)
         {
            this.limbToFront(param1,param2);
         }
         else
         {
            _loc3_ = this.target[param1];
            if(this.target[param1].parent != null)
            {
               _loc3_.parent.setChildIndex(_loc3_,this.target.numChildren - 1);
               this.onPartToFront(param1);
            }
         }
      }
      
      private function limbToFront(param1:String, param2:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc7_:DisplayObject = null;
         var _loc8_:uint = 0;
         if(Utils.inArray(this.skinType,[Globals.BIRD,Globals.DINOSAUR]))
         {
            return;
         }
         param2 = this.normalizeSuffix(param2);
         if(param1 == FOOT)
         {
            _loc4_ = this.getTurn("torso");
            _loc5_ = this.isFacingAway(_loc4_);
            _loc3_ = ["upperLeg"];
            if(!_loc5_ && this.getPart("lowerLeg" + param2).flippedX || _loc5_ && !this.getPart("lowerLeg" + param2).flippedX)
            {
               if(this.partExists("sock"))
               {
                  _loc3_.unshift("sock");
               }
               _loc3_.unshift("lowerLeg");
            }
            else
            {
               _loc3_.push("lowerLeg");
               if(this.partExists("sock"))
               {
                  _loc3_.push("sock");
               }
            }
            if(this.bareAnkles() || this.isBootSock(!!this.partExists("sock" + this.normalizeSuffix("1")) ? int(this.getPart("sock" + this.normalizeSuffix("1")).look) : -1) || Utils.inArray(this.getPart("lowerLeg" + this.normalizeSuffix("1")).look,this.skinInfo.looksPantsNarrow))
            {
               _loc3_.push(FOOT);
            }
            else
            {
               _loc3_.unshift(FOOT);
            }
         }
         else
         {
            _loc4_ = this.getTurn("ribs");
            _loc5_ = this.isFacingAway(_loc4_);
            if(this.skinInfo.armParts2 is Array)
            {
               if(_loc5_)
               {
                  _loc3_ = this.skinInfo.armParts2[1];
               }
               else
               {
                  _loc3_ = this.skinInfo.armParts2[0];
               }
            }
            else
            {
               _loc3_ = this.skinInfo.armParts2;
            }
         }
         var _loc6_:uint = this.target.numChildren - 1;
         var _loc9_:uint = _loc3_.length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            if((_loc7_ = this.target[_loc3_[_loc8_] + param2]).parent != null)
            {
               _loc7_.parent.setChildIndex(_loc7_,_loc6_);
               this.onPartToFront(_loc3_[_loc8_] + param2);
            }
            _loc8_++;
         }
      }
      
      private function onPartToFront(param1:String) : void
      {
         if(this.target.drawing != null && (Utils.inArray(param1,["torso","foot1","foot2"]) || Utils.inArray(param1,this.skinInfo.legParts)))
         {
            this.target.setChildIndex(this.target.drawing,this.target.numChildren - 1);
         }
      }
      
      public function getPositionData() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.skinInfo.parts)
         {
            if(_loc2_ == null)
            {
               _loc1_.push(null);
            }
            else if(this.target[_loc2_] != null)
            {
               _loc1_.push(this.getRotation(this.target[_loc2_]));
            }
         }
         return _loc1_;
      }
      
      public function setPositionData(param1:Array, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param1 != null)
         {
            _loc5_ = this.skinInfo.parts.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(this.skinInfo.parts[_loc4_] != null)
               {
                  if(param2 && param3 || param2 && Utils.inArray(this.skinInfo.parts[_loc4_],this.skinInfo.faceParts) || param3 && !Utils.inArray(this.skinInfo.parts[_loc4_],this.skinInfo.faceParts))
                  {
                     if(isNaN(param1[_loc4_]))
                     {
                        if(Utils.inArray(this.skinInfo.parts[_loc4_],["earring1"]))
                        {
                           param1[_loc4_] = 0;
                        }
                        else if(Utils.inArray(this.skinInfo.parts[_loc4_],["earring2"]))
                        {
                           param1[_loc4_] = 180;
                        }
                        else
                        {
                           param1[_loc4_] = this.getRotation(this.target["torso"]);
                        }
                     }
                     this.setRotation(this.target[this.skinInfo.parts[_loc4_]],param1[_loc4_]);
                  }
               }
               _loc4_++;
            }
         }
      }
      
      public function getExpressionData() : Array
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = [];
         var _loc3_:uint = this.bodyParts.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.bodyParts[_loc2_] == null)
            {
               _loc1_[_loc2_] = 0;
            }
            else
            {
               _loc1_[_loc2_] = this.bodyParts[_loc2_].expression;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setExpressionData(param1:Array, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc4_:BodyPart = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = this.bodyParts.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(!(this.bodyParts[_loc5_] == null || param1 == null))
            {
               _loc4_ = BodyPart(this.bodyParts[_loc5_]);
               if(param2 && param3 || param2 && Utils.inArray(_loc4_.getTargetName(),this.skinInfo.faceParts) || param3 && !Utils.inArray(_loc4_.getTargetName(),this.skinInfo.faceParts))
               {
                  _loc4_.expression = param1[_loc5_];
               }
            }
            _loc5_++;
         }
         this.drawHead();
      }
      
      public function getLooksData() : Array
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = [];
         var _loc3_:uint = this.bodyParts.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.bodyParts[_loc2_] == null)
            {
               _loc1_[_loc2_] = null;
            }
            else
            {
               _loc1_[_loc2_] = BodyPart(this.bodyParts[_loc2_]).look;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setLooksData(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = this.bodyParts.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(!(this.bodyParts[_loc7_] == null || param1 == null))
            {
               _loc6_ = BodyPart(this.bodyParts[_loc7_]).getTargetName();
               if(!(param2 && (Utils.empty(this.skinInfo.outfitParts) || !Utils.inArray(_loc6_,this.skinInfo.outfitParts))))
               {
                  if(this.isHuman())
                  {
                     if(this.version < 2 && Utils.inArray(_loc6_,["eye1","eye2"]))
                     {
                        param1[_loc7_] = Math.floor(param1[_loc7_] / 2);
                     }
                     else if(_loc6_ == "torso")
                     {
                        _loc4_ = param1[_loc7_];
                     }
                     else if(_loc6_ == "head")
                     {
                        _loc5_ = param1[_loc7_];
                     }
                     else if(_loc6_ == "ribs" && param1[_loc7_] == null)
                     {
                        param1[_loc7_] = _loc4_;
                     }
                     else if(_loc6_ == "chin" && param1[_loc7_] == null)
                     {
                        param1[_loc7_] = _loc5_;
                     }
                     if(!Character.ALLOW_FEMALE)
                     {
                        if(_loc6_ == "breasts")
                        {
                           param1[_loc7_] = 0;
                        }
                        else if(Utils.inArray(_loc6_,this.skinInfo.armParts) && this.skinInfo.looksShirtsNone && Utils.inArray(param1[_loc7_],this.skinInfo.looksShirtsNone))
                        {
                           param1[_loc7_] = SHIRT_SHORT;
                        }
                     }
                  }
                  if(param1[_loc7_] >= BodyPart(this.bodyParts[_loc7_]).numLooks)
                  {
                     param1[_loc7_] = 0;
                  }
                  BodyPart(this.bodyParts[_loc7_]).look = param1[_loc7_];
               }
            }
            _loc7_++;
         }
         if(this.biped && this.partExists("sock1"))
         {
            this.enforceLooks(this.getPart("sock1"));
         }
         this.updateHairMask();
      }
      
      public function getExtraLooksData() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         var _loc4_:String = null;
         var _loc3_:Object = {};
         _loc3_["m"] = [];
         _loc3_["s"] = [];
         for each(_loc4_ in this.skinInfo.movableLookNames)
         {
            _loc3_["s"].push(this.sizableLookData[_loc4_]);
            _loc1_ = this.movableLookData[_loc4_];
            if(_loc1_ != null)
            {
               _loc3_["m"].push(_loc1_);
            }
         }
         _loc3_["v"] = VERSION;
         return _loc3_;
      }
      
      public function setExtraLooksData(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:String = null;
         var _loc3_:uint = this.skinInfo.movableLookNames.length;
         if(param1 != null)
         {
            if(param1["m"] == null)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  _loc4_ = this.skinInfo.movableLookNames[_loc2_];
                  this.movableLookData[_loc4_] = [0,0];
                  _loc2_++;
               }
               this.version = 0;
            }
            else
            {
               this.version = param1["v"];
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  _loc4_ = this.skinInfo.movableLookNames[_loc2_];
                  this.movableLookData[_loc4_] = param1["m"][_loc2_];
                  if(param1["s"] != null)
                  {
                     this.sizableLookData[_loc4_] = param1["s"][_loc2_];
                  }
                  _loc2_++;
               }
            }
         }
         this.renderExtraLooksData();
         this.reposition(this.skinInfo.rootHeadPart);
         this.drawHead();
      }
      
      private function renderExtraLooksData() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = null;
         for(_loc2_ in this.movableLookData)
         {
            this.getPart(this.skinInfo.pivots[_loc2_]).setPivotData(_loc2_,this.movableLookData[_loc2_]);
            if(this.skinInfo.matchScale != null && this.skinInfo.matchScale[_loc2_] != null)
            {
               for each(_loc1_ in this.skinInfo.matchScale[_loc2_])
               {
                  this.getPart(this.skinInfo.pivots[_loc1_]).setPivotData(_loc1_,this.movableLookData[_loc2_]);
               }
            }
         }
      }
      
      public function getExtraPositionData() : Object
      {
         var _loc1_:String = null;
         var _loc2_:Object = {};
         _loc2_["m"] = {};
         for each(_loc1_ in this.skinInfo.movableParts)
         {
            if(this.isMovableExpression(_loc1_))
            {
               _loc2_["m"][_loc1_] = this.getPart(_loc1_).getMovablePos();
            }
         }
         _loc2_["t"] = {};
         for each(_loc1_ in this.skinInfo.saveTurningParts)
         {
            _loc2_["t"][_loc1_] = this.getTurn(_loc1_);
         }
         _loc2_["h"] = this.hiddenPartData;
         return _loc2_;
      }
      
      public function setExtraPositionData(param1:Object) : void
      {
         var _loc2_:* = null;
         if(param1["m"] == null)
         {
            for(_loc2_ in param1)
            {
               this.getPart(_loc2_).setMovablePos(param1[_loc2_]);
            }
         }
         else
         {
            for(_loc2_ in param1["m"])
            {
               this.getPart(_loc2_).setMovablePos(param1["m"][_loc2_]);
            }
            for(_loc2_ in param1["t"])
            {
               this.setTurn(_loc2_,param1["t"][_loc2_]);
            }
            if(param1["h"] != null)
            {
               for(_loc2_ in param1["h"])
               {
                  this.hidePart(_loc2_,param1["h"][_loc2_],false,true);
               }
            }
         }
      }
      
      public function get widthScale() : Number
      {
         return this.scaleW;
      }
      
      public function set widthScale(param1:Number) : void
      {
         this.scaleW = param1;
         if(this.scaleW < this.minWidth)
         {
            this.scaleW = this.minWidth;
         }
         else if(this.scaleW > this.maxWidth)
         {
            this.scaleW = this.maxWidth;
         }
         this.updateScale();
      }
      
      public function get heightScale() : Number
      {
         return this.scaleH;
      }
      
      public function set heightScale(param1:Number) : void
      {
         this.scaleH = param1;
         if(this.scaleH < this.skinInfo.minHeight)
         {
            this.scaleH = this.skinInfo.minHeight;
         }
         else if(this.scaleH > this.skinInfo.maxHeight)
         {
            this.scaleH = this.skinInfo.maxHeight;
         }
         this.minWidth = this.skinInfo.minWidth * Math.pow(this.scaleH,this.skinInfo.widthFactor);
         this.maxWidth = this.skinInfo.maxWidth * Math.pow(this.scaleH,this.skinInfo.widthFactor);
         this.widthScale = this.widthScale;
         this.updateScale();
      }
      
      private function updateScale() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:* = false;
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:* = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Array = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:* = null;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         if(this.isHuman())
         {
            for each(_loc1_ in this.skinInfo.parts)
            {
               this.setScaleX(_loc1_,1);
               this.setScaleY(_loc1_,1);
            }
         }
         for each(_loc1_ in this.skinInfo.parts)
         {
            if(_loc1_ != null)
            {
               _loc3_ = false;
               if(this.skinInfo.narrowShoulders != null && this.skinInfo.narrowShoulders[this.skinInfo.rootBodyPart] != null)
               {
                  if(_loc1_ == "shoulder1" || _loc1_ == "shoulder2")
                  {
                     _loc3_ = !Utils.inArray(this.getPart("ribs").look,this.skinInfo.narrowShoulders[this.skinInfo.rootBodyPart]);
                  }
                  else if(Utils.inArray(_loc1_,["lowerArm1","lowerArm2","upperArm1","upperArm2"]))
                  {
                     _loc3_ = !Utils.inArray(this.getPart("ribs").look,this.skinInfo.narrowShoulders[this.skinInfo.rootBodyPart]);
                  }
               }
               if(this.skinInfo.wExcludes == null || this.skinInfo.wExcludes[_loc1_] == null || _loc3_)
               {
                  this.setScaleX(_loc1_,this.scaleW);
               }
               else if(this.skinInfo.wExcludes[_loc1_] < 0)
               {
                  if(this.scaleW / this.scaleH > -this.skinInfo.wExcludes[_loc1_])
                  {
                     this.setScaleX(_loc1_,-this.skinInfo.wExcludes[_loc1_] * this.scaleH);
                  }
                  else
                  {
                     this.setScaleX(_loc1_,this.scaleW);
                  }
               }
               else if(this.skinInfo.wExcludes[_loc1_] != 0)
               {
                  this.setScaleX(_loc1_,Math.max(1 + (this.scaleW - 1) * this.skinInfo.wExcludes[_loc1_],1));
               }
               if(this.skinInfo.hExcludes == null || this.skinInfo.hExcludes[_loc1_] == null)
               {
                  this.setScaleY(_loc1_,this.scaleH * this.getYStretch(_loc1_));
               }
               else if(this.skinInfo.hExcludes[_loc1_] != 0)
               {
                  this.setScaleY(_loc1_,Math.max(1 + (this.scaleH - 1) * this.skinInfo.hExcludes[_loc1_],0.8));
               }
            }
         }
         if(this.skinInfo.faceParts != null)
         {
            for each(_loc1_ in this.skinInfo.faceParts)
            {
               this.setScaleX(_loc1_,this.getScaleY(this.skinInfo.rootHeadPart));
               this.setScaleY(_loc1_,this.getScaleY(this.skinInfo.rootHeadPart));
            }
         }
         if(this.isHuman(true))
         {
            this.setScaleY("hand1",Math.pow(this.getScaleY("torso"),0.5));
            this.setScaleX("hand1",this.getScaleY("hand1"));
            this.setScaleY("hand2",this.getScaleY("hand1"));
            this.setScaleX("hand2",this.getScaleY("hand2"));
            if(this.getScaleX("foot1") / this.getScaleY("foot1") > MAX_FOOT_RATIO)
            {
               this.setScaleX("foot1",MAX_FOOT_RATIO * this.getScaleY("foot1"));
               this.setScaleX("foot2",MAX_FOOT_RATIO * this.getScaleY("foot2"));
            }
            if(this.partExists("chin"))
            {
               this.setScaleX("chin",this.getScaleX(this.skinInfo.rootHeadPart));
               this.setScaleY("chin",this.getScaleY(this.skinInfo.rootHeadPart));
            }
            if(this.partExists("hair"))
            {
               this.setScaleX("hair",this.getScaleX(this.skinInfo.rootHeadPart));
               this.setScaleY("hair",Math.pow(this.getScaleY(this.skinInfo.rootHeadPart),0.8));
            }
            if(this.partExists("hairBehind"))
            {
               this.setScaleX("hairBehind",this.getScaleX("hair"));
               this.setScaleY("hairBehind",this.getScaleY("hair"));
            }
            if(this.partExists("breasts"))
            {
               this.setScaleY("breasts",this.getScaleX("breasts"));
            }
            if(this.partExists("beard"))
            {
               this.setScaleX("beard",this.getScaleX("hair"));
               this.setScaleY("beard",this.getScaleY("hair"));
            }
            if(this.partExists("moustache"))
            {
               this.setScaleX("moustache",this.getScaleX("hair"));
               this.setScaleY("moustache",this.getScaleY("hair"));
            }
            if(this.partExists("hat"))
            {
               this.setScaleX("hat",this.getScaleX("hair"));
               this.setScaleY("hat",this.getScaleY("hair"));
            }
            if(this.partExists("eyewear"))
            {
               this.setScaleX("eyewear",this.getScaleX(this.skinInfo.rootHeadPart));
               this.setScaleY("eyewear",this.target["eyewear"].scaleX);
            }
            if(this.partExists("accessory"))
            {
               this.setScaleX("accessory",Math.min(1,this.getScaleY("torso") * 1.4));
               this.setScaleY("accessory",this.getScaleX("accessory"));
            }
            if(this.partExists("belt"))
            {
               this.adjustBelt();
            }
         }
         this.updateScaleParts();
         if(!this.isHuman())
         {
            if(this.skinInfo.range != null && Utils.inArray(this.skinType,[Globals.CARNIVORE,Globals.HOT_DOG,Globals.HORSE]))
            {
               _loc11_ = Utils.normalizeAngle(this.getRotation(this.target[this.skinInfo.rootHeadPart]) - this.getRotation(this.target["neck"]));
               _loc12_ = 1;
               if(_loc11_ > -this.skinInfo.range.head[0])
               {
                  this.setRotation(this.target[this.skinInfo.rootHeadPart],-this.skinInfo.range.head[0] + this.getRotation(this.target["neck"]));
                  _loc12_ = -1;
               }
               else if(_loc11_ < this.skinInfo.range.head[0])
               {
                  this.setRotation(this.target[this.skinInfo.rootHeadPart],this.skinInfo.range.head[0] + this.getRotation(this.target["neck"]));
                  _loc12_ = 1;
               }
               else if(_loc11_ > 0)
               {
                  _loc12_ = -1;
               }
               _loc4_ = this.getHeadParts(this.skinType,true);
               for each(_loc1_ in _loc4_)
               {
                  if(_loc1_ != "body")
                  {
                     this.setScaleX(_loc1_,this.getScaleX(_loc1_) * _loc12_);
                  }
               }
            }
         }
         if(this.skinInfo.foreshortenedParts != null)
         {
            for(_loc7_ in this.skinInfo.foreshortenedParts)
            {
               _loc6_ = this.getTurn(_loc7_);
               _loc9_ = this.skinInfo.foreshortenedParts[_loc7_].length;
               _loc8_ = 0;
               while(_loc8_ < _loc9_)
               {
                  _loc2_ = this.skinInfo.foreshortenedParts[_loc7_][_loc8_];
                  _loc5_ = this.getScaleX(_loc2_);
                  if(!isNaN(_loc5_))
                  {
                     if(this.skinInfo.foreshortening[_loc6_] is Array)
                     {
                        this.setScaleX(_loc2_,_loc5_ * this.skinInfo.foreshortening[_loc6_][_loc8_]);
                     }
                     else
                     {
                        this.setScaleX(_loc2_,_loc5_ * this.skinInfo.foreshortening[_loc6_]);
                     }
                  }
                  _loc8_++;
               }
            }
         }
         if(this.skinInfo.limbForeshortening != null && this.armBehind > 0)
         {
            _loc6_ = this.getTurn(this.skinInfo.rootBodyPart);
            _loc10_ = ["upperArm" + this.armBehind,"lowerArm" + this.armBehind];
            for each(_loc7_ in _loc10_)
            {
               _loc5_ = this.getScaleY(_loc7_);
               this.setScaleY(_loc7_,_loc5_ * this.skinInfo.limbForeshortening[_loc6_]);
            }
         }
         if(this.skinInfo.turningParts != null)
         {
            for(_loc13_ in this.skinInfo.turningParts)
            {
               _loc6_ = this.getTurn(_loc13_);
               if(this.skinInfo.turningParts[_loc13_][_loc6_] < 0)
               {
                  if(this.skinInfo.turningAxis[_loc13_] != null)
                  {
                     if(this.skinInfo.turningAxis[_loc13_] == "y")
                     {
                        this.setScaleY(_loc13_,this.getScaleY(_loc13_) * -1);
                     }
                  }
                  else
                  {
                     this.setScaleX(_loc13_,this.getScaleX(_loc13_) * -1);
                  }
               }
            }
         }
         if(this.isHuman())
         {
            _loc4_ = this.getHeadParts(this.skinType,true);
            _loc15_ = this._char.dummy && !Main.isPosesUser();
            for each(_loc1_ in this.skinInfo.parts)
            {
               if(Utils.inArray(_loc1_,_loc4_))
               {
                  if(_loc1_.match(/eye|brow/))
                  {
                     this.setScaleX(_loc1_,this.getScaleX(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_EYES_THUMB : Character.SCALE_FACTOR_EYES));
                     this.setScaleY(_loc1_,this.getScaleY(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_EYES_THUMB : Character.SCALE_FACTOR_EYES));
                  }
                  else if(_loc1_.match(/mouth/))
                  {
                     this.setScaleX(_loc1_,this.getScaleX(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_MOUTH_THUMB : Character.SCALE_FACTOR_MOUTH));
                     this.setScaleY(_loc1_,this.getScaleY(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_MOUTH_THUMB : Character.SCALE_FACTOR_MOUTH));
                  }
                  else if(_loc1_.match(/nose/))
                  {
                     this.setScaleX(_loc1_,this.getScaleX(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_NOSE_THUMB : Character.SCALE_FACTOR_NOSE));
                     this.setScaleY(_loc1_,this.getScaleY(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_NOSE_THUMB : Character.SCALE_FACTOR_NOSE));
                  }
                  else
                  {
                     this.setScaleX(_loc1_,this.getScaleX(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_HEAD_THUMB : Character.SCALE_FACTOR_HEAD));
                     this.setScaleY(_loc1_,this.getScaleY(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_HEAD_THUMB : Character.SCALE_FACTOR_HEAD));
                  }
               }
               else
               {
                  this.setScaleX(_loc1_,this.getScaleX(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_BODY_X_THUMB : Character.SCALE_FACTOR_BODY_X));
                  if(_loc1_.match(/arm|leg|sock/i))
                  {
                     this.setScaleY(_loc1_,this.getScaleY(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_LIMBS_THUMB : Character.SCALE_FACTOR_LIMBS));
                  }
                  else if(_loc1_.match(/neck/i))
                  {
                     this.setScaleY(_loc1_,this.getScaleY(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_NECK_Y_THUMB : Character.SCALE_FACTOR_NECK_Y));
                  }
                  else
                  {
                     this.setScaleY(_loc1_,this.getScaleY(_loc1_) * (!!_loc15_ ? Character.SCALE_FACTOR_BODY_Y_THUMB : Character.SCALE_FACTOR_BODY_Y));
                  }
               }
            }
         }
      }
      
      private function updateScaleParts() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(FeatureTrial.can(FeatureTrial.CHARACTER_STRETCH))
         {
            for each(_loc2_ in this.skinInfo.movableLookNames)
            {
               _loc1_ = this.sizableLookData[_loc2_];
               if(_loc1_ != null)
               {
                  if(_loc1_.scaleX != null)
                  {
                     this.setScaleX(_loc2_,this.getScaleX(_loc2_) * _loc1_.scaleX);
                  }
                  if(_loc1_.scaleY != null)
                  {
                     this.setScaleY(_loc2_,this.getScaleY(_loc2_) * _loc1_.scaleY);
                  }
                  if((_loc1_.scaleX != null || _loc1_.scaleY != null) && this.skinInfo.matchScale[_loc2_] != null)
                  {
                     for each(_loc3_ in this.skinInfo.matchScale[_loc2_])
                     {
                        if(_loc1_.scaleX != null)
                        {
                           this.setScaleX(_loc3_,this.getScaleX(_loc2_));
                        }
                        if(_loc1_.scaleY != null)
                        {
                           this.setScaleY(_loc3_,this.getScaleY(_loc2_));
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function partExists(param1:String) : Boolean
      {
         return this.target[param1] != null || this.target[param1 + this.normalizeSuffix("1")] != null;
      }
      
      public function canScale(param1:String = null) : Boolean
      {
         if(param1 == null)
         {
            return this.skinInfo.scalableParts.length > 0;
         }
         if(Utils.inArray(this.normalizePartName(param1),this.getHeadParts(this.skinType,true)) && this.getTurn("head") != TURNED_TOWARD)
         {
            return false;
         }
         return true;
      }
      
      public function hasPhoto(param1:String = null) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:BodyPart = null;
         if(param1 == null)
         {
            for each(_loc2_ in this.skinInfo.photoParts)
            {
               if(this.getPart(_loc2_).hasPhoto())
               {
                  return true;
               }
            }
            return false;
         }
         _loc3_ = this.getPart(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return _loc3_.hasPhoto();
      }
      
      public function hasExpressions(param1:String = null) : Boolean
      {
         var _loc2_:BodyPart = null;
         if(param1 == null)
         {
            return this.skinInfo.movableParts != null && this.skinInfo.movableParts.length > 0;
         }
         _loc2_ = this.getPart(param1);
         if(_loc2_ == null)
         {
            return false;
         }
         return _loc2_.numExpressions > 1;
      }
      
      public function isMovableLook(param1:String) : Boolean
      {
         return this.skinInfo.movableLookMap[this.normalizePartName(param1)] != null;
      }
      
      public function isMovableExpression(param1:String) : Boolean
      {
         return this.getPart(param1).isMovable();
      }
      
      public function isMovablePart(param1:String) : Boolean
      {
         return Utils.inArray(this.normalizePartName(param1),this.skinInfo.movableParts);
      }
      
      public function saveMovablePos(param1:String) : void
      {
         param1 = this.normalizePartName(param1);
         this.getPart(param1).saveMovablePos();
         if(this.skinInfo.symmetricalMovable[param1] != null)
         {
            this.getPart(this.skinInfo.symmetricalMovable[param1]).saveMovablePos();
         }
      }
      
      public function updateMovable(param1:String, param2:Point, param3:Point, param4:Boolean = false) : void
      {
         param1 = this.normalizePartName(param1);
         this.getPart(param1).updateMovable(param2,param3);
         var _loc5_:Object = this.getPart(param1).getMovablePos();
         if(!param4 && this.skinInfo.symmetricalMovable[param1] != null)
         {
            this.getPart(this.skinInfo.symmetricalMovable[param1]).updateMovable(param2,param3,{"y":_loc5_.y});
         }
      }
      
      public function moveLook(param1:String, param2:Number, param3:Number, param4:Number = 0, param5:Boolean = true) : void
      {
         var _loc6_:BodyPart = null;
         var _loc8_:Object = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         param1 = this.normalizePartName(param1);
         var _loc7_:Object = this.getMovableConstraints(param1);
         var _loc9_:Boolean = false;
         if((_loc8_ = this.sizableLookData)[param1] == null || _loc8_[param1].scaleX == null)
         {
            _loc8_[param1] = {
               "scaleX":1,
               "scaleY":1,
               "rotation":0
            };
         }
         if(param4 != 0)
         {
            _loc6_ = this.getPart(param1);
         }
         else
         {
            _loc6_ = this.getPart(this.skinInfo.pivots[param1]);
         }
         var _loc10_:Boolean = false;
         if(_loc7_.x != null && param2 != 0)
         {
            _loc6_.nudgePivot(param1,_loc7_,param2,0);
            _loc10_ = true;
         }
         else if(_loc7_.y != null && param3 != 0)
         {
            _loc6_.nudgePivot(param1,_loc7_,0,param3);
            _loc10_ = true;
         }
         else if(_loc7_.rMin != null && _loc7_.rMax != null && param4 != 0)
         {
            _loc8_[param1].rotation = _loc6_.setRotation(_loc7_,param4);
            _loc9_ = true;
         }
         else
         {
            _loc11_ = 0;
            _loc12_ = 0;
            _loc13_ = 0;
            _loc14_ = 0;
            _loc15_ = 40;
            if(_loc7_.x != null)
            {
               _loc13_ = param3;
               if(_loc7_.linkXY)
               {
                  _loc12_ = _loc13_;
               }
            }
            else if(_loc7_.y != null)
            {
               _loc12_ = param2;
               if(_loc7_.linkXY)
               {
                  _loc13_ = _loc12_;
               }
            }
            else if(_loc7_.xMin == _loc7_.xMax || _loc7_.yMin == _loc7_.yMax)
            {
               if(param2 != 0)
               {
                  _loc13_ = _loc12_ = param2;
               }
               else
               {
                  _loc13_ = _loc12_ = param3 * (!!this.isReverseDirection(param1) ? 1 : -1);
               }
            }
            else if(_loc7_.linkXY)
            {
               _loc13_ = _loc12_ = Math.abs(param2) > Math.abs(param3) ? Number(param2) : Number(param3);
            }
            else
            {
               _loc12_ = param2;
               _loc13_ = param3 * (!!this.isReverseDirection(param1) ? 1 : -1);
            }
            if(_loc12_ != 0)
            {
               _loc8_[param1].scaleX = Utils.limit(1 + _loc12_ / _loc15_,_loc7_.xMin,_loc7_.xMax);
            }
            if(_loc13_ != 0)
            {
               _loc8_[param1].scaleY = Utils.limit(1 + _loc13_ / _loc15_,_loc7_.yMin,_loc7_.yMax);
            }
         }
         this.onMoveLook(param1,param5,_loc9_,_loc10_);
      }
      
      public function setLooksScale(param1:String, param2:String, param3:Number, param4:Boolean = false) : void
      {
         var _loc5_:Object = null;
         if(param2 == "scaleXY")
         {
            param2 = "scaleX";
         }
         if(Utils.inArray(param2,["scaleX","scaleY","rotation"]))
         {
            if(this.sizableLookData[param1] == null)
            {
               this.sizableLookData[param1] = {};
            }
            this.sizableLookData[param1][param2] = param3;
            if((_loc5_ = this.getMovableConstraints(param1)).linkXY)
            {
               if(param2 == "scaleX")
               {
                  if(_loc5_.yMin != _loc5_.yMax)
                  {
                     this.sizableLookData[param1]["scaleY"] = param3;
                  }
               }
               else if(param2 == "scaleY")
               {
                  if(_loc5_.xMin != _loc5_.xMax)
                  {
                     this.sizableLookData[param1]["scaleX"] = param3;
                  }
               }
            }
            this.onMoveLook(param1,param4);
         }
         else if(Utils.inArray(param2,["x","y"]))
         {
            this.getPart(this.skinInfo.pivots[param1]).setPivotValue(param1,param2,param3);
            this.onMoveLook(param1,param4,false,true);
         }
      }
      
      private function onMoveLook(param1:String, param2:Boolean, param3:Boolean = false, param4:Boolean = false) : void
      {
         this.doSymmetryPivots(param1);
         if(!param4)
         {
            this.doSymmetryScalables(param1);
         }
         if(param2)
         {
            if(param3 || this.requiresRender(param1))
            {
               this.render();
            }
            else
            {
               this.updateScale();
               this.updateYPosition();
            }
            this.saveMovableLookData();
         }
      }
      
      private function isReverseDirection(param1:String) : Boolean
      {
         return param1.indexOf("Arm") != -1 || param1.indexOf("Leg") != -1 || param1.indexOf("brow") != -1;
      }
      
      private function requiresRender(param1:String) : Boolean
      {
         return param1.indexOf("Arm") != -1 || param1.indexOf("Leg") != -1 || param1 == "chin" || param1 == "torso";
      }
      
      private function saveMovableLookValue(param1:String) : void
      {
         var _loc2_:BodyPart = this.getPart(this.skinInfo.pivots[param1]);
         this.movableLookData[param1] = _loc2_.getPivotData(param1);
      }
      
      private function saveMovableLookData() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.skinInfo.movableLookNames)
         {
            this.saveMovableLookValue(_loc1_);
         }
      }
      
      public function updateLook(param1:String) : void
      {
         var _loc3_:BodyPart = null;
         param1 = this.normalizePartName(param1);
         var _loc2_:String = this.skinInfo.pivots[param1];
         if(_loc2_ != null)
         {
            _loc3_ = this.getPart(_loc2_);
            _loc3_.updatePivot(param1);
         }
      }
      
      private function adjustBelt() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.setScaleX("belt",1);
         var _loc1_:Array = [];
         _loc1_[0] = this.getAnchor("belt","anchorA");
         _loc1_[1] = this.getAnchor("belt","anchorB");
         _loc1_[2] = this.getAnchor("torso","anchor0");
         _loc1_[3] = this.getAnchor("torso","anchor1");
         if(_loc1_[0] != null && _loc1_[1] != null && _loc1_[2] != null && _loc1_[3] != null)
         {
            _loc2_ = (_loc1_[3].x - _loc1_[2].x) / (_loc1_[1].x - _loc1_[0].x);
            if(this.sizableLookData["torso"] != null && this.sizableLookData["torso"].scaleX != null)
            {
               _loc3_ = this.sizableLookData["torso"].scaleX;
            }
            else
            {
               _loc3_ = 1;
            }
            this.setScaleX("belt",_loc2_ * this.getScaleX("torso") * _loc3_);
         }
         this.setScaleX("detail",this.getScaleX("belt"));
      }
      
      public function flipPose(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         for each(_loc5_ in this.skinInfo.reflectParts)
         {
            if(this.target[_loc5_] == null)
            {
               _loc3_ = this.getRotation(this.target[_loc5_ + "1"]);
               if(param1 == Globals.FLIP_X)
               {
                  this.setRotation(this.target[_loc5_ + "1"],180 - this.getRotation(this.target[_loc5_ + "2"]));
                  this.setRotation(this.target[_loc5_ + "2"],180 - _loc3_);
               }
               else if(_loc5_ == "foot")
               {
                  this.setRotation(this.target[_loc5_ + "1"],this.getRotation(this.target[_loc5_ + "2"]));
                  this.setRotation(this.target[_loc5_ + "2"],_loc3_);
               }
               else
               {
                  this.setRotation(this.target[_loc5_ + "1"],180 + this.getRotation(this.target[_loc5_ + "2"]));
                  this.setRotation(this.target[_loc5_ + "2"],180 + _loc3_);
               }
               if(_loc5_ == HAND)
               {
                  _loc4_ = this.getPart(_loc5_ + "1").expression;
                  if(param1 == Globals.FLIP_X)
                  {
                     this.getPart(_loc5_ + "1").expression = this.getPart(_loc5_ + "2").expression;
                     this.getPart(_loc5_ + "2").expression = _loc4_;
                  }
               }
            }
            else if(param1 == Globals.FLIP_X)
            {
               this.setRotation(this.target[_loc5_],-this.getRotation(this.target[_loc5_]));
            }
         }
         if(param1 == Globals.FLIP_X)
         {
            for each(_loc5_ in this.skinInfo.saveTurningParts)
            {
               this.setTurn(_loc5_,-this.getTurn(_loc5_));
            }
            if(param2 && this.isHuman())
            {
               this.getPart("eye1").flipMovable();
               this.getPart("eye2").flipMovable();
            }
         }
      }
      
      private function normalizeSuffix(param1:String) : String
      {
         if(this.skinInfo.type == 101)
         {
            if(param1 == "1")
            {
               return "L";
            }
            if(param1 == "2")
            {
               return "R";
            }
         }
         return param1;
      }
      
      public function normalizePartName(param1:*) : String
      {
         if(param1 == null)
         {
            return null;
         }
         if(!(param1 is String))
         {
            param1 = param1.name;
         }
         if(this.target[param1] == null)
         {
            return null;
         }
         return this.target[param1].__name;
      }
      
      public function hasHiddenPart() : Boolean
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.skinInfo.movableParts)
         {
            if(this.isHidden(_loc1_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function hasHidables() : Boolean
      {
         return !Utils.empty(this.skinInfo.hidableParts);
      }
      
      public function isHidable(param1:Object) : Boolean
      {
         if(!this.hasHidables())
         {
            return false;
         }
         var _loc2_:String = this.normalizePartName(param1);
         return this.getHidableRoot(_loc2_) != null;
      }
      
      public function getHidableRoot(param1:String) : String
      {
         var _loc4_:* = null;
         var _loc2_:String = this.getBaseName(param1);
         var _loc3_:String = _loc2_ == param1 ? "" : getSuffix(param1);
         for(_loc4_ in this.skinInfo.hidableParts)
         {
            if(Utils.inArray(_loc2_,this.skinInfo.hidableParts[_loc4_]))
            {
               return _loc4_ + _loc3_;
            }
         }
         return null;
      }
      
      public function hidePart(param1:Object, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:MovieClip = null;
         var _loc7_:String = null;
         if(param1 == null || param1 == "null")
         {
            return;
         }
         var _loc6_:String = this.normalizePartName(param1);
         if(!param4)
         {
            if(!param3)
            {
               _loc6_ = this.getHidableRoot(_loc6_);
            }
            if(!param3 || _loc6_ != "neck")
            {
               for each(_loc7_ in anchors[this.skinType][_loc6_])
               {
                  this.hidePart(_loc7_,param2,true);
               }
            }
         }
         if(this.skinInfo.turningParts[_loc6_] != null)
         {
            _loc5_ = this.turningMapMC[this.skinType][_loc6_][this.getTurn(_loc6_)] as MovieClip;
         }
         else
         {
            _loc5_ = this.target[_loc6_] as MovieClip;
         }
         if(param2)
         {
            this.hiddenPartData[_loc6_] = true;
            if(_loc5_.parent != null)
            {
               this.target.removeChild(_loc5_);
            }
         }
         else if(_loc5_.parent == null)
         {
            this.target.addChild(_loc5_);
         }
      }
      
      public function isHidden(param1:String) : Boolean
      {
         return this.hiddenPartData[param1] == true;
      }
      
      public function isCurve(param1:String) : Boolean
      {
         return this.skinInfo.bendy != null && this.skinInfo.bendy.parts[param1] != null;
      }
      
      public function canYStretch(param1:String) : Boolean
      {
         return this.skinInfo.yStretchable != null && Utils.inArray(param1,this.skinInfo.yStretchable);
      }
      
      public function setYStretch(param1:String, param2:Number) : void
      {
         this.getPart(param1).setYStretch(param2);
      }
      
      public function getYStretch(param1:String) : Number
      {
         return this.getPart(param1).getYStretch();
      }
      
      public function showAllParts() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this.hiddenPartData)
         {
            this.hidePart(_loc1_,false,false,true);
         }
         this.hiddenPartData = {};
      }
      
      public function showHide(param1:Array, param2:Array) : void
      {
         var _loc3_:String = null;
         for each(_loc3_ in this.skinInfo.parts)
         {
            if(!(_loc3_ == null || this.target[_loc3_] == null))
            {
               if(param1 != null)
               {
                  this.target[_loc3_].visible = Utils.inArray(_loc3_,param1);
               }
               else if(param2 != null)
               {
                  this.target[_loc3_].visible = !Utils.inArray(_loc3_,param2);
               }
               else
               {
                  this.target[_loc3_].visible = true;
               }
            }
         }
      }
      
      private function normalizePart(param1:String) : MovieClip
      {
         return this.target[this.normalizePartName(param1)] as MovieClip;
      }
      
      public function getPickerPosition(param1:String) : Object
      {
         var _loc2_:Object = {};
         var _loc3_:Rectangle = this.normalizePart(param1).getBounds(Main.self);
         _loc2_.y = Math.round(_loc3_.y);
         if(Utils.inArray(param1,this.skinInfo.faceParts))
         {
            _loc3_ = this.target["head"].getBounds(Main.self);
         }
         _loc2_.x = Math.round(_loc3_.x + _loc3_.width) + 10;
         _loc2_.r = _loc3_;
         return _loc2_;
      }
      
      public function leaveHead() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.render();
         var _loc5_:Array;
         (_loc5_ = this.getHeadParts(this.skinType,true)).unshift("neck");
         for each(_loc1_ in this.skinInfo.parts)
         {
            if(_loc1_ != null)
            {
               if(!Utils.inArray(_loc1_,_loc5_))
               {
                  this.target[_loc1_].parent.removeChild(this.target[_loc1_]);
               }
               if(turningMap[this.skinType][_loc1_] != null)
               {
                  _loc4_ = turningMap[this.skinType][_loc1_].length;
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     if(_loc3_ != this.skinInfo.defTurn)
                     {
                        _loc2_ = turningMap[this.skinType][_loc1_][_loc3_];
                        if(_loc2_ != turningMap[this.skinType][_loc1_][this.skinInfo.defTurn] && this.target[_loc2_] != null && this.target[_loc2_].parent != null)
                        {
                           this.target[_loc2_].parent.removeChild(this.target[_loc2_]);
                        }
                     }
                     _loc3_++;
                  }
               }
            }
         }
         for each(_loc1_ in _loc5_)
         {
            if(!(_loc1_ == "body" || _loc1_.substr(0,1) == "/"))
            {
               if(this.isHuman() && _loc1_ == "chin" || !this.isHuman() && _loc1_ == "head")
               {
                  this.getPart("neck").leaveUsed();
                  this.bringPartToFront("neck");
               }
               this.getPart(_loc1_).leaveUsed();
               this.bringPartToFront(_loc1_);
            }
         }
      }
      
      public function leaveOutfit() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.setColor(Globals.SKIN_COLOR,Palette.GRAY_ID);
         this.setColor(Globals.HAIR_COLOR,Palette.GRAY_ID);
         this.setColor(Globals.IRIS_COLOR,Palette.GRAY_ID);
         this.setColor(Globals.EYELID_COLOR,Palette.GRAY_ID);
         this.setColor(Globals.LIP_COLOR,Palette.GRAY_ID);
         this.render();
         var _loc5_:Array = ["hair","hairBehind","brow1","brow2","eye1","eye2","mouth","beard","moustache","nose","breasts"];
         for each(_loc1_ in this.skinInfo.parts)
         {
            if(_loc1_ != null)
            {
               if(Utils.inArray(_loc1_,_loc5_))
               {
                  if(this.target[_loc1_].parent != null)
                  {
                     this.target[_loc1_].parent.removeChild(this.target[_loc1_]);
                  }
               }
               if(turningMap[this.skinType][_loc1_] != null)
               {
                  _loc4_ = turningMap[this.skinType][_loc1_].length;
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     if(_loc3_ != this.skinInfo.defTurn)
                     {
                        _loc2_ = turningMap[this.skinType][_loc1_][_loc3_];
                        if(_loc2_ != turningMap[this.skinType][_loc1_][this.skinInfo.defTurn] && this.target[_loc2_] != null && this.target[_loc2_].parent != null)
                        {
                           if(this.target[_loc2_].parent != null)
                           {
                              this.target[_loc2_].parent.removeChild(this.target[_loc2_]);
                           }
                        }
                     }
                     _loc3_++;
                  }
               }
            }
         }
      }
      
      public function getHeadHeight() : Number
      {
         var _loc1_:DisplayObject = this.target["head"] as DisplayObject;
         var _loc2_:Rectangle = _loc1_.getBounds(Main.self);
         return _loc2_.height;
      }
      
      public function getMovableParts() : Array
      {
         return this.skinInfo.movableParts;
      }
      
      private function setScaleX(param1:String, param2:Number) : void
      {
         this.getPart(param1).scaleX = param2;
      }
      
      private function setScaleY(param1:String, param2:Number) : void
      {
         this.getPart(param1).scaleY = param2;
      }
      
      private function getScaleX(param1:String) : Number
      {
         return this.getPart(param1).scaleX;
      }
      
      private function getScaleY(param1:String) : Number
      {
         return this.getPart(param1).scaleY;
      }
      
      public function interpolatePositionData(param1:Array, param2:String, param3:Number) : void
      {
         var _loc5_:uint = 0;
         var _loc4_:Array = [];
         var _loc6_:uint = this.skinInfo.parts.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(this.skinInfo.parts[_loc5_] != null)
            {
               _loc4_[_loc5_] = Animation.interpolate(param1[0][param2][_loc5_],param1[1][param2][_loc5_],param1[2][param2][_loc5_],param1[3][param2][_loc5_],param3,Utils.WRAP_360);
            }
            _loc5_++;
         }
         this.setPositionData(_loc4_);
      }
      
      public function interpolateExpressionData(param1:Array, param2:String, param3:Number) : void
      {
         var _loc5_:uint = 0;
         var _loc4_:Array = [];
         var _loc6_:uint = this.bodyParts.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(this.bodyParts[_loc5_] == null)
            {
               _loc4_[_loc5_] = 0;
            }
            else
            {
               _loc4_[_loc5_] = Animation.interpolate(param1[0][param2][_loc5_],param1[1][param2][_loc5_],param1[2][param2][_loc5_],param1[3][param2][_loc5_],param3,0,false,Animation.INTERPOLATE_BINARY);
            }
            _loc5_++;
         }
         this.setExpressionData(_loc4_);
      }
      
      public function interpolateExtraPositionData(param1:Array, param2:String, param3:Number) : void
      {
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:Object;
         (_loc6_ = {})["m"] = {};
         _loc6_["t"] = {};
         for each(_loc4_ in this.skinInfo.movableParts)
         {
            Debug.trace("isMovableExpression(" + _loc4_ + "): " + this.isMovableExpression(_loc4_));
            if(this.isMovableExpression(_loc4_))
            {
               _loc6_["m"][_loc4_] = {};
               _loc6_["m"][_loc4_].x = Animation.interpolate(param1[0][param2]["m"][_loc4_].x,param1[1][param2]["m"][_loc4_].x,param1[2][param2]["m"][_loc4_].x,param1[3][param2]["m"][_loc4_].x,param3);
               _loc6_["m"][_loc4_].y = Animation.interpolate(param1[0][param2]["m"][_loc4_].y,param1[1][param2]["m"][_loc4_].y,param1[2][param2]["m"][_loc4_].y,param1[3][param2]["m"][_loc4_].y,param3);
            }
         }
         for each(_loc4_ in this.skinInfo.saveTurningParts)
         {
            _loc5_ = this.skinInfo.turningParts[_loc4_].length;
            _loc6_["t"][_loc4_] = Animation.interpolate(param1[0][param2]["t"][_loc4_],param1[1][param2]["t"][_loc4_],param1[2][param2]["t"][_loc4_],param1[3][param2]["t"][_loc4_],param3,_loc5_,true);
         }
         this.setExtraPositionData(_loc6_);
      }
      
      public function isHuman(param1:Boolean = false) : Boolean
      {
         if(param1)
         {
            return this.skinInfo.type == 0;
         }
         return this.skinInfo.human != null;
      }
      
      public function getPartValue(param1:String, param2:uint, param3:uint) : uint
      {
         var _loc4_:String = null;
         if(Main.controlPressed && Main.isSuper())
         {
            return param3;
         }
         if(param2 == Globals.LOOKS)
         {
            _loc4_ = "look";
         }
         else
         {
            if(param2 != Globals.EXPRESSION)
            {
               return param3;
            }
            _loc4_ = "expr";
         }
         if(this.skinInfo.partOrder && this.skinInfo.partOrder[_loc4_] && this.skinInfo.partOrder[_loc4_][param1] && this.skinInfo.partOrder[_loc4_][param1][param3] != null)
         {
            return this.skinInfo.partOrder[_loc4_][param1][param3];
         }
         return param3;
      }
      
      public function getPartByID(param1:int) : Object
      {
         var _loc2_:String = null;
         _loc2_ = partIDMap[param1.toString()];
         if(_loc2_ != null)
         {
            return this.getPart(_loc2_).target;
         }
         return null;
      }
      
      public function isLocked() : Boolean
      {
         return this.skinInfo.locked == true;
      }
      
      private function getDrawing(param1:String, param2:uint = 0) : MovieClip
      {
         return this.getPart(param1).getDrawing(param2);
      }
      
      public function setRotation(param1:Object, param2:Number, param3:Boolean = false) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc4_:String = this.normalizePartName(param1);
         var _loc5_:Number = param1.rotation;
         if(this.sizableLookData[_loc4_] != null && this.sizableLookData[_loc4_].rotation != null)
         {
            param1.rotation = param2 + this.sizableLookData[_loc4_].rotation * (getSuffix(_loc4_) == "1" ? 1 : -1);
         }
         else
         {
            param1.rotation = param2;
         }
         if(param3)
         {
            _loc6_ = param1.rotation - _loc5_;
            if(!Main.controlPressed && this.skinInfo.movableRelateds != null && this.skinInfo.movableRelateds[_loc4_] != null)
            {
               for each(_loc7_ in this.skinInfo.movableRelateds[_loc4_])
               {
                  this.getPart(_loc7_).target.rotation = this.getPart(_loc7_).target.rotation + _loc6_;
               }
            }
         }
      }
      
      public function getRotation(param1:Object) : Number
      {
         var _loc2_:String = this.normalizePartName(param1);
         if(this.sizableLookData[_loc2_] != null && this.sizableLookData[_loc2_].rotation != null)
         {
            return param1.rotation - this.sizableLookData[_loc2_].rotation * (getSuffix(_loc2_) == "1" ? 1 : -1);
         }
         return param1.rotation;
      }
      
      private function getGender(param1:String) : uint
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(param1 != "breasts" && this.getPart("breasts").look > 0)
         {
            return GENDER_FEMALE;
         }
         if(param1 != "earring" && this.getPart("earring1").look > 0)
         {
            return GENDER_FEMALE;
         }
         if(param1 != "eyeShadow" && this.getPart("eyeShadow1").look > 0)
         {
            return GENDER_FEMALE;
         }
         if(param1 != "hat" && Utils.inArray(this.getPart("hat").look,this.skinInfo.looksHatsFemale))
         {
            return GENDER_FEMALE;
         }
         if(param1 != "ribs" && Utils.inArray(this.getPart("ribs").look,this.skinInfo.looksRibsFemale))
         {
            return GENDER_FEMALE;
         }
         if(param1 != "hair" && Utils.inArray(this.getPart("hair").look,this.skinInfo.looksHairFemale))
         {
            return GENDER_FEMALE;
         }
         if(param1 != "beard" && this.getPart("beard").look > 0 || param1 != "moustache" && this.getPart("moustache").look > 0)
         {
            return GENDER_MALE;
         }
         if(param1 != "chin" && Utils.inArray(this.getPart("chin").look,this.skinInfo.looksChinsMale))
         {
            return GENDER_MALE;
         }
         if(param1 != "ribs" && Utils.inArray(this.getPart("ribs").look,this.skinInfo.looksRibsMale))
         {
            return GENDER_MALE;
         }
         if(param1 != "hair" && Utils.inArray(this.getPart("hair").look,this.skinInfo.looksHairMale))
         {
            return GENDER_MALE;
         }
         return GENDER_UNKNOWN;
      }
      
      public function getGenderLooks(param1:String) : Object
      {
         var _loc2_:uint = this.getGender(param1);
         if(_loc2_ == GENDER_MALE)
         {
            if(param1 == "hair")
            {
               return {"exc":this.skinInfo.looksHairFemale};
            }
            if(param1 == "breasts")
            {
               return {"inc":[]};
            }
         }
         else if(_loc2_ == GENDER_FEMALE)
         {
            if(param1 == "chin")
            {
               return {"exc":this.skinInfo.looksChinsMale};
            }
            if(param1.match(/^brow/))
            {
               return {"exc":this.skinInfo.looksBrowsMale};
            }
            if(param1 == "hair")
            {
               return {"exc":this.skinInfo.looksHairMale};
            }
            if(param1 == "beard" || param1 == "moustache")
            {
               return {"inc":[]};
            }
         }
         return null;
      }
      
      public function captureZOrder() : Object
      {
         var _loc1_:String = null;
         var _loc2_:BodyPart = null;
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc3_:Object = {};
         _loc3_["skinType"] = this.skinType;
         _loc3_["turn"] = {};
         _loc3_["turn"][this.skinInfo.rootHeadPart] = this.getTurn(this.skinInfo.rootHeadPart);
         _loc3_["turn"][this.skinInfo.rootBodyPart] = this.getTurn(this.skinInfo.rootBodyPart);
         _loc3_["part"] = {};
         for each(_loc1_ in this.skinInfo.parts)
         {
            if(_loc1_ != null)
            {
               _loc4_ = {};
               _loc2_ = this.getPart(_loc1_);
               _loc4_["zIndex"] = _loc2_.target.parent.getChildIndex(_loc2_.target);
               if(this.skinInfo.turningParts[_loc1_] != null)
               {
                  _loc7_ = this.getTurn(_loc1_);
                  Debug.trace("test: " + _loc7_ + "; " + turningMap[this.skinType][_loc1_]);
                  _loc4_["turn"] = turningMap[this.skinType][_loc1_][_loc7_];
               }
               _loc2_ = this.getPart(_loc1_);
               _loc3_["part"][_loc1_] = _loc4_;
            }
         }
         return _loc3_;
      }
   }
}

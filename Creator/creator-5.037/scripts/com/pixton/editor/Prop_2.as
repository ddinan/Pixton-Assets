package com.pixton.editor
{
   import com.pixton.animate.Animation;
   import com.pixton.propSkin.PropPart;
   import com.pixton.team.TeamRole;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Prop extends Asset
   {
      
      public static const PRELOAD:Boolean = true;
      
      public static const USE_IMAGES:Boolean = false;
      
      public static var preloadAll:Boolean = false;
      
      public static var hasFeaturedProps:Boolean = false;
      
      private static const SPRITE_SIZE:uint = 55;
      
      static const PROP_PRESET:uint = 0;
      
      static const PROP_SET:uint = 1;
      
      static const PROP_PHOTO:uint = 2;
      
      static const PROP_WEB:uint = 3;
      
      static const PROP_DRAWING:uint = 4;
      
      static const MOVABLE_DX:Number = 10;
      
      public static const ALPHA_MIN:uint = 1;
      
      public static const ALPHA_MAX:uint = 100;
      
      public static var version:String;
      
      public static var basePath:String;
      
      public static var previewID:uint = 0;
      
      static var lastPool:uint;
      
      private static var newProps:Array;
      
      private static var newPropReport:Array = [];
      
      private static var propsAll:Array;
      
      private static var propsVis:Array;
      
      private static var propMap:Object;
      
      private static var _restrictProps:Boolean = false;
      
      public static const NORMAL:uint = 0;
      
      public static const ICON:uint = 1;
      
      private static const MAX_FILLS:uint = 5;
      
      private static var propFiles:Array;
      
      private static var lockInfo:Object;
      
      private static var searchCache:Object = {};
      
      private static var photoPolicyNotified:Boolean = false;
      
      public static var allowAnimation:Boolean = false;
      
      private static var currentFile:uint = 0;
      
      private static var numFiles:uint = 0;
      
      private static var spriteMap:Object;
      
      private static var spriteSheetJSON:Array = [];
      
      private static var spriteSheetImage:Array = [];
      
      private static var numJSONLoaded:uint = 0;
      
      private static var numImageLoaded:uint = 0;
      
      private static var _spriteCache:Array = [];
      
      private static var _spriteCacheIndex = 0;
       
      
      public var startZ:Number = 1;
      
      public var id:uint;
      
      public var alphable:MovieClip;
      
      public var handle:MovieClip;
      
      public var propName:String;
      
      public var asset:MovieClip;
      
      public var hasIcon:Boolean = false;
      
      private var _z:Number = 1;
      
      private var lines:Array;
      
      private var fills:Array;
      
      private var fillAlphas:Array;
      
      private var _transparency:uint = 100;
      
      private var transparentFills:Array;
      
      private var images:Array;
      
      private var inners:Array;
      
      private var movables:Array;
      
      private var movableMap:Object;
      
      private var _isDummy:Boolean;
      
      private var _animating:Boolean = false;
      
      private var _editMode:uint;
      
      private var currentTargetOver:Object;
      
      private var currentPartIndex:uint;
      
      private var startPosition:uint;
      
      private var startPoint:Point;
      
      public function Prop(param1:uint = 0, param2:uint = 0, param3:Boolean = false, param4:Function = null)
      {
         var data:Object = null;
         var id:uint = param1;
         var mode:uint = param2;
         var isDummy:Boolean = param3;
         var onLoaded:Function = param4;
         this.movables = [];
         this.movableMap = {};
         super();
         this.dummy = isDummy;
         if(id > 0)
         {
            this.id = id;
            data = Prop.getData(id);
            this.propName = !!Main.isPropsAdmin() ? data.l : data.n;
            this.startZ = data.z;
            this._transparency = data.a;
            if(data.t != null)
            {
               this.transparentFills = data.t.split(",");
            }
            if(Utils.hasDefinition("com.pixton.prop." + data.l))
            {
               this.initAsset(mode,onLoaded);
            }
            else
            {
               this.loadSWF(mode,function():void
               {
                  initAsset(mode,onLoaded);
               });
            }
         }
         if(OS.canInvalidate() && !Main.isHiResRender())
         {
            Utils.addListener(this,Event.RENDER,this.onRender);
         }
      }
      
      public static function loadMeta() : void
      {
         Utils.loadXML(basePath + "props/_props-meta-" + version + Utils.EXT_JSON,onLoadMeta);
      }
      
      private static function onLoadMeta(param1:Object) : void
      {
         var _loc2_:String = null;
         numFiles = param1.i + 1;
         spriteMap = param1.map;
         var _loc3_:uint = 0;
         while(_loc3_ < numFiles)
         {
            loadFiles(_loc3_);
            _loc3_++;
         }
      }
      
      private static function loadFiles(param1:uint) : void
      {
         var i:uint = param1;
         Utils.loadXML(basePath + "props/_props-" + i + "-" + version + Utils.EXT_JSON,function(param1:Object):void
         {
            onLoadSpriteSheetJSON(i,param1);
         });
         Utils.load(basePath + "props/_props-" + i + "-" + version + Utils.EXT_PNG,function(param1:Event):void
         {
            var _loc2_:BitmapData = Bitmap(param1.target.loader.contentLoaderInfo.content).bitmapData;
            onLoadSpriteSheetImage(i,_loc2_);
         },false,File.BUCKET_DYNAMIC);
      }
      
      private static function onLoadSpriteSheetJSON(param1:uint, param2:Object) : void
      {
         spriteSheetJSON[param1] = param2;
         ++numJSONLoaded;
         checkLoad();
      }
      
      private static function onLoadSpriteSheetImage(param1:uint, param2:BitmapData) : void
      {
         spriteSheetImage[param1] = param2;
         ++numImageLoaded;
         checkLoad();
      }
      
      private static function checkLoad() : void
      {
         if(numJSONLoaded == numFiles && numImageLoaded == numFiles)
         {
            Main.self.onLoadProps();
         }
      }
      
      public static function hasSprite(param1:uint) : Boolean
      {
         return spriteMap[param1.toString()] != null;
      }
      
      public static function getSprite(param1:uint) : Bitmap
      {
         var _loc5_:Bitmap = null;
         var _loc6_:BitmapData = null;
         if(spriteMap[param1.toString()] == null)
         {
            Debug.trace("No sprite sheet for " + param1);
            return null;
         }
         var _loc2_:uint = spriteMap[param1.toString()];
         var _loc3_:Object = spriteSheetJSON[_loc2_][param1.toString()];
         var _loc4_:BitmapData = spriteSheetImage[_loc2_] as BitmapData;
         if(_loc3_)
         {
            if(_spriteCache[_spriteCacheIndex] == null)
            {
               _loc6_ = new BitmapData(SPRITE_SIZE,SPRITE_SIZE,false,16777215);
               _loc5_ = new Bitmap(_loc6_);
               _spriteCache[_spriteCacheIndex] = _loc5_;
            }
            else
            {
               (_loc6_ = (_loc5_ = _spriteCache[_spriteCacheIndex] as Bitmap).bitmapData).fillRect(new Rectangle(0,0,SPRITE_SIZE,SPRITE_SIZE),16777215);
            }
            ++_spriteCacheIndex;
            _loc6_.copyPixels(_loc4_,new Rectangle(_loc3_.x,_loc3_.y,SPRITE_SIZE,SPRITE_SIZE),new Point(0,0));
            if(_loc6_)
            {
               return _loc5_;
            }
         }
         Debug.trace("Failed to get sprite: " + param1);
         return null;
      }
      
      public static function resetSpriteCache() : void
      {
         _spriteCacheIndex = 0;
      }
      
      public static function init(param1:Array) : void
      {
         propFiles = param1;
         lastPool = Pixton.POOL_PACK;
      }
      
      public static function setLock(param1:Array) : void
      {
         var _loc2_:uint = 0;
         lockInfo = {};
         var _loc3_:uint = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            lockInfo[param1[_loc2_].id_int.toString()] = param1[_loc2_];
            _loc2_++;
         }
         PropPack.updateFree();
      }
      
      public static function getLock(param1:uint) : Object
      {
         if(lockInfo != null && lockInfo[param1.toString()] != null)
         {
            return lockInfo[param1.toString()];
         }
         return null;
      }
      
      public static function getNextFile() : String
      {
         if(propFiles && propFiles.length > 0)
         {
            return propFiles.shift();
         }
         return null;
      }
      
      private static function isColorName(param1:String, param2:uint) : Boolean
      {
         return param2 == 1 && param1 == "fill" || param1 == "fill" + param2;
      }
      
      public static function getAllPropData() : Array
      {
         return propsAll;
      }
      
      public static function setData(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc4_:uint = 0;
         if(param1.rp)
         {
            _restrictProps = true;
         }
         var _loc5_:Array = param1.p;
         propsAll = [];
         propsVis = [];
         propMap = {};
         if(_loc5_)
         {
            _loc7_ = _loc5_.length;
            _loc2_ = 0;
            while(_loc2_ < _loc7_)
            {
               if(preloadAll && !Utils.hasDefinition("com.pixton.prop." + _loc5_[_loc2_].l) || !preloadAll && USE_IMAGES && !hasSprite(_loc5_[_loc2_].id))
               {
                  Debug.trace("Missing: com.pixton.prop." + _loc5_[_loc2_].l);
               }
               else if(!(_restrictProps && _loc5_[_loc2_].r == 1))
               {
                  _loc4_ = Math.max(_loc4_,_loc5_[_loc2_].id);
                  _loc3_ = propsAll.length;
                  propsAll[_loc3_] = _loc5_[_loc2_];
                  propMap[propsAll[_loc3_].id.toString()] = _loc3_;
                  if(propsAll[_loc3_].hd == 0)
                  {
                     _loc3_ = propsVis.length;
                     propsVis[_loc3_] = _loc5_[_loc2_];
                     (_loc8_ = []).push(propsVis[_loc3_].n);
                     if(propsVis[_loc3_].w != null)
                     {
                        _loc8_.push(propsVis[_loc3_].w);
                     }
                     propsVis[_loc3_].kw = _loc8_.join(" ").toLowerCase();
                  }
               }
               _loc2_++;
            }
         }
         PropPack.propPacks = [];
         PropPack.propPackMap = {};
         if(_loc5_ = param1.pc)
         {
            if(param1.ppf != null)
            {
               _loc5_.unshift({
                  "id":0,
                  "k":"featured",
                  "p":param1.ppf as Array,
                  "n":L.text("pc-featured")
               });
               Prop.hasFeaturedProps = true;
            }
            _loc7_ = _loc5_.length;
            _loc3_ = 0;
            _loc2_ = 0;
            for(; _loc2_ < _loc7_; _loc2_++)
            {
               if(_loc5_[_loc2_].k == "faves")
               {
                  if(param1.faveProps == null)
                  {
                     continue;
                  }
                  _loc5_[_loc2_].p = param1.faveProps;
               }
               if(!Template.isActive() || Prop.hasFeaturedProps && _loc5_[_loc2_].id == 0)
               {
                  PropPack.propPacks[_loc3_] = new PropPack(_loc5_[_loc2_]);
                  PropPack.propPackMap[PropPack.propPacks[_loc3_].id.toString()] = _loc3_;
                  _loc3_++;
               }
            }
         }
         if(newProps != null)
         {
            for each(_loc9_ in newProps)
            {
               _loc9_.id = ++_loc4_;
               _loc2_ = _loc9_.className.indexOf("::");
               if(_loc2_ <= 0)
               {
                  newPropReport.push("Prop class is invalid: " + _loc9_.className);
               }
               else
               {
                  _loc9_.l = _loc9_.className.substr(_loc2_ + 2);
                  _loc9_.z = 1;
                  _loc9_.c = Palette.WHITE_ID;
                  _loc9_.c2 = Palette.WHITE_ID;
                  _loc9_.c3 = Palette.WHITE_ID;
                  _loc9_.c4 = Palette.WHITE_ID;
                  _loc9_.c5 = Palette.WHITE_ID;
                  _loc9_.a = 100;
                  _loc9_.s = 0;
                  _loc9_.hd = 0;
                  _loc3_ = propsAll.length;
                  propsAll[_loc3_] = _loc9_;
                  propMap[_loc4_.toString()] = _loc3_;
               }
            }
         }
      }
      
      public static function getRandomID() : uint
      {
         return propsVis[Math.floor(Math.random() * propsVis.length)].id;
      }
      
      public static function getAll() : Array
      {
         var _loc2_:Object = null;
         var _loc1_:Array = [];
         for each(_loc2_ in propsVis)
         {
            _loc1_.push(_loc2_.id);
         }
         return _loc1_;
      }
      
      public static function exists(param1:int = -1) : Boolean
      {
         var _loc2_:String = null;
         if(param1 == -1)
         {
            return propsAll != null && propsAll.length > 0;
         }
         _loc2_ = param1.toString();
         return propMap[_loc2_] != null;
      }
      
      public static function getList(param1:uint, param2:uint = 0, param3:uint = 0, param4:int = -1) : Object
      {
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc8_:Object = null;
         var _loc9_:PropPack = null;
         if(param1 == Pixton.POOL_MINE)
         {
            return PropSet.getList(Pixton.POOL_MINE,PropSet.OBJECT,param3,param4);
         }
         if(param1 == Pixton.POOL_PACK)
         {
            _loc5_ = (_loc9_ = PropPack.getPack(param2)).props.slice(param3,Math.min(_loc9_.props.length,param3 + param4));
            _loc6_ = _loc9_.props.length;
         }
         else if(param1 == Pixton.POOL_CATEGORIES)
         {
            _loc6_ = PropPack.propPacks.length;
            if(param4 == -1)
            {
               param4 = _loc6_;
            }
            _loc5_ = PropPack.propPacks.slice(param3,Math.min(PropPack.propPacks.length,param3 + param4));
         }
         else
         {
            if(param1 == Pixton.POOL_COMMUNITY)
            {
               return PropSet.getList(Pixton.POOL_COMMUNITY,PropSet.OBJECT,param3,param4);
            }
            if(param1 == Pixton.POOL_PRESET)
            {
               return PropSet.getList(Pixton.POOL_PRESET,PropSet.OBJECT,param3,param4);
            }
            _loc5_ = propsVis.slice(param3,Math.min(propsVis.length,param3 + param4));
            _loc6_ = propsVis.length;
         }
         var _loc7_:Array = [];
         for each(_loc8_ in _loc5_)
         {
            _loc7_.push(_loc8_.id);
         }
         return {
            "array":_loc7_,
            "list":_loc5_,
            "showPrev":param3 > 0,
            "showNext":param3 + param4 < _loc6_
         };
      }
      
      public static function searchList(param1:uint, param2:uint, param3:String, param4:uint, param5:uint) : Object
      {
         var _loc9_:Object = null;
         if(param1 == Pixton.POOL_MINE)
         {
            return PropSet.searchList(Pixton.POOL_MINE,PropSet.OBJECT,param3,param4,param5);
         }
         if(param1 == Pixton.POOL_COMMUNITY)
         {
            return PropSet.searchList(Pixton.POOL_COMMUNITY,PropSet.OBJECT,param3,param4,param5);
         }
         var _loc6_:Array = propsVis;
         var _loc7_:Array = [];
         var _loc8_:Array = Keyword.prepareUserSearch(param3);
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
            "showPrev":param4 > 0,
            "showNext":param4 + param5 < _loc7_.length,
            "search":_loc8_.join(" ")
         };
      }
      
      public static function getRandomIndex(param1:*) : uint
      {
         if(propsVis.length <= param1)
         {
            return 0;
         }
         return Math.floor(Math.random() * propsVis.length);
      }
      
      public static function getData(param1:uint) : Object
      {
         var _loc2_:String = param1.toString();
         if(propMap[_loc2_] != null)
         {
            return propsAll[propMap[_loc2_]];
         }
         return null;
      }
      
      static function getType(param1:DisplayObject) : uint
      {
         if(param1 is PropSet)
         {
            return PROP_SET;
         }
         if(param1 is PropPhoto)
         {
            return PROP_PHOTO;
         }
         if(param1 is WebPhoto)
         {
            return PROP_WEB;
         }
         return PROP_PRESET;
      }
      
      private static function reuseProp(param1:Array, param2:Object) : Prop
      {
         var _loc3_:Prop = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = param1[_loc4_] as Prop;
            if(_loc3_.id == param2.id && getType(_loc3_) == param2.s)
            {
               param1.splice(_loc4_,1);
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      static function load(param1:MovieClip, param2:Array) : void
      {
         var _loc4_:Prop = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:DisplayObject = null;
         var _loc10_:Object = null;
         var _loc3_:Array = [];
         var _loc9_:MovieClip = param1 is Editor ? param1.containerC : param1;
         _loc6_ = 0;
         _loc7_ = _loc9_.numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc7_)
         {
            if((_loc8_ = _loc9_.getChildAt(_loc6_)) is Prop)
            {
               _loc3_.push(_loc8_);
               _loc9_.removeChild(_loc8_);
            }
            else
            {
               _loc6_++;
            }
            _loc5_++;
         }
         for each(_loc10_ in param2)
         {
            if(!(_loc10_.s == PROP_SET && !FeatureTrial.can(FeatureTrial.PROP_GROUPING)))
            {
               if(_loc10_.s == PROP_PHOTO && !FeatureTrial.can(FeatureTrial.IMAGE_UPLOADS) && !FileUpload.forcedVisible)
               {
                  Editor.warnFeatureLoss();
                  continue;
               }
               if(_loc10_.s == PROP_WEB && !FeatureTrial.can(FeatureTrial.BROWSE_PHOTOS) && !FileUpload.forcedVisible)
               {
                  Editor.warnFeatureLoss();
                  continue;
               }
            }
            if((_loc4_ = reuseProp(_loc3_,_loc10_)) != null)
            {
               onAdd(param1,_loc4_,_loc10_.s);
            }
            else
            {
               _loc4_ = add(param1,_loc10_.id,_loc10_.s);
            }
            if(_loc4_ != null)
            {
               _loc4_.setData(_loc10_);
               param1.zOrder.push(_loc4_);
               if(_loc10_.zon != null && _loc10_.zon == 0)
               {
                  if(param1 is Editor)
                  {
                     param1.zOrderLegacy[_loc10_.zo] = _loc4_;
                  }
                  _loc4_.size = _loc10_.z;
               }
            }
         }
         if((_loc7_ = param1 is Editor ? uint(param1.zOrderLegacy.length) : uint(0)) > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               param1.zOrderLegacy[_loc5_].parent.setChildIndex(param1.zOrderLegacy[_loc5_],_loc5_);
               _loc5_++;
            }
            Editor.updateZ(_loc9_);
         }
         else
         {
            param1.zOrder.sortOn("zIndex");
            _loc7_ = param1.zOrder.length;
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               param1.zOrder[_loc5_].parent.setChildIndex(param1.zOrder[_loc5_],_loc5_);
               _loc5_++;
            }
         }
      }
      
      static function permitted(param1:uint, param2:uint) : Boolean
      {
         if(TeamRole.can(TeamRole.PROPS))
         {
            if(Utils.inArray(param2,[Prop.PROP_PHOTO,Prop.PROP_WEB]) && !FileUpload.imagesEnabled && !FileUpload.forcedVisible)
            {
               if(!photoPolicyNotified)
               {
                  photoPolicyNotified = true;
                  Confirm.alert("err-photo-policy");
               }
               Editor.warnFeatureLoss();
               return false;
            }
            if(param2 == PROP_PRESET && Globals.isLocked(getLock(param1)))
            {
               Editor.warnFeatureLoss();
               return false;
            }
         }
         return true;
      }
      
      static function add(param1:MovieClip, param2:uint, param3:uint = 0, param4:Boolean = false) : Prop
      {
         var _loc5_:Prop = null;
         if(!permitted(param2,param3))
         {
            return null;
         }
         if(param3 == PROP_SET)
         {
            if(PropSet.getData(param2) == null)
            {
               return null;
            }
            _loc5_ = new PropSet(param2) as Prop;
         }
         else if(param3 == PROP_PHOTO)
         {
            if(param2 > 0 && PropPhoto.getData(param2) == null)
            {
               return null;
            }
            _loc5_ = new PropPhoto(param2) as Prop;
         }
         else if(param3 == PROP_WEB)
         {
            _loc5_ = new WebPhoto(param2) as Prop;
         }
         else if(param3 == PROP_DRAWING)
         {
            _loc5_ = new PhotoDrawing(param2) as Prop;
         }
         else
         {
            if(Prop.getData(param2) == null)
            {
               return null;
            }
            _loc5_ = new Prop(param2);
         }
         return onAdd(param1,_loc5_,param3,true,param4);
      }
      
      private static function onAdd(param1:MovieClip, param2:Prop, param3:uint = 0, param4:Boolean = false, param5:Boolean = false) : Prop
      {
         var _loc7_:uint = 0;
         var _loc11_:Moveable = null;
         if(param1 == null)
         {
            return param2;
         }
         var _loc8_:uint;
         var _loc6_:MovieClip;
         var _loc9_:uint = _loc8_ = (_loc6_ = param1 is Editor ? param1.containerC : param1.vector).numChildren;
         var _loc10_:Boolean = false;
         if(param3 == PROP_SET && PropSet(param2).isBkgd())
         {
            _loc9_ = 0;
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc11_ = _loc6_.getChildAt(_loc7_) as Moveable;
               if(param2.zIndex < 1 && param2.zIndex < _loc11_.zIndex)
               {
                  _loc9_ = _loc7_;
                  break;
               }
               _loc9_ = _loc7_ + 1;
               _loc7_++;
            }
         }
         _loc6_.addChildAt(param2,_loc9_);
         if(param1 is Editor)
         {
            if(param4)
            {
               if(param5)
               {
                  param1.positionNew(param2 as MovieClip,param3);
               }
               param1.activateTarget(param2 as MovieClip);
            }
            if(param2 is Photo && Main.isPhotoEssay())
            {
               Editor.self.showImageCredit(param2 as Photo);
            }
         }
         return param2;
      }
      
      static function setSearched(param1:String) : void
      {
         searchCache[param1] = true;
      }
      
      static function searched(param1:String) : Boolean
      {
         return searchCache[param1] != null;
      }
      
      static function detectNew(param1:Event = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         if(!Main.isPropPreview())
         {
            return;
         }
         if(param1 != null && !param1.target.loader.contentLoaderInfo.url.match(/preview/))
         {
            return;
         }
         if(param1 == null)
         {
            _loc2_ = Editor.self.containerC;
         }
         else
         {
            _loc2_ = MovieClip(param1.target.loader.contentLoaderInfo.content);
         }
         var _loc6_:uint = _loc2_.numChildren;
         newProps = [];
         Debug.trace("mc: " + _loc2_);
         Debug.trace("ni: " + _loc6_);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = _loc2_.getChildAt(_loc5_);
            Debug.trace("child: " + _loc3_);
            if(!(!(_loc3_ is MovieClip) || _loc3_ is Character))
            {
               if(param1 == null && _loc3_ is Prop)
               {
                  _loc3_ = Prop(_loc3_).asset;
               }
               _loc9_ = [];
               _loc8_ = MovieClip(_loc3_).numChildren;
               _loc7_ = 0;
               while(_loc7_ < _loc8_)
               {
                  _loc4_ = MovieClip(_loc3_).getChildAt(_loc7_);
                  _loc9_.push(_loc4_.name);
                  _loc7_++;
               }
               _loc10_ = {
                  "className":Utils.getClassName(_loc3_),
                  "children":_loc9_
               };
               _loc10_.n = _loc10_.className;
               if(!Utils.inArray("fill1",_loc9_) && !Utils.inArray("fill",_loc9_) && !Utils.inArray("color1",_loc9_))
               {
                  newPropReport.push(_loc10_.n + ": missing or misnamed color1");
               }
               newProps.push(_loc10_);
            }
            _loc5_++;
         }
         if(newProps.length > 0)
         {
            Utils.remote("newPropReport",{"props":newProps});
         }
      }
      
      static function addNewProps() : void
      {
         var _loc1_:Object = null;
         if(newProps == null)
         {
            if(previewID <= 0)
            {
               return;
            }
            newProps = [{"id":previewID}];
         }
         for each(_loc1_ in newProps)
         {
            Editor.self.addProp(_loc1_.id);
         }
         if(newPropReport.length > 0)
         {
            Utils.javascript("Pixton.alert",newPropReport.join("\n"));
         }
      }
      
      public static function getIDMap() : Object
      {
         var _loc2_:uint = 0;
         var _loc1_:Object = {};
         var _loc3_:uint = propsAll.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_[propsAll[_loc2_].l] = propsAll[_loc2_].id;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getURL(param1:uint) : String
      {
         var _loc2_:Object = Prop.getData(param1);
         return basePath + "props/prop/_" + param1 + File.v(_loc2_.v) + Utils.EXT_PNG;
      }
      
      private function loadSWF(param1:uint, param2:Function) : void
      {
         var mode:uint = param1;
         var onLoaded:Function = param2;
         var data:Object = Prop.getData(this.id);
         var propPath:String = basePath + "props/prop/_" + data.id + File.v(data.v) + ".swf";
         Utils.load(propPath,function(param1:Event):void
         {
            initAsset(mode,onLoaded);
         },false,File.BUCKET_ASSET);
      }
      
      private function initAsset(param1:uint, param2:Function) : void
      {
         Debug.trace("initAsset " + this);
         var _loc3_:Object = Prop.getData(this.id);
         this.asset = Utils.getAsset("com.pixton.prop." + _loc3_.l);
         Debug.trace("asset " + _loc3_.l + ": " + this.asset);
         this.hasIcon = this.asset.icon != null;
         if(param1 == ICON && this.hasIcon)
         {
            vector.addChild(this.asset.icon);
         }
         else
         {
            if(this.hasIcon)
            {
               this.asset.removeChild(this.asset.icon);
            }
            vector.addChild(this.asset);
         }
         if(this.asset.masker != null && this.asset.fill != null)
         {
            this.asset.fill.mask = this.asset.masker;
         }
         else if(this.asset.animation != null && this.asset.animation.masker != null && this.asset.animation.fill != null)
         {
            this.asset.animation.fill.mask = this.asset.animation.masker;
         }
         this.images = [];
         this.inners = [];
         this.lines = [];
         this.fills = [[],[],[],[],[]];
         this.fillAlphas = [[],[],[],[],[]];
         this.checkForFills(this.asset);
         this.setColor(0,_loc3_.c);
         this.setColor(1,_loc3_.c2);
         this.setColor(2,_loc3_.c3);
         this.setColor(3,_loc3_.c4);
         this.setColor(4,_loc3_.c5);
         if(param1 == ICON && _loc3_.c == Palette.WHITE_ID && this.isAlphable())
         {
            this.setColor(0,Palette.OFF_WHITE_ID,true);
         }
         this.loadImage();
         if(param2 != null)
         {
            param2();
         }
      }
      
      private function checkForFills(param1:DisplayObject) : void
      {
         var _loc2_:uint = 0;
         if(!(param1 is MovieClip))
         {
            return;
         }
         var _loc3_:MovieClip = param1 as MovieClip;
         var _loc4_:uint = _loc3_.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            param1 = _loc3_.getChildAt(_loc2_);
            if(isColorName(param1.name,1))
            {
               this.fills[0].push(param1);
               this.fillAlphas[0].push(param1.alpha);
               param1.alpha = 1;
            }
            else if(isColorName(param1.name,2))
            {
               this.fills[1].push(param1);
               this.fillAlphas[1].push(param1.alpha);
               param1.alpha = 1;
            }
            else if(isColorName(param1.name,3))
            {
               this.fills[2].push(param1);
               this.fillAlphas[2].push(param1.alpha);
               param1.alpha = 1;
            }
            else if(isColorName(param1.name,4))
            {
               this.fills[3].push(param1);
               this.fillAlphas[3].push(param1.alpha);
               param1.alpha = 1;
            }
            else if(isColorName(param1.name,5))
            {
               this.fills[4].push(param1);
               this.fillAlphas[4].push(param1.alpha);
               param1.alpha = 1;
            }
            else if(param1.name.substr(0,4) == "line")
            {
               this.lines.push(param1);
            }
            else if(param1.name == "image")
            {
               this.images.push(param1);
            }
            else if(param1.name == "inner")
            {
               this.inners.push(param1);
            }
            else if(param1 is PropPart)
            {
               this.movables.push(new PropMovablePart(param1 as PropPart,this.numMovables()));
               this.movableMap[param1.name] = this.movables[this.numMovables() - 1];
            }
            this.checkForFills(param1);
            _loc2_++;
         }
      }
      
      override public function redraw(param1:Boolean = false) : void
      {
         Utils.monitorMemory("prop");
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
      }
      
      function getData() : Object
      {
         return {
            "id":this.id,
            "x":x,
            "y":y,
            "z":zIndex,
            "r":rotation,
            "sz":size,
            "sx":flipX,
            "sy":flipY,
            "c":getColor(0),
            "c2":getColor(1),
            "c3":getColor(2),
            "c4":getColor(3),
            "c5":getColor(4),
            "sh":(!!silhouette ? 1 : 0),
            "a":this.getAlpha(),
            "s":this.getPropType(),
            "ex":Utils.encode(this.getExtraData()),
            "an":(!!this.isAnimating() ? 1 : 0)
         };
      }
      
      override function getExtraData() : Object
      {
         var _loc2_:uint = 0;
         var _loc1_:Object = {};
         var _loc3_:uint = this.movables.length;
         var _loc4_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_.push(this.getMovablePart(_loc2_));
            _loc2_++;
         }
         _loc1_.mov = _loc4_;
         return Utils.mergeObjects(_loc1_,super.getExtraData());
      }
      
      override function setExtraData(param1:Object = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 != null && param1.mov != null)
         {
            _loc3_ = this.movables.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.setMovablePart(_loc2_,param1.mov[_loc2_]);
               _loc2_++;
            }
         }
         super.setExtraData(param1);
      }
      
      private function getMovablePart(param1:uint) : uint
      {
         return PropMovablePart(this.movables[param1]).value;
      }
      
      private function setMovablePart(param1:uint, param2:uint) : void
      {
         PropMovablePart(this.movables[param1]).value = param2;
      }
      
      function hasMovables() : Boolean
      {
         return this.numMovables() > 0;
      }
      
      private function numMovables() : uint
      {
         return this.movables.length;
      }
      
      function getPropType() : uint
      {
         if(this is PropSet)
         {
            return PROP_SET;
         }
         if(this is PropPhoto)
         {
            return PROP_PHOTO;
         }
         if(this is WebPhoto)
         {
            return PROP_WEB;
         }
         return PROP_PRESET;
      }
      
      function setData(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:Object = {
            "x":x,
            "y":y
         };
         x = param1.x;
         y = param1.y;
         rotation = param1.r;
         if(param1.z != null)
         {
            zIndex = param1.z;
         }
         this.setAlpha(param1.a,false);
         setSilhouette(param1.sh == 1,false);
         if(param1.sz != null)
         {
            this.size = param1.sz;
            flipX = param1.sx;
            flipY = param1.sy;
            this.setColor(0,param1.c,param2);
            this.setColor(1,param1.c2,param2);
            this.setColor(2,param1.c3,param2);
            this.setColor(3,param1.c4,param2);
            this.setColor(4,param1.c5,param2);
         }
         if(param1.ex != null)
         {
            this.setExtraData(Utils.decode(param1.ex));
         }
         else
         {
            this.setExtraData();
         }
         this.setAnimating(param1.an != null && param1.an);
         if(Animation.isPlaying())
         {
            FX.motionBlur(this,_loc3_,param1);
         }
         else
         {
            FX.motionBlur(this);
         }
      }
      
      public function setName(param1:String) : void
      {
         this.propName = param1;
      }
      
      public function getName() : String
      {
         if(this.propName == null)
         {
            return "?";
         }
         return this.propName;
      }
      
      function hasFill(param1:uint) : Boolean
      {
         return this.fills[param1].length > 0 || param1 == 0 && this.images.length > 0;
      }
      
      function hasImages() : Boolean
      {
         return this.images != null && this.images.length > 0;
      }
      
      function isMultiColor() : Boolean
      {
         return this.hasFill(1);
      }
      
      function hasTransparentFills(param1:uint) : Boolean
      {
         return this.transparentFills != null && Utils.inArray(param1,this.transparentFills);
      }
      
      public function reloadColors() : void
      {
         this.setColor(0,_colorID[0],false,false);
         this.setColor(1,_colorID[1],false,false);
         this.setColor(2,_colorID[2],false,false);
         this.setColor(3,_colorID[3],false,false);
         this.setColor(4,_colorID[4],false,false);
      }
      
      override function setColor(param1:int, param2:*, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:DisplayObject = null;
         if(param2 == 0)
         {
            return;
         }
         if(param1 == -1)
         {
            this.setColor(0,param2[0],param3,param4);
            this.setColor(1,param2[1],param3,param4);
            this.setColor(2,param2[2],param3,param4);
            this.setColor(3,param2[3],param3,param4);
            this.setColor(4,param2[4],param3,param4);
            return;
         }
         if(param1 == -2)
         {
            this.setColor(0,param2,param3,param4);
            this.setColor(1,param2,param3,param4);
            this.setColor(2,param2,param3,param4);
            this.setColor(3,param2,param3,param4);
            this.setColor(4,param2,param3,param4);
            return;
         }
         if(!(param2 is Array) && param1 > 0 && param2 <= 0)
         {
            if(this.fills[param1].length > 0)
            {
               Main.warn("prop-color-missing",true);
            }
            return;
         }
         if(!param3)
         {
            _colorID[param1] = param2;
         }
         if(param2 is Array)
         {
            _loc5_ = param2.slice();
         }
         else
         {
            _loc5_ = [(_loc6_ = Palette.getColor(param2))[0],_loc6_[1],_loc6_[2]];
            if(param2 == Palette.TRANSPARENT_ID)
            {
               _loc5_[Palette.A] = 0;
            }
         }
         if(this.isAlphable())
         {
            _loc5_[Palette.A] = 255 * this.getAlpha() / 100;
         }
         if(silhouette)
         {
            if(param1 == 0 || param1 == -2)
            {
               if(this.asset.handle == null)
               {
                  Utils.setColor(this.asset,_loc5_,0,false);
               }
               else
               {
                  _loc8_ = this.asset.numChildren;
                  _loc7_ = 0;
                  while(_loc7_ < _loc8_)
                  {
                     if((_loc9_ = this.asset.getChildAt(_loc7_)) != this.asset.handle)
                     {
                        Utils.setColor(_loc9_,_loc5_,0,false);
                     }
                     _loc7_++;
                  }
               }
            }
         }
         else
         {
            Utils.setColor(this.asset);
            this.colorFills(_loc5_,param1);
         }
      }
      
      function colorFills(param1:Array, param2:int = -1) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param2 == -1 || param2 == -2)
         {
            param2 = 0;
            while(param2 < MAX_FILLS)
            {
               this.colorFills(param1,param2);
               param2++;
            }
         }
         else if(this.fills != null)
         {
            if(this.fills[param2] != null)
            {
               _loc4_ = this.fills[param2].length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  Utils.setColor(this.fills[param2][_loc3_],param1,0,false,this.fillAlphas[param2][_loc3_]);
                  _loc3_++;
               }
            }
            _loc4_ = this.images.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               Palette.setTint(this.images[_loc3_],param1);
               _loc3_++;
            }
         }
      }
      
      function setAlpha(param1:uint, param2:Boolean = true) : void
      {
         this._transparency = param1;
         if(param2)
         {
            this.setColor(-1,getColor());
         }
      }
      
      function getAlpha() : uint
      {
         return this._transparency;
      }
      
      function isAlphable() : Boolean
      {
         return this.asset.alphable != null;
      }
      
      override function canSilhouette() : Boolean
      {
         return !this.hasImages();
      }
      
      public function getAnimationData() : Object
      {
         return {
            "hh":0,
            "x":x,
            "y":y,
            "r":rotation,
            "a":this.getAlpha(),
            "sz":size,
            "sx":flipX,
            "sy":flipY,
            "c":getColor(0),
            "c2":getColor(1),
            "c3":getColor(2),
            "c4":getColor(3),
            "c5":getColor(4),
            "sh":(!!silhouette ? 1 : 0)
         };
      }
      
      public function getAnimationPositionData() : Object
      {
         return {
            "x":x,
            "y":y,
            "r":rotation
         };
      }
      
      public function getInterpolatedPositionData(param1:Array, param2:Number) : Object
      {
         return this.setAnimationData(param1,param2,true);
      }
      
      public function setAnimationData(param1:Array, param2:Number, param3:Boolean = false) : Object
      {
         var _loc4_:Object = null;
         setHidden(Animation.interpolate(param1[0].hh,param1[1].hh,param1[2].hh,param1[3].hh,param2,0,false,Animation.INTERPOLATE_BINARY_ONKEY) == 1);
         if(!getHidden())
         {
            (_loc4_ = {}).x = Animation.interpolate(param1[0].x,param1[1].x,param1[2].x,param1[3].x,param2);
            _loc4_.y = Animation.interpolate(param1[0].y,param1[1].y,param1[2].y,param1[3].y,param2);
            _loc4_.r = Animation.interpolate(param1[0].r,param1[1].r,param1[2].r,param1[3].r,param2,Utils.WRAP_360);
            _loc4_.a = Animation.interpolate(param1[0].a,param1[1].a,param1[2].a,param1[3].a,param2);
            _loc4_.sx = Animation.interpolate(param1[0].sx,param1[1].sx,param1[2].sx,param1[3].sx,param2);
            _loc4_.sy = Animation.interpolate(param1[0].sy,param1[1].sy,param1[2].sy,param1[3].sy,param2);
            _loc4_.sz = Animation.interpolate(param1[0].sz,param1[1].sz,param1[2].sz,param1[3].sz,param2,0,false,Animation.INTERPOLATE_CONTINUOUS,Animation.INTERPOLATE_COSINE);
            _loc4_.c = Animation.interpolate(param1[0].c,param1[1].c,param1[2].c,param1[3].c,param2,0,true,Animation.INTERPOLATE_COLOR,Animation.INTERPOLATE_COSINE);
            _loc4_.c2 = Animation.interpolate(param1[0].c2,param1[1].c2,param1[2].c2,param1[3].c2,param2,0,true,Animation.INTERPOLATE_COLOR,Animation.INTERPOLATE_COSINE);
            _loc4_.c3 = Animation.interpolate(param1[0].c3,param1[1].c3,param1[2].c3,param1[3].c3,param2,0,true,Animation.INTERPOLATE_COLOR,Animation.INTERPOLATE_COSINE);
            _loc4_.c4 = Animation.interpolate(param1[0].c4,param1[1].c4,param1[2].c4,param1[3].c4,param2,0,true,Animation.INTERPOLATE_COLOR,Animation.INTERPOLATE_COSINE);
            _loc4_.c5 = Animation.interpolate(param1[0].c5,param1[1].c5,param1[2].c5,param1[3].c5,param2,0,true,Animation.INTERPOLATE_COLOR,Animation.INTERPOLATE_COSINE);
            _loc4_.sh = Animation.interpolate(param1[0].sh,param1[1].sh,param1[2].sh,param1[3].sh,param2,0,true,Animation.INTERPOLATE_BINARY);
            if(param3)
            {
               return _loc4_;
            }
            this.setData(_loc4_,true);
         }
         return null;
      }
      
      override public function getAttachPos() : Point
      {
         return this.localToGlobal(new Point(0,0));
      }
      
      private function loadImage() : void
      {
         var image:MovieClip = null;
         var imagePath:String = null;
         var loadedImage:DisplayObject = null;
         var cacheKey:String = null;
         var bitmapData:BitmapData = null;
         if(this.dummy)
         {
            return;
         }
         for each(image in this.images)
         {
            if(image.jpg != null)
            {
               cacheKey = "prop";
               imagePath = "style/" + Platform._get("key") + "/prop/" + this.id + ".jpg";
               bitmapData = Cache.load(cacheKey,this.id);
               if(bitmapData == null)
               {
                  Utils.load(imagePath,function(param1:Event):void
                  {
                     onLoadImage(param1,image,cacheKey,id);
                  },false,File.BUCKET_ASSET);
               }
               else
               {
                  this.placeImage(image,bitmapData);
               }
            }
         }
      }
      
      private function placeImage(param1:MovieClip, param2:BitmapData) : Bitmap
      {
         var _loc3_:Bitmap = new Bitmap(param2);
         _loc3_.smoothing = true;
         if(param1.jpg.parent != null)
         {
            param1.removeChild(param1.jpg);
         }
         param1.addChild(_loc3_);
         return _loc3_;
      }
      
      private function onLoadImage(param1:Event, param2:MovieClip, param3:String, param4:uint) : void
      {
         var _loc5_:BitmapData = Bitmap(param1.target.loader.contentLoaderInfo.content).bitmapData;
         this.placeImage(param2,_loc5_);
         Cache.save(param3,param4,_loc5_);
      }
      
      public function set dummy(param1:Boolean) : void
      {
         this._isDummy = param1;
      }
      
      public function get dummy() : Boolean
      {
         return this._isDummy;
      }
      
      public function hasAnimation() : Boolean
      {
         return this.asset != null && this.asset.animation != null;
      }
      
      public function isAnimating() : Boolean
      {
         return this._animating;
      }
      
      public function setAnimating(param1:Boolean) : void
      {
         if(!this.hasAnimation())
         {
            return;
         }
         this._animating = param1;
         if(param1)
         {
            this.asset.animation.gotoAndPlay(1);
         }
         else
         {
            this.asset.animation.gotoAndStop(1);
         }
      }
      
      public function getMode() : uint
      {
         return this._editMode;
      }
      
      public function setMode(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:PropMovablePart = null;
         var _loc4_:MovieClip = null;
         if(param1 == this.getMode() && !param2)
         {
            return;
         }
         onSetMode(param1);
         if(param1 == Editor.MODE_EXPR)
         {
            Utils.useHand(this as MovieClip,false);
            for each(_loc3_ in this.movables)
            {
               _loc4_ = _loc3_.target;
               Utils.addListener(_loc4_,MouseEvent.ROLL_OVER,this.onOverPart);
               Utils.useHand(_loc4_ as MovieClip,true);
               _loc4_.mouseEnabled = true;
               _loc4_.mouseChildren = _loc4_.mouseEnabled;
            }
         }
         else
         {
            Utils.useHand(this as MovieClip,true);
            for each(_loc3_ in this.movables)
            {
               _loc4_ = _loc3_.target;
               Utils.removeListener(_loc4_,MouseEvent.ROLL_OVER,this.onOverPart);
               _loc4_.mouseEnabled = false;
               _loc4_.mouseChildren = _loc4_.mouseEnabled;
            }
         }
         this._editMode = param1;
      }
      
      private function onOverPart(param1:MouseEvent) : void
      {
         if(this.startPoint != null)
         {
            return;
         }
         this.currentTargetOver = param1.currentTarget;
         this.currentPartIndex = PropMovablePart(this.movableMap[this.currentTargetOver.name]).index;
         this.highlightPart(this.currentTargetOver);
         Utils.addListener(this.currentTargetOver,MouseEvent.MOUSE_DOWN,this.startPart);
         Utils.addListener(this.currentTargetOver,MouseEvent.ROLL_OUT,this.onOutPart);
      }
      
      private function onOutPart(param1:MouseEvent = null) : void
      {
         if(this.startPoint != null)
         {
            return;
         }
         this.highlightPart(this.currentTargetOver,false);
         Utils.removeListener(this.currentTargetOver,MouseEvent.MOUSE_DOWN,this.startPart);
         Utils.removeListener(this.currentTargetOver,MouseEvent.ROLL_OUT,this.onOutPart);
         this.currentTargetOver = null;
      }
      
      private function startPart(param1:MouseEvent) : void
      {
         this.startPoint = new Point(param1.stageX,param1.stageY);
         this.startPosition = this.getMovablePart(this.currentPartIndex);
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updatePart);
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.stopPart);
      }
      
      private function updatePart(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Number = _loc2_.x - this.startPoint.x;
         this.setMovablePart(this.currentPartIndex,this.startPosition - Math.round(_loc3_ / MOVABLE_DX) * flipX);
      }
      
      private function stopPart(param1:MouseEvent) : void
      {
         this.startPoint = null;
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updatePart);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.stopPart);
         this.onOutPart();
      }
      
      private function highlightPart(param1:Object, param2:Boolean = true) : void
      {
         if(param2)
         {
            this.revealHotspot(param1 as MovieClip,Editor.COLOR[this.getMode()]);
         }
         else
         {
            this.concealHotspot(param1 as MovieClip);
         }
      }
      
      function revealHotspot(param1:MovieClip, param2:Array) : void
      {
         FX.glow(param1);
         Utils.setColor(param1,param2,1 - (!!Utils.SCREEN_CAPTURE_MODE ? 0 : Globals.HIGHLIGHTING_ALPHA),true);
      }
      
      function concealHotspot(param1:MovieClip) : void
      {
         FX.glow(param1,0);
         Utils.setColor(param1);
      }
      
      function setLineAlpha(param1:Number) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in this.lines)
         {
            _loc2_.alpha = param1;
         }
      }
      
      override function set size(param1:Number) : void
      {
         super.size = param1;
         this.updateInners();
      }
      
      public function updateInners(param1:Number = 0) : void
      {
         if(!this.inners || this.inners.length == 0)
         {
            return;
         }
         if(param1 == 0)
         {
            param1 = Editor.getTotalScale(this);
         }
         var _loc2_:Number = Utils.limit(param1 / 2,0.1,1);
         var _loc3_:uint = this.inners.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            MovieClip(this.inners[_loc4_]).alpha = _loc2_;
            _loc4_++;
         }
      }
   }
}

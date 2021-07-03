package com.pixton.character
{
   import com.pixton.characterSkin.Expression;
   import com.pixton.characterSkin.Texture;
   import com.pixton.editor.Cache;
   import com.pixton.editor.Debug;
   import com.pixton.editor.File;
   import com.pixton.editor.Palette;
   import com.pixton.editor.Platform;
   import com.pixton.editor.Utils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Point;
   
   public final class BodyPartLook
   {
      
      private static const excludes:Array = ["special","ear1","ear2","movable","brow","ontop","onbottom","long","masker","buttons","photo"];
      
      private static const excludesStart:Array = ["fill","line","drawing","anchor","pivot"];
      
      private static const hidables:Array = ["buttons"];
       
      
      var target:MovieClip;
      
      var maskers:Array;
      
      var onTop:Boolean = false;
      
      var onBottom:Boolean = false;
      
      var isLong:Boolean = false;
      
      var photo:MovieClip;
      
      var drawing:MovieClip;
      
      var drawing2:MovieClip;
      
      var drawing3:MovieClip;
      
      var drawing4:MovieClip;
      
      var drawing5:MovieClip;
      
      private var variants:Array;
      
      private var fills:Array;
      
      private var lines:Array;
      
      private var textures:Array;
      
      private var images:Array;
      
      private var movables:Array;
      
      private var movableContainers:Array;
      
      private var movableInitPos:Array;
      
      private var movableSavedPos:Array;
      
      private var special:Array;
      
      private var cullables:Array;
      
      private var noscaleLine:MovieClip;
      
      private var noscaleFill:MovieClip;
      
      private var currentValue:uint;
      
      private var movable:Boolean = false;
      
      private var map:Object;
      
      private var hidable:Array;
      
      public function BodyPartLook(param1:MovieClip)
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         super();
         this.target = param1;
         this.variants = [];
         this.lines = [];
         this.fills = [[],[],[],[],[],[]];
         this.textures = [];
         this.images = [];
         this.special = [];
         this.movables = [];
         this.movableContainers = [];
         this.movableInitPos = [];
         this.cullables = [];
         this.hidable = [];
         if(param1._ == null)
         {
            _loc7_ = [];
            _loc4_ = param1.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               _loc5_ = param1.getChildAt(_loc2_);
               _loc7_.push(_loc5_);
               _loc2_++;
            }
            param1._ = _loc7_;
            param1._y0 = param1.y;
         }
         this.map = {};
         for each(_loc5_ in param1._)
         {
            if(_loc5_ is MovieClip)
            {
               MovieClip(_loc5_).mouseEnabled = false;
               MovieClip(_loc5_).mouseChildren = false;
            }
            if(_loc5_.name != null && !(_loc5_ is Shape))
            {
               this.setPivot(_loc5_);
            }
            if(Utils.startsWith(_loc5_.name,"fill"))
            {
               MovieClip(_loc5_).mouseEnabled = true;
               if(_loc5_.name == "fill")
               {
                  if(this.fills[0] == null)
                  {
                     this.fills[0] = [];
                  }
                  this.fills[0].push(_loc5_);
                  if(_loc5_.noscale != null)
                  {
                     this.noscaleFill = _loc5_.noscale as MovieClip;
                  }
               }
               else
               {
                  _loc8_ = parseInt(_loc5_.name.substr(4)) - 1;
                  if(this.fills[_loc8_] == null)
                  {
                     this.fills[_loc8_] = [];
                  }
                  this.fills[_loc8_].push(_loc5_);
               }
            }
            else if(Utils.startsWith(_loc5_.name,"line"))
            {
               this.lines.push(_loc5_);
            }
            else if(_loc5_.name == "image")
            {
               this.images.push(_loc5_);
            }
            else if(_loc5_.name == "drawing")
            {
               this.drawing = _loc5_ as MovieClip;
            }
            else if(_loc5_.name == "drawing2")
            {
               this.drawing2 = _loc5_ as MovieClip;
            }
            else if(_loc5_.name == "drawing3")
            {
               this.drawing3 = _loc5_ as MovieClip;
            }
            else if(_loc5_.name == "drawing4")
            {
               this.drawing4 = _loc5_ as MovieClip;
            }
            else if(_loc5_.name == "drawing5")
            {
               this.drawing5 = _loc5_ as MovieClip;
            }
            else if(_loc5_.name == "photo")
            {
               this.photo = _loc5_ as MovieClip;
               _loc5_.visible = false;
            }
            else if(Utils.inArray(_loc5_.name,hidables))
            {
               this.hidable.push(_loc5_);
            }
            else if(_loc5_ is Texture)
            {
               this.addTexture(_loc5_ as Texture);
            }
            else if(_loc5_.name == "ontop")
            {
               this.onTop = true;
            }
            else if(_loc5_.name == "onbottom")
            {
               this.onBottom = true;
            }
            else if(_loc5_.name == "long")
            {
               this.isLong = true;
            }
            else if(_loc5_.name == "movable")
            {
               this.movable = true;
            }
            else if(_loc5_.name == "noscale")
            {
               this.noscaleLine = _loc5_ as MovieClip;
            }
            else if(_loc5_.name == "special")
            {
               this.special.push(_loc5_);
               this.cullables.push(_loc5_);
               this.hidable.push(_loc5_);
               if(_loc5_["fill"] != null)
               {
                  this.fills[0].push(_loc5_["fill"]);
               }
               if(_loc5_["fill2"] != null)
               {
                  this.fills[1].push(_loc5_["fill2"]);
               }
               if(_loc5_["fill3"] != null)
               {
                  this.fills[2].push(_loc5_["fill3"]);
               }
               if(_loc5_["fill4"] != null)
               {
                  this.fills[3].push(_loc5_["fill4"]);
               }
               if(_loc5_["fill5"] != null)
               {
                  this.fills[4].push(_loc5_["fill5"]);
               }
               if(_loc5_["fill6"] != null)
               {
                  this.fills[5].push(_loc5_["fill6"]);
               }
            }
            else if(_loc5_.name == "masker")
            {
               if(this.maskers == null)
               {
                  this.maskers = [];
               }
               this.maskers.push(_loc5_);
               _loc5_.visible = false;
               if(_loc5_.fill != null)
               {
                  this.fills[0].push(_loc5_.fill);
               }
               this.cullables.push(_loc5_);
            }
            if(!Debug.ACTIVE && (Utils.startsWith(_loc5_.name,"anchor") || Utils.startsWith(_loc5_.name,"drawing")))
            {
               while(_loc5_.numChildren > 0)
               {
                  _loc5_.removeChildAt(0);
               }
            }
            if(!(!(_loc5_ is MovieClip) || Utils.inArray(_loc5_.name,excludes) || Utils.startsWithArr(_loc5_.name,excludesStart)))
            {
               if(_loc5_ is Expression)
               {
                  MovieClip(_loc5_).mouseEnabled = true;
                  MovieClip(_loc5_).mouseChildren = true;
                  this.variants.push(_loc5_);
               }
               _loc3_ = _loc5_.numChildren;
               _loc9_ = 0;
               while(_loc9_ < _loc3_)
               {
                  if((_loc6_ = _loc5_.getChildAt(_loc9_)) is MovieClip)
                  {
                     MovieClip(_loc6_).mouseEnabled = false;
                     MovieClip(_loc6_).mouseChildren = false;
                  }
                  if(Utils.startsWith(_loc6_.name,"fill"))
                  {
                     MovieClip(_loc6_).mouseEnabled = true;
                     _loc8_ = _loc6_.name == "fill" ? uint(0) : uint(parseInt(_loc6_.name.substr(4)) - 1);
                     if(this.fills[_loc8_] == null)
                     {
                        this.fills[_loc8_] = [];
                     }
                     this.fills[_loc8_].push(_loc6_);
                  }
                  else if(Utils.startsWith(_loc6_.name,"line"))
                  {
                     this.lines.push(_loc6_);
                  }
                  else if(_loc6_.name == "movable")
                  {
                     this.movables[this.variants.length - 1] = _loc6_;
                     this.movableInitPos[this.variants.length - 1] = {
                        "x":_loc6_.x,
                        "y":_loc6_.y
                     };
                     if(_loc6_.fill != null)
                     {
                        this.fills[0].push(_loc6_.fill);
                     }
                  }
                  else if(_loc6_.name == "container")
                  {
                     this.movableContainers[this.variants.length - 1] = _loc6_;
                  }
                  else if(_loc6_ is Texture)
                  {
                     this.addTexture(_loc6_ as Texture,this.variants.length);
                  }
                  _loc9_++;
               }
            }
         }
      }
      
      private function addTexture(param1:Texture, param2:uint = 0) : void
      {
         if(this.textures[param2] == null)
         {
            this.textures[param2] = [];
         }
         this.textures[param2].push(param1);
      }
      
      private function setPivot(param1:Object) : void
      {
         var _loc2_:String = null;
         if(Utils.startsWith(param1.name,"pivot_"))
         {
            _loc2_ = param1.name.substr(6);
         }
         else
         {
            _loc2_ = param1.name;
         }
         this.map[_loc2_] = param1;
      }
      
      function getPivot(param1:String) : DisplayObject
      {
         if(this.map[param1] == null)
         {
            param1 = "pivot";
         }
         if(this.map[param1].parent == null)
         {
            this.target.addChild(this.map[param1]);
         }
         return this.map[param1];
      }
      
      function isVariable() : Boolean
      {
         return this.variants.length > 1;
      }
      
      function isMovable() : Boolean
      {
         return this.movables.length > 0;
      }
      
      function saveMovablePos() : void
      {
         var _loc1_:uint = 0;
         this.movableSavedPos = [];
         var _loc2_:uint = this.movables.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.movables[_loc1_] != null)
            {
               this.movableSavedPos.push(new Point(this.movables[_loc1_].x,this.movables[_loc1_].y));
            }
            _loc1_++;
         }
      }
      
      function getMovablePos() : Object
      {
         var _loc1_:DisplayObject = this.target;
         while(_loc1_ != null)
         {
            _loc1_ = _loc1_.parent;
         }
         if(this.movables[this.currentValue] != null)
         {
            return {
               "x":this.movables[this.currentValue].x,
               "y":this.movables[this.currentValue].y
            };
         }
         if(this.movableInitPos.length > 0)
         {
            return {
               "x":this.movableInitPos[0].x,
               "y":this.movableInitPos[0].y
            };
         }
         return {
            "x":0,
            "y":0
         };
      }
      
      function setMovablePos(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this.movables.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.movables[_loc2_] != null)
            {
               if(!(param1.x == -4.55 && param1.y == 0))
               {
                  this.movables[_loc2_].x = param1.x;
                  this.movables[_loc2_].y = param1.y;
               }
            }
            _loc2_++;
         }
      }
      
      function flipMovable() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.movables.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.movables[_loc1_] != null)
            {
               this.movables[_loc1_].x = this.movableInitPos[_loc1_].x + (this.movableInitPos[_loc1_].x - this.movables[_loc1_].x);
            }
            _loc1_++;
         }
      }
      
      function updateMovable(param1:Point, param2:Point, param3:Object) : void
      {
         var _loc7_:uint = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Point = null;
         var _loc4_:Point = this.target.globalToLocal(param1);
         var _loc5_:Point = this.target.globalToLocal(param2);
         var _loc6_:DisplayObject = this.target;
         while(_loc6_ != null)
         {
            _loc6_ = _loc6_.parent;
         }
         var _loc8_:uint = this.movables.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(this.movables[_loc7_] != null)
            {
               _loc9_ = this.movableInitPos[_loc7_].x + _loc5_.x - _loc4_.x;
               _loc10_ = this.movableInitPos[_loc7_].y + _loc5_.y - _loc4_.y;
               _loc11_ = this.movables[_loc7_].parent.localToGlobal(new Point(_loc9_,_loc10_));
               if(this.movables[_loc7_].stage == null || this.movableContainers[_loc7_] != null && this.movableContainers[_loc7_].hitTestPoint(_loc11_.x,_loc11_.y,true))
               {
                  this.movables[_loc7_].x = _loc9_;
                  this.movables[_loc7_].y = _loc10_;
               }
               if(param3 != null && param3.y != null)
               {
                  this.movables[_loc7_].y = param3.y;
               }
            }
            _loc7_++;
         }
      }
      
      function getNum() : uint
      {
         return this.variants.length;
      }
      
      function setYOff(param1:Number) : void
      {
         this.target.y = this.target._y0 + param1;
      }
      
      function getYOffset() : Number
      {
         if(this.variants[this.currentValue] == null || this.variants[this.currentValue].yoffset == null)
         {
            return 0;
         }
         return this.variants[this.currentValue].yoffset.y;
      }
      
      function getAnchor(param1:String, param2:Boolean = false) : MovieClip
      {
         if(this.map[param1] == null)
         {
            if(isNaN(this.currentValue) || this.variants[this.currentValue] == null)
            {
               return null;
            }
            return this.variants[this.currentValue][param1];
         }
         if(param2 && this.map[param1].parent == null)
         {
            this.target.addChild(this.map[param1]);
         }
         return this.map[param1];
      }
      
      function set expression(param1:uint) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.variants.length)
         {
            if(this.variants[_loc2_].parent == null)
            {
               if(_loc2_ == param1)
               {
                  this.target.addChild(this.variants[_loc2_]);
               }
            }
            else if(_loc2_ != param1)
            {
               this.target.removeChild(this.variants[_loc2_]);
            }
            _loc2_++;
         }
         this.currentValue = param1;
      }
      
      function get expression() : uint
      {
         return this.currentValue;
      }
      
      function setColor(param1:Array, param2:uint = 0) : void
      {
         var _loc3_:Object = null;
         var _loc4_:MovieClip = null;
         for each(_loc3_ in this.fills[param2])
         {
            Utils.setColor(_loc3_,param1,0,_loc3_.preserveAlpha != null);
         }
         if(param2 == 0)
         {
            for each(_loc4_ in this.images)
            {
               Palette.setTint(_loc4_,param1);
            }
         }
      }
      
      function loadImage(param1:uint, param2:String, param3:uint) : void
      {
         var image:MovieClip = null;
         var imagePath:String = null;
         var loadedImage:DisplayObject = null;
         var cacheKey:String = null;
         var bitmapData:BitmapData = null;
         var skinType:uint = param1;
         var targetName:String = param2;
         var lookValue:uint = param3;
         for each(image in this.images)
         {
            if(image.png != null)
            {
               cacheKey = skinType + "_" + targetName;
               imagePath = "style/" + Platform._get("key") + "/character/" + cacheKey + "_" + lookValue + ".png";
               bitmapData = Cache.load(cacheKey,lookValue);
               if(bitmapData == null)
               {
                  Utils.load(imagePath,function(param1:Event):void
                  {
                     onLoadImage(param1,image,cacheKey,lookValue);
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
         if(param1.png.parent != null)
         {
            param1.removeChild(param1.png);
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
      
      function updateScale(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = 1 / param2 * param1;
         if(this.noscaleLine != null)
         {
            this.noscaleLine.scaleY = _loc3_;
         }
         if(this.noscaleFill != null)
         {
            this.noscaleFill.scaleY = _loc3_;
         }
      }
      
      function updateMovableScale(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this.movables.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.movables[_loc2_] != null)
            {
               this.movables[_loc2_].scaleX = param1;
               this.movables[_loc2_].scaleY = this.movables[_loc2_].scaleX;
            }
            _loc2_++;
         }
      }
      
      function show(param1:Boolean) : void
      {
         this.target.visible = param1;
      }
      
      function showSpecial(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.special)
         {
            _loc2_.visible = param1;
         }
      }
      
      function hasImages() : Boolean
      {
         return this.images.length > 0;
      }
      
      function getTexture() : DisplayObject
      {
         if(this.textures.length == 0)
         {
            return null;
         }
         if(this.textures[0] != null && this.textures[0].length > 0)
         {
            return this.textures[0][0];
         }
         if(this.textures[this.currentValue + 1] != null && this.textures[this.currentValue + 1].length > 0)
         {
            return this.textures[this.currentValue + 1][0];
         }
         return null;
      }
      
      function isFixed() : Boolean
      {
         return !this.movable;
      }
      
      function cull() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this.cullables)
         {
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      function hideExtra() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this.hidable)
         {
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      function setLineAlpha(param1:Number) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in this.lines)
         {
            _loc2_.alpha = param1;
         }
      }
   }
}

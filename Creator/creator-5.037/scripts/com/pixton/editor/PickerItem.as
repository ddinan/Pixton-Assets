package com.pixton.editor
{
   import com.pixton.character.BodyPart;
   import com.pixton.character.BodyParts;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class PickerItem extends MovieClip
   {
      
      public static const FADE_DURATION:Number = 0.25;
      
      public static const IMAGE_EXT:String = ".png";
      
      public static const FILL_COLOR:uint = 16777215;
      
      public static const COLOR_SELECTED:uint = 16763904;
      
      public static const COLOR_LINE:uint = 0;
      
      private static const DESIGNER_PADDING:Number = 5;
      
      private static const ALPHA_PAIR:Number = 0.9;
      
      private static const ALPHA_DISABLED:Number = 0.5;
      
      private static const LOAD_STAGGER:uint = 200;
      
      private static var matrix:Matrix;
      
      private static var staggerCount:uint = 0;
      
      private static var dummyChar:Character;
      
      private static var dummyChars:Object = {};
       
      
      public var fill:MovieClip;
      
      public var btnDelete:ButtonDelete;
      
      public var lock:Object;
      
      private var frame:MovieClip;
      
      var bodyPart:BodyPart;
      
      var bodyPart2:BodyPart;
      
      var type:int = -1;
      
      var id:int;
      
      var value:int;
      
      var pool:int;
      
      private var _width:uint;
      
      private var _height:uint;
      
      private var timeout:uint;
      
      private var itemName:String;
      
      private var tween:PixtonTween;
      
      private var imageContainer:MovieClip;
      
      private var targetName:String;
      
      private var cacheBM:Bitmap;
      
      private var cacheData:Object;
      
      private var _selected:Boolean = false;
      
      private var _showName:Boolean = false;
      
      public function PickerItem(param1:Object)
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         super();
         var _loc2_:int = Utils._get("i",param1);
         var _loc3_:int = Utils._get("subType",param1);
         _loc4_ = Utils._get("type",param1);
         _loc5_ = Utils._get("value",param1,0);
         var _loc6_:Class = Utils._get("targetClass",param1);
         var _loc7_:BodyPart = Utils._get("bodyPart",param1);
         var _loc8_:Class = Utils._get("targetClass2",param1);
         var _loc9_:BodyPart = Utils._get("bodyPart2",param1);
         var _loc10_:Object = Utils._get("obj",param1);
         var _loc11_:Boolean = false;
         var _loc12_:uint = Utils._get("cols",param1);
         var _loc13_:uint = Utils._get("totalNum",param1);
         var _loc14_:Object = Utils._get("extra",param1);
         var _loc15_:Function = Utils._get("onComplete",param1);
         this.lock = Utils._get("lock",param1);
         this._width = Utils._get("w",param1);
         this._height = Utils._get("h",param1);
         this._showName = Utils._get("showName",param1);
         this.pool = Utils._get("pool",param1);
         Utils.useHand(this);
         visible = false;
         if(_loc4_ == Globals.FONT_FACE)
         {
            if(_loc12_ == 1)
            {
               _loc5_ = Fonts.maxFontID - _loc5_ - Fonts.unicode.length;
            }
            else
            {
               _loc5_ = (_loc5_ += Fonts.unicode.length) % _loc12_ * Math.ceil(_loc13_ / _loc12_) + Math.floor(_loc5_ / _loc12_) - Fonts.unicode.length;
            }
         }
         this.value = _loc5_;
         if(Utils._get("deletable",param1,false))
         {
            this.btnDelete = new ButtonDelete();
            addChild(this.btnDelete);
            this.btnDelete.x = this._width;
            this.btnDelete.y = 0;
         }
         if(_loc4_ == Globals.DESIGNER)
         {
            _loc11_ = param1.n != null && param1.n > 12;
         }
         else if(Utils.inArray(_loc4_,[Globals.CHARACTERS,Globals.OUTFITS]))
         {
            _loc11_ = !Character.hasCacheData(_loc4_,_loc5_) && (Utils.inArray(this.pool,[Pixton.POOL_PRESET,Pixton.POOL_PRESET_2,Pixton.POOL_NEW]) || !Character.hasImage(_loc5_));
         }
         else if(Utils.inArray(_loc4_,[Globals.POSES,Globals.FACES,Globals.SEQUENCES]))
         {
            _loc11_ = false;
         }
         if(_loc11_)
         {
            this.timeout = setTimeout(this.create,staggerCount,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc14_,_loc15_,true);
            staggerCount += LOAD_STAGGER;
         }
         else
         {
            this.create(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc14_,_loc15_);
            visible = true;
         }
      }
      
      static function resetStagger() : void
      {
         staggerCount = 0;
      }
      
      private static function drawBox(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:uint, param6:Boolean = false) : void
      {
         var _loc7_:Graphics = param1.graphics;
         var _loc8_:Number = 0;
         if(param4 == 0 && !param6)
         {
            _loc7_.lineStyle();
            _loc7_.beginFill(param5);
         }
         else
         {
            _loc7_.lineStyle(!!param6 ? Number(1) : Number(param4),param5,!!param6 ? Number(1) : Number(1),true,"normal","square","miter");
            _loc8_ = !!param6 ? Number(0) : Number(Math.floor(param4 * 0.5));
         }
         _loc7_.moveTo(_loc8_,_loc8_);
         _loc7_.lineTo(param2 - _loc8_,_loc8_);
         _loc7_.lineTo(param2 - _loc8_,param3 - _loc8_);
         _loc7_.lineTo(_loc8_,param3 - _loc8_);
         _loc7_.lineTo(_loc8_,_loc8_);
         if(param4 == 0 && !param6)
         {
            _loc7_.endFill();
         }
      }
      
      private function create(param1:int, param2:uint, param3:int = 0, param4:Class = null, param5:BodyPart = null, param6:Class = null, param7:BodyPart = null, param8:Object = null, param9:Object = null, param10:Function = null, param11:Boolean = false) : void
      {
         var positionData:Array = null;
         var data:Object = null;
         var mc:MovieClip = null;
         var info:Object = null;
         var poseData:Object = null;
         var target:Object = null;
         var tf:TextFormat = null;
         var thumbPath:String = null;
         var bitmapData:BitmapData = null;
         var setData:Object = null;
         var icon:MovieClip = null;
         var more:MovieClip = null;
         var onPropLoaded:Function = null;
         var bm:Bitmap = null;
         var duplicate:MovieClip = null;
         var duplicate2:MovieClip = null;
         var toFit:MovieClip = null;
         var targetName:String = null;
         var duplicatesParent:MovieClip = null;
         var duplicatesContainer:MovieClip = null;
         var children:Array = null;
         var turnedAway:Boolean = false;
         var flipped:Boolean = false;
         var child:MovieClip = null;
         var upperPart:Object = null;
         var lowerPart:Object = null;
         var t:TextField = null;
         var masker:MovieClip = null;
         var g:Graphics = null;
         var plusIcon:MovieClip = null;
         var paidIcon:MovieClip = null;
         var subType:int = param1;
         var type:uint = param2;
         var value:int = param3;
         var targetClass:Class = param4;
         var bodyPart:BodyPart = param5;
         var targetClass2:Class = param6;
         var bodyPart2:BodyPart = param7;
         var obj:Object = param8;
         var extra:Object = param9;
         var onComplete:Function = param10;
         var doFade:Boolean = param11;
         this.imageContainer = new MovieClip();
         addChild(this.imageContainer);
         if(type == Globals.PROPS && Utils.inArray(this.pool,[Pixton.POOL_MINE,Pixton.POOL_COMMUNITY]))
         {
            type = Globals.PROPSETS;
         }
         this.type = type;
         switch(type)
         {
            case Globals.PROPSETS:
               setData = PropSet.getData(value);
               Utils.load(PropSet.getImagePath(setData.id),this.onLoadImage,false,File.BUCKET_DYNAMIC);
               this.updateBox();
               target = setData;
               visible = false;
               if(this._showName)
               {
                  this.itemName = Template.getSettingNameByID(setData.id);
                  if(this.itemName)
                  {
                     more = new iconMore();
                     more.x = this._width;
                     more.y = this._height;
                     addChild(more);
                  }
               }
               break;
            case Globals.PHOTOS:
            case Globals.BODY_PHOTOS:
               bitmapData = Cache.load("PropPhotoThumb",value);
               if(bitmapData != null)
               {
                  this.revealImage(bitmapData,false);
               }
               else
               {
                  Utils.load(PropPhoto.getImagePath(value),this.onLoadPhoto,false,File.BUCKET_DYNAMIC);
               }
               this.updateBox();
               target = PropPhoto.getData(value);
               visible = false;
               break;
            case Globals.PROPS:
               if(obj && obj.url)
               {
                  Utils.load(obj.url,this.onLoadPhoto,false,File.BUCKET_DYNAMIC);
                  this.updateBox();
                  visible = false;
               }
               else if(Prop.PRELOAD || !Prop.USE_IMAGES)
               {
                  onPropLoaded = function():void
                  {
                     updateBox();
                     Utils.fit(mc,fill);
                     Prop(mc).updateInners(0.25);
                  };
                  mc = new Prop(value,Prop.ICON,true) as MovieClip;
                  addChild(mc);
                  onPropLoaded();
               }
               else
               {
                  mc = new MovieClip();
                  bm = Prop.getSprite(value);
                  if(bm)
                  {
                     bm.x = Utils.DEFAULT_PADDING;
                     bm.y = Math.round((Picker.ITEM_HEIGHT_2 - Picker.ITEM_WIDTH) / 2);
                     mc.addChild(bm);
                     mc.graphics.beginFill(16777215);
                     mc.graphics.moveTo(0,0);
                     mc.graphics.lineTo(Picker.ITEM_WIDTH,0);
                     mc.graphics.lineTo(Picker.ITEM_WIDTH,Picker.ITEM_HEIGHT_2);
                     mc.graphics.lineTo(0,Picker.ITEM_HEIGHT_2);
                     mc.graphics.lineTo(0,0);
                     mc.graphics.endFill();
                  }
                  addChild(mc);
               }
               target = mc;
               break;
            case Globals.SEQUENCES:
               break;
            case Globals.POSES:
            case Globals.FACES:
               info = Pose.getInfo(value);
               this.itemName = info.name;
               if(obj && !(obj is Character) && obj.url)
               {
                  Utils.load(obj.url,this.onLoadPhoto,false,File.BUCKET_ASSET);
                  this.updateBox();
                  visible = false;
               }
               else
               {
                  poseData = info.poseData;
                  this.cacheData = Character.getCacheData(type,Character(obj).getID(),value);
                  if(this.cacheData != null)
                  {
                     this.cacheBM = new Bitmap(this.cacheData.bmd);
                     addChild(this.cacheBM);
                     this.updateBox();
                     this.setName(this.cacheData.name);
                  }
                  else
                  {
                     dummyChar = this.getDummyChar(subType,obj as Character);
                     if(type == Globals.FACES)
                     {
                        dummyChar.resetPose();
                        dummyChar.bodyParts.setExtraPositionData(Character(obj).bodyParts.getExtraPositionData());
                     }
                     mc = dummyChar as MovieClip;
                     addChild(mc);
                     if(poseData != null)
                     {
                        if(type == Globals.FACES)
                        {
                           dummyChar.bodyParts.setExpressionData(poseData.e,true,false);
                           dummyChar.bodyParts.resetHeadTurn();
                        }
                        else
                        {
                           dummyChar.bodyParts.setPositionData(poseData.p,false,true);
                           dummyChar.bodyParts.setExtraPositionData(poseData.px);
                           dummyChar.bodyParts.setExpressionData(poseData.e,false,true);
                        }
                     }
                     dummyChar.redraw(true);
                     this.updateBox();
                     if(type == Globals.FACES)
                     {
                        Utils.fit(mc,this.fill,Utils.NO_SCALE,false,Character(mc).getHeadParts(),0);
                        this.updateBox();
                     }
                     else
                     {
                        Utils.fit(mc,this.fill,Utils.NO_SCALE,true);
                     }
                     target = mc;
                     if(Main.isSavingPoses() || Main.isSavingPosesWeb())
                     {
                        Character.saveCacheData(type,value,Character(obj).skinType,this.saveSnapshot(mc,this.fill),this.setName(target));
                     }
                     else
                     {
                        Character.saveCacheData(type,Character(obj).getID(),value,this.saveSnapshot(mc,this.fill),this.setName(target));
                     }
                     mc.parent.removeChild(mc);
                  }
               }
               break;
            case Globals.CHARACTERS:
            case Globals.OUTFITS:
               this.cacheData = Character.getCacheData(type,value);
               if(this.cacheData != null)
               {
                  this.cacheBM = new Bitmap(this.cacheData.bmd);
                  this.imageContainer.addChild(this.cacheBM);
                  this.imageContainer.x = Math.round((this._width - this.cacheBM.width) * 0.5);
                  this.imageContainer.y = Math.round((this._height - this.cacheBM.height) * 0.5);
                  this.updateBox();
                  this.setName(this.cacheData.name);
               }
               else if(Character.hasImage(value) && !Utils.inArray(this.pool,[Pixton.POOL_PRESET,Pixton.POOL_PRESET_2,Pixton.POOL_NEW]))
               {
                  this.setName(Character.getName(value));
                  Utils.load(Character.getImagePath(value),this.onLoadImage,false,File.BUCKET_DYNAMIC);
                  this.updateBox();
               }
               else
               {
                  dummyChar = this.getDummyChar(-1,value);
                  dummyChar.resetPose();
                  mc = dummyChar as MovieClip;
                  addChild(mc);
                  dummyChar.redraw(true);
                  this.updateBox();
                  if(type == Globals.OUTFITS)
                  {
                     Character(mc).setBodyHeight(1,false);
                     Character(mc).setBodyWidth(1,false);
                     Character(mc).bodyParts.leaveOutfit();
                  }
                  Utils.fit(mc,this.fill,Utils.NO_SCALE,true);
                  this.updateBox();
                  target = mc;
                  Character.saveCacheData(type,value,0,this.saveSnapshot(mc,this.fill),this.setName(target),!Utils.inArray(this.pool,[Pixton.POOL_PRESET,Pixton.POOL_PRESET_2,Pixton.POOL_NEW]),onComplete);
                  mc.parent.removeChild(mc);
               }
               break;
            case Globals.LOOKS:
            case Globals.EXPRESSION:
               if(obj && obj.url)
               {
                  Utils.load(obj.url,this.onLoadPhoto,false,File.BUCKET_ASSET);
                  this.updateBox();
                  visible = false;
               }
               else
               {
                  targetName = bodyPart.getTargetName();
                  duplicate = new targetClass() as MovieClip;
                  duplicatesParent = new MovieClip();
                  if(bodyPart2 != null)
                  {
                     duplicatesContainer = new MovieClip();
                     toFit = duplicatesParent;
                     addChild(duplicatesContainer);
                  }
                  else
                  {
                     duplicatesContainer = this;
                     toFit = duplicate;
                  }
                  duplicatesContainer.addChild(duplicatesParent);
                  children = [duplicate];
                  if(bodyPart2 != null && Utils.inArray(targetName,["hair","collar","cape","hairBehind","collarBehind","capeBehind","upperArm1","lowerArm1","upperLeg1","lowerLeg1","upperArm2","lowerArm2","upperLeg2","lowerLeg2","sock1","foot1","sock2","foot2"]))
                  {
                     duplicate2 = new targetClass2() as MovieClip;
                     children.push(duplicate2);
                  }
                  turnedAway = bodyPart.isTurnedAway();
                  flipped = bodyPart.isFlippedTurn();
                  if(turnedAway && Utils.inArray(targetName,["hairBehind","collarBehind","capeBehind"]) || !turnedAway && Utils.inArray(targetName,["hair","collar","cape"]) || targetName.match(/^lower/) || targetName.match(/^foot/))
                  {
                     children.reverse();
                  }
                  for each(child in children)
                  {
                     duplicatesParent.addChild(child);
                  }
                  if(children.length > 1 && (targetName.match(/^lower/) || targetName.match(/^upper/) || targetName.match(/^sock/) || targetName.match(/^foot/)))
                  {
                     upperPart = duplicatesParent.getChildAt(0) as Object;
                     lowerPart = duplicatesParent.getChildAt(1) as Object;
                     if(upperPart.pivot)
                     {
                        Utils.matchPosition(lowerPart,upperPart.pivot);
                     }
                     if(upperPart.special)
                     {
                        MovieClip(upperPart.special).parent.removeChild(upperPart.special as MovieClip);
                     }
                  }
                  this.bodyPart = new BodyPart(duplicate,duplicate.skinType,duplicate.turnPos,bodyPart,null,true);
                  if(bodyPart.skinType == Globals.HUMAN)
                  {
                     if(targetName == "foot1" || targetName == "foot2")
                     {
                        toFit.scaleY = (!!bodyPart.flippedY ? -1 : 1) * (targetName == "foot1" ? -1 : 1);
                     }
                     else if(targetName == "hand1")
                     {
                        toFit.scaleY *= -1;
                     }
                  }
                  if(targetName == "hand1" || targetName == "hand2" || targetName == "foot1" || targetName == "foot2")
                  {
                     if(Main.isSavingPoses() || Main.isSavingPosesWeb())
                     {
                        duplicate.rotation = -90;
                     }
                     else
                     {
                        duplicate.rotation = bodyPart.target.rotation;
                     }
                  }
                  else if(targetName == "eye2" || targetName == "brow2" || flipped)
                  {
                     duplicate.scaleX = -duplicate.scaleX;
                     if(duplicate2 != null)
                     {
                        duplicate2.scaleX = duplicate.scaleX;
                     }
                  }
                  if(bodyPart2 != null && duplicate2 != null)
                  {
                     this.bodyPart2 = new BodyPart(duplicate2,bodyPart2.skinType,duplicate2.turnPos,bodyPart2,null,true);
                  }
                  if(type == Globals.EXPRESSION)
                  {
                     this.bodyPart.expression = value;
                     if(bodyPart2 != null)
                     {
                        this.bodyPart2.expression = value;
                     }
                  }
                  else
                  {
                     this.bodyPart.look = value;
                     if(targetName == "eye1" || targetName == "eye2")
                     {
                        this.bodyPart.expression = 0;
                     }
                     if(bodyPart2 != null)
                     {
                        if(bodyPart.skinType == Globals.HUMAN && targetName.match(/^sock/))
                        {
                           if(BodyParts.isBootSock(bodyPart.skinType,value))
                           {
                              this.bodyPart2.look = BodyParts.getFootFromSock(bodyPart.skinType,value);
                              duplicate2.rotation = -90;
                              duplicate2.y = BodyParts.BOOT_OFFSET_Y;
                           }
                           else
                           {
                              duplicate2.parent.removeChild(duplicate2);
                           }
                        }
                        else if(bodyPart.skinType == Globals.HUMAN && targetName.match(/^foot/))
                        {
                           if(BodyParts.isBootShoe(bodyPart.skinType,value))
                           {
                              this.bodyPart2.look = BodyParts.getSockFromFoot(bodyPart.skinType,value);
                              duplicate2.y = -BodyParts.BOOT_OFFSET_Y;
                           }
                           else
                           {
                              duplicate2.parent.removeChild(duplicate2);
                           }
                        }
                        else
                        {
                           this.bodyPart2.look = value;
                        }
                     }
                  }
                  this.bodyPart.cull();
                  this.updateBox();
                  Utils.fit(toFit,this.fill);
                  bitmapData = this.saveSnapshot(duplicatesParent,this.fill);
                  if(Main.isSavingPoses() || Main.isSavingPosesWeb())
                  {
                     Character.saveCacheData(type,value,bodyPart.skinType,bitmapData,targetName);
                  }
                  if(duplicate != null)
                  {
                     duplicate.parent.removeChild(duplicate);
                  }
                  if(duplicate2 != null && duplicate2.parent != null)
                  {
                     duplicate2.parent.removeChild(duplicate2);
                  }
                  if(duplicatesParent != this)
                  {
                     duplicatesParent.parent.removeChild(duplicatesParent);
                  }
               }
               break;
            case Globals.BORDER_SHAPE:
               targetClass = SkinManager.getDefinition("border.iconShape",value.toString());
               toFit = new targetClass() as MovieClip;
               addChild(toFit);
               this.updateBox();
               Utils.fit(toFit,this.fill);
               break;
            case Globals.BKGD_GRADIENT:
               targetClass = SkinManager.getDefinition("gradient.iconType",value.toString());
               toFit = new targetClass() as MovieClip;
               addChild(toFit);
               this.updateBox();
               Utils.fit(toFit,this.fill);
               break;
            case Globals.BUBBLE_SHAPE:
            case Globals.BUBBLE_SPIKE:
               if(type == Globals.BUBBLE_SHAPE)
               {
                  targetClass = SkinManager.getDefinition("dialog.iconShape",value.toString());
               }
               else
               {
                  targetClass = SkinManager.getDefinition("dialog.iconSpike",value.toString());
               }
               toFit = new targetClass() as MovieClip;
               if(type == Globals.BUBBLE_SHAPE)
               {
                  toFit.mouseEnabled = false;
                  toFit.txtDialog.text = L.text("text");
                  Dialog(obj).updateFormat(toFit.txtDialog);
               }
               addChild(toFit);
               this.updateBox();
               Utils.fit(toFit,this.fill);
               break;
            case Globals.FONT_FACE:
               if(value < 0)
               {
                  icon = new MovieClip();
                  t = new TextField();
                  t.type = TextFieldType.DYNAMIC;
                  t.selectable = false;
                  t.autoSize = TextFieldAutoSize.LEFT;
                  icon.addChild(t);
                  icon.mouseEnabled = false;
                  icon.cacheAsBitmap = true;
                  tf = new TextFormat(Fonts.unicode[-value - 1]);
                  t.text = L.text("unicode");
                  t.setTextFormat(tf);
               }
               else
               {
                  targetClass = SkinManager.getDefinition("fonts.FontIcon",value.toString());
                  icon = new targetClass() as MovieClip;
               }
               addChild(icon);
               this.updateBox();
               Utils.fit(icon,this.fill);
               this.saveSnapshot(icon,this.fill);
               icon.parent.removeChild(icon);
               break;
            case Globals.FONT_SIZE:
               break;
            case Globals.DESIGNER:
               dummyChar = this.getDummyChar(-1,obj as Character);
               if(extra.color != null)
               {
                  dummyChar.setColor(subType,value);
               }
               else if(extra.part != null)
               {
                  bodyPart = dummyChar.bodyParts.getPart(extra.part);
                  if(extra.stretch != null)
                  {
                     dummyChar.bodyParts.setLooksScale(extra.part,extra.stretch,extra.list[value]);
                  }
                  else
                  {
                     bodyPart.look = value;
                     dummyChar.bodyParts.enforceLooks(bodyPart);
                  }
               }
               else if(extra.outfit != null)
               {
                  dummyChar.setOutfit(Character.getData(value),false);
               }
               else if(extra.size == "width")
               {
                  dummyChar.setBodyWidth(extra.list[value]);
               }
               else if(extra.size == "height")
               {
                  dummyChar.setBodyHeight(extra.list[value]);
               }
               else if(extra.size == "size")
               {
                  dummyChar.setBodyHeight(extra.list[value][1],false);
                  dummyChar.setBodyWidth(extra.list[value][0]);
               }
               dummyChar.bodyParts.showHide(extra.show,extra.hide);
               mc = dummyChar as MovieClip;
               addChild(mc);
               dummyChar.redraw(true);
               this.updateBox(true,DESIGNER_PADDING);
               if(extra.zoom != null)
               {
                  Utils.fit(mc,this.fill,Utils.NO_SCALE,false,Character(mc).getHeadParts(extra.zoom),10,extra.zoomLevel != null ? Number(extra.zoomLevel) : Number(0.8));
                  this.updateBox(true,DESIGNER_PADDING);
               }
               else
               {
                  Utils.fit(mc,this.fill,Utils.NO_SCALE,true);
               }
               target = mc;
               this.saveSnapshot(mc,this.fill);
               mc.parent.removeChild(mc);
               break;
            default:
               this.updateBox();
               if(value == Palette.TRANSPARENT_ID)
               {
                  Utils.setColor(this.fill,Palette.WHITE);
                  masker = new MovieClip();
                  addChild(masker);
                  g = masker.graphics;
                  g.lineStyle(1,16711680,1);
                  g.moveTo(this.fill.width,0);
                  g.lineTo(0,this.fill.height);
               }
               else
               {
                  Utils.setColor(this.fill,Palette.getColor(value));
               }
         }
         if(type == Globals.FONT_FACE && value > Fonts.minFontID && !FeatureTrial.can(FeatureTrial.EXTRA_FONTS))
         {
            this.fill.getChildAt(0).alpha = 0.6;
            plusIcon = new iconPickerPlus();
            plusIcon.x = Math.round(width);
            plusIcon.y = 0;
            addChild(plusIcon);
         }
         else if(this.lock != null && !(this.lock.plusFree_bool == 1 && Globals.isFullVersion()) && !(Platform.exists() && this.lock.platformFree_bool == 1))
         {
            paidIcon = new iconPickerPaid();
            paidIcon.x = Math.round(width);
            paidIcon.y = 0;
            addChild(paidIcon);
         }
         if(this.btnDelete != null)
         {
            Utils.rearrange(this.btnDelete,true,1);
         }
         if(doFade)
         {
            alpha = 0;
            visible = true;
            this.tween = new PixtonTween(this,"alpha",1,0,FADE_DURATION);
         }
         else
         {
            visible = false;
         }
         this.setName(target);
      }
      
      private function getDummyChar(param1:int, param2:*) : Character
      {
         var _loc3_:Character = null;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         if(param2 is Character)
         {
            _loc4_ = Character(param2).getID();
            _loc5_ = Character(param2).getGenome();
         }
         else
         {
            _loc4_ = param2;
            _loc5_ = Character.getData(_loc4_);
         }
         if(param1 == -1)
         {
            param1 = _loc5_.t;
         }
         if(dummyChars[param1.toString()] == null)
         {
            _loc3_ = new Character(0,param1,false,false,false,true);
            dummyChars[param1.toString()] = _loc3_;
         }
         else
         {
            _loc3_ = dummyChars[param1.toString()] as Character;
         }
         _loc3_.setGenome(_loc5_);
         _loc3_.scaleX = 1;
         _loc3_.scaleY = 1;
         return _loc3_;
      }
      
      private function updateBox(param1:Boolean = false, param2:Number = 2) : void
      {
         this.fill.graphics.clear();
         drawBox(this.fill,this._width,this._height,0,FILL_COLOR);
         if(param1)
         {
            if(this.frame == null)
            {
               this.frame = new MovieClip();
               addChild(this.frame);
            }
            this.frame.graphics.clear();
            if(this.selected)
            {
               drawBox(this.frame,this._width,this._height,param2,!!this.selected ? uint(COLOR_SELECTED) : uint(FILL_COLOR));
            }
            drawBox(this.frame,this._width,this._height,0,COLOR_LINE,true);
         }
      }
      
      function onRemove() : void
      {
         if(!isNaN(this.timeout))
         {
            clearTimeout(this.timeout);
         }
      }
      
      function getHeight() : Number
      {
         return this._height;
      }
      
      function getWidth() : Number
      {
         return this._width;
      }
      
      private function setName(param1:*) : String
      {
         if(this.targetName != null)
         {
            return this.getName();
         }
         if(this.itemName != null)
         {
            this.targetName = this.itemName;
         }
         else if(param1 == null)
         {
            this.targetName = "";
         }
         else if(param1 is Character)
         {
            this.targetName = Character(param1).getName();
         }
         else if(param1 is Prop)
         {
            if(!L.isEnglish() && param1 is PropSet && this.pool == Pixton.POOL_PRESET)
            {
               this.targetName = null;
            }
            else
            {
               this.targetName = Prop(param1).getName();
            }
         }
         else if(param1 is String)
         {
            this.targetName = param1;
         }
         else if(param1 is Object)
         {
            if(param1.u != null && param1.u != Main.userName)
            {
               this.targetName = param1.n + " " + L.text("by",param1.u);
            }
            else
            {
               this.targetName = param1.n;
            }
         }
         else
         {
            this.targetName = "";
         }
         return this.getName();
      }
      
      function getName() : String
      {
         return this.type == Globals.DESIGNER ? null : this.targetName;
      }
      
      private function saveSnapshot(param1:MovieClip, param2:MovieClip, param3:Boolean = true) : BitmapData
      {
         var _loc5_:Bitmap = null;
         var _loc4_:BitmapData = new BitmapData(param2.width,param2.height,true,0);
         if(matrix == null)
         {
            matrix = new Matrix();
         }
         matrix.identity();
         if(param1 != param2)
         {
            matrix.scale(param1.scaleX,param1.scaleY);
            matrix.translate(param1.x,param1.y);
         }
         _loc4_.draw(param1,matrix);
         if(param3)
         {
            _loc5_ = new Bitmap(_loc4_);
            param2.addChild(_loc5_);
         }
         return _loc4_;
      }
      
      private function onLoadPhoto(param1:Event) : void
      {
         var _loc2_:BitmapData = Bitmap(param1.target.loader.contentLoaderInfo.content).bitmapData;
         Cache.save("PropPhotoThumb",this.value,_loc2_);
         this.revealImage(_loc2_);
      }
      
      private function onLoadImage(param1:Event) : void
      {
         var _loc2_:BitmapData = Bitmap(param1.target.loader.contentLoaderInfo.content).bitmapData;
         this.revealImage(_loc2_);
         if(Utils.inArray(this.type,[Globals.CHARACTERS,Globals.OUTFITS]))
         {
            Character.saveCacheData(this.type,this.value,0,this.saveSnapshot(this.imageContainer,this.imageContainer,false),this.getName());
         }
      }
      
      private function revealImage(param1:BitmapData, param2:Boolean = true) : void
      {
         visible = true;
         var _loc3_:Bitmap = new Bitmap(param1);
         this.imageContainer.addChild(_loc3_);
         this.imageContainer.x = Math.round((this._width - _loc3_.width) * 0.5);
         this.imageContainer.y = Math.round((this._height - _loc3_.height) * 0.5);
         _loc3_.smoothing = true;
      }
      
      function disable() : void
      {
         mouseEnabled = false;
         mouseChildren = false;
         alpha = ALPHA_DISABLED;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
      }
      
      public function setSelected(param1:Boolean = true) : void
      {
         this.selected = param1;
         this.updateBox(true,DESIGNER_PADDING);
      }
   }
}

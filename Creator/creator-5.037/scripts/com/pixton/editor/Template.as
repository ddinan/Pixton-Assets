package com.pixton.editor
{
   import com.pixton.preloader.Status;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public final class Template
   {
      
      public static const MAX_NUM_CHARS:uint = 3;
      
      private static var _cache:Object = {};
      
      private static var _comicSetting:String;
      
      private static var _setting:String;
      
      private static var _scene:String;
      
      private static var _charIDs:Array;
      
      private static var _scenes:Array;
      
      private static var _map:Object;
       
      
      public function Template()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param1.setting != null)
         {
            _loc2_ = param1.setting.split(".");
            if(_loc2_.length == 2)
            {
               _setting = _loc2_[0];
               _scene = _loc2_[1];
               _comicSetting = _setting;
               _charIDs = [];
               if(param1.chars != null)
               {
                  _loc3_ = param1.chars.split(",");
                  _loc5_ = Math.min(MAX_NUM_CHARS,_loc3_.length);
                  _loc4_ = 0;
                  while(_loc4_ < _loc5_)
                  {
                     _charIDs.push(parseInt(_loc3_[_loc4_],16));
                     _loc4_++;
                  }
               }
            }
         }
      }
      
      public static function setCharID(param1:uint, param2:uint) : void
      {
         _charIDs[param1] = param2;
      }
      
      public static function getNumChars() : String
      {
         return _charIDs.length.toString();
      }
      
      public static function isActive() : Boolean
      {
         return _comicSetting != null;
      }
      
      public static function getSetting() : String
      {
         return _setting;
      }
      
      public static function setSetting(param1:String) : void
      {
         _setting = param1;
      }
      
      public static function addScene(param1:Array = null, param2:String = null, param3:String = null) : Boolean
      {
         if(param2 != null)
         {
            _setting = param2;
         }
         if(param3 != null)
         {
            _scene = param3;
         }
         if(param1 != null)
         {
            _charIDs = param1;
         }
         if(_charIDs.length > MAX_NUM_CHARS)
         {
            return false;
         }
         var _loc4_:String = getNumChars();
         if(_cache[_setting] && _cache[_setting][_scene] && _cache[_setting][_scene][_loc4_])
         {
            onLoadSetting(Utils.clone(_cache[_setting][_scene][_loc4_]),true);
         }
         else
         {
            Status.setMessage(L.text("please-wait"));
            Utils.remote("loadSetting",{
               "setting":_setting,
               "scene":_scene,
               "numChars":_charIDs.length
            },onLoadSetting);
         }
         return true;
      }
      
      private static function onLoadSetting(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:* = null;
         var _loc15_:Asset = null;
         var _loc16_:Character = null;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:Object = null;
         if(param1.sceneData)
         {
            if(!param2)
            {
               if(param1.propsetData)
               {
                  PropSet.setData(param1,false);
               }
               _loc17_ = getNumChars();
               if(!_cache[_setting])
               {
                  _cache[_setting] = {};
               }
               if(!_cache[_setting][_scene])
               {
                  _cache[_setting][_scene] = {};
               }
               _cache[_setting][_scene][_loc17_] = Utils.clone(param1);
            }
            _loc5_ = Editor.self.getDialogData();
            _loc6_ = Editor.self.getCharData();
            _loc7_ = Editor.self.getWHData();
            _loc8_ = Editor.self.getPanelData();
            _loc9_ = Editor.self.getBorderData();
            _loc11_ = {};
            if(!isActive())
            {
               _loc10_ = param1.sceneData.d as Array;
               param1.sceneData.d = _loc5_;
               _loc4_ = _loc10_.length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  if(param1.sceneData.d[_loc3_])
                  {
                     param1.sceneData.d[_loc3_].tgt = _loc10_[_loc3_].tgt;
                  }
                  _loc3_++;
               }
            }
            else if(param1.sceneData.d)
            {
               _loc4_ = (_loc10_ = param1.sceneData.d as Array).length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  if(_loc5_[_loc3_])
                  {
                     _loc10_[_loc3_].t = _loc5_[_loc3_].t;
                  }
                  else
                  {
                     _loc10_[_loc3_].t = "";
                  }
                  _loc11_[_loc10_[_loc3_].tgt.toString()] = _loc10_[_loc3_].t != "";
                  _loc3_++;
               }
            }
            _loc12_ = {};
            if(param1.sceneData.c as Array)
            {
               _loc4_ = (_loc18_ = param1.sceneData.c as Array).length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc18_[_loc3_].id = _charIDs[_loc3_];
                  if(_loc6_[_loc3_])
                  {
                     _loc12_[_loc3_.toString()] = {};
                     _loc12_[_loc3_.toString()]["face"] = _loc6_[_loc3_].e;
                     if(_loc6_[_loc3_].ex)
                     {
                        _loc19_ = Utils.decode(_loc6_[_loc3_].ex);
                        _loc12_[_loc3_.toString()]["glow"] = _loc19_.gv;
                     }
                     if(_loc6_[_loc3_].skinType != Globals.HUMAN)
                     {
                        _loc12_[_loc3_.toString()]["pose"] = _loc6_[_loc3_].p;
                     }
                  }
                  else if((_loc13_ = Character.getData(_loc18_[_loc3_].id)).t != Globals.HUMAN)
                  {
                     _loc12_[_loc3_.toString()] = {};
                  }
                  _loc3_++;
               }
            }
            param1.sceneData.extraData = Utils.encode(Editor.makeExtraData(_setting,_scene));
            param1.sceneData = Utils.mergeObjects(param1.sceneData,_loc8_,_loc9_,_loc7_);
            Editor.self.setData(param1.sceneData);
            for(_loc14_ in _loc11_)
            {
               if((_loc15_ = Editor.self.getTarget(parseInt(_loc14_))) is Character)
               {
                  Character(_loc15_).speak(_loc11_[_loc14_]);
               }
            }
            for(_loc14_ in _loc12_)
            {
               if(_loc16_ = Editor.self.getCharacter(parseInt(_loc14_)) as Character)
               {
                  if(_loc12_[_loc14_]["pose"] != null)
                  {
                     _loc16_.bodyParts.setPositionData(Utils.decode(_loc12_[_loc14_]["pose"]) as Array);
                     _loc16_.bodyParts.setExpressionData(Utils.decode(_loc12_[_loc14_]["face"]) as Array,true,true);
                     _loc16_.redraw(true);
                  }
                  else if(_loc12_[_loc14_]["face"] != null)
                  {
                     _loc16_.bodyParts.setExpressionData(Utils.decode(_loc12_[_loc14_]["face"]) as Array,true,false);
                  }
                  else
                  {
                     _loc16_.resetPose();
                  }
                  if(_loc12_[_loc14_]["glow"] != null)
                  {
                     _loc16_.setGlowAmount(_loc12_[_loc14_]["glow"]);
                  }
               }
            }
            Editor.self.autoFitScene();
            Editor.self.onStateChange();
         }
         Status.reset();
      }
      
      public static function getDialogPositions(param1:MovieClip) : Array
      {
         var _loc2_:uint = 0;
         var _loc4_:DisplayObject = null;
         var _loc3_:uint = param1.numChildren;
         var _loc5_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.getChildAt(_loc2_);
            _loc5_.push({
               "x":_loc4_.x,
               "y":_loc4_.y
            });
            _loc2_++;
         }
         return _loc5_;
      }
      
      public static function getSettingNameByID(param1:uint) : String
      {
         return getSettingName(extractSetting(param1));
      }
      
      public static function getSettingName(param1:String) : String
      {
         return getSettingNameFromNum(extractSettingNum(param1));
      }
      
      public static function getSettingNameFromNum(param1:String) : String
      {
         return !!param1 ? L.text("setting-" + param1) : null;
      }
      
      public static function extractSetting(param1:uint) : String
      {
         var _loc2_:Object = PropSet.getData(param1);
         if(_loc2_.setting != null)
         {
            return extractSettingNum(_loc2_.setting);
         }
         return null;
      }
      
      public static function extractSettingNum(param1:String) : String
      {
         var _loc2_:Array = param1.split(".");
         if(_loc2_ && _loc2_.length >= 1)
         {
            return _loc2_[0];
         }
         return null;
      }
      
      public static function extractSettingScene(param1:String) : String
      {
         var _loc2_:Array = param1.split(".");
         if(_loc2_ && _loc2_.length >= 2)
         {
            return _loc2_[1];
         }
         return null;
      }
   }
}

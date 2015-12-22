package 
{
	import com.myflashlab.air.extensions.timerTask.Alarm
	import com.myflashlab.air.extensions.timerTask.AlarmEvent;
	import com.myflashlab.air.extensions.timerTask.alarmTypes.Alarm_Notification;
	import com.myflashlab.air.extensions.timerTask.alarmTypes.Alarm_ShowToast;
	import com.myflashlab.air.extensions.timerTask.alarmTypes.Alarm_SimpleDispatch;
	import com.myflashlab.air.extensions.timerTask.alarmTypes.alarm_Notification.TouchActionObject;
	import flash.utils.setTimeout;
	
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	
	import com.doitflash.starling.utils.list.List;
	
	import com.doitflash.text.modules.MySprite;
	
	import com.luaye.console.C;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import flash.filesystem.File;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * 
	 * @author Hadi Tavakoli - 5/3/2015 1:57 PM
	 */
	public class MainFinal extends Sprite 
	{
		private var _ex:Alarm;
		
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		public function MainFinal():void 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 100;
			C.width = 500;
			C.height = 250;
			C.strongRef = true;
			C.visible = true;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Alarm Manager V" + Alarm.VERSION + " for adobe air</b></font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			init();
			onResize();
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
			C.log(e.arguments[0]);
		}
		
		private function handleActivate(e:Event):void 
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleDeactivate(e:Event):void 
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				e.preventDefault();
				
				NativeApplication.nativeApplication.exit();
            }
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
		}
		
		private function init():void
		{
			// to use android default icons, find their constent values here:
			// http://developer.android.com/reference/android/R.drawable.html
			
			// required only if you are a member of the club
			Alarm.clubId = "paypal-address-you-used-to-join-the-club";
			
			_ex = new Alarm();
			_ex.addEventListener(AlarmEvent.ALARM_SIMPLE_DISPATCH, onReceivedDispatch); // required only if you are setting a SIMPLE_DISPATCH task
			
			var alarmTask:Alarm_Notification = new Alarm_Notification();
			
			var btn1:MySprite = createBtn("set a notification Task with 5 sec delay!");
			btn1.addEventListener(MouseEvent.CLICK, setAlarm_notification);
			_list.add(btn1);
			
			function setAlarm_notification(e:MouseEvent):void
			{
				var actionObj1:TouchActionObject = new TouchActionObject();
				actionObj1.setSelfType(); // every notification can have only one action with its "selfType" and upto 3 "BtnType" actions. Older Android versions does not support "BtnType" actions at all but you don't have to worry about this. your app won't break on older devices :)
				actionObj1.setAppAction("Message to be sent to flash app when user touches the notification!");
				
				var actionObj2:TouchActionObject = new TouchActionObject();
				actionObj2.setBtnType(0x0108001f, "myappsnippet"); //
				actionObj2.setBrowseAction("http://www.myappsnippet.com/");
				
				var actionObj3:TouchActionObject = new TouchActionObject();
				actionObj3.setBrowseAction("http://www.myflashlab.com/");
				actionObj3.setBtnType(0x0108001a, "myflashlab");
				
				var actionObj4:TouchActionObject = new TouchActionObject();
				actionObj4.setBrowseAction("http://www.google.com/");
				actionObj4.setBtnType(0x0108001a, "google");
				
				alarmTask.setWakeUp(true); // if true, then as soon as the alarm goes off, your device screen will turn on!
				alarmTask.setDelay(5); // use delay based on seconds OR set a date with new "Date()"
				alarmTask.setNotificationID(5); // you may use the id of this notification so you can manually remove it from your app
				alarmTask.setContentTitle("title test");
				alarmTask.setContentInfo("info test");
				alarmTask.setContentNumber(0); // if this number is greater than 0, then "setContentText" won't be shown
				alarmTask.setContentText("text test");
				alarmTask.setLargeIconRes(0x01080029); // to use large icons from assets OR sdcard, you must send 0 for setLargeIconRes param
				//alarmTask.setLargeIconAssets("notificationIcons/icon_512.png"); // to use large icons from sdcard pass an empty string "" for setLargeIconAssets
				//alarmTask.setLargeIconSDcard(File.documentsDirectory.resolvePath("icon_512.png"));
				alarmTask.setLights("#ff0000", 1, 1); // lights will be red and will blink every 1 seconds! (nothing will happen on a device with no lights hardware of course!)
				alarmTask.setOngoing(false);
				alarmTask.setOnlyAlertOnce(false);
				alarmTask.setSmallIcon(0); // when set to 0, the app icon will be used or pass android default icons like 0x1080072
				alarmTask.setSound(""); // an empty string will play device's default sound. to play your own mp3 file from sdcard, send File.documentsDirectory.resolvePath("sound01.mp3")
				alarmTask.setSubText("sub text test");
				alarmTask.setTicker("ticker test");
				alarmTask.setTouchAction(actionObj1, actionObj2, actionObj3, actionObj4);
				alarmTask.setVibrate(true);
				alarmTask.setAutoCancel(true);
				
				var id:int = _ex.setAlarm(alarmTask.data);
				
				// you can cancel an alarm by its id
				//_ex.cancelAlarm(id);
			}
			
			// -------------------------
			
			var btn2:MySprite = createBtn("set toast Task!");
			btn2.addEventListener(MouseEvent.CLICK, AlarmShowToast);
			_list.add(btn2);
			
			function AlarmShowToast(e:MouseEvent):void
			{
				var alarmTask:Alarm_ShowToast = new Alarm_ShowToast();
				alarmTask.setWakeUp(true);
				alarmTask.setMassage("Toast Message!!!");
				
				var date:Date = new Date();
				date.time = date.time + 5000;
				alarmTask.setDate(date); // you may also use setDelay method
				
				var id:int = _ex.setAlarm(alarmTask.data);
			}
			
			// -------------------------
			
			var btn3:MySprite = createBtn("set dispatch! (works only when app is running)");
			btn3.addEventListener(MouseEvent.CLICK, AlarmSimpleDispatch);
			_list.add(btn3);
			
			function AlarmSimpleDispatch(e:MouseEvent):void
			{
				var alarmTask:Alarm_SimpleDispatch = new Alarm_SimpleDispatch();
				alarmTask.setWakeUp(true);
				alarmTask.setMassage("this is a msg!");
				
				var date:Date = new Date();
				date.time = date.time + 5000;
				alarmTask.setDate(date);
				
				var id:int = _ex.setAlarm(alarmTask.data);
			}
			
			// -------------------------
			
			
		}
		
		private function onReceivedDispatch(e:AlarmEvent):void
		{
			var msg:String = e.param;
			C.log("onReceivedDispatch: ", msg);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = 0xDFE4FF;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xFFDB48;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xDFE4FF;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			return sp;
		}
	}
	
}
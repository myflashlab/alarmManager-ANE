# Alarm Manager ANE
Alarm manager ANE is a very simple to use extension library which lets you set a time using the Date API in AS3 and setup a task to be executed as soon as the alarm goes off! this alarm manager extension is configured wisely enough so that even if the user reboots his/her device, the extension will be notified and will make sure that the task will run as expected!

with the current first release of this extension we are supporting Android only but we are working on the iOS version too and we will update the extension as soon as it’s ready but it’s worthy to mention that you cannot be much creative with the iOS version of this extension! the reason is simple, it’s because iOS has limited dev access to background processes. you may learn more about this on [apple here] (https://developer.apple.com/library/ios/documentation/iPhone/Reference/UILocalNotification_Class/). So, with the coming soon iOS version of this extension we will support UILocalNotification which sends local notifications to iOS based on a defined date and time. That’s the best you can do with iOS when it comes to Alarm Management!

checkout here for the commercial version: http://myappsnippet.com/alarm-manager/

![Alarm Manager ANE](http://myappsnippet.com/wp-content/uploads/2015/05/alarm-manager-adobe-air-extension_preview.jpg)

you may like to see the ANE in action? check this out: https://github.com/myflashlab/alarmManager-ANE/tree/master/FD/dist

**NOTICE: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.**

# AS3 API:
```actionscript
import com.doitflash.air.extensions.timerTask.Alarm
import com.doitflash.air.extensions.timerTask.AlarmEvent;
import com.doitflash.air.extensions.timerTask.alarmTypes.Alarm_Notification;
import com.doitflash.air.extensions.timerTask.alarmTypes.Alarm_ShowToast;
import com.doitflash.air.extensions.timerTask.alarmTypes.Alarm_SimpleDispatch;
import com.doitflash.air.extensions.timerTask.alarmTypes.alarm_Notification.TouchActionObject;

// setup touch action objects
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

// setup your task
var alarmTask:Alarm_Notification = new Alarm_Notification();
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

// to use android default icons, find their constent values here:
// http://developer.android.com/reference/android/R.drawable.html

// initialize the alarm and set its task
var _ex:Alarm = new Alarm();
var id:int = _ex.setAlarm(alarmTask.data);

// you can cancel an alarm by its id
//_ex.cancelAlarm(id);
```

For the ANE to work as expected, make sure you are adding the required services and permissions to your .xml manifest file. below are the necessary changes to the manifest.

```xml
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="com.android.alarm.permission.SET_ALARM" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />

<application android:hardwareAccelerated="true" android:allowBackup="true">
	<activity android:hardwareAccelerated="false">
		<intent-filter>
			<action android:name="android.intent.action.MAIN" />
			<category android:name="android.intent.category.LAUNCHER" />
		</intent-filter>
		<intent-filter>
			<action android:name="android.intent.action.VIEW" />
			<category android:name="android.intent.category.BROWSABLE" />
			<category android:name="android.intent.category.DEFAULT" />
			<data android:scheme="air.com.doitflash.exAlarm" />
		</intent-filter>
	</activity>
	
	<receiver android:name="com.doitflash.alarmManager.alarmTypes.Alarm_ShowToast" />
	<receiver android:name="com.doitflash.alarmManager.alarmTypes.Alarm_Notification" />
	<receiver android:name="com.doitflash.alarmManager.alarmTypes.Alarm_SimpleDispatch" />
	
	<receiver android:name="com.doitflash.alarmManager.RebootAutoStartAlarms">
		<intent-filter>
			<action android:name="android.intent.action.BOOT_COMPLETED" />
		</intent-filter>
	</receiver>
	
	<activity android:name="com.doitflash.alarmManager.WakeActivity" android:theme="@style/Theme.Transparent" />
</application>
```


package kro13.vk.sdk;

@:native('VK')
extern class MobileSDK
{
    public static inline var MTD_SHOW_LEADERBOARD_BOX:String = 'showLeaderboardBox';
    public static inline var MTD_SHOW_INVITE_BOX:String = 'showInviteBox';
    public static inline var MTD_SHOW_SETTINGS_BOX:String = 'showSettingsBox';
    public static inline var EVT_ON_SETTINGS_BOX_DONE:String = 'onSettingsBoxDone';

    public static function test():Void;
    public static function init(successCallback:Void -> Void, failedCallback:Void -> Void, ver:String = '5.92', query:String = ''):Void;
    public static function callMethod(name:String, ?params:Dynamic):Void;
    public static function addCallback(eventName:String, callback:Dynamic):Void;
    public static function removeCallback(eventName:String):Void;
    public static function api(methodName:String, params:Dynamic, callback:Dynamic -> Void = null):Void;
}

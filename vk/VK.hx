package kro13.vk;

import kro13.kk.data.TRemoteProfile;
import kro13.vk.sdk.JavascriptSDK;
import kro13.vk.sdk.MobileSDK;
import js.html.URL;
import openfl.Lib;
import js.jquery.Event;
import js.Browser;
class VK
{
    public static var instance(get, null):VK;

    private var accessToken:String;
    private var viewerId:String;
    private var language:String;
    private var platform:String;
    private var firstName:String;
    private var lastName:String;

    private static inline var API_VER:String = '5.95';

    private function new()
    {
    }

    public function addVisibilityHandler():Void
    {
        Browser.window.addEventListener("visibilitychange", onVisibilityChange, false);
    }

    public function init(onSuccess:Void -> Void = null, onError:Void -> Void = null):Void
    {
        var url:URL = new URL(Browser.location.href);
        //trace('VK: location ${url.href}');

        accessToken = url.searchParams.get('access_token');
        viewerId = url.searchParams.get('viewer_id');
        language = url.searchParams.get('language');
        platform = url.searchParams.get('platform');
        try
        {
#if (vk_mobile)
            MobileSDK.init(onSDKInitSuccess.bind(onSuccess), onSDKInitFailed.bind(onError));
#else
            JavascriptSDK.init(onSDKInitSuccess.bind(onSuccess), onSDKInitFailed.bind(onError));
#end
        }
        catch(e:Dynamic)
        {
            js.Browser.alert('Error: ${e}');
            onSDKInitFailed(onError);
        }
    }

    public function getUserId():String
    {
        return viewerId;
    }

    public function getUserName(onSuccess:String -> Void):Void
    {
#if (vk_mobile)
            MobileSDK.api('users.get', {user_ids:viewerId, test_mode:0, v: API_VER}, onGetUser.bind(onSuccess));
#else
            JavascriptSDK.api('users.get', {user_ids:viewerId, test_mode:0, v: API_VER}, onGetUser.bind(onSuccess));
#end
    }

    public function showLeaderboardBox(userResult:Int):Void
    {
#if vk_mobile
        MobileSDK.callMethod(MobileSDK.MTD_SHOW_LEADERBOARD_BOX, userResult);
#else
        trace('not implemented!');
#end
    }

    public function showInviteBox():Void
    {
#if vk_mobile
        MobileSDK.callMethod(MobileSDK.MTD_SHOW_INVITE_BOX);
#else
        trace('not implemented!');
#end
    }

    public function getLeaderboard(global:Int, onSuccess:Array<TRemoteProfile> -> Void):Void
    {
        #if (vk_mobile)
                MobileSDK.api('apps.getLeaderboard', {type:'score', global:global, extended:1, test_mode:0, v: API_VER}, onGetLeaderboard.bind(onSuccess));
        #else
                JavascriptSDK.api('apps.getLeaderboard', {type:'score', global:global, extended:1, test_mode:0, v: API_VER}, onGetLeaderboard.bind(onSuccess));
        #end
    }

    private function onSDKInitSuccess(callback:Void -> Void):Void
    {
        if (callback != null)
        {
            callback();
        }
    }

    private function onSDKInitFailed(callback:Void -> Void):Void
    {
        js.Browser.alert('sdk init failed!');
        if (callback != null)
        {
            callback();
        }
    }

    private function onSettingsSet(callback:Void -> Void):Void
    {
        if (callback != null)
        {
            callback();
        }
    }

    private function onGetLeaderboard(callback:Array<TRemoteProfile> -> Void, response:Dynamic):Void
    {
        var items:Array<Dynamic> = response.response.items;
        var profiles:Array<Dynamic> = response.response.profiles;
        var top:Array<TRemoteProfile> = [];

        for (i in items)
        {
            var prof:TRemoteProfile =
            {
                userName: 'Таинственный Тип',
                totalScore: Std.parseInt(i.score),
                remoteId: ''
            }
            for (p in profiles)
            {
                if (i.user_id == p.id)
                {
                    prof.userName = '${p.first_name} ${p.last_name}';
                }
            }
            top.push(prof);
        }

        callback(top);
    }

    private function onGetUser(callback:String -> Void, response:Dynamic):Void
    {
        firstName = response.response[0].first_name;
        lastName = response.response[0].last_name;
        callback('${firstName} ${lastName}');
    }

    private function onVisibilityChange(e:Event):Void
    {
        var hidden:Bool = Browser.window.document.hidden;
        if (hidden)
        {
            Lib.current.dispatchEvent(new openfl.events.Event(openfl.events.Event.DEACTIVATE));
        }
    }

    private static function get_instance():VK
    {
        if (instance == null)
        {
            instance = new VK();
        }
        return instance;
    }
}

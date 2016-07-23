//
//  APIKey.h
//  SearchV3Demo
//
//  Created by Mark C.J. on 15-10-10.
//  Copyright (c) 2015年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

// Tencent Bugdy App Key.
#define kBuglyAppID                         @"900015343"

/// umeng 在线参数 按照地区来
#define kDiscovery_activity_banner_target_url       @"discovery_activity_banner_target_url"     //中国区域的banner的web URL
#define kDiscovery_activity_banner_target_url_en    @"discovery_activity_banner_target_url_en"  //外国区域的banner的web URL
#define kDiscovery_activity_img_url                 @"discovery_activity_img_url"               //中国banner的图片的url
#define kDiscovery_activity_img_url_en              @"discovery_activity_img_url_en"            //外国banner的图片的url
#define kShowAdOnIOSAboutPage                       @"showAdOnIOSAboutPage"                     //0是在iOS关于页面不显示广告，1为展示广告
#define kOpen_Launch_Ad                             @"open_launch_ad"                   // 是否开启启动广告、国内
#define kOpen_Launch_Ad_En                          @"open_launch_ad_en"                // 是否开启启动广告、国外
#define kLaunch_Ad_Image_Url                        @"launch_ad_image_url"              // 广告图片url 国内
#define kLaunch_Ad_Image_Url_En                     @"launch_ad_image_url_en"           // 广告图片URL 国外
#define kLaunch_Ad_Image_Target_Url                 @"launch_ad_image_target_url"       // 点击广告图片跳转的url 国内
#define kLaunch_Ad_Image_Target_Url_En              @"launch_ad_image_target_url_en"    // 广告图片跳转的url 国外

// 第三方登录 - 微信
#define kWeixinAppID                        @"wx9518a9961f317f45"
#define kWechatSecretKey                    @"d4cd22c7aa4920329b6150da222c55f4"

// 第三方登录 - 新浪微博
// Sina Weibo Login App Key.
#define Sina_APP_ID                         @"1134292133"
#define kSinaWeiboSecretKey                 @"4b8db7b0206b5fd1b910080b148a63f5"
// Sina Weibo Login redirect URL.
#define Sina_RedirectURI                    @"https://api.weibo.com/oauth2/default.html"

// 第三方登录 - Twitter
#define kTwitterConsumerKey                 @"DdLqllMyHpyj45ohZW7WCZHZK"
#define kTwitterConsumerSecretKey           @"iZTeLHV2Umnifsw1YtV8zomkMJIsiivv8igq0et1WR7pkpRzLj"

// 第三方登录 - QQ
#define kQQAppID                            @"1104062989"
#define kQQAppKey                           @"rQqUv9fkheWiZYnv"

// ------- 系统消息key相关 ---------

#ifdef DEBUG        // 调试

//测试服务器
#define AVCLOUD_APP_ID                      @"qiz2ee6ucwbte8130yevxnkc8iwltldvtaazx6tl2d4hey3r"
#define AVCLOUD_APP_KEY                     @"119uiyex7d42pezuuf6hv7afebg58fwjyfry3lit8rswc4b1"

//融云测试 key
#define RONGCLOUD_IM_APPKEY                 @"25wehl3uwar5w"              //dev 用的
#define RONGCLOUD_IM_CONSUMER_SERVICE_ID    @"KEFU144774233468125"        //dev 用的

#define HOSTNAME                            @"dev.beast_tester.avosapps.com"

#define MY_Activity_URL                     @"http://dev.beast_tester.avosapps.com/activity/myActivity"
#define CLUB_ACTIVITY_ENTRY_URL             @"http://dev.beast_tester.avosapps.com/club/activity?clubId="
#define CLUB_ACTIVITY_ADD_NEW_URL           @"http://dev.beast_tester.avosapps.com/club/publish.html"

// 接口测试服务器地址
#define CLIENT_HTTP_API                     @"https://tester.speedx.com/api"     //服务器API地址
// 测试服务器俱乐部活动详情 API
#define CLUB_ACTIVITY_DETAIL_APP            @"https://tester.speedx.com/app"

// 网络接口API Domain
#define COOKIES_DOMAIN                      @"tester.speedx.com"

// 网页相关页面Domain
#define COOKIES_DOMAIN_FOR_WEBPAGE          @".avosapps.com"

// BEGIN. 第三方登录相关

#define kGooglePlusClientID                 @"625890119395-c2dka0odhdjrtvpder9rsj8salfom686.apps.googleusercontent.com"

// com.beastbikes.ios
#define kFacebookAPIKey                     @"1533225403674587"
#define kFacebookAPPSecretKey               @"b9bab49db579df72eaf414a4e5719847"

// END. 第三方登录相关

#else               // 发布

//正式服务器
#define AVCLOUD_APP_ID  @"1xzez6xivqxdogg3ayf8nuit72ae175eggjtcqpeyahfhkqf"
#define AVCLOUD_APP_KEY @"bv7d83jp0gwhwc6hcfshmcy2ymjpp5h7u3m0wcp18cwlfxsk"

//融云线上正式 key
#define RONGCLOUD_IM_APPKEY                     @"qd46yzrf4o2df"              //AppStore 用的
#define RONGCLOUD_IM_CONSUMER_SERVICE_ID        @"KEFU144774296732097"        //AppStore 用的

//新浪微博 app_key 和应用授权回调页（正式服务器）

#define HOSTNAME                            @"www.beastbikes.com"

#define MY_Activity_URL                     @"http://www.beastbikes.com/activity/myActivity"
#define CLUB_ACTIVITY_ENTRY_URL             @"http://www.beastbikes.com/club/activity?clubId="
#define CLUB_ACTIVITY_ADD_NEW_URL           @"http://www.beastbikes.com/club/publish.html"

// 接口测试服务器地址
#define CLIENT_HTTP_API                     @"https://api.speedx.com/api"     //服务器API地址
// 测试服务器俱乐部活动详情 API
#define CLUB_ACTIVITY_DETAIL_APP            @"https://speedx.com/app"
// 网络接口API Domain
#define COOKIES_DOMAIN                      @".speedx.com"

// 网页相关页面Domain
#define COOKIES_DOMAIN_FOR_WEBPAGE          @".beastbikes.com"

// BEGIN. 第三方登录相关

#define kGooglePlusClientID                 @"625890119395-2f02c00b7690p5n8ih7tab49uf7u5voe.apps.googleusercontent.com"

// com.o2riding.ios
#define kFacebookAPIKey                     @"1521430224854105"
#define kFacebookAPPSecretKey               @"52ea699bbe2c02210041e10cbf4a3383"

// END. 第三方登录相关
#endif

#endif


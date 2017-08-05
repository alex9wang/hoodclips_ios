//
//  Constants.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#ifndef hoodclips_Constants_h
#define hoodclips_Constants_h

//For HttpRequest

#define BASE_URL                            @"http://www.hoodclips.com/api/"
//#define BASE_URL                            @"http://192.168.1.211/hoodclips_web/api/main-api.php"
#define WEBSITE_URL                         @"http://www.hoodclips.com/"
#define HOODCLIPS_DSIQUS_COM                @"http://hoodclips.disqus.com/"
#define HOODCLIPS_NET_JOSHUA                @"http://www.hoodclips.net/joshua/"

#define SUB_URL_ALLVIDEOS                   @"main-api.php"
#define post_param_page_num_key             @"PageNumber"
#define post_param_page_num_value           @"0"
#define post_param_limit_key                @"ListviewLimit"
#define post_param_limit_value              20
#define post_param_webapi_mode_key          @"MethodType"
#define post_param_webapi_mode_value        @"LoadUploadedVideoList"
#define WATCH_PHP                           @"watch.php"
#define POST_PARAM_DEVICEID                 @"DeviceID"
#define POST_PARAM_VIDEOID                  @"VideoID"
#define POST_PARAM_WEBAPI_FAVORITE          @"Favourite"
#define POST_PARAM_WEBAPI_TRENDING          @"Trending"
#define POST_PARAM_WEBAPI_SEARCH            @"search"
#define POST_PARAM_WEBAPI_ADDFAVORITE       @"AddToFavourite"
#define POST_PARAM_WEBAPI_REMOVEFAVORITE    @"RemoveFromFavourite"

#define SAVE_TOKEN_URL                      @"hoodclips_save_token.php"
#define POST_PARAM_WEBAPI_TOKEN             @"token"

#define DISQUS_LOGOUT                       @"disqus.com/logout"
#define DISQUS_SUCCESS                      @"disqus.com/next/login-success"
#define DISQUS_TWITTER_COMPLETE             @"disqus.com/_ax/twitter/complete"
#define DISQUS_GOOGLE_COMPLETE              @"disqus.com/_ax/google/complete"
#define DISQUS_FACEBOOK_COMPLETE            @"disqus.com/_ax/facebook/complete"
#define DISQUS_NEXT_LOGIN                   @"disqus.com/next/login/?forum=hoodclips#"

#define DISQUS_EMBED_PROFILE                @"disqus.com/embed/profile"

// Ad Network Contants
#define MOPUB_INTERSTITIAL_AD_UNIT_ID       @"50ce7164a2fe4a4c81aa883e543c314a"
#define MOPUB_BANNER_AD_UNIT_ID             @"5fbfc9ed5763430fb13d17d93f3903b0"
#define MOPUB_NATIVE_AD_UNIT_ID             @"2745c3df0c924b5f924bc28021b2d02b"

// Admob Contants
#define ADMOB_INTERSTITIAL_AD_UNIT_ID       @"ca-app-pub-7913152423620879/5130057945"
#define ADMOB_BANMNER_AD_UNIT_ID             @"ca-app-pub-7913152423620879/2176591540"
#define ADMOB_NATIVE_AD_UNIT_ID             @"ca-app-pub-7913152423620879/2036990744"
#endif

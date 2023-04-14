//
//  Constant.h
//  FleaApp
//
//  Copyright (c) 2015 karmick. All rights reserved.
//

#ifndef FleaApp_Constant_h
#define FleaApp_Constant_h

#import "Utility.h"
#import "DataValidation.h"
#import "UILabel+Border.h"
#import "UIView+Border.h"
#import "SpinnerView.h"
#import "ServerConnection.h"
#import "Base64.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "NSString+MD5.h"
#import "AppDelegate.h"
//#import "KxMenu.h"
//#import "NIDropDown.h"
#import "LoginViewController.h"
#import "User.h"
#import "DownPicker.h"

#define ALERT_TITLE @"BRC"
#define SESSION_EXPIRED @"Session expired"
#define PARSING_ERROR_MESSAGE @"Could not connect. Please check your connection and try again."
//LOCAL: http://10.194.5.15/projects10/brc_update/index.php/service/
//LIVE: https://www.bengalrowingclub.com/index.php/service/

//8f07d202c15816ac7df597d8afb69948
//01cfcd4f6b8770febfb40cb906715822


#define BASEURL @"https://www.bengalrowingclub.com/index.php/service/"
#define EVENTPASSIMAGEURL @"https://www.bengalrowingclub.com/uploads/events/"
#define BILLDOWNLOADURL @"https://www.bengalrowingclub.com/bills/"
#define BANQUET_BOOKING_IMAGEURL @"https://www.bengalrowingclub.com/skin/pages/images/booking/"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define MAINSTORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define IPHONEWIDTH [[UIScreen mainScreen] bounds].size.width
#define IPHONEHEIGHT  [[UIScreen mainScreen] bounds].size.height

#define FULLHEIGHT [UIScreen mainScreen].bounds.size.height
#define FULLWIDTH  [UIScreen mainScreen].bounds.size.width

#define TWITTER_CONSUMER_KEY @"c2RlXoksHXmi5BuDtCyf9Xmfr"//@"HRrZPg09kVVtW5WFk4Nf9fzCO"
#define TWITTER_SECRET_KEY @"XeU2UmXr8pZe50BGnYfKmnhNL7XgEYTdt20euUvC7gC2gy0t5e"//@"gdEuWoaAmZNzI5Tuk15EwsdtRtYjbfNeuETKAzOXDy88Cb0JJe"
#define DEGREES_IN_RADIANS(x) (M_PI * x / 180.0);
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define STING_LENGTH interestRate >= 8

#endif

//
//  Utility.h
//  ProjDemo
//
//  Created by Ankush Chakraborty on 17/11/14.
//  Copyright (c) 2014 Isis Design Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

typedef enum {
    kWebServiceTypeLogin,
    kWebServiceTypeGetOffers,
    kWebServiceFavouriteOffer,
    kWebServiceTypeForgotPassword
} webServiceType;

typedef enum{
    UserTypeFB=1,
    UserTypeGooglePlus,
    UserTypeEmail
}UserType;

@interface Utility : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byWidth:(CGFloat)width;
+ (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byHeight:(CGFloat)height;
+ (UIImage *)resizeImageIgnoringAspectRatio:(UIImage *)sourceImage bySize:(CGSize)newSize;
+ (UIImage *)cropImage:(UIImage *)sourceImage withRect:(CGRect)rect;
+ (UIImage *)blurImage:(UIImage *)sourceImage blurAmount:(float)blur;
+ (UIImage*)mergeImage:(UIImage *)firstImage withImage:(UIImage*)secondImage;
+ (UIImage *)maskImage:(UIImage *)sourceImage withMask:(UIImage *)maskImage;
+ (UIImage *)normalizedCapturedImage:(UIImage *)rawImage;
+ (UIImage *)getCurrentScreenShot:(UIViewController *)viewController;

+ (NSString *)getProjectVersionNumber;
+ (NSString *)getBuildVersionNumber;
+ (CGSize)getDeviceScreenSize;
+ (NSString *)getDeviceOSVersionNumber;

+ (BOOL)isNetworkAvailable;
+(BOOL)WifiorLteAvailable;
+(NSDictionary *)WIFIName;
+ (NSDate *)getGMTDateTimeFromLocalDateTime:(NSDate *)date;
+ (int)differenceBetweenTwoDates:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSDate *)getLocalDateTimeFromGMTDateTime:(NSDate *)date;

+ (NSDateComponents *)getTodayComponentsFromDate:(NSDate *)theDate;

+ (NSString *)encodeStringToBase64:(NSString *)str;
+ (NSString *)decodeStringFromBase64:(NSString *)str;
+ (NSString *)changeDate:(NSString *)date fromFormat:(NSString *)from toFormat:(NSString *)to;
+ (void)saveUserInfo:(User *)userInfo;
+ (User *)getUserInfo;
+ (void)removeUserInfo;
+ (NSString *)getDocumentDirectoryPath;
+ (NSString *)createFolderInDocumentDirectory:(NSString *)folderName;
+ (NSString *)getFolderPathFromDocumentDirectory:(NSString *)folderName;
+ (NSString *)getFilePathFromDocumentDirectory:(NSString *)fileName inFolder:(NSString *)folderName;
+ (NSString *)saveFileInDocumentDirectory:(NSData *)fileData fileName:(NSString *)fileName inDirectory:(NSString *)folderName;
+ (BOOL)removeSpecificFileFromDirectory:(NSString *)folderName fileName:(NSString *)fileName;
+ (BOOL)removeAllFilesFromDirectory:(NSString *)folderName;
+ (BOOL)removeSpecificDirectoryFromDocumentDirectory:(NSString *)folderName;
+ (BOOL)removeAllFilesAndFolderFromDocumentDirectory;

+(UIImage *) getImageFromURL:(NSString *)fileURL;
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
+(BOOL)isUserLoggedIn;
+(void)setUserLoginEnable:(BOOL)login;

+(BOOL)isUserAgree;
+(void)setUserAgreement:(BOOL)isAgree;

+(BOOL)isNotificationAlertFirstTime;
+(void)setNotificatioAlertFirstTime:(BOOL)alert;

+(void)checkPassword:(NSString *)_status;
+(NSString *)passwordStatus;
+(void)removePasswordInfo;

+(NSString*)deviceToken;
+(void)setDeviceToken:(NSString*)token;

+(UIBezierPath *)roundedPolygonPathWithRect:(CGRect)rect lineWidth:(CGFloat)lineWidth sides:(NSInteger)sides cornerRadius:(CGFloat)cornerRadius;
+(BOOL)networkAvaialability;
+(void)setWIFIlte:(BOOL)wifilte;
+(BOOL)isWifiLteEnable;
+(void)wifilteNetworkAlert;

+(void)saveUserDetails:(NSDictionary *)_dictUser;
+(NSDictionary *)getUserDetails;
+(void)deleteUserDetails;

+(void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth view:(UIView *)_view;
+(void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth view:(UIView *)_view;
+(void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth view:(UIView *)_view;

@end

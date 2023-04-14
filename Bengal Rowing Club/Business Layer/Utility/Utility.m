//
//  Utility.m
//  ProjDemo
//
//  Created by Ankush Chakraborty on 17/11/14.
//  Copyright (c) 2014 Isis Design Services. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"
#import "NSString+HTML.h"
#import "Constant.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#define SQUARE(i) ((i)*(i))
#define USER_INFO @"UserInfo"
#define PASSWORD_STATUS @"passwordStatus"
inline static void zeroClearInt(int* p, size_t count) { memset(p, 0, sizeof(int) * count); }

static NSString* const DeviceTokenKey = @"DeviceToken";

@implementation Utility

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

+ (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byWidth:(CGFloat)width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byHeight:(CGFloat)height {
    float oldWidth = sourceImage.size.height;
    float scaleFactor = height / oldWidth;
    float  newWidth = sourceImage.size.width * scaleFactor;
    float newHeight = oldWidth * scaleFactor;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)resizeImageIgnoringAspectRatio:(UIImage *)sourceImage bySize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)changeDate:(NSString *)date fromFormat:(NSString *)from toFormat:(NSString *)to {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:from];
    NSDate *dt = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:to];
    return [dateFormatter stringFromDate:dt];
}

+ (UIImage *)cropImage:(UIImage *)sourceImage withRect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, sourceImage.size.width, sourceImage.size.height);
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [sourceImage drawInRect:drawRect];
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
    
}

+ (UIImage *)maskImage:(UIImage *)sourceImage withMask:(UIImage *)maskImage
{
    CGImageRef imageReference = sourceImage.CGImage;
    CGImageRef maskReference = maskImage.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    return maskedImage;
}

+ (UIImage *)normalizedCapturedImage:(UIImage *)rawImage {
    if (rawImage.imageOrientation == UIImageOrientationUp)return rawImage ;
    
    UIGraphicsBeginImageContextWithOptions(rawImage.size, NO, rawImage.scale);
    [rawImage drawInRect:(CGRect){0, 0, rawImage.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

+ (NSString *)getProjectVersionNumber {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getBuildVersionNumber {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (CGSize)getDeviceScreenSize {
    return [[UIScreen mainScreen] bounds].size;
}

+ (NSString *)getDeviceOSVersionNumber {
    return [[UIDevice currentDevice] systemVersion];
}

+ (BOOL)isNetworkAvailable {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    return ([networkReachability currentReachabilityStatus] == NotReachable) ? NO : YES;
}

+(BOOL)WifiorLteAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if([self isWifiLteEnable]){
        if (status==ReachableViaWiFi) {
            [self setWIFIlte:YES];
            return YES;
        }
        else
        {
            [self showAlertWithTitle:ALERT_TITLE message:@"Please turn on your device WIFI to Sync"];
            return NO;
        }
    }
    else{
        if (status==ReachableViaWiFi) {
            [self setWIFIlte:YES];
            return YES;
        }
        else if (status==ReachableViaWWAN){
            [self setWIFIlte:NO];
            return YES;
        }
        else
        {
            [self showAlertWithTitle:ALERT_TITLE message:@"Please turn on your device WIFI to Sync"];
            return NO;
        }
    }
}

+(NSDictionary *)WIFIName{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    NSLog(@"%@",SSIDInfo);
    return SSIDInfo;
}

+(BOOL)networkAvaialability{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if ([self isWifiLteEnable]){
        if (status==ReachableViaWiFi){
            return YES;
        }
        /*else if (status==ReachableViaWWAN) {
            [self showAlertWithTitle:@"Oops, something went wrong!" message:@"Disable Sync on Wifi in settings to be able use the app on cellular data"];
            return NO;
        }*/
        else {
            [self showAlertWithTitle:@"Oops, something went wrong!" message:@"Disable 'sync on WiFi' in settings to allow the app to use cellular data"];
            return NO;
        }
    }
    else{
        if (status==ReachableViaWiFi) {
            return YES;
        }
        else if (status==ReachableViaWWAN){
            return YES;
        }
        else{
            [self showAlertWithTitle:@"Oops, something went wrong!" message:@"Disable 'sync on WiFi' in settings to allow the app to use cellular data"];
            return NO;
        }
    }
}
+(void)wifilteNetworkAlert
{
    if (![self isNetworkAvailable]) {
        [self showAlertWithTitle:ALERT_TITLE message:@"Please check internet connection of your Device"];
    }
    else
    {
        [self showAlertWithTitle:ALERT_TITLE message:@"Turn on WIFI/LTE option of your settings page"];
    }
    
}

+(void)setWIFIlte:(BOOL)wifilte
{
    [[NSUserDefaults standardUserDefaults]setValue:wifilte==YES ? @"YES":@"NO" forKey:@"WifiLte"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"WifiLte"]);
}
+(BOOL)isWifiLteEnable
{
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"WifiLte"]);
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"WifiLte"] isEqualToString:@"YES"]){
        return YES;
    }
    else{
        return NO;
    }
    
}

+ (NSDate *)getGMTDateTimeFromLocalDateTime:(NSDate *)date {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setTimeZone:timeZone];
    return [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
}

+ (int)differenceBetweenTwoDates:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSTimeInterval secondsBetween = [endDate timeIntervalSinceDate:startDate];
    return secondsBetween / 86400;
}

+ (NSDate *)getLocalDateTimeFromGMTDateTime:(NSDate *)date {
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [date dateByAddingTimeInterval:timeZoneSeconds];
    return dateInLocalTimezone;
}

+ (UIImage *)getCurrentScreenShot:(UIViewController *)viewController {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(viewController.view.window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(viewController.view.window.bounds.size);
    [viewController.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot;
}

+ (NSString *)encodeStringToBase64:(NSString *)str {
    str= [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *htmlEncodedString = [str kv_encodeHTMLCharacterEntities];
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        NSData *plainData = [htmlEncodedString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [plainData base64EncodedStringWithOptions:0];
        str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        return str;
    }
    else
    {
        static char base64EncodingTable[64] = {
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
            'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
            'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
        };
        
        unsigned long ixtext, lentext;
        long ctremaining;
        unsigned char input[3], output[4];
        short i, charsonline = 0, ctcopy;
        const unsigned char *raw;
        NSMutableString *result;
        NSData* data = [htmlEncodedString dataUsingEncoding:NSUTF8StringEncoding];
        lentext = [data length];
        if (lentext < 1)
            return @"";
        result = [NSMutableString stringWithCapacity: lentext];
        raw = [data bytes];
        ixtext = 0;
        
        while (true) {
            ctremaining = lentext - ixtext;
            if (ctremaining <= 0)
                break;
            for (i = 0; i < 3; i++) {
                unsigned long ix = ixtext + i;
                if (ix < lentext)
                    input[i] = raw[ix];
                else
                    input[i] = 0;
            }
            output[0] = (input[0] & 0xFC) >> 2;
            output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
            output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
            output[3] = input[2] & 0x3F;
            ctcopy = 4;
            switch (ctremaining) {
                case 1:
                    ctcopy = 2;
                    break;
                case 2:
                    ctcopy = 3;
                    break;
            }
            
            for (i = 0; i < ctcopy; i++)
                [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
            
            for (i = ctcopy; i < 4; i++)
                [result appendString: @"="];
            
            ixtext += 3;
            charsonline += 4;
            
            if ((lentext > 0) && (charsonline >= lentext))
                charsonline = 0;
        }
        NSString *finalString = [result stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        return finalString;
    }
}

+ (void)saveUserInfo:(User *)userInfo {
//    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [prefs setObject:myEncodedObject forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (User *)getUserInfo {
    //return [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:USER_INFO];
    User *obj = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}

+ (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**************** USER DETAILS **************************/

+(void)saveUserDetails:(NSDictionary *)_dictUser{
    [[NSUserDefaults standardUserDefaults] setObject:_dictUser forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDictionary *)getUserDetails{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
}
+(void)deleteUserDetails{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/******************************************/

+(void)checkPassword:(NSString *)_status{
    [[NSUserDefaults standardUserDefaults] setObject:_status forKey:PASSWORD_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)passwordStatus{
    return [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_STATUS];
}

+(void)removePasswordInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PASSWORD_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isUserLoggedIn {
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userLogin"]);
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"userLogin"] isEqualToString:@"YES"]){
        return YES;
    }
    else{
        return NO;
    }
}
+(void)setUserLoginEnable:(BOOL)login {
    [[NSUserDefaults standardUserDefaults] setValue:login == YES ? @"YES" : @"NO" forKey:@"userLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userLogin"]);
}

+(BOOL)isUserAgree{
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userAgree"]);
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"userAgree"] isEqualToString:@"YES"]){
        return YES;
    }
    else{
        return NO;
    }
}
+(void)setUserAgreement:(BOOL)isAgree{
    [[NSUserDefaults standardUserDefaults] setValue:isAgree == YES ? @"YES" : @"NO" forKey:@"userAgree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userAgree"]);
}

+(BOOL)isNotificationAlertFirstTime{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"notificationAlert"] isEqualToString:@"NO"]){
        return YES;
    }
    else{
        
        return NO;
    }
}
+(void)setNotificatioAlertFirstTime:(BOOL)alert{
    [[NSUserDefaults standardUserDefaults] setValue:alert == NO ? @"YES" : @"NO" forKey:@"notificationAlert"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getDocumentDirectoryPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)createFolderInDocumentDirectory:(NSString *)folderName {
    if ([folderName isEqualToString:@""] || folderName == nil)
        return nil;
    NSError *error;
    NSString *dataPath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return dataPath;
}

+ (NSString *)getFolderPathFromDocumentDirectory:(NSString *)folderName {
    if ([folderName isEqualToString:@""] || folderName == nil)
        return nil;
    NSString *dataPath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        return nil;
    return dataPath;
}

+ (NSString *)getFilePathFromDocumentDirectory:(NSString *)fileName inFolder:(NSString *)folderName {
    NSString *folderPath = [self getDocumentDirectoryPath];
    if (!([folderName isEqualToString:@""] || folderName == nil))
        folderPath = [folderPath stringByAppendingPathComponent:folderName];
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:folderPath];
    NSString *documentsSubpath;
    BOOL isFound = NO;
    while (documentsSubpath = [direnum nextObject]) {
        if (![documentsSubpath.lastPathComponent isEqual:fileName])
            continue;
        isFound = YES;
        break;
    }
    return isFound == YES ? [folderPath stringByAppendingPathComponent:documentsSubpath] : nil;
}

+ (NSString *)saveFileInDocumentDirectory:(NSData *)fileData fileName:(NSString *)fileName inDirectory:(NSString *)folderName {
    NSString *filePath = [self getDocumentDirectoryPath];
    if (!([folderName isEqualToString:@""] || folderName == nil)) {
        filePath = [filePath stringByAppendingPathComponent:folderName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            filePath = [self createFolderInDocumentDirectory:folderName];
    }
    filePath = [filePath stringByAppendingPathComponent:[fileName isEqualToString:@""] || fileName == nil ? @"undefined" : fileName];
    [fileData writeToFile:filePath atomically:NO];
    return filePath;
}

+ (BOOL)removeSpecificFileFromDirectory:(NSString *)folderName fileName:(NSString *)fileName {
    if (fileName == nil || [fileName isEqualToString:@""])
        return NO;
    NSString *filePath = [self getDocumentDirectoryPath];
    if (!([folderName isEqualToString:@""] || folderName == nil)) {
        filePath = [filePath stringByAppendingPathComponent:folderName];
    }
    NSError *error;
    filePath = [filePath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        NSLog(@"Error to delete file : %@", error);
        return NO;
    }
    return YES;
}

+ (BOOL)removeAllFilesFromDirectory:(NSString *)folderName {
    if (folderName != nil || [folderName isEqualToString:@""]) {
        NSString *fPath = [self getFolderPathFromDocumentDirectory:folderName];
        if (fPath == nil)
            return NO;
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *directory = [fPath stringByAppendingPathComponent:@"/"];
        NSError *error;
        for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
            BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
            if (!success || error)
                NSLog(@"Error to delete file : %@", error);
        }
        fm = nil;
        return YES;
    }
    return NO;
}

+ (BOOL)removeSpecificDirectoryFromDocumentDirectory:(NSString *)folderName {
    if ([folderName isEqualToString:@""] || folderName == nil)
        return NO;
    NSString *folderPath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:folderName];
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:folderPath error:&error]) {
        return NO;
    }
    return YES;
}

+ (BOOL)removeAllFilesAndFolderFromDocumentDirectory {
    NSString *documentDirectoryPath = [self getDocumentDirectoryPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    for (NSString *file in [fm contentsOfDirectoryAtPath:documentDirectoryPath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentDirectoryPath, file] error:&error];
        if (!success || error)
            NSLog(@"Error to delete file : %@", error);
    }
    fm = nil;
    return YES;
}

+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage
{
    CGFloat secondWidth = secondImage.size.width;
    CGFloat secondHeight = secondImage.size.height;
    CGSize mergedSize = CGSizeMake(MAX(secondWidth, secondWidth), MAX(secondHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    [firstImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)decodeStringFromBase64:(NSString *)str {
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:str options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        decodedString = [decodedString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
        return [decodedString kv_decodeHTMLCharacterEntities];
    }
    else
    {
        unsigned long ixtext, lentext;
        unsigned char ch, inbuf[4], outbuf[3];
        short i, ixinbuf;
        Boolean flignore, flendtext = false;
        const unsigned char *tempcstring;
        NSMutableData *theData;
        if (str == nil)
        {
            NSString* responseString = [[NSString alloc] initWithData:[NSData data] encoding:NSNonLossyASCIIStringEncoding];
            return responseString;
        }
        ixtext = 0;
        tempcstring = (const unsigned char *)[str UTF8String];
        lentext = [str length];
        theData = [NSMutableData dataWithCapacity: lentext];
        ixinbuf = 0;
        while (true)
        {
            if (ixtext >= lentext)
            {
                break;
            }
            ch = tempcstring [ixtext++];
            
            flignore = false;
            
            if ((ch >= 'A') && (ch <= 'Z'))
            {
                ch = ch - 'A';
            }
            else if ((ch >= 'a') && (ch <= 'z'))
            {
                ch = ch - 'a' + 26;
            }
            else if ((ch >= '0') && (ch <= '9'))
            {
                ch = ch - '0' + 52;
            }
            else if (ch == '+')
            {
                ch = 62;
            }
            else if (ch == '=')
            {
                flendtext = true;
            }
            else if (ch == '/')
            {
                ch = 63;
            }
            else
            {
                flignore = true;
            }
            if (!flignore)
            {
                short ctcharsinbuf = 3;
                Boolean flbreak = false;
                if (flendtext)
                {
                    if (ixinbuf == 0)
                    {
                        break;
                    }
                    if ((ixinbuf == 1) || (ixinbuf == 2))
                    {
                        ctcharsinbuf = 1;
                    }
                    else
                    {
                        ctcharsinbuf = 2;
                    }
                    ixinbuf = 3;
                    flbreak = true;
                }
                inbuf [ixinbuf++] = ch;
                if (ixinbuf == 4)
                {
                    ixinbuf = 0;
                    outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                    outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                    outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                    for (i = 0; i < ctcharsinbuf; i++)
                    {
                        [theData appendBytes: &outbuf[i] length: 1];
                    }
                }
                if (flbreak)
                {
                    break;
                }
            }
        }
        NSString* decodeString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
        decodeString = [decodeString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
        return [decodeString kv_decodeHTMLCharacterEntities];
    }
}

+ (UIImage *)blurImage:(UIImage *)sourceImage blurAmount:(float)blur {
    if (blur < 1){
        return sourceImage;
    }
    // Suggestion xidew to prevent crash if size is null
    if (CGSizeEqualToSize(sourceImage.size, CGSizeZero)) {
        return sourceImage;
    }
    
    //	return [other applyBlendFilter:filterOverlay  other:self context:nil];
    // First get the image into your data buffer
    CGImageRef inImage = sourceImage.CGImage;
    long nbPerCompt = CGImageGetBitsPerPixel(inImage);
    if(nbPerCompt != 32){
        UIImage *tmpImage = [self normalize:sourceImage];
        inImage = tmpImage.CGImage;
    }
    CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    CFMutableDataRef m_DataRef = CFDataCreateMutableCopy(0, 0, dataRef);
    CFRelease(dataRef);
    UInt8 * m_PixelBuf=malloc(CFDataGetLength(m_DataRef));
    CFDataGetBytes(m_DataRef,
                   CFRangeMake(0,CFDataGetLength(m_DataRef)) ,
                   m_PixelBuf);
    
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
                                             CGImageGetWidth(inImage),
                                             CGImageGetHeight(inImage),
                                             CGImageGetBitsPerComponent(inImage),
                                             CGImageGetBytesPerRow(inImage),
                                             CGImageGetColorSpace(inImage),
                                             CGImageGetBitmapInfo(inImage)
                                             );
    
    // Apply stack blur
    const int imageWidth  = CGImageGetWidth(inImage);
    const int imageHeight = CGImageGetHeight(inImage);
    [self applyStackBlurToBuffer:m_PixelBuf
                                 width:imageWidth
                                height:imageHeight
                            withRadius:blur];
    
    // Make new image
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);	
    
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);	
    CFRelease(m_DataRef);
    free(m_PixelBuf);
    return finalImage;
}

+ (UIImage *) normalize:(UIImage *)image {
    int width = image.size.width;
    int height = image.size.height;
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                         width,
                                                         height,
                                                         8, (4 * width),
                                                         genericColorSpace,
                                                         kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, image.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);
    return result;
}

+ (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius {
    // Constants
    const int radius = (int)inradius; // Transform unsigned into signed for further operations
    const int wm = w - 1;
    const int hm = h - 1;
    const int wh = w*h;
    const int div = radius + radius + 1;
    const int r1 = radius + 1;
    const int divsum = SQUARE((div+1)>>1);
    
    // Small buffers
    int stack[div*3];
    zeroClearInt(stack, div*3);
    
    int vmin[MAX(w,h)];
    zeroClearInt(vmin, MAX(w,h));
    
    // Large buffers
    int *r = malloc(wh*sizeof(int));
    int *g = malloc(wh*sizeof(int));
    int *b = malloc(wh*sizeof(int));
    zeroClearInt(r, wh);
    zeroClearInt(g, wh);
    zeroClearInt(b, wh);
    
    const size_t dvcount = 256 * divsum;
    int *dv = malloc(sizeof(int) * dvcount);
    for (int i = 0;(size_t)i < dvcount;i++) {
        dv[i] = (i / divsum);
    }
    
    // Variables
    int x, y;
    int *sir;
    int routsum,goutsum,boutsum;
    int rinsum,ginsum,binsum;
    int rsum, gsum, bsum, p, yp;
    int stackpointer;
    int stackstart;
    int rbs;
    
    int yw = 0, yi = 0;
    for (y = 0;y < h;y++) {
        rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
        
        for(int i = -radius;i <= radius;i++){
            sir = &stack[(i + radius)*3];
            int offset = (yi + MIN(wm, MAX(i, 0)))*4;
            sir[0] = targetBuffer[offset];
            sir[1] = targetBuffer[offset + 1];
            sir[2] = targetBuffer[offset + 2];
            
            rbs = r1 - abs(i);
            rsum += sir[0] * rbs;
            gsum += sir[1] * rbs;
            bsum += sir[2] * rbs;
            if (i > 0){
                rinsum += sir[0];
                ginsum += sir[1];
                binsum += sir[2];
            } else {
                routsum += sir[0];
                goutsum += sir[1];
                boutsum += sir[2];
            }
        }
        stackpointer = radius;
        
        for (x = 0;x < w;x++) {
            r[yi] = dv[rsum];
            g[yi] = dv[gsum];
            b[yi] = dv[bsum];
            
            rsum -= routsum;
            gsum -= goutsum;
            bsum -= boutsum;
            
            stackstart = stackpointer - radius + div;
            sir = &stack[(stackstart % div)*3];
            
            routsum -= sir[0];
            goutsum -= sir[1];
            boutsum -= sir[2];
            
            if (y == 0){
                vmin[x] = MIN(x + radius + 1, wm);
            }
            
            int offset = (yw + vmin[x])*4;
            sir[0] = targetBuffer[offset];
            sir[1] = targetBuffer[offset + 1];
            sir[2] = targetBuffer[offset + 2];
            rinsum += sir[0];
            ginsum += sir[1];
            binsum += sir[2];
            
            rsum += rinsum;
            gsum += ginsum;
            bsum += binsum;
            
            stackpointer = (stackpointer + 1) % div;
            sir = &stack[(stackpointer % div)*3];
            
            routsum += sir[0];
            goutsum += sir[1];
            boutsum += sir[2];
            
            rinsum -= sir[0];
            ginsum -= sir[1];
            binsum -= sir[2];
            
            yi++;
        }
        yw += w;
    }
    
    for (x = 0;x < w;x++) {
        rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
        yp = -radius*w;
        for(int i = -radius;i <= radius;i++) {
            yi = MAX(0, yp) + x;
            
            sir = &stack[(i + radius)*3];
            
            sir[0] = r[yi];
            sir[1] = g[yi];
            sir[2] = b[yi];
            
            rbs = r1 - abs(i);
            
            rsum += r[yi]*rbs;
            gsum += g[yi]*rbs;
            bsum += b[yi]*rbs;
            
            if (i > 0) {
                rinsum += sir[0];
                ginsum += sir[1];
                binsum += sir[2];
            } else {
                routsum += sir[0];
                goutsum += sir[1];
                boutsum += sir[2];
            }
            
            if (i < hm) {
                yp += w;
            }
        }
        yi = x;
        stackpointer = radius;
        for (y = 0;y < h;y++) {
            int offset = yi*4;
            targetBuffer[offset]     = dv[rsum];
            targetBuffer[offset + 1] = dv[gsum];
            targetBuffer[offset + 2] = dv[bsum];
            rsum -= routsum;
            gsum -= goutsum;
            bsum -= boutsum;
            
            stackstart = stackpointer - radius + div;
            sir = &stack[(stackstart % div)*3];
            
            routsum -= sir[0];
            goutsum -= sir[1];
            boutsum -= sir[2];
            
            if (x == 0){
                vmin[y] = MIN(y + r1, hm)*w;
            }
            p = x + vmin[y];
            
            sir[0] = r[p];
            sir[1] = g[p];
            sir[2] = b[p];
            
            rinsum += sir[0];
            ginsum += sir[1];
            binsum += sir[2];
            
            rsum += rinsum;
            gsum += ginsum;
            bsum += binsum;
            
            stackpointer = (stackpointer + 1) % div;
            sir = &stack[stackpointer*3];
            
            routsum += sir[0];
            goutsum += sir[1];
            boutsum += sir[2];
            
            rinsum -= sir[0];
            ginsum -= sir[1];
            binsum -= sir[2];
            
            yi += w;
        }
    }
    free(r);
    free(g);
    free(b);
    free(dv);
}

/////// New Addition //////

// Get Image
+(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

//Save Image

+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath{
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

//Load Image

+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath{
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    return result;
}

+ (NSDateComponents *)getTodayComponentsFromDate:(NSDate *)theDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitYear fromDate:theDate];
}

+(NSString*)deviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
}

+(void)setDeviceToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
}

+(UIBezierPath *)roundedPolygonPathWithRect:(CGRect)rect lineWidth:(CGFloat)lineWidth sides:(NSInteger)sides cornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path  = [UIBezierPath bezierPath];
    
    CGFloat theta       = 2.0 * M_PI / sides;                           // how much to turn at every corner
   // CGFloat offset      = cornerRadius * tanf(theta / 2.0);             // offset from which to start rounding corners
    CGFloat width = MIN(rect.size.width, rect.size.height);   // width of the square
    
    // Calculate Center
    CGPoint center = CGPointMake(rect.origin.x + width / 2.0, rect.origin.y + width / 2.0);
    CGFloat radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0;
    
    // Start drawing at a point, which by default is at the right hand edge
    // but can be offset
    CGFloat angle = M_PI / 2;
    
    CGPoint corner = CGPointMake(center.x + (radius - cornerRadius) * cos(angle), center.y + (radius - cornerRadius) * sin(angle));
    [path moveToPoint:(CGPointMake(corner.x + cornerRadius * cos(angle + theta), corner.y + cornerRadius * sin(angle + theta)))];
    
    // draw the sides and rounded corners of the polygon
    
    for (NSInteger side = 0; side < sides; side++)
    {
        
        angle += theta;
        
        CGPoint corner = CGPointMake(center.x + (radius - cornerRadius) * cos(angle), center.y + (radius - cornerRadius) * sin(angle));
        CGPoint tip = CGPointMake(center.x + radius * cos(angle), center.y + radius * sin(angle));
        CGPoint start = CGPointMake(corner.x + cornerRadius * cos(angle - theta), corner.y + cornerRadius * sin(angle - theta));
        CGPoint end = CGPointMake(corner.x + cornerRadius * cos(angle + theta), corner.y + cornerRadius * sin(angle + theta));
        
        [path addLineToPoint:start];
        [path addQuadCurveToPoint:end controlPoint:tip];
    }
    
    [path closePath];
    
    CGRect bounds = path.bounds;
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(-bounds.origin.x + rect.origin.x + lineWidth / 2.0, -bounds.origin.y + rect.origin.y + lineWidth / 2.0);
    [path applyTransform:transform];
    
    return path;
}

#pragma mark - UIVIEW BOTTOM BORDER

+(void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth view:(UIView *)_view {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border.frame = CGRectMake(0, _view.frame.size.height - borderWidth, _view.frame.size.width, borderWidth);
    [_view addSubview:border];
}

+(void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth view:(UIView *)_view {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border.frame = CGRectMake(_view.frame.size.width - borderWidth, 0, borderWidth, _view.frame.size.height);
    [_view addSubview:border];
}

+(void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth view:(UIView *)_view{
    UIView *border = [UIView new];
    border.backgroundColor = color;
    border.frame = CGRectMake(0, 0, borderWidth, _view.frame.size.height);
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [_view addSubview:border];
}

@end

//
//  DataValidation.h
//  ProjDemo
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataValidation : NSObject

+ (BOOL)isDeviceiPhone;
+ (BOOL)isNullString:(NSString *)textString;
+ (BOOL)isNumericString:(NSString *)textString;
+ (BOOL)isAlphabetString:(NSString *)textString;
+ (BOOL)isValidPassword:(NSString*)password;
+ (BOOL)isValidateMailid:(NSString *)email;
+ (BOOL)isFutureDateByToday:(NSDate *)date;
+ (BOOL)isFutureDate:(NSDate *)date1 byDate:(NSDate *)date2;
+ (BOOL)isAgeGreaterThanOrEqualTo:(int)age dateOfBirth:(NSDate *)dob;
+ (BOOL)validatePhone:(NSString *)phoneNumber CountryCode:(NSString *)_countryCode;
+ (BOOL)isGreaterDate:(NSDate *)date1 byDate:(NSDate *)date2;
+ (NSString *)isString:(NSString *)textString;
@end

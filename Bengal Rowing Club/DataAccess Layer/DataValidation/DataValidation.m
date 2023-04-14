//
//  DataValidation.m
//  ProjDemo
//
//

#import "DataValidation.h"

@implementation DataValidation

+ (BOOL)isDeviceiPhone {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNullString:(NSString *)textString {
    if (textString == nil || textString == (id)[NSNull null] || [[NSString stringWithFormat:@"%@",textString] length] == 0 || [[[NSString stringWithFormat:@"%@",textString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 || [textString isEqualToString:@"(null)"] || [textString isEqualToString:@"<null>"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (NSString *)isString:(NSString *)textString {
    if (textString == nil || textString == (id)[NSNull null] || [[NSString stringWithFormat:@"%@",textString] length] == 0 || [[[NSString stringWithFormat:@"%@",textString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 || [textString isEqualToString:@"(null)"] || [textString isEqualToString:@"<null>"]) {
        return @"";
    }
    else{
        return textString;
    }
}

+ (BOOL)isNumericString:(NSString *)text {
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    return valid;
}

+ (BOOL)isAlphabetString:(NSString *)text {
    NSCharacterSet *alpha = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    return [alpha isSupersetOfSet:inStringSet];
}

+ (BOOL)isValidateMailid:(NSString *)email {
//    NSString *emailRegex = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-‌​Za-z0-9-]+)*(\\.[A-Z‌​a-z]{2,4})$";//@"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:email];
    
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:email]) {
        aRange = [email rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [email length])];
        NSUInteger indexOfDot = aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [email substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    return FALSE;
}

+ (BOOL)isValidPassword:(NSString*)password {
    /*Minimum 6 character
     Atleast one english capital letter
     One english small letter
     One digit
     One special character (#?!@$%^&*-)*/
    
    NSString *emailRegex = @"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,15}$";
    NSPredicate *passwordlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [passwordlTest evaluateWithObject:password];
}

+ (BOOL)isFutureDateByToday:(NSDate *)date {
    return ([date compare:[NSDate date]] == NSOrderedSame || [date compare:[NSDate date]] == NSOrderedAscending) ? NO : YES;
}

+ (BOOL)isFutureDate:(NSDate *)date1 byDate:(NSDate *)date2 {
    return ([date1 compare:date2] == NSOrderedSame || [date1 compare:date2] == NSOrderedAscending) ? NO : YES;
}

+ (BOOL)isAgeGreaterThanOrEqualTo:(int)age dateOfBirth:(NSDate *)dob {
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dob
                                       toDate:[NSDate date]
                                       options:0];
    return [ageComponents year] >= age ? YES : NO;
}

+ (BOOL)validatePhone:(NSString *)phoneNumber CountryCode:(NSString *)_countryCode
{
    NSString *phoneRegex;
    if([_countryCode isEqualToString:@"+852"] || [_countryCode isEqualToString:@"+853"] || [_countryCode isEqualToString:@"+65"]){
        phoneRegex = @"^[0-9]{8,8}$";
    }
    else if ([_countryCode isEqualToString:@"+62"] || [_countryCode isEqualToString:@"+886"]){
        phoneRegex = @"^[0-9]{9,9}$";
    }
    else if ([_countryCode isEqualToString:@"+60"] || [_countryCode isEqualToString:@"+1"]){
        phoneRegex = @"^[0-9]{10,10}$";
    }
    else
    {
        phoneRegex = @"^[0-9]{11,11}$";
    }
    //phoneRegex = @"^[0-9]{6,10}$";//^((\\+)|(00))[0-9]{6,14}$
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

+ (BOOL)isGreaterDate:(NSDate *)date1 byDate:(NSDate *)date2{
    
    NSComparisonResult result = [date2 compare:date1];
    
    if(result==NSOrderedAscending){
        NSLog(@"Date1 is in the future");
        return NO;
    }
    else if(result==NSOrderedDescending){
        NSLog(@"Date1 is in the past");
        return YES;
    }
    else{
        NSLog(@"Both dates are the same");
        return NO;
    }
    //return ([date1 compare:date2] == NSOrderedDescending) ? NO : YES;
}

@end

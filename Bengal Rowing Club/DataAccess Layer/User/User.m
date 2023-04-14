
#import "User.h"

static User *user=nil;

@implementation User


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    
    if( (self=[super init])) {
        self.ID = @"";
        self.user_email = @"";
        self.user_login_token = @"";
        self.user_mobile = @"";
        self.user_Name = @"";
        self.user_membership_no = @"";
        self.token = @"";
        self.user_password = @"";
        self.user_status = @"";
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:_ID forKey:@"ID"];
    [encoder encodeObject:_user_login_token forKey:@"user_login_token"];
    [encoder encodeObject:_user_Name forKey:@"user_Name"];
    [encoder encodeObject:_user_membership_no forKey:@"user_membership_no"];
    [encoder encodeObject:_token forKey:@"token"];
    [encoder encodeObject:_user_password forKey:@"user_password"];
    [encoder encodeObject:_user_status forKey:@"user_status"];
    [encoder encodeObject:_user_email forKey:@"user_email"];
    [encoder encodeObject:_user_mobile forKey:@"user_mobile"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        _ID = [decoder decodeObjectForKey:@"ID"];
        _user_login_token = [decoder decodeObjectForKey:@"user_login_token"];
        _user_Name = [decoder decodeObjectForKey:@"user_Name"];
        _user_membership_no = [decoder decodeObjectForKey:@"user_membership_no"];
        _token = [decoder decodeObjectForKey:@"token"];
        _user_password = [decoder decodeObjectForKey:@"user_password"];
        _user_status = [decoder decodeObjectForKey:@"user_status"];
        _user_email = [decoder decodeObjectForKey:@"user_email"];
        _user_mobile = [decoder decodeObjectForKey:@"user_mobile"];
    }
    return self;
}

@end

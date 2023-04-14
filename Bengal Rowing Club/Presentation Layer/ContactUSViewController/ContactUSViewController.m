//
//  ContactUSViewController.m
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 22/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "ContactUSViewController.h"
#import "Constant.h"
#import <WebKit/WebKit.h>

@interface ContactUSViewController ()<ServerConnectionDelegate,WKNavigationDelegate>{
    SpinnerView *mSpinnerView;
    NSString *strHTML;
}
@property (weak, nonatomic) IBOutlet WKWebView *wkView_ContactUs;

@end

@implementation ContactUSViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
    _wkView_ContactUs.navigationDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        //[mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection get_contact_page];
    }
    else
    {
        [self.view setUserInteractionEnabled:YES];
        //[mSpinnerView hideFromView:self.view animated:YES];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please check internet connection of your Device" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click_BackContactUS:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)get_contact_page:(id)result{
    NSLog(@"%@",result);
    [self.view setUserInteractionEnabled:YES];
    //[mSpinnerView hideFromView:self.view animated:YES];
    if([result isKindOfClass:[NSError class]]){
        //[Utility showAlertWithTitle:ALERT_TITLE message:PARSING_ERROR_MESSAGE];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:PARSING_ERROR_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([result isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)result;
        if([[dict valueForKey:@"status"] integerValue]==1)
        {
            strHTML = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"data"] valueForKey:@"contact"]];
            /*User *mUser = [User new];
            mUser.token = [dict valueForKey:@"token"];
            mUser.user_email = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"Email"];
            mUser.user_Name = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"Name"];
            mUser.ID = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"id"];
            mUser.user_login_token = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"login_token"];
            mUser.user_membership_no = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"membership_no"];
            mUser.user_mobile = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"mobile"];
            mUser.user_password = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"password"];
            mUser.user_status = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"status"];
            [Utility saveUserInfo:mUser];*/
            
            //NSString *headerString = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=0.4, user-scalable=no'></head>";
            NSString *strHeader = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><link href=\"https://www.bengalrowingclub.com/skin/pages/css/ios_style.css\" media=\"all\" rel=\"stylesheet\"></head><body><div class=\"contactUs\">"];
            NSString *strFooter= @"</div></body></html>";
            strHTML = [strHeader stringByAppendingString:strHTML];
            strHTML = [strHTML stringByAppendingString:strFooter];
            //[_wkView_ContactUs loadHTMLString:[headerString stringByAppendingString:strHTML] baseURL:nil];
            [_wkView_ContactUs loadHTMLString:strHTML baseURL:nil];
            _wkView_ContactUs.allowsBackForwardNavigationGestures = YES;
        }
    }
    else{
    }
}



@end

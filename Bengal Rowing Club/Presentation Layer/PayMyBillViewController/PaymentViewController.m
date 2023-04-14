//
//  PaymentViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 24/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "PaymentViewController.h"
#import "PayMyBillViewController.h"
#import <WebKit/WebKit.h>
@interface PaymentViewController ()<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *wbView_Pay;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *headerString = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>";
    [_wbView_Pay loadHTMLString:[headerString stringByAppendingString:_strHTML] baseURL:nil];
    //[_wkView_ContactUs loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.bengalrowingclub.com/"]]];
    _wbView_Pay.allowsBackForwardNavigationGestures = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click_BackPayMent:(UIButton *)sender {
    PayMyBillViewController *mPayMyBillViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMyBillViewController"];
    [self.navigationController pushViewController:mPayMyBillViewController animated:NO];
}

@end

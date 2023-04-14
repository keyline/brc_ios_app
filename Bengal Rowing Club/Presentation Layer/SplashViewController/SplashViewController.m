//
//  SplashViewController.m
//  Tolly Tee off
//
//  Created by Chakraborty, Sayan on 25/08/17.
//  Copyright © 2017 Chakraborty, Sayan. All rights reserved.
//

#import "SplashViewController.h"
#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "Constant.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(moveToNextScreen) withObject:nil afterDelay:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SELF METHODS

-(void)moveToNextScreen{

    
    if([Utility isUserLoggedIn]==YES){
        DashboardViewController *mDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        [self.navigationController pushViewController:mDashboardViewController animated:NO];
    }
    else{
        LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:mLoginViewController animated:NO];
    }
}

@end

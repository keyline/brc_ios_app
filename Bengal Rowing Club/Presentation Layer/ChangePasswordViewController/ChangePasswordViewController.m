//
//  ChangePasswordViewController.m
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 24/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Constant.h"

@interface ChangePasswordViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
}
@property (weak, nonatomic) IBOutlet UITextField *txt_oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txt_NewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_ConfirmNewPassword;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _txt_oldPassword){
        [_txt_NewPassword becomeFirstResponder];
    }
    else if(textField == _txt_NewPassword){
        [_txtFld_ConfirmNewPassword becomeFirstResponder];
    }
    else{
        if (FULLHEIGHT == 568){
            [self moveDownViewFrame:20];
        }
        else if (FULLHEIGHT == 480){
            [self moveDownViewFrame:70];
        }
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   if (FULLHEIGHT == 568){
        [self moveUpViewFrame:20];
    }
    else if (FULLHEIGHT == 480){
        [self moveUpViewFrame:70];
    }
}

#pragma mark - SELF METHODS

/********************************************//*!
* @brief This method is used to move up the view
***********************************************/

-(void)moveUpViewFrame:(CGFloat)_height//call at begin editing
{
    CGRect viewFrame = self.view.frame;
    if (viewFrame.origin.y>=0 )
    {
        viewFrame.origin.y -= _height;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:.5];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}


/********************************************//*!
 * @brief This method is used to move down the view
 ***********************************************/

-(void)moveDownViewFrame:(CGFloat)_height//call at return
{
    CGRect viewFrame = self.view.frame;
    if (viewFrame.origin.y<0)
    {
        viewFrame.origin.y += _height;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:.5];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}

#pragma mark - BUTTON METHODS

- (IBAction)click_backChangePassword:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)click_Login:(UIButton *)sender {
    [_txt_oldPassword resignFirstResponder];
    [_txt_NewPassword resignFirstResponder];
    [_txtFld_ConfirmNewPassword resignFirstResponder];
    if([DataValidation isNullString:_txt_oldPassword.text]==YES){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"You must enter old password!"  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    
                                                    // call method whatever u need
                                                }];
                    [alert addAction:yesButton];
                    [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([DataValidation isNullString:_txt_NewPassword.text]==YES){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE
                                                                      message:@"You must enter new password!"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                        // call method whatever u need
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([DataValidation isNullString:_txtFld_ConfirmNewPassword.text]==YES){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE
                                                                      message:@"You must confirm your new password!"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                        // call method whatever u need
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (![_txt_NewPassword.text isEqualToString:_txtFld_ConfirmNewPassword.text]){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE
                                                                      message:@"New password and confirm new password should be same!"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                        // call method whatever u need
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        
        if ([Utility isNetworkAvailable]) {
            User *mUser = [User new];
            mUser = [Utility getUserInfo];
            [self.view setUserInteractionEnabled:NO];
            [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
            ServerConnection *mServerConnection = [[ServerConnection alloc] init];
            mServerConnection.delegate = self;
            [mServerConnection change_password:mUser.ID OldPassword:_txt_oldPassword.text NewPassword:_txt_NewPassword.text ConfirmPassword:_txtFld_ConfirmNewPassword.text];
        }
        else
        {
            [self.view setUserInteractionEnabled:YES];
            [mSpinnerView hideFromView:self.view animated:YES];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please check internet connection of your Device" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
- (IBAction)click_Cancel:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - SERVER CONNECTION

-(void)change_password:(id)result
{
    NSLog(@"%@",result);
    [self.view setUserInteractionEnabled:YES];
    [mSpinnerView hideFromView:self.view animated:YES];
    if([result isKindOfClass:[NSError class]]){
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
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self.navigationController pushViewController:mLoginViewController animated:NO];
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if([[dict valueForKey:@"status"] integerValue]==0){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self.navigationController pushViewController:mLoginViewController animated:NO];
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:PARSING_ERROR_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:mLoginViewController animated:NO];
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

//
//  LoginViewController.m
//  Tolly Tee off
//
//  Created by Chakraborty, Sayan on 25/08/17.
//  Copyright © 2017 Chakraborty, Sayan. All rights reserved.
//

#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "Constant.h"

@interface LoginViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSString *strKey;
    NSString *strSalt;
}
@property (weak, nonatomic) IBOutlet UITextField *txtfld_UserIDLogin;
@property (weak, nonatomic) IBOutlet UIView *vw_UserIDLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtfld_PasswordLogin;
@property (weak, nonatomic) IBOutlet UIView *vw_PasswordLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_Logo;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
    _imgVw_Logo.layer.cornerRadius = _imgVw_Logo.frame.size.height/2;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection initLogin];
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

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self hideTextFieldBorder];
    if(textField == _txtfld_UserIDLogin){
        [_txtfld_PasswordLogin becomeFirstResponder];
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
    if(textField == _txtfld_UserIDLogin){
        [self hideTextFieldBorder];
        _vw_UserIDLogin.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:81.0/255.0 green:181.0/255.0 blue:0.0/255.0 alpha:1.0];
        _vw_UserIDLogin.frame = CGRectMake(_vw_UserIDLogin.frame.origin.x, _vw_UserIDLogin.frame.origin.y, _vw_UserIDLogin.frame.size.width, 3);
    }
    else{
        [self hideTextFieldBorder];
        _vw_PasswordLogin.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:81.0/255.0 green:181.0/255.0 blue:0.0/255.0 alpha:1.0];
        _vw_PasswordLogin.frame = CGRectMake(_vw_PasswordLogin.frame.origin.x, _vw_PasswordLogin.frame.origin.y, _vw_PasswordLogin.frame.size.width, 3);
        if (FULLHEIGHT == 568){
            [self moveUpViewFrame:20];
        }
        else if (FULLHEIGHT == 480){
            [self moveUpViewFrame:70];
        }
    }
}

#pragma mark - SELF METHODS

-(void)hideTextFieldBorder{
    _vw_UserIDLogin.backgroundColor = [UIColor darkGrayColor];
    _vw_PasswordLogin.backgroundColor = [UIColor darkGrayColor];
    
    _vw_UserIDLogin.frame = CGRectMake(_vw_UserIDLogin.frame.origin.x, _vw_UserIDLogin.frame.origin.y, _vw_UserIDLogin.frame.size.width, 1);
    _vw_PasswordLogin.frame = CGRectMake(_vw_PasswordLogin.frame.origin.x, _vw_PasswordLogin.frame.origin.y, _vw_PasswordLogin.frame.size.width, 1);
}

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

- (IBAction)click_btnForgetPasswordLogin:(id)sender {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Forget Password"  preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^ (UITextField *textfield)
     {
        textfield.placeholder = @"email id";
        textfield.textColor = [UIColor blackColor];
        textfield.borderStyle = UITextBorderStyleRoundedRect;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Submit"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    NSArray *textfields = alert.textFields;
                                    UITextField *email = textfields[0];
        
                                    if([DataValidation isNullString:email.text]==YES){
                                        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please enter your email id"  preferredStyle:UIAlertControllerStyleAlert];
                                                    
                                                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:^(UIAlertAction * action)
                                                                                {
                                                                                    
                                                                                    // call method whatever u need
                                                                                }];
                                                    [alert addAction:yesButton];
                                                    [self presentViewController:alert animated:YES completion:nil];
                                    }
                                    else if([DataValidation isValidateMailid:email.text]==NO){
                                        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please enter your valid email id"  preferredStyle:UIAlertControllerStyleAlert];
                        
                                                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)
                                                                            {
                                                        
                                                                            }];
                                                [alert addAction:yesButton];
                                                [self presentViewController:alert animated:YES completion:nil];
                                        }
                                    else{
                                        if ([Utility isNetworkAvailable]) {
                                            [self.view setUserInteractionEnabled:NO];
                                            [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
                                            ServerConnection *mServerConnection = [[ServerConnection alloc] init];
                                            mServerConnection.delegate = self;
                                            [mServerConnection forgot_password:email.text];
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
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Cancel"
                            style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
    {
        
    }];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)click_btnLogin:(id)sender {
    [_txtfld_UserIDLogin resignFirstResponder];
    [_txtfld_PasswordLogin resignFirstResponder];
    if([DataValidation isNullString:_txtfld_UserIDLogin.text]==YES){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"You must enter Member's user ID!"  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    
                                                    // call method whatever u need
                                                }];
                    [alert addAction:yesButton];
                    [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([DataValidation isNullString:_txtfld_PasswordLogin.text]==YES){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE
                                                                      message:@"Please enter your login password!"
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
            
            NSString *strFinalPass = [[NSString alloc] generateMD5:[NSString stringWithFormat:@"%@%@",[[NSString alloc] generateMD5:_txtfld_PasswordLogin.text],[[NSString alloc] generateMD5:[NSString stringWithFormat:@"%@",strSalt]]]];
            [self.view setUserInteractionEnabled:NO];
            [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
            ServerConnection *mServerConnection = [[ServerConnection alloc] init];
            mServerConnection.delegate = self;
            [mServerConnection login:_txtfld_UserIDLogin.text Password:strFinalPass Key:strKey];
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

#pragma mark - SERVER CONNECTION DELEGATES

-(void)initLogin:(id)result{
    NSLog(@"%@",result);
    [self.view setUserInteractionEnabled:YES];
    [mSpinnerView hideFromView:self.view animated:YES];
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
            strKey = [NSString stringWithFormat:@"%@",[dict valueForKey:@"key"]];
            strSalt = [NSString stringWithFormat:@"%@",[dict valueForKey:@"salt"]];
        }
    }
    else{
    }
}

-(void)login:(id)result{
    NSLog(@"%@",result);
    [self.view setUserInteractionEnabled:YES];
    [mSpinnerView hideFromView:self.view animated:YES];
    
    if([result isKindOfClass:[NSError class]]){
        [Utility showAlertWithTitle:ALERT_TITLE message:PARSING_ERROR_MESSAGE];
    }
    else if ([result isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dict = (NSMutableDictionary *)result;
        if([[dict valueForKey:@"status"] integerValue]==1){
            User *mUser = [User new];
            mUser.token = [dict valueForKey:@"token"];
            mUser.user_email = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"Email"];
            mUser.user_Name = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"Name"];
            mUser.ID = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"id"];
            mUser.user_login_token = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"login_token"];
            mUser.user_membership_no = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"membership_no"];
            mUser.user_mobile = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"mobile"];
            mUser.user_password = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"password"];
            mUser.user_status = [[[dict valueForKey:@"data"] valueForKey:@"user"] valueForKey:@"status"];
            [Utility saveUserInfo:mUser];
            [Utility setUserLoginEnable:YES];
            DashboardViewController *mDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
            [self.navigationController pushViewController:mDashboardViewController animated:YES];
        }
        else if([[dict valueForKey:@"status"] integerValue]==0)
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            if ([Utility isNetworkAvailable]) {
                                                
                                                [self.view setUserInteractionEnabled:NO];
                                                [self->mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
                                                ServerConnection *mServerConnection = [[ServerConnection alloc] init];
                                                mServerConnection.delegate = self;
                                                [mServerConnection initLogin];
                                            }
                                            else
                                            {
                                                [self.view setUserInteractionEnabled:YES];
                                                [self->mSpinnerView hideFromView:self.view animated:YES];
                                                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please check internet connection of your Device" preferredStyle:UIAlertControllerStyleAlert];
                                                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                                                [alert addAction:defaultAction];
                                                [self presentViewController:alert animated:YES completion:nil];
                                            }
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:PARSING_ERROR_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            _txtfld_UserIDLogin.text = @"";
            _txtfld_PasswordLogin.text = @"";
        }
    }
}

-(void)forgot_password:(id)result
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
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if([[dict valueForKey:@"status"] integerValue]==0){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:PARSING_ERROR_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

//
//  ReviewPaymentDetailsViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 03/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "ReviewPaymentDetailsViewController.h"
#import "ReviewPaymentDetailsListCell.h"
#import "PaymentViewController.h"
#import "Constant.h"

@interface ReviewPaymentDetailsViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSString *payAmount;
    NSString *payName;
    NSString *payEmail;
    NSString *payMobile;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_ReviewPaymentDetails;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_PaymentDetails;

@end

@implementation ReviewPaymentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mSpinnerView = [[SpinnerView alloc] init];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utility isNetworkAvailable]) {
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection hdfc_form_mobile:mUser.token MembershipNo:mUser.user_membership_no Amount:_strAmount];
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
- (IBAction)click_backFromPaymentDetails:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)click_Submit:(UIButton *)sender{
    if ([Utility isNetworkAvailable]) {
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection insert_payment_hdfc_mobile:@"bill" MembershipNo:mUser.user_membership_no Amount:payAmount Name:payName Email:payEmail Phone:payMobile];
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

#pragma mark -  tableView Delagate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewPaymentDetailsListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ReviewPaymentDetailsListCell"];
    if (cell==nil)
    {
        cell =(ReviewPaymentDetailsListCell *)[[[NSBundle mainBundle] loadNibNamed:@"ReviewPaymentDetailsListCell" owner:self options:nil] objectAtIndex:0];
    }
    if (indexPath.row==0) {
        cell.lbl_DetailsHeader.text = @"Amount";
        cell.txtFld_Value.text = payAmount;
        cell.Vw_border.layer.borderWidth = 1.0;
        cell.Vw_border.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.Vw_border.layer.cornerRadius = 4.0;
        cell.btn_Submit.hidden = YES;
        cell.Vw_border.hidden = NO;
        cell.lbl_DetailsHeader.hidden = NO;
        cell.txtFld_Value.hidden = NO;
    }
    else if (indexPath.row==1) {
        cell.lbl_DetailsHeader.text = @"Name";
        cell.txtFld_Value.text = payName;
        cell.Vw_border.layer.borderWidth = 1.0;
        cell.Vw_border.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.Vw_border.layer.cornerRadius = 4.0;
        cell.btn_Submit.hidden = YES;
        cell.Vw_border.hidden = NO;
    }
    else if (indexPath.row==2) {
        cell.lbl_DetailsHeader.text = @"Email";
        cell.txtFld_Value.text = payEmail;
        cell.Vw_border.layer.borderWidth = 1.0;
        cell.Vw_border.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.Vw_border.layer.cornerRadius = 4.0;
        cell.btn_Submit.hidden = YES;
        cell.Vw_border.hidden = NO;
    }
    else if (indexPath.row==3) {
        cell.lbl_DetailsHeader.text = @"Mobile";
        cell.txtFld_Value.text = payMobile;
        cell.Vw_border.layer.borderWidth = 1.0;
        cell.Vw_border.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.Vw_border.layer.cornerRadius = 4.0;
        cell.btn_Submit.hidden = YES;
        cell.Vw_border.hidden = NO;
    }
    else{
        cell.btn_Submit.hidden = NO;
        cell.Vw_border.hidden = YES;
        [cell.btn_Submit addTarget:self action:@selector(click_Submit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)hdfc_form_mobile:(id)result{
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
            
            payAmount = [[dict valueForKey:@"data"] valueForKey:@"amount"];
            payName = [[dict valueForKey:@"data"] valueForKey:@"Name"];
            payEmail = [[dict valueForKey:@"data"] valueForKey:@"Email"];
            payMobile = [[dict valueForKey:@"data"] valueForKey:@"mobile"];
            _tblVw_PaymentDetails.hidden = NO;
            [_tblVw_PaymentDetails reloadData];
            _lbl_ReviewPaymentDetails.hidden = NO;
            
        }
        else if ([[dict valueForKey:@"status"] integerValue]==0){
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                        LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                        [self.navigationController pushViewController:mLoginViewController animated:NO];
                                    }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else{
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:PARSING_ERROR_MESSAGE
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                    LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                    [self.navigationController pushViewController:mLoginViewController animated:NO];
                                }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)insert_payment_hdfc_mobile:(id)result{
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
            PaymentViewController *mPaymentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
            mPaymentViewController.strHTML = [NSString stringWithFormat:@"%@",[dict valueForKey:@"html"]];
            [self.navigationController pushViewController:mPaymentViewController animated:NO];
        }
    }
    else{
    }
}

@end

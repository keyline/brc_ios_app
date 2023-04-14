//
//  PaymentDetailsViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 25/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "PaymentDetailsViewController.h"
#import "PaymentDetailsCell.h"
#import "Constant.h"

@interface PaymentDetailsViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrPaymentDetails;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_PaymentDetails;

@end

@implementation PaymentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    _tblVw_PaymentDetails.hidden = YES;
    arrPaymentDetails = [[NSMutableArray alloc] init];
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection my_payment_detail:mUser.token paymentID:_strPayID];
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

#pragma mark -  tableView Delagate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrPaymentDetails.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 635;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentDetailsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PaymentDetailsCell"];
    if (cell==nil)
    {
        cell =(PaymentDetailsCell *)[[[NSBundle mainBundle] loadNibNamed:@"PaymentDetailsCell" owner:self options:nil] objectAtIndex:0];
    }
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    cell.lbl_TransID_DetailsTop.text = [NSString stringWithFormat:@"%@",[[arrPaymentDetails valueForKey:@"bill_trans_ref_no"] objectAtIndex:indexPath.row]];
    cell.lbl_ReceiptNo_DetailsTop.text = [NSString stringWithFormat:@"%@",[[arrPaymentDetails valueForKey:@"id"] objectAtIndex:indexPath.row]];
    cell.lbl_ReceivedFrom_DetailsTop.text = mUser.user_Name;
    cell.lbl_MemberShipNo_DetailsTop.text = [NSString stringWithFormat:@"%@",[[arrPaymentDetails valueForKey:@"membership_no"] objectAtIndex:indexPath.row]];
    
    cell.lbl_Code_DetailsMIddle.text = [NSString stringWithFormat:@"%@",[[arrPaymentDetails valueForKey:@"membership_no"] objectAtIndex:indexPath.row]];
    cell.lbl_Name_DetailsMiddle.text = mUser.user_Name;
    cell.lbl_Credit_DetailsMiddle.text = [NSString stringWithFormat:@"%@",[[arrPaymentDetails valueForKey:@"amount"] objectAtIndex:indexPath.row]];
    cell.lbl_TotalCredit_DetailsMiddle.text = [NSString stringWithFormat:@"%@",[[arrPaymentDetails valueForKey:@"amount"] objectAtIndex:indexPath.row]];
    
    cell.lbl_Amount_DetailsBottom.text = [NSString stringWithFormat:@"%@",[[arrPaymentDetails valueForKey:@"amount"] objectAtIndex:indexPath.row]];
    cell.lbl_PaymentGateway.text = [NSString stringWithFormat:@"%@",[[arrPaymentDetails valueForKey:@"pg_name"] objectAtIndex:indexPath.row]];
    cell.lbl_PaymentDate.text = [NSString stringWithFormat:@"%@",[[arrPaymentDetails valueForKey:@"return_time"] objectAtIndex:indexPath.row]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click_BackPaymentDetails:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)my_payment_detail:(id)result{
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
            
            if([[[dict valueForKey:@"data"] valueForKey:@"is_my_booking_detail"] integerValue]==1){
                if([[dict valueForKey:@"data"] valueForKey:@"my_payment_detail"]!=nil){
                    if(arrPaymentDetails.count>0){
                        [arrPaymentDetails removeAllObjects];
                    }
                    [arrPaymentDetails addObject:[[dict valueForKey:@"data"] valueForKey:@"my_payment_detail"]];
                    _tblVw_PaymentDetails.hidden = NO;
                    [_tblVw_PaymentDetails reloadData];
                }
                else{
                }
            }
            else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
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
                                                                
                                                                // call method whatever u need
                                    LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                    [self.navigationController pushViewController:mLoginViewController animated:NO];
                                }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

//
//  MyOnlinePaymentViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 25/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "MyOnlinePaymentViewController.h"
#import "MyOnlinePaymentCell.h"
#import "PaymentDetailsViewController.h"
#import "Constant.h"

@interface MyOnlinePaymentViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrMyPaymentList;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_OnlinePayment;

@end

@implementation MyOnlinePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    
    arrMyPaymentList = [[NSMutableArray alloc] init];
    _tblVw_OnlinePayment.hidden = YES;
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection my_payment:mUser.token MembershipNo:mUser.user_membership_no];
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
    return arrMyPaymentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 248;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOnlinePaymentCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyOnlinePaymentCell"];
    if (cell==nil)
    {
        cell =(MyOnlinePaymentCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyOnlinePaymentCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.lbl_paymentGateway.text = [NSString stringWithFormat:@"%@",[[arrMyPaymentList valueForKey:@"pg_name"] objectAtIndex:indexPath.row]];
    cell.lbl_PayType.text = [NSString stringWithFormat:@"%@",[[arrMyPaymentList valueForKey:@"pay_type"] objectAtIndex:indexPath.row]];
    cell.lbl_BankTransID.text = [NSString stringWithFormat:@"%@",[[arrMyPaymentList valueForKey:@"bill_trans_ref_no"] objectAtIndex:indexPath.row]];
    cell.lbl_Amount.text = [NSString stringWithFormat:@"%@",[[arrMyPaymentList valueForKey:@"amount"] objectAtIndex:indexPath.row]];
    cell.lbl_TransDate.text = [NSString stringWithFormat:@"%@",[[arrMyPaymentList valueForKey:@"return_time"] objectAtIndex:indexPath.row]];
    cell.btn_View.tag = indexPath.row;
    [cell.btn_View addTarget:self action:@selector(click_View:) forControlEvents:UIControlEventTouchUpInside];
    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_OnlinePayment];
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
- (IBAction)click_BackOnlinePayment:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)click_View:(UIButton *)sender{
    NSLog(@"ID: %@", [NSString stringWithFormat:@"%@",[[arrMyPaymentList valueForKey:@"id"] objectAtIndex:sender.tag]]);
    PaymentDetailsViewController *mPaymentDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentDetailsViewController"];
    mPaymentDetailsViewController.strPayID = [NSString stringWithFormat:@"%@",[[arrMyPaymentList valueForKey:@"id"] objectAtIndex:sender.tag]];
    [self.navigationController pushViewController:mPaymentDetailsViewController animated:NO];
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)my_payment:(id)result{
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
            
            if([[[dict valueForKey:@"data"] valueForKey:@"is_my_booking"] integerValue]==1){
                if([[dict valueForKey:@"data"] valueForKey:@"my_payment_data"]!=nil){
                    if(arrMyPaymentList.count>0){
                        [arrMyPaymentList removeAllObjects];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"my_payment_data"] count]; i++) {
                        [arrMyPaymentList addObject:[[[dict valueForKey:@"data"] valueForKey:@"my_payment_data"] objectAtIndex:i]];
                    }
                    NSLog(@"Payment: %@",arrMyPaymentList);
                    _tblVw_OnlinePayment.hidden = NO;
                    [_tblVw_OnlinePayment reloadData];
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

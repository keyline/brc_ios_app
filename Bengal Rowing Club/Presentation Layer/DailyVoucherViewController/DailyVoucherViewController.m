//
//  DailyVoucherViewController.m
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 28/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "DailyVoucherViewController.h"
#import "PayMyBillViewController.h"
#import "DaillyVoucherListCell.h"
#import "DailyVoucherSubmitCell.h"
#import "Constant.h"

@interface DailyVoucherViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrDailyVoucherList;
    NSString *strTotalCredit;
    NSString *strTotalDebit;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_Voucher;

@end

@implementation DailyVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tblVw_Voucher.hidden = YES;
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    arrDailyVoucherList = [[NSMutableArray alloc] init];
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection getVoucherDetails:mUser.token MembershipNo:mUser.user_membership_no];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -  tableView Delagate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return [arrDailyVoucherList count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        return 119;
    }
    return 106;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        DaillyVoucherListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"DaillyVoucherListCell"];
        if (cell==nil)
        {
            cell =(DaillyVoucherListCell *)[[[NSBundle mainBundle] loadNibNamed:@"DaillyVoucherListCell" owner:self options:nil] objectAtIndex:0];
        }
        
        cell.lbl_VoucherNo.text = [[arrDailyVoucherList valueForKey:@"Voucherno"] objectAtIndex:indexPath.row];
        cell.lbl_VoucherDate.text = [[arrDailyVoucherList valueForKey:@"Date"] objectAtIndex:indexPath.row];
        cell.lbl_VoucherType.text = [[arrDailyVoucherList valueForKey:@"Creditdebit"] objectAtIndex:indexPath.row];
        cell.lbl_VoucherAmount.text = [[arrDailyVoucherList valueForKey:@"Amount"] objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        DailyVoucherSubmitCell *cell =[tableView dequeueReusableCellWithIdentifier:@"DailyVoucherSubmitCell"];
        if (cell==nil)
        {
            cell =(DailyVoucherSubmitCell *)[[[NSBundle mainBundle] loadNibNamed:@"DailyVoucherSubmitCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.lbl_TotalDebit.text = strTotalDebit;
        cell.lbl_TotalCredit.text = strTotalCredit;
        [cell.btn_makePayment addTarget:self action:@selector(click_MakePayment:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - BUTTON METHODS

- (IBAction)click_backVoucher:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)click_MakePayment:(id)sender{
    PayMyBillViewController *mPayMyBillViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMyBillViewController"];
    [self.navigationController pushViewController:mPayMyBillViewController animated:NO];
}


#pragma mark - SERVER CONNECTION DELEGATES

-(void)getVoucherDetails:(id)result{
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
            
            if([[dict valueForKey:@"data"] valueForKey:@"vouchers"]!=nil){
                //[_lbl_NoMsg setHidden:YES];
                for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"vouchers"] count]; i++) {
                    [arrDailyVoucherList addObject:[[[dict valueForKey:@"data"] valueForKey:@"vouchers"] objectAtIndex:i]];
                }
                strTotalCredit = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"data"] valueForKey:@"total_credit"]];
                strTotalDebit = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"data"] valueForKey:@"total_debit"]];
            }
            else{
                //[_lbl_NoMsg setHidden:NO];
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
            _tblVw_Voucher.hidden = NO;
            [_tblVw_Voucher reloadData];
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

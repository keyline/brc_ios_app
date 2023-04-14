//
//  PayMyBillViewController.m
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 28/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "PayMyBillViewController.h"
#import "DashboardViewController.h"
#import "ReviewPaymentDetailsViewController.h"
#import "PayMyBillCell.h"
#import "PaymentSumissionCell.h"
#import "Constant.h"

@interface PayMyBillViewController ()<ServerConnectionDelegate,UITextFieldDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrMyBillList;
    NSMutableArray* arrPaymentOptionList;
    NSString *strAmount;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_MyBill;
@property (strong, nonatomic) DownPicker *downPicker;

@end

@implementation PayMyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tblVw_MyBill.hidden = YES;
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    strAmount = @"";
    arrMyBillList = [[NSMutableArray alloc] init];
    arrPaymentOptionList = [[NSMutableArray alloc] init];
    
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection makePayment:mUser.token MembershipNo:mUser.user_membership_no];
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
        return [arrMyBillList count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        return 65;
    }
    return 192;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        PayMyBillCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PayMyBillCell"];
        if (cell==nil)
        {
            cell =(PayMyBillCell *)[[[NSBundle mainBundle] loadNibNamed:@"PayMyBillCell" owner:self options:nil] objectAtIndex:0];
        }
        
        cell.lbl_BillMonth.text = [NSString stringWithFormat:@"Month %@",[[arrMyBillList valueForKey:@"month_name"] objectAtIndex:indexPath.row]];
        cell.btn_billDetails.tag = indexPath.row;
        [cell.btn_billDetails addTarget:self action:@selector(click_ViewDetails:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        PaymentSumissionCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PaymentSumissionCell"];
        if (cell==nil)
        {
            cell =(PaymentSumissionCell *)[[[NSBundle mainBundle] loadNibNamed:@"PaymentSumissionCell" owner:self options:nil] objectAtIndex:0];
        }
        self.downPicker = [[DownPicker alloc] initWithTextField:cell.txtFld_PaymentOptions withData:arrPaymentOptionList];
        cell.txtFld_Amount.delegate = self;
        cell.txtFld_Amount.text = strAmount;
        cell.txtFld_Amount.tag = indexPath.row;
        cell.txtFld_Amount.keyboardType = UIKeyboardTypeNumberPad;
        cell.txtFld_Amount.layer.borderWidth = 1.0;
        cell.txtFld_Amount.layer.borderColor = [UIColor blackColor].CGColor;
        cell.txtFld_PaymentOptions.layer.borderWidth = 1.0;
        cell.txtFld_PaymentOptions.layer.borderColor = [UIColor blackColor].CGColor;
        [cell.btn_Submit addTarget:self action:@selector(click_SubmitPayment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_Cancel addTarget:self action:@selector(click_CancelPayment:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark - BUTTON METHODS

- (IBAction)click_backMyBill:(UIButton *)sender {
    DashboardViewController *mDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController pushViewController:mDashboardViewController animated:NO];
}

-(IBAction)click_ViewDetails:(UIButton *)sender{
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    NSString *strBill = [NSString stringWithFormat:@"%@%@/%@-%@bill.PDF",BILLDOWNLOADURL,[[arrMyBillList valueForKey:@"month_name"] objectAtIndex:sender.tag],mUser.user_membership_no,[[arrMyBillList valueForKey:@"month_name"] objectAtIndex:sender.tag]];
    NSLog(@"%@",strBill);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strBill] options:@{} completionHandler:nil];
}

-(IBAction)click_Done:(UIButton *)sender{
    [self moveDownViewFrame:50];
    NSIndexPath *sibling = [NSIndexPath indexPathForRow:0 inSection:1];
    PaymentSumissionCell *cell = [_tblVw_MyBill cellForRowAtIndexPath:sibling];
    strAmount = cell.txtFld_Amount.text;
    [cell.txtFld_Amount resignFirstResponder];
    [_tblVw_MyBill reloadData];
}

-(IBAction)click_Cancel:(UIButton *)sender{
    [self moveDownViewFrame:50];
    NSIndexPath *sibling = [NSIndexPath indexPathForRow:0 inSection:1];
    PaymentSumissionCell *cell = [_tblVw_MyBill cellForRowAtIndexPath:sibling];
    [cell.txtFld_Amount resignFirstResponder];
    [_tblVw_MyBill reloadData];
}

-(IBAction)click_SubmitPayment:(UIButton *)sender{
    if([DataValidation isNullString:self.downPicker.text]==YES){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select payment option"  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    
                                                    // call method whatever u need
                                                }];
                    [alert addAction:yesButton];
                    [self presentViewController:alert animated:YES completion:nil];
    }
    else if([DataValidation isNullString:strAmount]==YES){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select amount"  preferredStyle:UIAlertControllerStyleAlert];
                    
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
        ReviewPaymentDetailsViewController *mReviewPaymentDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewPaymentDetailsViewController"];
        mReviewPaymentDetailsViewController.strAmount = strAmount;
        [self.navigationController pushViewController:mReviewPaymentDetailsViewController animated:NO];
    }
}
-(IBAction)click_CancelPayment:(UIButton *)sender{
}

#pragma mark- UITextField Delegate -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%ld",(long)textField.tag);
    NSIndexPath *sibling = [NSIndexPath indexPathForRow:textField.tag inSection:1];
    PaymentSumissionCell *cell = [_tblVw_MyBill cellForRowAtIndexPath:sibling];
    if(textField==cell.txtFld_Amount){
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(click_Done:)];
        UIBarButtonItem *canceleBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(click_Cancel:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:canceleBtn,space,doneBtn, nil]];
        [cell.txtFld_Amount setInputAccessoryView:toolBar];
        [self moveUpViewFrame:50];
    }
}

#pragma mark - SELF METHODS

-(void)moveUpViewFrame:(NSInteger)_yOrigin//call at begin editing
{
    CGRect viewFrame = self.view.frame;//self.view.frame;
    if (viewFrame.origin.y>=0 )
    {
        viewFrame.origin.y -= _yOrigin;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:.5];
        //[self.view setFrame:viewFrame];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}


/********************************************//*!
* @brief This method is used to move down the view
***********************************************/

-(void)moveDownViewFrame:(NSInteger)_yOrigin//call at return
{
    CGRect viewFrame = self.view.frame;//self.view.frame;
    if (viewFrame.origin.y<0)
    {
        viewFrame.origin.y += _yOrigin;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:.5];
        //[self.view setFrame:viewFrame];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)makePayment:(id)result{
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
            
            if([[dict valueForKey:@"data"] valueForKey:@"bill_data"]!=nil){
                //[_lbl_NoMsg setHidden:YES];
                for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"bill_data"] count]; i++) {
                    [arrMyBillList addObject:[[[dict valueForKey:@"data"] valueForKey:@"bill_data"] objectAtIndex:i]];
                }
                [arrPaymentOptionList addObject:@"Pay using HDFC"];
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
            _tblVw_MyBill.hidden = NO;
            [_tblVw_MyBill reloadData];
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

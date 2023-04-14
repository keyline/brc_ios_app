//
//  MySportsBookingViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 25/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "MySportsBookingViewController.h"
#import "BadmintonCell.h"
#import "SportsCell.h"
#import "SquashWithMemberCell.h"
#import "Constant.h"

@interface MySportsBookingViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrMySportsBookingList;
    NSInteger index;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_SportsSlotBooking;

@end

@implementation MySportsBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    
    arrMySportsBookingList = [[NSMutableArray alloc] init];
    _tblVw_SportsSlotBooking.hidden = YES;
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection my_sports_booking:mUser.token MembershipNo:mUser.user_membership_no];
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
    return arrMySportsBookingList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[[arrMySportsBookingList valueForKey:@"no_of_members"] objectAtIndex:indexPath.row] isEqualToString:@"1"]){
        return 216;
    }
    else if([[[arrMySportsBookingList valueForKey:@"no_of_members"] objectAtIndex:indexPath.row] isEqualToString:@"2"]){
        return 244;
    }
    return 301;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[[arrMySportsBookingList valueForKey:@"no_of_members"] objectAtIndex:indexPath.row] isEqualToString:@"1"]){
        SportsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SportsCell"];
        if (cell==nil)
        {
            cell =(SportsCell *)[[[NSBundle mainBundle] loadNibNamed:@"SportsCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.lbl_SportsName.text = [NSString stringWithFormat:@"%@",[[arrMySportsBookingList valueForKey:@"sports_name"] objectAtIndex:indexPath.row]];
        cell.lbl_BookingDate.text = [NSString stringWithFormat:@"%@",[[arrMySportsBookingList valueForKey:@"booking_date"] objectAtIndex:indexPath.row]];
        cell.lbl_TimePeriod.text = [NSString stringWithFormat:@"%@",[[arrMySportsBookingList valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
        cell.lbl_Member1.text = [NSString stringWithFormat:@"%@-%@ %@ Inr",[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"Name"] objectAtIndex:0],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"membership_no"] objectAtIndex:0],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"amount"] objectAtIndex:0]];
        if([DataValidation isNullString:[[arrMySportsBookingList valueForKey:@"cancelled_by"] objectAtIndex:indexPath.row]]==YES){
            cell.btn_Cancel.userInteractionEnabled = YES;
            [cell.btn_Cancel setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:144.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [cell.btn_Cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.btn_Cancel.tag = indexPath.row;
            [cell.btn_Cancel addTarget:self action:@selector(click_Cancel:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else{
            cell.btn_Cancel.userInteractionEnabled = NO;
            [cell.btn_Cancel setBackgroundColor:[UIColor clearColor]];
            [cell.btn_Cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.btn_Cancel setTitle:@"Cancelled" forState:UIControlStateNormal];
        }
        
        [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_Back];
        return cell;
    }
    else if([[[arrMySportsBookingList valueForKey:@"no_of_members"] objectAtIndex:indexPath.row] isEqualToString:@"2"]){
        SquashWithMemberCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SquashWithMemberCell"];
        if (cell==nil)
        {
            cell =(SquashWithMemberCell *)[[[NSBundle mainBundle] loadNibNamed:@"SquashWithMemberCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.lbl_SportsName.text = [NSString stringWithFormat:@"%@",[[arrMySportsBookingList valueForKey:@"sports_name"] objectAtIndex:indexPath.row]];
        cell.lbl_BookingDate.text = [NSString stringWithFormat:@"%@",[[arrMySportsBookingList valueForKey:@"booking_date"] objectAtIndex:indexPath.row]];
        cell.lbl_TimePeriod.text = [NSString stringWithFormat:@"%@",[[arrMySportsBookingList valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
        cell.lbl_Member1.text = [NSString stringWithFormat:@"%@-%@ %@ Inr",[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"Name"] objectAtIndex:0],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"membership_no"] objectAtIndex:0],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"amount"] objectAtIndex:0]];
        cell.lbl_Member2.text = [NSString stringWithFormat:@"%@-%@ %@ Inr",[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"Name"] objectAtIndex:1],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"membership_no"] objectAtIndex:1],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"amount"] objectAtIndex:1]];
        if([DataValidation isNullString:[[arrMySportsBookingList valueForKey:@"cancelled_by"] objectAtIndex:indexPath.row]]==YES){
            cell.btn_Cancel.userInteractionEnabled = YES;
            [cell.btn_Cancel setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:144.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [cell.btn_Cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.btn_Cancel.tag = indexPath.row;
            [cell.btn_Cancel addTarget:self action:@selector(click_Cancel:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else{
            cell.btn_Cancel.userInteractionEnabled = NO;
            [cell.btn_Cancel setBackgroundColor:[UIColor clearColor]];
            [cell.btn_Cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.btn_Cancel setTitle:@"Cancelled" forState:UIControlStateNormal];
        }
        [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_Back];
        return cell;
    }
    else{
        BadmintonCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BadmintonCell"];
        if (cell==nil)
        {
            cell =(BadmintonCell *)[[[NSBundle mainBundle] loadNibNamed:@"BadmintonCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.lbl_SportsName.text = [NSString stringWithFormat:@"%@",[[arrMySportsBookingList valueForKey:@"sports_name"] objectAtIndex:indexPath.row]];
        cell.lbl_BookingDate.text = [NSString stringWithFormat:@"%@",[[arrMySportsBookingList valueForKey:@"booking_date"] objectAtIndex:indexPath.row]];
        cell.lbl_TimePeriod.text = [NSString stringWithFormat:@"%@",[[arrMySportsBookingList valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
        cell.lbl_Member1.text = [NSString stringWithFormat:@"%@-%@ %@ Inr",[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"Name"] objectAtIndex:0],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"membership_no"] objectAtIndex:0],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"amount"] objectAtIndex:0]];
        cell.lbl_Member2.text = [NSString stringWithFormat:@"%@-%@ %@ Inr",[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"Name"] objectAtIndex:1],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"membership_no"] objectAtIndex:1],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"amount"] objectAtIndex:1]];
        cell.lbl_Member3.text = [NSString stringWithFormat:@"%@-%@ %@ Inr",[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"Name"] objectAtIndex:2],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"membership_no"] objectAtIndex:2],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"amount"] objectAtIndex:2]];
        cell.lbl_Member4.text = [NSString stringWithFormat:@"%@-%@ %@ Inr",[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"Name"] objectAtIndex:3],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"membership_no"] objectAtIndex:3],[[[[arrMySportsBookingList valueForKey:@"member_details"] objectAtIndex:indexPath.row]valueForKey:@"amount"] objectAtIndex:3]];
        if([DataValidation isNullString:[[arrMySportsBookingList valueForKey:@"cancelled_by"] objectAtIndex:indexPath.row]]==YES){
            cell.btn_Cancel.userInteractionEnabled = YES;
            [cell.btn_Cancel setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:144.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [cell.btn_Cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.btn_Cancel.tag = indexPath.row;
            [cell.btn_Cancel addTarget:self action:@selector(click_Cancel:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else{
            cell.btn_Cancel.userInteractionEnabled = NO;
            [cell.btn_Cancel setBackgroundColor:[UIColor clearColor]];
            [cell.btn_Cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.btn_Cancel setTitle:@"Cancelled" forState:UIControlStateNormal];
        }
        [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_Back];
        return cell;
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

#pragma mark - BTTON METHODS

- (IBAction)click_BackSportsBooking:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)click_Cancel:(UIButton *)sender{
    if ([Utility isNetworkAvailable]) {
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        index = sender.tag;
        [mServerConnection cancel_sports_booking:mUser.token MembershipNo:mUser.user_membership_no BookingID:[[arrMySportsBookingList valueForKey:@"id"] objectAtIndex:sender.tag]];
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

#pragma mark - SERVER CONNECTION DELEGATES

-(void)my_sports_booking:(id)result{
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
                if([[dict valueForKey:@"data"] valueForKey:@"my_sports_booking"]!=nil){
                    if(arrMySportsBookingList.count>0){
                        [arrMySportsBookingList removeAllObjects];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"my_sports_booking"] count]; i++) {
                        [arrMySportsBookingList addObject:[[[dict valueForKey:@"data"] valueForKey:@"my_sports_booking"] objectAtIndex:i]];
                    }
                    NSLog(@"Sports Booking: %@",arrMySportsBookingList);
                    _tblVw_SportsSlotBooking.hidden = NO;
                    [_tblVw_SportsSlotBooking reloadData];
                }
                else{
                }
            }
            else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"No Sports Booking" preferredStyle:UIAlertControllerStyleAlert];
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

-(void)cancel_sports_booking:(id)result{
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
            
            if([[[dict valueForKey:@"data"] valueForKey:@"is_booking_cancel"] integerValue]==1){
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                NSMutableDictionary *dict = [arrMySportsBookingList[index] mutableCopy];
                [dict setObject:@"member" forKey:@"cancelled_by"];
                [arrMySportsBookingList replaceObjectAtIndex:index withObject:dict];
                [_tblVw_SportsSlotBooking reloadData];
            }
            else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            User *mUser = [User new];
            mUser.token = [dict valueForKey:@"token"];
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

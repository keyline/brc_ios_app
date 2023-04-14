//
//  EventDetailsViewController.m
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 26/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventBookingDetailsCell.h"
#import "Constant.h"

@interface EventDetailsViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrMyEventBookingDetailsList;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_EventDetails;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    
    arrMyEventBookingDetailsList = [[NSMutableArray alloc] init];
    _tblVw_EventDetails.hidden = YES;
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection my_event_booking_detail:mUser.token MembershipNo:mUser.user_membership_no EventBookingID:_strBookingID];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMyEventBookingDetailsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 279;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventBookingDetailsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EventBookingDetailsCell"];
    if (cell==nil)
    {
        cell =(EventBookingDetailsCell *)[[[NSBundle mainBundle] loadNibNamed:@"EventBookingDetailsCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.lbl_BookingID.text = [NSString stringWithFormat:@"%@",[[arrMyEventBookingDetailsList valueForKey:@"booking_id"] objectAtIndex:indexPath.row]];
    cell.lbl_EventName.text = [NSString stringWithFormat:@"%@",[[arrMyEventBookingDetailsList valueForKey:@"event_name"] objectAtIndex:indexPath.row]];
    cell.lbl_PassName.text = [NSString stringWithFormat:@"%@",[[arrMyEventBookingDetailsList valueForKey:@"ticket_name"] objectAtIndex:indexPath.row]];
    cell.lbl_PassNo.text = [NSString stringWithFormat:@"%@",[[arrMyEventBookingDetailsList valueForKey:@"ticket_id"] objectAtIndex:indexPath.row]];
    cell.lbl_NoOfPass.text = [NSString stringWithFormat:@"%@",[[arrMyEventBookingDetailsList valueForKey:@"ticket_number"] objectAtIndex:indexPath.row]];
    cell.lbl_Amount.text = [NSString stringWithFormat:@"%@",[[arrMyEventBookingDetailsList valueForKey:@"amount"] objectAtIndex:indexPath.row]];
    cell.lbl_BookingDate.text = [NSString stringWithFormat:@"%@",[[arrMyEventBookingDetailsList valueForKey:@"booking_date"] objectAtIndex:indexPath.row]];
    
    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
    return cell;
}

- (IBAction)click_backDetails:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)my_event_booking_detail:(id)result{
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
            
            if([[[dict valueForKey:@"data"] valueForKey:@"is_my_event_ticket_booking"] integerValue]==1){
                if([[dict valueForKey:@"data"] valueForKey:@"my_event_ticket_booking"]!=nil){
                    if(arrMyEventBookingDetailsList.count>0){
                        [arrMyEventBookingDetailsList removeAllObjects];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"my_event_ticket_booking"] count]; i++) {
                        [arrMyEventBookingDetailsList addObject:[[[dict valueForKey:@"data"] valueForKey:@"my_event_ticket_booking"] objectAtIndex:i]];
                    }
                    NSLog(@"Event Details Booking: %@",arrMyEventBookingDetailsList);
                    _tblVw_EventDetails.hidden = NO;
                    [_tblVw_EventDetails reloadData];
                }
                else{
                }
            }
            else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"No Event Booking" preferredStyle:UIAlertControllerStyleAlert];
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

//
//  MyHomeDeliveryViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 01/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "MyHomeDeliveryViewController.h"
#import "HomeDeliveryDetailsViewController.h"
#import "MyHomeDeliveryCell.h"
#import "Constant.h"

@interface MyHomeDeliveryViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrMyHomeBookingList;
    NSInteger index;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_HomeDelivery;

@end

@implementation MyHomeDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super viewWillAppear:animated];
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    
    arrMyHomeBookingList = [[NSMutableArray alloc] init];
    _tblVw_HomeDelivery.hidden = YES;
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection my_food_booking:mUser.token MembershipNo:mUser.user_membership_no];
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
    return arrMyHomeBookingList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 234;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyHomeDeliveryCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyHomeDeliveryCell"];
    if (cell==nil)
    {
        cell =(MyHomeDeliveryCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyHomeDeliveryCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.lbl_OrderID.text = [NSString stringWithFormat:@"%@",[[arrMyHomeBookingList valueForKey:@"id"] objectAtIndex:indexPath.row]];
    if([[NSString stringWithFormat:@"%@",[[arrMyHomeBookingList valueForKey:@"delivery_type"] objectAtIndex:indexPath.row]] isEqualToString:@"1"]){
        cell.lbl_DeliveryType.text = @"Take Away";
    }else{
        cell.lbl_DeliveryType.text = @"Home Delivery";
    }
    cell.lbl_OrderDate.text = [NSString stringWithFormat:@"%@",[[arrMyHomeBookingList valueForKey:@"booking_date"] objectAtIndex:indexPath.row]];
    cell.lbl_PreferedTime.text = [NSString stringWithFormat:@"%@",[[arrMyHomeBookingList valueForKey:@"prefered_time"] objectAtIndex:indexPath.row]];
    if([[NSString stringWithFormat:@"%@",[[arrMyHomeBookingList valueForKey:@"process_KOT"] objectAtIndex:indexPath.row]] isEqualToString:@"1"]){
        cell.lbl_Status.text = @"Processed";
    }else{
        cell.lbl_Status.text = @"Not Processed Yet";
    }
    cell.lbl_SubmittedDate.text = [NSString stringWithFormat:@"%@",[[arrMyHomeBookingList valueForKey:@"submited_date"] objectAtIndex:indexPath.row]];
    [cell.btn_ViewDetails addTarget:self action:@selector(click_Details:) forControlEvents:UIControlEventTouchUpInside];
    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
    return cell;
}

#pragma mark - BUTTON METHODS

- (IBAction)click_backHomeDelivery:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)click_Details:(UIButton *)sender{
    HomeDeliveryDetailsViewController *mHomeDeliveryDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDeliveryDetailsViewController"];
    mHomeDeliveryDetailsViewController.strFoodBookingID = [NSString stringWithFormat:@"%@",[[arrMyHomeBookingList valueForKey:@"id"] objectAtIndex:sender.tag]];
    [self.navigationController pushViewController:mHomeDeliveryDetailsViewController animated:NO];
}

#pragma mark - SERVER DELEGATES

-(void)my_food_booking:(id)result{
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
                if([[dict valueForKey:@"data"] valueForKey:@"my_food_booking"]!=nil){
                    if(arrMyHomeBookingList.count>0){
                        [arrMyHomeBookingList removeAllObjects];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"my_food_booking"] count]; i++) {
                        [arrMyHomeBookingList addObject:[[[dict valueForKey:@"data"] valueForKey:@"my_food_booking"] objectAtIndex:i]];
                    }
                    NSLog(@"Food Booking: %@",arrMyHomeBookingList);
                    _tblVw_HomeDelivery.hidden = NO;
                    [_tblVw_HomeDelivery reloadData];
                }
                else{
                }
            }
            else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"No Banquet Booking" preferredStyle:UIAlertControllerStyleAlert];
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

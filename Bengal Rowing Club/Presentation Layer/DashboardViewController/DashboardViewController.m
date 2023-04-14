//
//  DashboardViewController.m
//  Tolly Tee off
//
//  Created by Chakraborty, Sayan on 25/08/17.
//  Copyright © 2017 Chakraborty, Sayan. All rights reserved.
//

#import "DashboardViewController.h"
#import "LoginViewController.h"
#import "ContactUSViewController.h"
#import "NotificationViewController.h"
#import "EventPassesViewController.h"
#import "ChangePasswordViewController.h"
#import "PayMyBillViewController.h"
#import "DailyVoucherViewController.h"
#import "BanquetViewController.h"
#import "ConferenceViewController.h"
#import "TableBookingViewController.h"
#import "SportsSlotBookingViewController.h"
#import "MyBookingsViewController.h"
#import "PDRBookingViewControllers.h"
#import "FoodDeviveryViewController.h"
#import "DashboardCell.h"
#import "Constant.h"

@interface DashboardViewController (){
    NSMutableArray *arrListMenuItem;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_Logo;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_Dashboard;


@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _imgVw_Logo.layer.cornerRadius = _imgVw_Logo.frame.size.height/2;
    arrListMenuItem = [[NSMutableArray alloc] initWithObjects:@"Table Booking",@"PDR Booking",@"Banquet Booking",@"Conference Room Booking",@"Sports Slot Booking",@"Pay My Bill",@"Event Passes",@"Home Delivery",@"Daily Voucher",@"My Bookings/Online Payments",@"Contact Us",@"Notification",@"Change Password",@"Logout", nil];
}

#pragma mark -  tableView Delagate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrListMenuItem count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DashboardCell *cell =[tableView dequeueReusableCellWithIdentifier:@"DashboardCell"];
    if (cell==nil)
    {
        cell =(DashboardCell *)[[[NSBundle mainBundle] loadNibNamed:@"DashboardCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.lbl_MenuName.text = [arrListMenuItem objectAtIndex:indexPath.row];
    if([cell.lbl_MenuName.text isEqualToString:@"Table Booking"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"table_booking"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"PDR Booking"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"pdr_booking"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Banquet Booking"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"banquet_booking"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Conference Room Booking"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"conference_room"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Sports Slot Booking"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"sports_slot_booking"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Pay My Bill"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"pay_my_bill"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Event Passes"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"event_passes"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Home Delivery"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"home_delivery"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Daily Voucher"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"daily_voucher"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"My Bookings/Online Payments"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"my_bookings"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Contact Us"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"contact_us"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Notification"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"notification"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Change Password"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"change_password"];
    }
    else if([cell.lbl_MenuName.text isEqualToString:@"Logout"]){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"logout"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        TableBookingViewController *mTableBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableBookingViewController"];
        [self.navigationController pushViewController:mTableBookingViewController animated:NO];
    }
    else if(indexPath.row==1){
        PDRBookingViewControllers *mPDRBookingViewControllers = [self.storyboard instantiateViewControllerWithIdentifier:@"PDRBookingViewControllers"];
        [self.navigationController pushViewController:mPDRBookingViewControllers animated:NO];
    }
    else if(indexPath.row==2){
        BanquetViewController *mBanquetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BanquetViewController"];
        [self.navigationController pushViewController:mBanquetViewController animated:NO];
    }
    else if(indexPath.row==3){
        ConferenceViewController *mConferenceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConferenceViewController"];
        [self.navigationController pushViewController:mConferenceViewController animated:NO];
    }
    else if(indexPath.row==4){
        SportsSlotBookingViewController *mSportsSlotBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SportsSlotBookingViewController"];
        [self.navigationController pushViewController:mSportsSlotBookingViewController animated:NO];
    }
    else if(indexPath.row==5){
        PayMyBillViewController *mPayMyBillViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PayMyBillViewController"];
        [self.navigationController pushViewController:mPayMyBillViewController animated:NO];
    }
    else if(indexPath.row==6){
        EventPassesViewController *mEventPassesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventPassesViewController"];
        [self.navigationController pushViewController:mEventPassesViewController animated:NO];
    }
    else if(indexPath.row==7){
        FoodDeviveryViewController *mFoodDeviveryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodDeviveryViewController"];
        [self.navigationController pushViewController:mFoodDeviveryViewController animated:NO];
    }
    else if(indexPath.row==8){
        DailyVoucherViewController *mDailyVoucherViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DailyVoucherViewController"];
        [self.navigationController pushViewController:mDailyVoucherViewController animated:NO];
    }
    else if(indexPath.row==9){
        MyBookingsViewController *mMyBookingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyBookingsViewController"];
        [self.navigationController pushViewController:mMyBookingsViewController animated:NO];
    }
    else if(indexPath.row==10){
        ContactUSViewController *mContactUSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUSViewController"];
        [self.navigationController pushViewController:mContactUSViewController animated:NO];
    }
    else if(indexPath.row==11){
        NotificationViewController *mNotificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        [self.navigationController pushViewController:mNotificationViewController animated:NO];
    }
    else if(indexPath.row==12){
        ChangePasswordViewController *mChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
        [self.navigationController pushViewController:mChangePasswordViewController animated:NO];
    }
    else if(indexPath.row==13){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Do you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [Utility setUserLoginEnable:NO];
                                        [Utility removeUserInfo];
                                        LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                        [self.navigationController pushViewController:mLoginViewController animated:NO];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No"
                                style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
        {
            
        }];
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

//
//  MyBookingsViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 24/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "MyBookingsViewController.h"
#import "MyOnlinePaymentViewController.h"
#import "MySportsBookingViewController.h"
#import "MyTableBookingViewController.h"
#import "MyEventBookingViewContoller.h"
#import "MyBanquestBookingViewController.h"
#import "MyConferenceBookingViewController.h"
#import "MyPDRBookingViewController.h"
#import "MyHomeDeliveryViewController.h"
#import "MyWaitingTableBookingViewController.h"
#import "DashboardCell.h"

@interface MyBookingsViewController (){
    NSMutableArray *arrMyBookingList;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_MyBooking;

@end

@implementation MyBookingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrMyBookingList = [[NSMutableArray alloc] initWithObjects:@"My Table Bookings",@"Table Waiting List",@"My PDR Bookings",@"My Banquet Bookings",@"My Conference Room Bookings",@"My Event Bookings",@"My Home Delivery Orders",@"My Sports Slot Bookings",@"My Online Payments", nil];
    //@"Table Waiting List",@"My Committee Files",
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMyBookingList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DashboardCell *cell =[tableView dequeueReusableCellWithIdentifier:@"DashboardCell"];
    if (cell==nil)
    {
        cell =(DashboardCell *)[[[NSBundle mainBundle] loadNibNamed:@"DashboardCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.lbl_MenuName.text = [arrMyBookingList objectAtIndex:indexPath.row];
    if(indexPath.row==0){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"table_booking"];
    }
    else if(indexPath.row==1){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"table_booking"];
    }
    else if(indexPath.row==2){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"pdr_booking"];
    }
    else if(indexPath.row==3){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"banquet_booking"];
    }
    else if(indexPath.row==4){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"conference_room"];
    }
    else if(indexPath.row==5){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"event_passes"];
    }
    else if(indexPath.row==6){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"home_delivery"];
    }
    else if(indexPath.row==7){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"sports_slot_booking"];
    }
    else if(indexPath.row==8){
        cell.imgVw_Menu.image = [UIImage imageNamed:@"pay_my_bill"];
    }
//    else if(indexPath.row==9){
//        cell.imgVw_Menu.image = [UIImage imageNamed:@"sports_slot_booking"];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        MyTableBookingViewController *mMyTableBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTableBookingViewController"];
        [self.navigationController pushViewController:mMyTableBookingViewController animated:NO];
    }
    else if(indexPath.row==1){
        MyWaitingTableBookingViewController *mMyWaitingTableBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWaitingTableBookingViewController"];
        [self.navigationController pushViewController:mMyWaitingTableBookingViewController animated:NO];
    }
    else if(indexPath.row==2){
        MyPDRBookingViewController *mMyPDRBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPDRBookingViewController"];
        [self.navigationController pushViewController:mMyPDRBookingViewController animated:NO];
    }
    else if(indexPath.row==3){
        MyBanquestBookingViewController *mMyBanquestBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyBanquestBookingViewController"];
        [self.navigationController pushViewController:mMyBanquestBookingViewController animated:NO];
    }
    else if(indexPath.row==4){
        MyConferenceBookingViewController *mMyConferenceBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyConferenceBookingViewController"];
        [self.navigationController pushViewController:mMyConferenceBookingViewController animated:NO];
    }
    else if(indexPath.row==5){
        MyEventBookingViewContoller *mMyEventBookingViewContoller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyEventBookingViewContoller"];
        [self.navigationController pushViewController:mMyEventBookingViewContoller animated:NO];
    }
    else if(indexPath.row==6){
        MyHomeDeliveryViewController *mMyHomeDeliveryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyHomeDeliveryViewController"];
        [self.navigationController pushViewController:mMyHomeDeliveryViewController animated:NO];
    }
    else if(indexPath.row==7){
        MySportsBookingViewController *mMySportsBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MySportsBookingViewController"];
        [self.navigationController pushViewController:mMySportsBookingViewController animated:NO];
    }
    else if(indexPath.row==8){
        MyOnlinePaymentViewController *mMyOnlinePaymentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOnlinePaymentViewController"];
        [self.navigationController pushViewController:mMyOnlinePaymentViewController animated:NO];
    }
//    else if(indexPath.row==9){
//
//    }
}

- (IBAction)click_backMyBookings:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end

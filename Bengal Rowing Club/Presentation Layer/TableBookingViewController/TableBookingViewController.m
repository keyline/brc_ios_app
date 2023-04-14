//
//  TableBookingViewController.m
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 05/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "TableBookingViewController.h"
#import "TableBookingUpperCell.h"
#import "AvailableTableCell.h"
#import "WaitingTableBookingCell.h"
#import "TableBookingBottomCell.h"
#import "TableCheckAvailabilityViewController.h"
#import "DashboardViewController.h"
#import "MembersListCell.h"
#import "Constant.h"

@interface TableBookingViewController ()<ServerConnectionDelegate,SelectDropDownDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray* arrTableList;
    NSMutableArray *arrAvailableTimeSlots;
    NSMutableArray *arrWaitingListTimeSlots;
    NSMutableArray *arrayOfSelectedBoolValues;
    NSString *strDinnigID;
    NSString *strTimeSlotID;
    NSString *strPaxValue;
    NSMutableArray *arrPax;
}
@property (weak, nonatomic) IBOutlet UIView *vw_SelectDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_SelectDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_SelectDinning;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerDate;
@property (strong, nonatomic) DownPicker *downPicker;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_TableBooking;
@property (weak, nonatomic) IBOutlet UIView *vw_Dining;
@property (weak, nonatomic) IBOutlet UIView *vw_SelectPax;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_SelectPax;
@end

@implementation TableBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
    [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:_vw_SelectDate];
    [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:_vw_Dining];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    _txtFld_SelectDate.text = @"";
    _txtFld_SelectDinning.text = @"Select Dinning Area";
    strPaxValue = @"Select Pax";
    arrTableList = [[NSMutableArray alloc] init];
    arrAvailableTimeSlots = [[NSMutableArray alloc] init];
    arrWaitingListTimeSlots = [[NSMutableArray alloc] init];
    arrayOfSelectedBoolValues = [[NSMutableArray alloc] init];
    arrPax = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    _tblVw_TableBooking.hidden = YES;
    if ([Utility isNetworkAvailable]) {
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection table:mUser.token];
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
    if(tableView==_tblVw_TableBooking){
        return 4;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_tblVw_TableBooking){
        if(section==0){
            return 1;
        }
        else if(section==1){
            return [arrWaitingListTimeSlots count];
        }
        else if(section==2){
            return [arrAvailableTimeSlots count];
        }
        return 1;
    }
    
    return arrPax.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==_tblVw_TableBooking){
        if (indexPath.section==0){
            return 44;
        }
        else if(indexPath.section==1){
            return 150;
        }
        else if(indexPath.section==2){
            return 70;
        }
        return 44;
    }
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==_tblVw_TableBooking){
        if(indexPath.section==0){
            TableBookingUpperCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TableBookingUpperCell"];
            if (cell==nil)
            {
                cell =(TableBookingUpperCell *)[[[NSBundle mainBundle] loadNibNamed:@"TableBookingUpperCell" owner:self options:nil] objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if(indexPath.section==1){
            WaitingTableBookingCell *cell =[tableView dequeueReusableCellWithIdentifier:@"WaitingTableBookingCell"];
            if (cell==nil)
            {
                cell =(WaitingTableBookingCell *)[[[NSBundle mainBundle] loadNibNamed:@"WaitingTableBookingCell" owner:self options:nil] objectAtIndex:0];
            }
            [cell.imgVw_WaitingList sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BANQUET_BOOKING_IMAGEURL,[[arrWaitingListTimeSlots objectAtIndex:indexPath.row]valueForKey:@"image"]]]
            placeholderImage:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (error) {
                           cell.imgVw_WaitingList.image = [UIImage imageNamed:@"default_image.jpg"];
                       }
                       else{
                           [cell.imgVw_WaitingList setImage:image];
                       }
                   }];
            cell.lbl_WaitingName.text = [NSString stringWithFormat:@"%@",[[arrWaitingListTimeSlots valueForKey:@"timeslot_name"] objectAtIndex:indexPath.row]];
            cell.lbl_TimeWaiting.text = [NSString stringWithFormat:@"%@",[[arrWaitingListTimeSlots valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
            [cell.btn_Pax setTitle:strPaxValue forState:UIControlStateNormal];
            [cell.btn_Pax addTarget:self action:@selector(click_SelectPax:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_WaitingList.tag = indexPath.row;
            [cell.btn_WaitingList addTarget:self action:@selector(click_SubmitWaitingList:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if(indexPath.section==2){
            AvailableTableCell *cell =[tableView dequeueReusableCellWithIdentifier:@"AvailableTableCell"];
            if (cell==nil)
            {
                cell =(AvailableTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"AvailableTableCell" owner:self options:nil] objectAtIndex:0];
            }
            [cell.imgVw_Available sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BANQUET_BOOKING_IMAGEURL,[[arrAvailableTimeSlots objectAtIndex:indexPath.row]valueForKey:@"image"]]]
            placeholderImage:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (error) {
                           cell.imgVw_Available.image = [UIImage imageNamed:@"default_image.jpg"];
                       }
                       else{
                           [cell.imgVw_Available setImage:image];
                       }
                   }];
            cell.lbl_nameAvailable.text = [NSString stringWithFormat:@"%@",[[arrAvailableTimeSlots valueForKey:@"timeslot_name"] objectAtIndex:indexPath.row]];
            cell.lbl_TimeAvailable.text = [NSString stringWithFormat:@"%@",[[arrAvailableTimeSlots valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
            if(![[arrayOfSelectedBoolValues objectAtIndex:indexPath.row] boolValue]){
                cell.vw_Available.backgroundColor = [UIColor blackColor];
            }
            else{
                cell.vw_Available.backgroundColor = [UIColor systemGreenColor];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            TableBookingBottomCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TableBookingBottomCell"];
            if (cell==nil)
            {
                cell =(TableBookingBottomCell *)[[[NSBundle mainBundle] loadNibNamed:@"TableBookingBottomCell" owner:self options:nil] objectAtIndex:0];
            }
            [cell.btn_CheckAvailabilty addTarget:self action:@selector(click_CheckAvailability:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else{
        MembersListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MembersListCell"];
        if (cell==nil)
        {
            cell =(MembersListCell *)[[[NSBundle mainBundle] loadNibNamed:@"MembersListCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.lbl_MemberName.text = [NSString stringWithFormat:@"%@",[arrPax objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblVw_TableBooking) {
        //Change the selected background view of the cell.
        if(indexPath.section==2){
            for (int i = 0; i < [arrAvailableTimeSlots count]; i++)
            {
               [arrayOfSelectedBoolValues replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            }

            [arrayOfSelectedBoolValues replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
            strTimeSlotID = [[arrAvailableTimeSlots valueForKey:@"id"] objectAtIndex:indexPath.row];
            [self.tblVw_TableBooking reloadData];
        }
    }
    else{
        strPaxValue = [arrPax objectAtIndex:indexPath.row];
        _vw_SelectPax.hidden = YES;
        NSIndexSet *section = [NSIndexSet indexSetWithIndex:1];
        [_tblVw_TableBooking reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - TEXTFIELD DELEGATES

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _txtFld_SelectDate.inputView = _datePickerDate;
    _datePickerDate.hidden = NO;
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateCancel:)];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateDone:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,doneBtn, nil]];
    [_txtFld_SelectDate setInputAccessoryView:toolBar];
}

#pragma mark - BUTTON METHODS

- (IBAction)click_backTable:(UIButton *)sender {
    DashboardViewController *mDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController pushViewController:mDashboardViewController animated:NO];
}

-(IBAction)click_btnDateCancel:(UIButton *)sender{
    [_txtFld_SelectDate resignFirstResponder];
    _datePickerDate.hidden = YES;
}

-(IBAction)click_btnDateDone:(UIButton *)sender{
    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString =  [dateFormatterYear stringFromDate:_datePickerDate.date];
    _txtFld_SelectDate.text = dateString;
    [_txtFld_SelectDate resignFirstResponder];
    _datePickerDate.hidden = YES;
    [self tableByDate];
}

-(IBAction)click_SelectPax:(UIButton *)sender{
    _vw_SelectPax.hidden = NO;
    [self.tblVw_SelectPax reloadData];
}
-(IBAction)click_SubmitWaitingList:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if([strPaxValue isEqualToString:@"Select Pax"]==YES){
        [Utility showAlertWithTitle:ALERT_TITLE message:@"Please Select pax value"];
    }
    else if ([Utility isNetworkAvailable]) {
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection insert_table_booking_waitng:mUser.token DinningID:strDinnigID BookingDate:_txtFld_SelectDate.text TimeSlot:[[arrWaitingListTimeSlots valueForKey:@"id"] objectAtIndex:sender.tag] Pax:@"4" MemberID:mUser.user_membership_no];
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

-(IBAction)click_CheckAvailability:(UIButton *)sender{
    if([DataValidation isNullString:strTimeSlotID]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select time slot " preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        if ([Utility isNetworkAvailable]) {
            User *mUser = [User new];
            mUser = [Utility getUserInfo];
            [self.view setUserInteractionEnabled:NO];
            [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
            ServerConnection *mServerConnection = [[ServerConnection alloc] init];
            mServerConnection.delegate = self;
            [mServerConnection checkTableTimeslotNow:mUser.token BookingDate:_txtFld_SelectDate.text TimeSlot:strTimeSlotID];
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
}
- (IBAction)click_CancelSelectPax:(UIButton *)sender {
    _vw_SelectPax.hidden = YES;
    NSIndexSet *section = [NSIndexSet indexSetWithIndex:1];
    [_tblVw_TableBooking reloadSections:section withRowAnimation:UITableViewRowAnimationNone]; 
}



#pragma mark - SELF METHODS

-(void)tableByDate{
    if ([Utility isNetworkAvailable]) {
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection getTableByDate:mUser.token BookingDate:_txtFld_SelectDate.text];
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

-(void)timeSlotsForTable{
    if ([Utility isNetworkAvailable]) {
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection getTableTimeSlots:mUser.token DinningID:strDinnigID BookingDate:_txtFld_SelectDate.text];
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

-(void)tableFromDinning{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         strDinnigID, @"dining_areas_id",
                         _txtFld_SelectDate.text, @"booking_date",
                         strTimeSlotID, @"timeslot_id",
                         nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection getTableFromDining:jsonString];
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

#pragma mark - CUSTOM DELEGATE

-(void)dp_Selected {
    //[self timeSlots];
    for (int i = 0; i<[arrTableList count]; i++) {
        if([[self.downPicker text] isEqualToString:[NSString stringWithFormat:@"%@",[[arrTableList valueForKey:@"name"] objectAtIndex:i]]]){
            strDinnigID = [NSString stringWithFormat:@"%@",[[arrTableList valueForKey:@"dining_id"] objectAtIndex:i]];
            break;
        }
    }
    [self timeSlotsForTable];
}
-(void)selectedString:(NSString *)value Type:(NSString *)type{
    strPaxValue = value;
    [_tblVw_TableBooking reloadData];
}


#pragma mark - SERVER CONNECTION DELEGATES

-(void)getTableByDate:(id)result{
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
                
                if([[[dict valueForKey:@"data"] valueForKey:@"dining_tables"] count]>0){
                    if(arrTableList.count>0){
                        [arrTableList removeAllObjects];
                        [arrWaitingListTimeSlots removeAllObjects];
                        [arrAvailableTimeSlots removeAllObjects];
                        [arrayOfSelectedBoolValues removeAllObjects];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"dining_tables"] count]; i++) {
                        [arrTableList addObject:[[[dict valueForKey:@"data"] valueForKey:@"dining_tables"] objectAtIndex:i]];
                    }
                    _tblVw_TableBooking.hidden = YES;
                    _txtFld_SelectDinning.text = @"Select Dinning Area";
                    self.downPicker = [[DownPicker alloc] initWithTextField:_txtFld_SelectDinning withData:[arrTableList valueForKey:@"name"]];
                    _downPicker.delegate = self;
                }
                else{
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }
            else if ([[dict valueForKey:@"status"] integerValue]==0){
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                [self.navigationController popViewControllerAnimated:NO];
                                        }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else{
            NSMutableDictionary *dict = (NSMutableDictionary *)result;
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                                     [self.navigationController popViewControllerAnimated:NO];
                                    }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
}

-(void)table:(id)result{
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
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                
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
            NSMutableDictionary *dict = (NSMutableDictionary *)result;
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]]
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

-(void)getTableTimeSlots:(id)result{
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
            if([[dict valueForKey:@"is_timeslot"] integerValue]==1){
                if([[dict valueForKey:@"data"] valueForKey:@"timeslots"]!=nil){
                    if(arrWaitingListTimeSlots.count>0){
                        [arrWaitingListTimeSlots removeAllObjects];
                        [arrAvailableTimeSlots removeAllObjects];
                        [arrayOfSelectedBoolValues removeAllObjects];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"timeslots"] count]; i++) {
                        if([[[[[dict valueForKey:@"data"] valueForKey:@"timeslots"] objectAtIndex:i] valueForKey:@"available"] isEqualToString:@"not_available"]){
                            [arrWaitingListTimeSlots addObject:[[[dict valueForKey:@"data"] valueForKey:@"timeslots"] objectAtIndex:i]];
                        }
                        else{
                            [arrAvailableTimeSlots addObject:[[[dict valueForKey:@"data"] valueForKey:@"timeslots"] objectAtIndex:i]];
                        }
                    }
                    NSLog(@"Waiting: %@",arrWaitingListTimeSlots);
                    NSLog(@"Available: %@",arrAvailableTimeSlots);
                    
                    for (int i = 0; i < [arrAvailableTimeSlots count]; i++)
                    {
                        [arrayOfSelectedBoolValues addObject:[NSNumber numberWithBool:NO]];
                    }
                }
                else{
                }
                _tblVw_TableBooking.hidden = NO;
                [_tblVw_TableBooking reloadData];
            }
            else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else if ([[dict valueForKey:@"status"] integerValue]==0){
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                        
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
                                }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)insert_table_booking_waitng:(id)result
{
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
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                        
                                    }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if ([[dict valueForKey:@"status"] integerValue]==0){
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                        
                                    }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else{
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Waiting  list facility is currently unavailable !!"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)checkTableTimeslotNow:(id)result
{
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
            [self tableFromDinning];
        }
        else if ([[dict valueForKey:@"status"] integerValue]==0){
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                        
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
                                }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)getTableFromDining:(id)result{
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
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (int i = 1; i<=[[[dict valueForKey:@"data"] valueForKey:@"dining_table_data"] count]; i++) {
                NSDictionary *dic = [[[dict valueForKey:@"data"] valueForKey:@"dining_table_data"] valueForKey:[NSString stringWithFormat:@"%d",i]];
                if([[[[[dict valueForKey:@"data"] valueForKey:@"dining_table_data"] valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"available"] isEqualToString:@"not_available"]){
                    [dic setValue:@"" forKey:@"table_select"];
                }
                else{
                    [dic setValue:@"NO" forKey:@"table_select"];
                }
                [arr addObject:[[[dict valueForKey:@"data"] valueForKey:@"dining_table_data"] valueForKey:[NSString stringWithFormat:@"%d",i]]];
            }
        
            TableCheckAvailabilityViewController *mTableCheckAvailabilityViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableCheckAvailabilityViewController"];
            mTableCheckAvailabilityViewController.arrCheckList = arr;
            mTableCheckAvailabilityViewController.strDinnigAreaID = [[dict valueForKey:@"data"] valueForKey:@"id"];
            mTableCheckAvailabilityViewController.strTimeSlotID = strTimeSlotID;
            mTableCheckAvailabilityViewController.strBookingDate = _txtFld_SelectDate.text;
            mTableCheckAvailabilityViewController.strTableName = _txtFld_SelectDinning.text;
            [self.navigationController pushViewController:mTableCheckAvailabilityViewController animated:NO];
        }
        else if ([[dict valueForKey:@"status"] integerValue]==0){
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                        
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
                                }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

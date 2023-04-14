//
//  FoodMenuSubmitViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 09/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "FoodMenuSubmitViewController.h"
#import "ThankYouFoodBooking.h"
#import "FoodNoteListCell.h"
#import "FoodTimeCell.h"
#import "FoodDeliveyAddressCell.h"
#import "FoodTextCell.h"
#import "FoodSubmitCell.h"
#import "Constant.h"

@interface FoodMenuSubmitViewController ()<SelectDropDownDelegate,UITextFieldDelegate,ServerConnectionDelegate>{
    NSString *strNote;
    NSMutableArray* arrDeliveryTypeList;
    NSString *strMobile;
    NSString *strOtherAddress;
    NSString *strPreferredTime;
    NSString *strRemarks;
    NSString *strTick;
    SpinnerView *mSpinnerView;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_foodSubmission;
@property (strong, nonatomic) DownPicker *downPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerTime;
@end

@implementation FoodMenuSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
    strMobile = @"";
    strOtherAddress = @"";
    strPreferredTime = @"";
    strRemarks = @"";
    strTick = @"NO";
    arrDeliveryTypeList  = [[NSMutableArray alloc] initWithObjects:@"Home",@"Office",@"Others", nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSDate *date = [dateFormatter dateFromString:_strBookingDate];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:date];
    if([comp weekday]==1 || [comp weekday]==7){
        if([_strTimeSlotName isEqualToString:@"Dinner"]){
            strNote = [NSString stringWithFormat:@"1. 20 MINUTES FOR RAWA AND UDIPI DOSA\n2. FOOD ONCE ORDERD CANNOT BE CANCELLED\n3. NOG STANDS FOR NO ONION NO GARLIC.\n4. LAST ORDER FOR LUNCH AT 02 P.M. SHARP.\n5. LAST ORDER FOR DINNER AT 10 P.M. SHARP."];
        }
        else if([_strTimeSlotName isEqualToString:@"Lunch"]){
            strNote = [NSString stringWithFormat:@"1. 20 MINUTES FOR RAWA AND UDIPI DOSA\n2. FOOD ONCE ORDERD CANNOT BE CANCELLED\n3. NOG STANDS FOR NO ONION NO GARLIC.\n4. LAST ORDER FOR LUNCH AT 02 P.M. SHARP.\n5. LAST ORDER FOR DINNER AT 10 P.M. SHARP."];
        }
        else if([_strTimeSlotName isEqualToString:@"Breakfast"]){
            strNote = [NSString stringWithFormat:@"1. Delivery Will Starts from 9 am.\n2. Last Order at 10 am.\n3. NOG Stands for No Onion & Garlic\n4. Order Once given cannot be cancelled."];
        }
        else{
            strNote = @"";
        }
    }
    else{
        if([_strTimeSlotName isEqualToString:@"Dinner"]){
            strNote = [NSString stringWithFormat:@"1. NOG Stands for No Onion & Garlic\n2. Food will get deliver after 8:30 pm only\n3. Last Oder Time is 10 p.m. Only.\n4. Food once ordered cannot be cancelled"];
        }
        else{
            strNote = @"";
        }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(![strNote isEqualToString:@""]){
        return 3;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(![strNote isEqualToString:@""]){
        if([self.downPicker.text isEqualToString:@"Others"]){
            if(section==0){
                return 1;
            }
            else if(section==1){
                return 5;
            }
            else if(section==2){
                return 1;
            }
        }
        else{
            if(section==0){
                return 1;
            }
            else if(section==1){
                return 4;
            }
            else if(section==2){
                return 1;
            }
        }
    }
    else{
        if([self.downPicker.text isEqualToString:@"Others"]){
            if(section==0){
                return 5;
            }
            else if(section==1){
                return 1;
            }
        }
        else{
            if(section==0){
                return 4;
            }
            else if(section==1){
                return 1;
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![strNote isEqualToString:@""]){
        if (indexPath.section==0) {
            return UITableViewAutomaticDimension;
        }
        else if (indexPath.section==1) {
            return 44;
        }
        else if (indexPath.section==2) {
            return 160;
        }
    }
    else{
        if (indexPath.section==0) {
            return 44;
        }
        else if (indexPath.section==1) {
            return 160;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![strNote isEqualToString:@""]){
        if (indexPath.section==0) {
            return 73;
        }
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![strNote isEqualToString:@""]){
        if([self.downPicker.text isEqualToString:@"Others"]){
            if(indexPath.section==0){
                FoodNoteListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodNoteListCell"];
                if (cell==nil)
                {
                    cell =(FoodNoteListCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodNoteListCell" owner:self options:nil] objectAtIndex:0];
                }
                cell.lbl_Note.text = strNote;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if(indexPath.section==1){
                if(indexPath.row==0){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Enter Mobile Number";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1024;
                    cell.txtFld_FoodText.text = strMobile;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==1){
                    FoodDeliveyAddressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodDeliveyAddressCell"];
                    if (cell==nil)
                    {
                        cell =(FoodDeliveyAddressCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodDeliveyAddressCell" owner:self options:nil] objectAtIndex:0];
                    }
                    self.downPicker = [[DownPicker alloc] initWithTextField:cell.txtFld_FoodDeliveryAddress withData:arrDeliveryTypeList];
                    _downPicker.delegate = self;
                    cell.txtFld_FoodDeliveryAddress.placeholder = @"Select Type";
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==2){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Enter Other Address";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1025;
                    cell.txtFld_FoodText.text = strOtherAddress;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==3){
                    FoodTimeCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTimeCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTimeCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTimeCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodTime.placeholder = @"Select Preferred Timing";
                    cell.txtFld_FoodTime.delegate = self;
                    cell.txtFld_FoodTime.tag = 1026;
                    cell.txtFld_FoodTime.text = strPreferredTime;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==4){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Remarks";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1027;
                    cell.txtFld_FoodText.text = strRemarks;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            else if(indexPath.section==2){
                FoodSubmitCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodSubmitCell"];
                if (cell==nil)
                {
                    cell =(FoodSubmitCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodSubmitCell" owner:self options:nil] objectAtIndex:0];
                }
                [cell.btn_HomeDelivary addTarget:self action:@selector(click_HomeDelivery:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_TakeAway addTarget:self action:@selector(click_TakeAway:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_Tick addTarget:self action:@selector(click_Accept:) forControlEvents:UIControlEventTouchUpInside];
                if([strTick isEqualToString:@"YES"]){
                    [cell.btn_Tick setImage:[UIImage imageNamed:@"tick_black.png"] forState:UIControlStateNormal];
                }
                else{
                    [cell.btn_Tick setImage:[UIImage imageNamed:@"untick_black.png"] forState:UIControlStateNormal];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else{
            if(indexPath.section==0){
                FoodNoteListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodNoteListCell"];
                if (cell==nil)
                {
                    cell =(FoodNoteListCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodNoteListCell" owner:self options:nil] objectAtIndex:0];
                }
                cell.lbl_Note.text = strNote;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if(indexPath.section==1){
                if(indexPath.row==0){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Enter Mobile Number";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1024;
                    cell.txtFld_FoodText.text = strMobile;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==1){
                    FoodDeliveyAddressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodDeliveyAddressCell"];
                    if (cell==nil)
                    {
                        cell =(FoodDeliveyAddressCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodDeliveyAddressCell" owner:self options:nil] objectAtIndex:0];
                    }
                    self.downPicker = [[DownPicker alloc] initWithTextField:cell.txtFld_FoodDeliveryAddress withData:arrDeliveryTypeList];
                    _downPicker.delegate = self;
                    cell.txtFld_FoodDeliveryAddress.placeholder = @"Select Type";
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==2){
                    FoodTimeCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTimeCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTimeCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTimeCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodTime.placeholder = @"Select Preferred Timing";
                    cell.txtFld_FoodTime.delegate = self;
                    cell.txtFld_FoodTime.tag = 1026;
                    cell.txtFld_FoodTime.text = strPreferredTime;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==3){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Remarks";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1027;
                    cell.txtFld_FoodText.text = strRemarks;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            else if(indexPath.section==2){
                FoodSubmitCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodSubmitCell"];
                if (cell==nil)
                {
                    cell =(FoodSubmitCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodSubmitCell" owner:self options:nil] objectAtIndex:0];
                }
                [cell.btn_HomeDelivary addTarget:self action:@selector(click_HomeDelivery:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_TakeAway addTarget:self action:@selector(click_TakeAway:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_Tick addTarget:self action:@selector(click_Accept:) forControlEvents:UIControlEventTouchUpInside];
                if([strTick isEqualToString:@"YES"]){
                    [cell.btn_Tick setImage:[UIImage imageNamed:@"tick_black.png"] forState:UIControlStateNormal];
                }
                else{
                    [cell.btn_Tick setImage:[UIImage imageNamed:@"untick_black.png"] forState:UIControlStateNormal];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    else{
        if([self.downPicker.text isEqualToString:@"Others"]){
            if (indexPath.section==0) {
                if(indexPath.row==0){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Enter Mobile Number";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1024;
                    cell.txtFld_FoodText.text = strMobile;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==1){
                    FoodDeliveyAddressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodDeliveyAddressCell"];
                    if (cell==nil)
                    {
                        cell =(FoodDeliveyAddressCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodDeliveyAddressCell" owner:self options:nil] objectAtIndex:0];
                    }
                    self.downPicker = [[DownPicker alloc] initWithTextField:cell.txtFld_FoodDeliveryAddress withData:arrDeliveryTypeList];
                    _downPicker.delegate = self;
                    cell.txtFld_FoodDeliveryAddress.placeholder = @"Select Type";
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==2){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Enter Other Address";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1025;
                    cell.txtFld_FoodText.text = strOtherAddress;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==3){
                    FoodTimeCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTimeCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTimeCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTimeCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodTime.placeholder = @"Select Preferred Timing";
                    cell.txtFld_FoodTime.delegate = self;
                    cell.txtFld_FoodTime.tag = 1026;
                    cell.txtFld_FoodTime.text = strPreferredTime;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==4){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Remarks";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1027;
                    cell.txtFld_FoodText.text = strRemarks;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            else if(indexPath.section==1){
                FoodSubmitCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodSubmitCell"];
                if (cell==nil)
                {
                    cell =(FoodSubmitCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodSubmitCell" owner:self options:nil] objectAtIndex:0];
                }
                [cell.btn_HomeDelivary addTarget:self action:@selector(click_HomeDelivery:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_TakeAway addTarget:self action:@selector(click_TakeAway:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_Tick addTarget:self action:@selector(click_Accept:) forControlEvents:UIControlEventTouchUpInside];
                if([strTick isEqualToString:@"YES"]){
                    [cell.btn_Tick setImage:[UIImage imageNamed:@"tick_black.png"] forState:UIControlStateNormal];
                }
                else{
                    [cell.btn_Tick setImage:[UIImage imageNamed:@"untick_black.png"] forState:UIControlStateNormal];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else{
            if(indexPath.section==0){
                if(indexPath.row==0){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Enter Mobile Number";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1024;
                    cell.txtFld_FoodText.text = strMobile;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==1){
                    FoodDeliveyAddressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodDeliveyAddressCell"];
                    if (cell==nil)
                    {
                        cell =(FoodDeliveyAddressCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodDeliveyAddressCell" owner:self options:nil] objectAtIndex:0];
                    }
                    self.downPicker = [[DownPicker alloc] initWithTextField:cell.txtFld_FoodDeliveryAddress withData:arrDeliveryTypeList];
                    _downPicker.delegate = self;
                    cell.txtFld_FoodDeliveryAddress.placeholder = @"Select Type";
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==2){
                    FoodTimeCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTimeCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTimeCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTimeCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodTime.placeholder = @"Select Preferred Timing";
                    cell.txtFld_FoodTime.delegate = self;
                    cell.txtFld_FoodTime.tag = 1026;
                    cell.txtFld_FoodTime.text = strPreferredTime;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.row==3){
                    FoodTextCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodTextCell"];
                    if (cell==nil)
                    {
                        cell =(FoodTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodTextCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.txtFld_FoodText.placeholder = @"Remarks";
                    cell.txtFld_FoodText.delegate = self;
                    cell.txtFld_FoodText.tag = 1027;
                    cell.txtFld_FoodText.text = strRemarks;
                    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_back];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            else if(indexPath.section==1){
                FoodSubmitCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodSubmitCell"];
                if (cell==nil)
                {
                    cell =(FoodSubmitCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodSubmitCell" owner:self options:nil] objectAtIndex:0];
                }
                [cell.btn_HomeDelivary addTarget:self action:@selector(click_HomeDelivery:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_TakeAway addTarget:self action:@selector(click_TakeAway:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_Tick addTarget:self action:@selector(click_Accept:) forControlEvents:UIControlEventTouchUpInside];
                if([strTick isEqualToString:@"YES"]){
                    [cell.btn_Tick setImage:[UIImage imageNamed:@"tick_black.png"] forState:UIControlStateNormal];
                }
                else{
                    [cell.btn_Tick setImage:[UIImage imageNamed:@"untick_black.png"] forState:UIControlStateNormal];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    return nil;
}

#pragma mark - TEXTFIELD DELEGATES

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(![strNote isEqualToString:@""]){
        if([self.downPicker.text isEqualToString:@"Others"]){
            if(textField.tag == 1024){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:0 inSection:1];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strMobile = textField.text;
                [textField resignFirstResponder];
            }
            else if(textField.tag == 1025){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:3 inSection:1];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strOtherAddress = textField.text;//cell.txtFld_FoodTime.text;
                [textField resignFirstResponder];
            }
            else if(textField.tag == 1027){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:4 inSection:1];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strRemarks = textField.text;//cell.txtFld_FoodTime.text;
                [textField resignFirstResponder];
            }
        }
        else{
            if(textField.tag == 1024){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:0 inSection:1];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strMobile = textField.text;//cell.txtFld_FoodTime.text;
                [textField resignFirstResponder];
            }
            else if(textField.tag == 1027){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:3 inSection:1];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strRemarks = textField.text;//cell.txtFld_FoodTime.text;
                [textField resignFirstResponder];
            }
        }
    }
    else{
        if([self.downPicker.text isEqualToString:@"Others"]){
            if(textField.tag == 1024){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:0 inSection:0];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strMobile = textField.text;//cell.txtFld_FoodTime.text;
                [textField resignFirstResponder];
            }
            else if(textField.tag == 1025){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:3 inSection:0];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strOtherAddress = textField.text;//cell.txtFld_FoodTime.text;
                [textField resignFirstResponder];
            }
            else if(textField.tag == 1027){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:4 inSection:0];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strRemarks = textField.text;//cell.txtFld_FoodTime.text;
                [textField resignFirstResponder];
            }
        }
        else{
            if(textField.tag == 1024){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:0 inSection:0];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strMobile = textField.text;//cell.txtFld_FoodTime.text;
                [textField resignFirstResponder];
            }
            else if(textField.tag == 1027){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:3 inSection:0];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                strRemarks = textField.text;//cell.txtFld_FoodTime.text;
                [textField resignFirstResponder];
            }
        }
    }
    [_tblVw_foodSubmission reloadData];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(![strNote isEqualToString:@""]){
        if([self.downPicker.text isEqualToString:@"Others"]){
            if(textField.tag == 1026){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:3 inSection:1];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                cell.txtFld_FoodTime.inputView = _datePickerTime;
                _datePickerTime.hidden = NO;
                UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                [toolBar setTintColor:[UIColor grayColor]];
                UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateCancel:)];
                UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateDone:)];
                UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,doneBtn, nil]];
                [cell.txtFld_FoodTime setInputAccessoryView:toolBar];
            }
        }
        else{
            if(textField.tag == 1026){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:2 inSection:1];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                cell.txtFld_FoodTime.inputView = _datePickerTime;
                _datePickerTime.hidden = NO;
                UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                [toolBar setTintColor:[UIColor grayColor]];
                UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateCancel:)];
                UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateDone:)];
                UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,doneBtn, nil]];
                [cell.txtFld_FoodTime setInputAccessoryView:toolBar];
            }
        }
        
    }
    else{
        if([self.downPicker.text isEqualToString:@"Others"]){
            if(textField.tag == 1026){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:3 inSection:0];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                //NSIndexPath *indexPath = [_tblVw_foodSubmission indexPathForCell:cell];
                cell.txtFld_FoodTime.inputView = _datePickerTime;
                _datePickerTime.hidden = NO;
                
                UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                [toolBar setTintColor:[UIColor grayColor]];
                UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateCancel:)];
                UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateDone:)];
                UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,doneBtn, nil]];
                [cell.txtFld_FoodTime setInputAccessoryView:toolBar];
            }
        }
        else{
            if(textField.tag == 1026){
                NSIndexPath *sibling = [NSIndexPath indexPathForRow:2 inSection:0];
                FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
                //NSIndexPath *indexPath = [_tblVw_foodSubmission indexPathForCell:cell];
                cell.txtFld_FoodTime.inputView = _datePickerTime;
                _datePickerTime.hidden = NO;
                
                UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                [toolBar setTintColor:[UIColor grayColor]];
                UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateCancel:)];
                UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(click_btnDateDone:)];
                UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,space,doneBtn, nil]];
                [cell.txtFld_FoodTime setInputAccessoryView:toolBar];
            }
        }
    }
}

#pragma mark - CUSTOM DELEGATE
-(void)dp_Selected {
    if(![self.downPicker.text isEqualToString:@"Others"]){
        strOtherAddress = @"";
    }
    [_tblVw_foodSubmission reloadData];
}

#pragma mark - BUTTON METHODS

- (IBAction)click_back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)click_btnDateCancel:(UIButton *)sender{
    //[_txtFld_SelectDate resignFirstResponder];
    if(![strNote isEqualToString:@""]){
        NSIndexPath *sibling = [NSIndexPath indexPathForRow:2 inSection:1];
        FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
        [cell.txtFld_FoodTime resignFirstResponder];
    }
    else{
        NSIndexPath *sibling = [NSIndexPath indexPathForRow:2 inSection:0];
        FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
        [cell.txtFld_FoodTime resignFirstResponder];
    }
    _datePickerTime.hidden = YES;
}

-(IBAction)click_btnDateDone:(UIButton *)sender{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    strPreferredTime = [dateFormatter stringFromDate:_datePickerTime.date];
    NSLog(@"%@", strPreferredTime);
    if(![strNote isEqualToString:@""]){
        if([self.downPicker.text isEqualToString:@"Others"]){
            NSIndexPath *sibling = [NSIndexPath indexPathForRow:3 inSection:1];
            FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
            [cell.txtFld_FoodTime resignFirstResponder];
        }
        else{
            NSIndexPath *sibling = [NSIndexPath indexPathForRow:2 inSection:1];
            FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
            [cell.txtFld_FoodTime resignFirstResponder];
        }
        
    }
    else{
        if([self.downPicker.text isEqualToString:@"Others"]){
            NSIndexPath *sibling = [NSIndexPath indexPathForRow:3 inSection:0];
            FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
            [cell.txtFld_FoodTime resignFirstResponder];
        }
        else{
            NSIndexPath *sibling = [NSIndexPath indexPathForRow:2 inSection:0];
            FoodTimeCell *cell = [_tblVw_foodSubmission cellForRowAtIndexPath:sibling];
            [cell.txtFld_FoodTime resignFirstResponder];
        }
    }
    _datePickerTime.hidden = YES;
    [_tblVw_foodSubmission reloadData];
}

- (IBAction)click_Accept:(UIButton *)sender {
    if(![sender isSelected]){
        [sender setSelected:YES];
        strTick = @"YES";
    }
    else{
        [sender setSelected:NO];
        strTick = @"NO";
    }
    [_tblVw_foodSubmission reloadData];
}

- (IBAction)click_HomeDelivery:(UIButton *)sender {
    if([DataValidation isNullString:strMobile]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please enter mobile no" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([DataValidation isNullString:self.downPicker.text]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select type" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([self.downPicker.text isEqualToString:@"Others"] && [DataValidation isNullString:strOtherAddress]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please enter address" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([DataValidation isNullString:strPreferredTime]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select preferresd time" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([DataValidation isNullString:strRemarks]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please enter your remarks" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([strTick isEqualToString:@"NO"]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please accept terms and conditions" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        NSLog(@"HOME DELIVERY");
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        
        NSDictionary *dicFood = [NSDictionary dictionaryWithObjectsAndKeys:_arrItemDetails,@"item_dtls", nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             mUser.user_membership_no, @"member_id",
                             strPreferredTime, @"prefered_time",
                             strRemarks, @"remarks",
                             strMobile, @"mobile",
                             self.downPicker.text, @"delivery_at",
                             strOtherAddress, @"other_address",
                             @"2", @"delivery_type",
                             _strBookingDate,@"booking_date",
                             _strTimeSlotID, @"timeslot_id",
                             dicFood, @"food_data",
                              nil];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        if ([Utility isNetworkAvailable]) {
            
            [self.view setUserInteractionEnabled:NO];
            [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
            ServerConnection *mServerConnection = [[ServerConnection alloc] init];
            mServerConnection.delegate = self;
            [mServerConnection insert_food_item_booking:jsonString];
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

- (IBAction)click_TakeAway:(UIButton *)sender {
    if([DataValidation isNullString:strMobile]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please enter mobile no" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([DataValidation isNullString:self.downPicker.text]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select type" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([self.downPicker.text isEqualToString:@"Others"] && [DataValidation isNullString:strOtherAddress]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please enter address" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([DataValidation isNullString:strPreferredTime]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select preferresd time" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([DataValidation isNullString:strRemarks]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please enter your remarks" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([strTick isEqualToString:@"NO"]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please accept terms and conditions" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        NSLog(@"TAKE AWAY");
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        
        NSDictionary *dicFood = [NSDictionary dictionaryWithObjectsAndKeys:_arrItemDetails,@"item_dtls", nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             mUser.user_membership_no, @"member_id",
                             strPreferredTime, @"prefered_time",
                             strRemarks, @"remarks",
                             strMobile, @"mobile",
                             self.downPicker.text, @"delivery_at",
                             strOtherAddress, @"other_address",
                             @"1", @"delivery_type",
                             _strBookingDate,@"booking_date",
                             _strTimeSlotID, @"timeslot_id",
                             dicFood, @"food_data",
                              nil];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        if ([Utility isNetworkAvailable]) {
            
            [self.view setUserInteractionEnabled:NO];
            [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
            ServerConnection *mServerConnection = [[ServerConnection alloc] init];
            mServerConnection.delegate = self;
            [mServerConnection insert_food_item_booking:jsonString];
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

#pragma mark - SERVER CONNECTION DELEGATE

-(void)insert_food_item_booking:(id)result{
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
            ThankYouFoodBooking *mThankYouFoodBooking = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouFoodBooking"];
            mThankYouFoodBooking.strThankYouMsg = [NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]];
            [self.navigationController pushViewController:mThankYouFoodBooking animated:NO];
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

//
//  SportsSlotBookingViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 12/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "SportsSlotBookingViewController.h"
#import "ChooseMemberCell.h"
#import "SelectSlot.h"
#import "SportsSlotCell.h"
#import "BookNowCell.h"
#import "MembersListCell.h"
#import "NIDropDown.h"
#import "Constant.h"

@interface SportsSlotBookingViewController ()<ServerConnectionDelegate,SelectDropDownDelegate,NIDropDownDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray* arrSportsList;
    NSMutableArray *arrTimeSlots;
    NSMutableArray *arrMembersList;
    NSMutableArray *arrSquashType;
    NSString *strSportsID;
    NSString *strMember2Name;
    NSString *strMember3Name;
    NSString *strMember4Name;
    NSString *strID2;
    NSString *strID3;
    NSString *strID4;
    NSString *strSearchText;
    NSInteger memberTag;
    NSString *strTimeSlotID;
    BOOL isSquashTypeCoach;
    NIDropDown *dropDown;
    NSString *strSquashTypeID;
    NSString *strTick;
}
@property (weak, nonatomic) IBOutlet UIView *vw_SelectDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_SelectDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_SelectSports;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerDate;
@property (strong, nonatomic) DownPicker *downPicker;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_Sports;
@property (weak, nonatomic) IBOutlet UIView *vw_Sports;
@property (weak, nonatomic) IBOutlet UIView *vw_Squash;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Squash;
@property (weak, nonatomic) IBOutlet UIButton *btn_Squash;

@property (weak, nonatomic) IBOutlet UIView *vw_Search;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HeaderCustomSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_CustomSearch;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_search;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutConstraint_TableTop;

@end

@implementation SportsSlotBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
    [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:_vw_SelectDate];
    [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:_vw_Sports];
    [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:_vw_Squash];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    strTick = @"NO";
    isSquashTypeCoach = NO;
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    arrSportsList = [[NSMutableArray alloc] init];
    arrTimeSlots = [[NSMutableArray alloc] init];
    arrMembersList = [[NSMutableArray alloc] init];
    arrSquashType = [[NSMutableArray alloc] init];
    _tblVw_Sports.hidden = YES;
    _vw_Search.hidden = YES;
    _lbl_HeaderCustomSearch.text = @"Members List";
    [_btn_Squash setTitle:@"Select Squash" forState:UIControlStateNormal];
    [_txtFld_search addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if ([Utility isNetworkAvailable]) {
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection sports_booking:mUser.token];
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

#pragma mark - TEXTFIELD DELEGATES

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _txtFld_SelectDate){
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
}
-(void)textFieldDidChange:(UITextField*)textField
{
    if(textField == _txtFld_search){
        strSearchText = textField.text;
        [self searchValue];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _txtFld_search){
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - BUTTON METHODS

- (IBAction)click_btnBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)click_Check:(UIButton *)sender {
    if(![sender isSelected]){
        [sender setSelected:YES];
        strTick = @"YES";
    }
    else{
        [sender setSelected:NO];
        strTick = @"NO";
    }
    [_tblVw_Sports reloadData];
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
    //[self timeSlots];
}

-(IBAction)click_selectMember:(UIButton *)sender{
    memberTag = sender.tag;
    [self searchValue];
}

- (IBAction)click_CancelSearch:(UIButton *)sender {
    _txtFld_search.text = @"";
    strSearchText = @"";
    [_txtFld_search resignFirstResponder];
    _vw_Search.hidden = YES;
}

-(IBAction)click_BookSports:(UIButton *)sender{
    if([self.downPicker.text isEqualToString:@"Badminton"]){
        if([strMember2Name isEqualToString:@"Choose Member 2..."] || [strMember3Name isEqualToString:@"Choose Member 3..."] || [strMember4Name isEqualToString:@"Choose Member 4..."]){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please choose members" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if([DataValidation isNullString:strTimeSlotID]==YES){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select time slot " preferredStyle:UIAlertControllerStyleAlert];
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
            User *mUser = [User new];
            mUser = [Utility getUserInfo];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
            strSportsID, @"sports_id",
            strTimeSlotID, @"timeslot_id",
            mUser.user_membership_no, @"member_id",
            _txtFld_SelectDate.text, @"book_date",
            @"7", @"type",
            strMember2Name, @"member2",
            strMember3Name, @"member3",
            strMember4Name, @"member4",
            nil];
           
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonString);
            if ([Utility isNetworkAvailable]) {
                
                [self.view setUserInteractionEnabled:NO];
                [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
                ServerConnection *mServerConnection = [[ServerConnection alloc] init];
                mServerConnection.delegate = self;
                [mServerConnection insert_sports_booking:jsonString];
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
    else if([self.downPicker.text isEqualToString:@"Pool"] || [self.downPicker.text isEqualToString:@"Billiard And Snooker"]){
        if([DataValidation isNullString:strTimeSlotID]==YES){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select time slot " preferredStyle:UIAlertControllerStyleAlert];
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
            User *mUser = [User new];
            mUser = [Utility getUserInfo];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
            strSportsID, @"sports_id",
            strTimeSlotID, @"timeslot_id",
            mUser.user_membership_no, @"member_id",
            _txtFld_SelectDate.text, @"book_date",
            @"7", @"type",
            nil];
           
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonString);
            if ([Utility isNetworkAvailable]) {
                
                [self.view setUserInteractionEnabled:NO];
                [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
                ServerConnection *mServerConnection = [[ServerConnection alloc] init];
                mServerConnection.delegate = self;
                [mServerConnection insert_sports_booking:jsonString];
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
    else{
        if([strSquashTypeID isEqualToString:@"1"] || [strSquashTypeID isEqualToString:@"3"] || [strSquashTypeID isEqualToString:@"4"]){
            if([DataValidation isNullString:strTimeSlotID]==YES){
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select time slot " preferredStyle:UIAlertControllerStyleAlert];
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
                User *mUser = [User new];
                mUser = [Utility getUserInfo];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                strSportsID, @"sports_id",
                strTimeSlotID, @"timeslot_id",
                mUser.user_membership_no, @"member_id",
                _txtFld_SelectDate.text, @"book_date",
                @"7", @"type",
                strSquashTypeID, @"squash_type",
                nil];
               
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@",jsonString);
                if ([Utility isNetworkAvailable]) {
                    
                    [self.view setUserInteractionEnabled:NO];
                    [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
                    ServerConnection *mServerConnection = [[ServerConnection alloc] init];
                    mServerConnection.delegate = self;
                    [mServerConnection insert_sports_booking:jsonString];
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
        else{
            if([strMember2Name isEqualToString:@"Choose Member 2..."]){
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please choose member" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if([DataValidation isNullString:strTimeSlotID]==YES){
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select time slot " preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else{
                User *mUser = [User new];
                mUser = [Utility getUserInfo];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                strSportsID, @"sports_id",
                strTimeSlotID, @"timeslot_id",
                mUser.user_membership_no, @"member_id",
                _txtFld_SelectDate.text, @"book_date",
                @"7", @"type",
                strSquashTypeID, @"squash_type",
                strMember2Name, @"member_squash",
                nil];
               
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@",jsonString);
                if ([Utility isNetworkAvailable]) {
                    
                    [self.view setUserInteractionEnabled:NO];
                    [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
                    ServerConnection *mServerConnection = [[ServerConnection alloc] init];
                    mServerConnection.delegate = self;
                    [mServerConnection insert_sports_booking:jsonString];
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
    }
}
- (IBAction)click_btnSquash:(UIButton *)sender {
    NSMutableArray *arrName = [[NSMutableArray alloc] init];
    for (int i = 0; i<[arrSquashType count]; i++) {
        [arrName addObject:[[arrSquashType valueForKey:@"name"] objectAtIndex:i]];
    }
    if(dropDown==nil){
        CGFloat heightDropDown = 120;
        dropDown = [[NIDropDown alloc] showDropDown:sender buttonHeight:&heightDropDown nameList:arrName imageList:nil openDirection:@"down"xPosition:_vw_Squash.frame.origin.x yPosition:_vw_Squash.frame.origin.y];//165
        
        dropDown.delegate = self;
        dropDown.userInteractionEnabled=YES;
        [self.view addSubview:dropDown];   // may be missing this line
    }
    else {
        [dropDown hideDropDown:sender xPosition:_vw_Squash.frame.origin.x yPosition:_vw_Squash.frame.origin.y];
        [self rel];
    }
}


#pragma mark -  tableView Delagate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==_tblVw_Sports){
        if([self.downPicker.text isEqualToString:@"Badminton"]){
            return 4;
        }
        else if([self.downPicker.text isEqualToString:@"Pool"] || [self.downPicker.text isEqualToString:@"Billiard And Snooker"]){
            return 3;
        }
        else{
            if([strSquashTypeID isEqualToString:@"1"] || [strSquashTypeID isEqualToString:@"3"] || [strSquashTypeID isEqualToString:@"4"]){
                return 3;
            }
            return 4;
        }
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_tblVw_Sports){
        if([self.downPicker.text isEqualToString:@"Badminton"]){
            if(section==0){
                return 0;  //removed Choose member. previously 3
            }
            else if(section==1){
                return 1;
            }
            else if(section==2){
                return [arrTimeSlots count];
            }
            return 1;
        }
        else if([self.downPicker.text isEqualToString:@"Pool"] || [self.downPicker.text isEqualToString:@"Billiard And Snooker"]){
            if(section==0){
                return 1;
            }
            else if(section==1){
                return [arrTimeSlots count];;
            }
            else{
                return 1;
            }
        }
        else{
            if([strSquashTypeID isEqualToString:@"1"] || [strSquashTypeID isEqualToString:@"3"] || [strSquashTypeID isEqualToString:@"4"]){
                if(section==0){
                    return 0; // removed Choose member. previously 1
                }
                else if(section==1){
                    return [arrTimeSlots count];;
                }
                else{
                    return 1;
                }
            }
            else{
                if(section==0){
                    return 0;  //removed Choose member. previously 1
                }
                else if(section==1){
                    return 1;
                }
                else if(section==2){
                    return [arrTimeSlots count];
                }
                return 1;
            }
        }
    }
    return self.searchResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==_tblVw_Sports){
        if([self.downPicker.text isEqualToString:@"Badminton"]){
            if (indexPath.section==0){
                return 50;
            }
            if (indexPath.section==1){
                return 44;
            }
            else if(indexPath.section==2){
                return 70;
            }
            return 100;
        }
        else if([self.downPicker.text isEqualToString:@"Pool"] || [self.downPicker.text isEqualToString:@"Billiard And Snooker"]){
            if (indexPath.section==0){
                return 44;
            }
            else if(indexPath.section==1){
                return 70;
            }
            return 100;
        }
        else{
            if([strSquashTypeID isEqualToString:@"1"] || [strSquashTypeID isEqualToString:@"3"] || [strSquashTypeID isEqualToString:@"4"]){
                if (indexPath.section==0){
                    return 44;
                }
                else if(indexPath.section==1){
                    return 70;
                }
                return 100;
            }
            else{
                if (indexPath.section==0){
                    return 50;
                }
                if (indexPath.section==1){
                    return 44;
                }
                else if(indexPath.section==2){
                    return 70;
                }
                return 100;
            }
        }
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==_tblVw_Sports){
        if([self.downPicker.text isEqualToString:@"Badminton"]){
            if(indexPath.section==0){
                ChooseMemberCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ChooseMemberCell"];
                if (cell==nil)
                {
                    cell =(ChooseMemberCell *)[[[NSBundle mainBundle] loadNibNamed:@"ChooseMemberCell" owner:self options:nil] objectAtIndex:0];
                }
                if (indexPath.row==0) {
                    if([DataValidation isNullString:strMember2Name]==YES){
                        strMember2Name = @"Choose Member 2...";
                    }
                    [cell.btn_Member setTitle:strMember2Name forState:UIControlStateNormal];
                    cell.btn_Member.tag = indexPath.row;
                    [cell.btn_Member addTarget:self action:@selector(click_selectMember:) forControlEvents:UIControlEventTouchUpInside];
                    [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:cell.vw_member];
                }
                else if (indexPath.row==1) {
                    if([DataValidation isNullString:strMember3Name]==YES){
                        strMember3Name = @"Choose Member 3...";
                    }
                    [cell.btn_Member setTitle:strMember3Name forState:UIControlStateNormal];
                    cell.btn_Member.tag = indexPath.row;
                    [cell.btn_Member addTarget:self action:@selector(click_selectMember:) forControlEvents:UIControlEventTouchUpInside];
                    [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:cell.vw_member];
                }
                else {
                    if([DataValidation isNullString:strMember4Name]==YES){
                        strMember4Name = @"Choose Member 4...";
                    }
                    [cell.btn_Member setTitle:strMember4Name forState:UIControlStateNormal];
                    cell.btn_Member.tag = indexPath.row;
                    [cell.btn_Member addTarget:self action:@selector(click_selectMember:) forControlEvents:UIControlEventTouchUpInside];
                    [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:cell.vw_member];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if(indexPath.section==1){
                SelectSlot *cell =[tableView dequeueReusableCellWithIdentifier:@"SelectSlot"];
                if (cell==nil)
                {
                    cell =(SelectSlot *)[[[NSBundle mainBundle] loadNibNamed:@"SelectSlot" owner:self options:nil] objectAtIndex:0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if(indexPath.section==2){
                SportsSlotCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SportsSlotCell"];
                if (cell==nil)
                {
                    cell =(SportsSlotCell *)[[[NSBundle mainBundle] loadNibNamed:@"SportsSlotCell" owner:self options:nil] objectAtIndex:0];
                }
                cell.lbl_TimeSlot.text = [NSString stringWithFormat:@"%@",[[arrTimeSlots valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
                if([[[arrTimeSlots valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@""]){
                    cell.vw_Slot.backgroundColor = [UIColor darkGrayColor];
                }
                else{
                    if([[[arrTimeSlots valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@"NO"]){
                        cell.vw_Slot.backgroundColor = [UIColor blackColor];
                    }
                    else{
                        cell.vw_Slot.backgroundColor = [UIColor systemGreenColor];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else{
                BookNowCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BookNowCell"];
                if (cell==nil)
                {
                    cell =(BookNowCell *)[[[NSBundle mainBundle] loadNibNamed:@"BookNowCell" owner:self options:nil] objectAtIndex:0];
                }
                [cell.btn_BookNow addTarget:self action:@selector(click_BookSports:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_Check addTarget:self action:@selector(click_Check:) forControlEvents:UIControlEventTouchUpInside];
                if([strTick isEqualToString:@"YES"]){
                    [cell.btn_Check setImage:[UIImage imageNamed:@"tick_black.png"] forState:UIControlStateNormal];
                }
                else{
                    [cell.btn_Check setImage:[UIImage imageNamed:@"untick_black.png"] forState:UIControlStateNormal];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else if([self.downPicker.text isEqualToString:@"Pool"] || [self.downPicker.text isEqualToString:@"Billiard And Snooker"]){
            if(indexPath.section==0){
                SelectSlot *cell =[tableView dequeueReusableCellWithIdentifier:@"SelectSlot"];
                if (cell==nil)
                {
                    cell =(SelectSlot *)[[[NSBundle mainBundle] loadNibNamed:@"SelectSlot" owner:self options:nil] objectAtIndex:0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if(indexPath.section==1){
                SportsSlotCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SportsSlotCell"];
                if (cell==nil)
                {
                    cell =(SportsSlotCell *)[[[NSBundle mainBundle] loadNibNamed:@"SportsSlotCell" owner:self options:nil] objectAtIndex:0];
                }
                cell.lbl_TimeSlot.text = [NSString stringWithFormat:@"%@",[[arrTimeSlots valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
                if([[[arrTimeSlots valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@""]){
                    cell.vw_Slot.backgroundColor = [UIColor darkGrayColor];
                }
                else{
                    if([[[arrTimeSlots valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@"NO"]){
                        cell.vw_Slot.backgroundColor = [UIColor blackColor];
                    }
                    else{
                        cell.vw_Slot.backgroundColor = [UIColor systemGreenColor];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else{
                BookNowCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BookNowCell"];
                if (cell==nil)
                {
                    cell =(BookNowCell *)[[[NSBundle mainBundle] loadNibNamed:@"BookNowCell" owner:self options:nil] objectAtIndex:0];
                }
                [cell.btn_BookNow addTarget:self action:@selector(click_BookSports:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn_Check addTarget:self action:@selector(click_Check:) forControlEvents:UIControlEventTouchUpInside];
                if([strTick isEqualToString:@"YES"]){
                    [cell.btn_Check setImage:[UIImage imageNamed:@"tick_black.png"] forState:UIControlStateNormal];
                }
                else{
                    [cell.btn_Check setImage:[UIImage imageNamed:@"untick_black.png"] forState:UIControlStateNormal];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else{
            if([strSquashTypeID isEqualToString:@"1"] || [strSquashTypeID isEqualToString:@"3"] || [strSquashTypeID isEqualToString:@"4"]){
                if(indexPath.section==0){
                    SelectSlot *cell =[tableView dequeueReusableCellWithIdentifier:@"SelectSlot"];
                    if (cell==nil)
                    {
                        cell =(SelectSlot *)[[[NSBundle mainBundle] loadNibNamed:@"SelectSlot" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.section==1){
                    SportsSlotCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SportsSlotCell"];
                    if (cell==nil)
                    {
                        cell =(SportsSlotCell *)[[[NSBundle mainBundle] loadNibNamed:@"SportsSlotCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.lbl_TimeSlot.text = [NSString stringWithFormat:@"%@",[[arrTimeSlots valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
                    if([[[arrTimeSlots valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@""]){
                        cell.vw_Slot.backgroundColor = [UIColor darkGrayColor];
                    }
                    else{
                        if([[[arrTimeSlots valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@"NO"]){
                            cell.vw_Slot.backgroundColor = [UIColor blackColor];
                        }
                        else{
                            cell.vw_Slot.backgroundColor = [UIColor systemGreenColor];
                        }
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else{
                    BookNowCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BookNowCell"];
                    if (cell==nil)
                    {
                        cell =(BookNowCell *)[[[NSBundle mainBundle] loadNibNamed:@"BookNowCell" owner:self options:nil] objectAtIndex:0];
                    }
                    [cell.btn_BookNow addTarget:self action:@selector(click_BookSports:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.btn_Check addTarget:self action:@selector(click_Check:) forControlEvents:UIControlEventTouchUpInside];
                    if([strTick isEqualToString:@"YES"]){
                        [cell.btn_Check setImage:[UIImage imageNamed:@"tick_black.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell.btn_Check setImage:[UIImage imageNamed:@"untick_black.png"] forState:UIControlStateNormal];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            else{
                if(indexPath.section==0){
                    ChooseMemberCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ChooseMemberCell"];
                    if (cell==nil)
                    {
                        cell =(ChooseMemberCell *)[[[NSBundle mainBundle] loadNibNamed:@"ChooseMemberCell" owner:self options:nil] objectAtIndex:0];
                    }
                    if (indexPath.row==0) {
                        if([DataValidation isNullString:strMember2Name]==YES){
                            strMember2Name = @"Choose Member 2...";
                        }
                        [cell.btn_Member setTitle:strMember2Name forState:UIControlStateNormal];
                        cell.btn_Member.tag = indexPath.row;
                        [cell.btn_Member addTarget:self action:@selector(click_selectMember:) forControlEvents:UIControlEventTouchUpInside];
                        [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:cell.vw_member];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.section==1){
                    SelectSlot *cell =[tableView dequeueReusableCellWithIdentifier:@"SelectSlot"];
                    if (cell==nil)
                    {
                        cell =(SelectSlot *)[[[NSBundle mainBundle] loadNibNamed:@"SelectSlot" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if(indexPath.section==2){
                    SportsSlotCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SportsSlotCell"];
                    if (cell==nil)
                    {
                        cell =(SportsSlotCell *)[[[NSBundle mainBundle] loadNibNamed:@"SportsSlotCell" owner:self options:nil] objectAtIndex:0];
                    }
                    cell.lbl_TimeSlot.text = [NSString stringWithFormat:@"%@",[[arrTimeSlots valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
                    if([[[arrTimeSlots valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@""]){
                        cell.vw_Slot.backgroundColor = [UIColor darkGrayColor];
                    }
                    else{
                        if([[[arrTimeSlots valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@"NO"]){
                            cell.vw_Slot.backgroundColor = [UIColor blackColor];
                        }
                        else{
                            cell.vw_Slot.backgroundColor = [UIColor systemGreenColor];
                        }
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else{
                    BookNowCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BookNowCell"];
                    if (cell==nil)
                    {
                        cell =(BookNowCell *)[[[NSBundle mainBundle] loadNibNamed:@"BookNowCell" owner:self options:nil] objectAtIndex:0];
                    }
                    [cell.btn_BookNow addTarget:self action:@selector(click_BookSports:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.btn_Check addTarget:self action:@selector(click_Check:) forControlEvents:UIControlEventTouchUpInside];
                    if([strTick isEqualToString:@"YES"]){
                        [cell.btn_Check setImage:[UIImage imageNamed:@"tick_black.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell.btn_Check setImage:[UIImage imageNamed:@"untick_black.png"] forState:UIControlStateNormal];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            return nil;
        }
    }
    else{
        MembersListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MembersListCell"];
        if (cell==nil)
        {
            cell =(MembersListCell *)[[[NSBundle mainBundle] loadNibNamed:@"MembersListCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.lbl_MemberName.text = [NSString stringWithFormat:@"%@",[self.searchResult objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tblVw_Sports){
        if([self.downPicker.text isEqualToString:@"Badminton"]){
            if(indexPath.section==2){
                if([[[arrTimeSlots valueForKey:@"available"] objectAtIndex:indexPath.row] isEqualToString:@"available"]){
                    for (int i = 0; i < [arrTimeSlots count]; i++)
                    {
                        if([[[arrTimeSlots valueForKey:@"available"] objectAtIndex:i] isEqualToString:@"available"]){
                            NSMutableDictionary *dic = [arrTimeSlots objectAtIndex:i];
                            [dic setValue:@"NO" forKey:@"table_select"];
                            [arrTimeSlots removeObjectAtIndex:i];
                            [arrTimeSlots insertObject:dic atIndex:i];
                        }
                    }
                    NSMutableDictionary *dic = [arrTimeSlots objectAtIndex:indexPath.row];
                    [dic setValue:@"YES" forKey:@"table_select"];
                    [arrTimeSlots removeObjectAtIndex:indexPath.row];
                    [arrTimeSlots insertObject:dic atIndex:indexPath.row];
                    strTimeSlotID = [[arrTimeSlots valueForKey:@"id"] objectAtIndex:indexPath.row];
                    [self.tblVw_Sports reloadData];
                }
            }
        }
        else if([self.downPicker.text isEqualToString:@"Pool"] || [self.downPicker.text isEqualToString:@"Billiard And Snooker"]){
            if(indexPath.section==1){
                if([[[arrTimeSlots valueForKey:@"available"] objectAtIndex:indexPath.row] isEqualToString:@"available"]){
                    for (int i = 0; i < [arrTimeSlots count]; i++)
                    {
                        if([[[arrTimeSlots valueForKey:@"available"] objectAtIndex:i] isEqualToString:@"available"]){
                            NSMutableDictionary *dic = [arrTimeSlots objectAtIndex:i];
                            [dic setValue:@"NO" forKey:@"table_select"];
                            [arrTimeSlots removeObjectAtIndex:i];
                            [arrTimeSlots insertObject:dic atIndex:i];
                        }
                    }
                    NSMutableDictionary *dic = [arrTimeSlots objectAtIndex:indexPath.row];
                    [dic setValue:@"YES" forKey:@"table_select"];
                    [arrTimeSlots removeObjectAtIndex:indexPath.row];
                    [arrTimeSlots insertObject:dic atIndex:indexPath.row];
                    strTimeSlotID = [[arrTimeSlots valueForKey:@"id"] objectAtIndex:indexPath.row];
                    [self.tblVw_Sports reloadData];
                }
            }
        }
        else{
            if([strSquashTypeID isEqualToString:@"1"] || [strSquashTypeID isEqualToString:@"3"] || [strSquashTypeID isEqualToString:@"4"]){
                if(indexPath.section==1){
                    if([[[arrTimeSlots valueForKey:@"available"] objectAtIndex:indexPath.row] isEqualToString:@"available"]){
                        for (int i = 0; i < [arrTimeSlots count]; i++)
                        {
                            if([[[arrTimeSlots valueForKey:@"available"] objectAtIndex:i] isEqualToString:@"available"]){
                                NSMutableDictionary *dic = [arrTimeSlots objectAtIndex:i];
                                [dic setValue:@"NO" forKey:@"table_select"];
                                [arrTimeSlots removeObjectAtIndex:i];
                                [arrTimeSlots insertObject:dic atIndex:i];
                            }
                        }
                        NSMutableDictionary *dic = [arrTimeSlots objectAtIndex:indexPath.row];
                        [dic setValue:@"YES" forKey:@"table_select"];
                        [arrTimeSlots removeObjectAtIndex:indexPath.row];
                        [arrTimeSlots insertObject:dic atIndex:indexPath.row];
                        strTimeSlotID = [[arrTimeSlots valueForKey:@"id"] objectAtIndex:indexPath.row];
                        [self.tblVw_Sports reloadData];
                    }
                }
            }
            else{
                if(indexPath.section==2){
                    if([[[arrTimeSlots valueForKey:@"available"] objectAtIndex:indexPath.row] isEqualToString:@"available"]){
                        for (int i = 0; i < [arrTimeSlots count]; i++)
                        {
                            if([[[arrTimeSlots valueForKey:@"available"] objectAtIndex:i] isEqualToString:@"available"]){
                                NSMutableDictionary *dic = [arrTimeSlots objectAtIndex:i];
                                [dic setValue:@"NO" forKey:@"table_select"];
                                [arrTimeSlots removeObjectAtIndex:i];
                                [arrTimeSlots insertObject:dic atIndex:i];
                            }
                        }
                        NSMutableDictionary *dic = [arrTimeSlots objectAtIndex:indexPath.row];
                        [dic setValue:@"YES" forKey:@"table_select"];
                        [arrTimeSlots removeObjectAtIndex:indexPath.row];
                        [arrTimeSlots insertObject:dic atIndex:indexPath.row];
                        strTimeSlotID = [[arrTimeSlots valueForKey:@"id"] objectAtIndex:indexPath.row];
                        [self.tblVw_Sports reloadData];
                    }
                }
            }
        }
    }
    else{
        if (memberTag==0) {
            strMember2Name = [self.searchResult objectAtIndex:indexPath.row];
            /*NSArray *listItems = [strMember2Name componentsSeparatedByString:@"["];
            strID2 = [listItems objectAtIndex:1];
            strID2 = [strID2 stringByReplacingOccurrencesOfString:@"]" withString:@""];*/
           
        }
        else if (memberTag==1) {
            strMember3Name = [self.searchResult objectAtIndex:indexPath.row];
//            NSArray *listItems = [strMember3Name componentsSeparatedByString:@"["];
//            strID3 = [listItems objectAtIndex:1];
//            strID3 = [strID3 stringByReplacingOccurrencesOfString:@"]" withString:@""];
        }
        else{
            strMember4Name = [self.searchResult objectAtIndex:indexPath.row];
//            NSArray *listItems = [strMember4Name componentsSeparatedByString:@"["];
//            strID4 = [listItems objectAtIndex:1];
//            strID4 = [strID4 stringByReplacingOccurrencesOfString:@"]" withString:@""];
        }
        _txtFld_search.text = @"";
        strSearchText = @"";
        [_txtFld_search resignFirstResponder];
        _vw_Search.hidden = YES;
        NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
        [_tblVw_Sports reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - CUSTOM DELEGATE

-(void)dp_Selected {
    [self timeSlots];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    for (int i = 0; i <[arrSquashType count]; i++) {
        if([_btn_Squash.titleLabel.text isEqualToString:[[arrSquashType valueForKey:@"name"] objectAtIndex:i]]){
            strSquashTypeID = [[arrSquashType valueForKey:@"id"] objectAtIndex:i];
        }
    }
    NSLog(@"%@", _btn_Squash.titleLabel.text);
    _lbl_Squash.text = _btn_Squash.titleLabel.text;
    [_btn_Squash setTitle:@"" forState:UIControlStateNormal];
    if([strSquashTypeID isEqualToString:@"4"]){
        _tblVw_Sports.hidden = YES;
        [_tblVw_Sports reloadData];
        if ([Utility isNetworkAvailable]) {
            User *mUser = [User new];
            mUser = [Utility getUserInfo];
            [self.view setUserInteractionEnabled:NO];
            [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
            ServerConnection *mServerConnection = [[ServerConnection alloc] init];
            mServerConnection.delegate = self;
            for (int i = 0; i<[arrSportsList count]; i++) {
                if([[self.downPicker text] isEqualToString:[NSString stringWithFormat:@"%@",[[arrSportsList valueForKey:@"sports_name"] objectAtIndex:i]]]){
                    strSportsID = [NSString stringWithFormat:@"%@",[[arrSportsList valueForKey:@"id"] objectAtIndex:i]];
                    break;
                }
            }
            isSquashTypeCoach = YES;
            [mServerConnection getSportsTimeSlotsSquashWithCoach:strSportsID BookingDate:_txtFld_SelectDate.text MemberID:mUser.user_membership_no SquashTypeID:strSquashTypeID];
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
    else{
        if(isSquashTypeCoach==YES){
            [self timeSlots];
        }
        else{
            _tblVw_Sports.hidden = NO;
            [_tblVw_Sports reloadData];
        }
    }
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

#pragma mark - SELF METHODS

-(void)sportBooking{
}

-(void)timeSlots{
    if ([Utility isNetworkAvailable]) {
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        for (int i = 0; i<[arrSportsList count]; i++) {
            if([[self.downPicker text] isEqualToString:[NSString stringWithFormat:@"%@",[[arrSportsList valueForKey:@"sports_name"] objectAtIndex:i]]]){
                strSportsID = [NSString stringWithFormat:@"%@",[[arrSportsList valueForKey:@"id"] objectAtIndex:i]];
                break;
            }
        }
        [mServerConnection getSportsTimeSlots:strSportsID BookingDate:_txtFld_SelectDate.text MemberID:mUser.user_membership_no];
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

-(void)searchValue{
    if (strSearchText.length != 0) {
        self.searchResult = [NSMutableArray array];
        for (int i = 0; i < [arrMembersList count]; i++) {
            if ([[[arrMembersList objectAtIndex:i] lowercaseString] rangeOfString:[strSearchText lowercaseString]].location != NSNotFound) {
                [self.searchResult addObject:[arrMembersList objectAtIndex:i]];
            }
            
        }
    }
    else {
        self.searchResult = arrMembersList;
    }
    _vw_Search.hidden = NO;
    [self.tblVw_CustomSearch reloadData];
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)sports_booking:(id)result{
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
                
                if([[[dict valueForKey:@"data"] valueForKey:@"sports"] count]>0){
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"sports"] count]; i++) {
                        [arrSportsList addObject:[[[dict valueForKey:@"data"] valueForKey:@"sports"] objectAtIndex:i]];
                    }
                    self.downPicker = [[DownPicker alloc] initWithTextField:_txtFld_SelectSports withData:[arrSportsList valueForKey:@"sports_name"]];
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
                                                     [self.navigationController popViewControllerAnimated:NO];
                                                                    // call method whatever u need
//                                        LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                                        [self.navigationController pushViewController:mLoginViewController animated:NO];
                                    }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
}

-(void)getSportsTimeSlots:(id)result{
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
                    if(arrTimeSlots.count>0){
                        [arrTimeSlots removeAllObjects];
                        [arrMembersList removeAllObjects];
                        [arrSquashType removeAllObjects];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"timeslots"] count]; i++) {
                        NSDictionary *dic = [[[dict valueForKey:@"data"] valueForKey:@"timeslots"] objectAtIndex:i];
                        if([[[[[dict valueForKey:@"data"] valueForKey:@"timeslots"] objectAtIndex:i] valueForKey:@"available"] isEqualToString:@"not_available"]){
                            [dic setValue:@"" forKey:@"table_select"];
                        }
                        else{
                            [dic setValue:@"NO" forKey:@"table_select"];
                        }
                        [arrTimeSlots addObject:dic];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"members"] count]; i++) {
                        [arrMembersList addObject:[[[dict valueForKey:@"data"] valueForKey:@"members"] objectAtIndex:i]];
                    }
                }
                else{
                }
                if([self.downPicker.text isEqualToString:@"Squash"]){
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"squash_dropdown"] count]; i++) {
                        [arrSquashType addObject:[[[dict valueForKey:@"data"] valueForKey:@"squash_dropdown"] objectAtIndex:i]];
                    }
                    _vw_Squash.hidden = NO;
                    if(isSquashTypeCoach == YES){
                        isSquashTypeCoach = NO;
                        _tblVw_Sports.hidden = NO;
                    }
                    else{
                        _tblVw_Sports.hidden = YES;
                    }
                    [_tblVw_Sports reloadData];
                    _layOutConstraint_TableTop.constant = 50.0;
                }
                else{
                    [_btn_Squash setTitle:@"Select Squash" forState:UIControlStateNormal];
                    _lbl_Squash.text = @"";
                    isSquashTypeCoach = NO;
                    _vw_Squash.hidden = YES;
                    _layOutConstraint_TableTop.constant = 0.0;
                    _tblVw_Sports.hidden = NO;
                    [_tblVw_Sports reloadData];
                }
                
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

-(void)getSportsTimeSlotsSquashWithCoach:(id)result{
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
                    if(arrTimeSlots.count>0){
                        [arrTimeSlots removeAllObjects];
                        [arrMembersList removeAllObjects];
                        [arrSquashType removeAllObjects];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"timeslots"] count]; i++) {
                        NSDictionary *dic = [[[dict valueForKey:@"data"] valueForKey:@"timeslots"] objectAtIndex:i];
                        if([[[[[dict valueForKey:@"data"] valueForKey:@"timeslots"] objectAtIndex:i] valueForKey:@"available"] isEqualToString:@"not_available"]){
                            [dic setValue:@"" forKey:@"table_select"];
                        }
                        else{
                            [dic setValue:@"NO" forKey:@"table_select"];
                        }
                        [arrTimeSlots addObject:dic];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"members"] count]; i++) {
                        [arrMembersList addObject:[[[dict valueForKey:@"data"] valueForKey:@"members"] objectAtIndex:i]];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"squash_dropdown"] count]; i++) {
                        [arrSquashType addObject:[[[dict valueForKey:@"data"] valueForKey:@"squash_dropdown"] objectAtIndex:i]];
                    }
                    _vw_Squash.hidden = NO;
                    _tblVw_Sports.hidden = NO;
                    [_tblVw_Sports reloadData];
                    _layOutConstraint_TableTop.constant = 50.0;
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

-(void)insert_sports_booking:(id)result{
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
                                            _tblVw_Sports.hidden = YES;
                                            _vw_Squash.hidden = YES;
                                            _vw_Search.hidden = YES;
                                            _lbl_HeaderCustomSearch.text = @"Members List";
                                            [_btn_Squash setTitle:@"Select Squash" forState:UIControlStateNormal];
                                            [arrTimeSlots removeAllObjects];
                                            [arrMembersList removeAllObjects];
                                            [arrSquashType removeAllObjects];
                                            _lbl_Squash.text = @"";
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

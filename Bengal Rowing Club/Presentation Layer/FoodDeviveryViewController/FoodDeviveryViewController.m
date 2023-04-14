//
//  FoodDeviveryViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 01/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "FoodDeviveryViewController.h"
#import "FoodMenuListViewController.h"
#import "DashboardViewController.h"
#import "BanquetUpperCell.h"
#import "BanquetListCell.h"
#import "BanquetBottomCell.h"
#import "Constant.h"

@interface FoodDeviveryViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrTimeSlots;
    NSString *strTimeSlotID;
    NSString *strTimeSlotName;
    NSMutableArray *arrayOfSelectedBoolValues;
    NSString *strTick;
}
@property (weak, nonatomic) IBOutlet UIView *vw_SelectDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_SelectDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerDate;
@property (strong, nonatomic) DownPicker *downPicker;
@property (weak, nonatomic) IBOutlet UITableView *tblVw_FoodTime;
@end

@implementation FoodDeviveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
    [Utility addBottomBorderWithColor:[UIColor blackColor] andWidth:1.0 view:_vw_SelectDate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    strTick = @"NO";
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    arrTimeSlots = [[NSMutableArray alloc] init];
    arrayOfSelectedBoolValues = [[NSMutableArray alloc]init];
    _txtFld_SelectDate.text = @"";
    _tblVw_FoodTime.hidden = YES;
    if ([Utility isNetworkAvailable]) {
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection check_user:mUser.token];
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
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }
    else if(section==1){
        return [arrTimeSlots count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        return 65;
    }
    else if(indexPath.section==1){
        return 70;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        BanquetUpperCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BanquetUpperCell"];
        if (cell==nil)
        {
            cell =(BanquetUpperCell *)[[[NSBundle mainBundle] loadNibNamed:@"BanquetUpperCell" owner:self options:nil] objectAtIndex:0];
        }
        //cell.lbl_mg_banquet.text = [NSString stringWithFormat:@"Min. Guarentee: %@",strMG_banquet];
        cell.lbl_mg_banquet.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section==1){
        BanquetListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BanquetListCell"];
        if (cell==nil)
        {
            cell =(BanquetListCell *)[[[NSBundle mainBundle] loadNibNamed:@"BanquetListCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell.imgVw_Solt sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BANQUET_BOOKING_IMAGEURL,[[arrTimeSlots objectAtIndex:indexPath.row]valueForKey:@"image"]]]
        placeholderImage:nil
               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   if (error) {
                       cell.imgVw_Solt.image = [UIImage imageNamed:@"default_image.jpg"];
                   }
                   else{
                       [cell.imgVw_Solt setImage:image];
                   }
               }];
        cell.lbl_FoodType.text = [NSString stringWithFormat:@"%@",[[arrTimeSlots valueForKey:@"timeslot_name"] objectAtIndex:indexPath.row]];
        cell.lbl_FoodTime.text = [NSString stringWithFormat:@"%@",[[arrTimeSlots valueForKey:@"time_period"] objectAtIndex:indexPath.row]];
        if(![[arrayOfSelectedBoolValues objectAtIndex:indexPath.row] boolValue]){
            cell.vw_Back.backgroundColor = [UIColor blackColor];
        }
        else{
            cell.vw_Back.backgroundColor = [UIColor systemGreenColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        BanquetBottomCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BanquetBottomCell"];
        if (cell==nil)
        {
            cell =(BanquetBottomCell *)[[[NSBundle mainBundle] loadNibNamed:@"BanquetBottomCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell.btn_SendRequest setTitle:@"Food Menu" forState:UIControlStateNormal];
        [cell.btn_SendRequest addTarget:self action:@selector(click_Submit:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   //Change the selected background view of the cell.
    if(indexPath.section==1){
        for (int i = 0; i < [arrTimeSlots count]; i++)
        {
           [arrayOfSelectedBoolValues replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];

        }

        [arrayOfSelectedBoolValues replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        strTimeSlotID = [[arrTimeSlots valueForKey:@"id"] objectAtIndex:indexPath.row];
        strTimeSlotName = [[arrTimeSlots valueForKey:@"timeslot_name"] objectAtIndex:indexPath.row];
        [self.tblVw_FoodTime reloadData];
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

#pragma mark - SELF METHODS

-(void)timeSlots{
    if ([Utility isNetworkAvailable]) {
        User *mUser = [User new];
        mUser = [Utility getUserInfo];
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection get_food_timeslots:_txtFld_SelectDate.text];
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

#pragma mark - BUTTON METHODS

- (IBAction)click_btnBack:(UIButton *)sender {
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
    [self timeSlots];
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
    [_tblVw_FoodTime reloadData];
}

-(IBAction)click_Submit:(UIButton *)sender{
    if([DataValidation isNullString:strTimeSlotID]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select one time slot from the list" preferredStyle:UIAlertControllerStyleAlert];
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
        FoodMenuListViewController *mFoodMenuListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodMenuListViewController"];
        mFoodMenuListViewController.strTimeSlotID = strTimeSlotID;
        mFoodMenuListViewController.strTimeSlotName = strTimeSlotName;
        mFoodMenuListViewController.strBookingDate = _txtFld_SelectDate.text;
        [self.navigationController pushViewController:mFoodMenuListViewController animated:NO];
    }
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)check_user:(id)result{
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
            [self.navigationController popViewControllerAnimated:NO];
        }
}

-(void)get_food_timeslots:(id)result{
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
            if([[[dict valueForKey:@"data"] valueForKey:@"is_timeslot"] integerValue]==1){
                if([[dict valueForKey:@"data"] valueForKey:@"timeslots_data"]!=nil){
                    if(arrTimeSlots.count>0){
                        [arrTimeSlots removeAllObjects];
                        [arrayOfSelectedBoolValues removeAllObjects];
                    }
                    for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"timeslots_data"] count]; i++) {
                        [arrTimeSlots addObject:[[[dict valueForKey:@"data"] valueForKey:@"timeslots_data"] objectAtIndex:i]];
                    }
                    for (int i = 0; i < [arrTimeSlots count]; i++){
                        [arrayOfSelectedBoolValues addObject:[NSNumber numberWithBool:NO]];
                    }
                }
                else{
                }
                _tblVw_FoodTime.hidden = NO;
                [_tblVw_FoodTime reloadData];
            }
            else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[[dict valueForKey:@"data"] valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                //[self.navigationController popViewControllerAnimated:NO];
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

@end

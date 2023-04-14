//
//  FoodMenuListViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 01/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "FoodMenuListViewController.h"
#import "FoodMenuSubmitViewController.h"
#import "FoodSectionCell.h"
#import "FoodListCell.h"
#import "Constant.h"

@interface FoodMenuListViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrFoodCategory;
    NSMutableArray *arrRowFood;
    NSInteger currentRow;
    NSInteger currentSection;
    NSString *strItemNo;
    NSMutableArray *arrItemDetails;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_FoodList;
@property (weak, nonatomic) IBOutlet UIButton *btn_Continue;

@end

@implementation FoodMenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
    arrFoodCategory = [[NSMutableArray alloc] init];
    arrRowFood = [[NSMutableArray alloc] init];
    arrItemDetails = [[NSMutableArray alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _btn_Continue.hidden = YES;
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    _tblVw_FoodList.hidden = YES;
    strItemNo = @"";
    if ([Utility isNetworkAvailable]) {
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection get_food_details:mUser.token BookingDate:_strBookingDate TimeSlot:_strTimeSlotID];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrFoodCategory.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[arrFoodCategory objectAtIndex:section] valueForKey:@"foods"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FoodSectionCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FoodSectionCell"];
    if (cell==nil)
    {
        cell =(FoodSectionCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodSectionCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.lbl_SectionTitle.text = [[arrFoodCategory objectAtIndex:section] valueForKey:@"cat"];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodListCell"];
    
    if(cell==nil){
        cell = (FoodListCell *)[[[NSBundle mainBundle] loadNibNamed:@"FoodListCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSInteger sumSections = 0;
    for (int i = 0; i < indexPath.section; i++) {
        NSInteger rowsInSection = [_tblVw_FoodList numberOfRowsInSection:i];
        sumSections += rowsInSection;
    }
    currentRow = sumSections + indexPath.row;
    if([[NSString stringWithFormat:@"%@",[[arrRowFood objectAtIndex:currentRow] valueForKey:@"Itemno"]] isEqualToString:@"0"]){
        cell.btn_DeleteItem.hidden = YES;
    }
    else{
        cell.btn_DeleteItem.hidden = NO;
    }
    cell.btn_DeleteItem.tag = currentRow;
    cell.lbl_FoodName.text = [NSString stringWithFormat:@"%@ \nItem No: %@",[[arrRowFood objectAtIndex:currentRow] valueForKey:@"food_menu"], [[arrRowFood objectAtIndex:currentRow] valueForKey:@"Itemno"]];
    [Utility addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0 view:cell.vw_Food];
    [cell.btn_DeleteItem addTarget:self action:@selector(click_DeleteItem:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger sumSections = 0;
    for (int i = 0; i < indexPath.section; i++) {
        NSInteger rowsInSection = [_tblVw_FoodList numberOfRowsInSection:i];
        sumSections += rowsInSection;
    }
    currentRow = sumSections + indexPath.row;
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:[[arrRowFood objectAtIndex:currentRow] valueForKey:@"food_menu"]  preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^ (UITextField *textfield)
     {
        textfield.placeholder = @"Item No";
        textfield.textColor = [UIColor blackColor];
        textfield.borderStyle = UITextBorderStyleRoundedRect;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    NSArray *textfields = alert.textFields;
                                    UITextField *item = textfields[0];
        
                                    if([DataValidation isNullString:item.text]==YES){
                                        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please enter no of item"  preferredStyle:UIAlertControllerStyleAlert];
                                                    
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
                                        NSMutableDictionary *dict = [arrRowFood[currentRow] mutableCopy];
                                        [dict setObject:item.text forKey:@"Itemno"];
                                        [arrRowFood replaceObjectAtIndex:currentRow withObject:dict];
                                        NSMutableArray *arrDuplicate = [[NSMutableArray alloc] init];
                                        [arrDuplicate addObject:dict];
                                        if(arrItemDetails.count>0){
                                            for (int i = 0; i < [arrItemDetails count]; i++) {
                                                if([[[arrDuplicate objectAtIndex:0] valueForKey:@"food_menu"] isEqualToString:[[arrItemDetails objectAtIndex:i] valueForKey:@"food_menu"]]){
                                                    [arrItemDetails removeObject:[arrItemDetails objectAtIndex:i]];
                                                    [arrItemDetails addObject:dict];
                                                    break;
                                                }
                                                else{
                                                    [arrItemDetails addObject:dict];
                                                }
                                            }
                                        }else{
                                            [arrItemDetails addObject:dict];
                                        }
                                        _btn_Continue.hidden = NO;
                                        [_tblVw_FoodList reloadData];
                                    }
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Cancel"
                            style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
    {
        
    }];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BUTTON METHODS

- (IBAction)click_backFoodMenu:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)click_DeleteItem:(UIButton *)sender{
    if(arrItemDetails.count>0){
        NSMutableDictionary *dict = [arrRowFood[sender.tag] mutableCopy];
        [dict setObject:@"0" forKey:@"Itemno"];
        [arrRowFood replaceObjectAtIndex:sender.tag withObject:dict];
        for (int i = 0; i < [arrItemDetails count]; i++) {
            if([[[arrRowFood objectAtIndex:sender.tag] valueForKey:@"food_menu"] isEqualToString:[[arrItemDetails objectAtIndex:i] valueForKey:@"food_menu"]]){
                [arrItemDetails removeObject:[arrItemDetails objectAtIndex:i]];
            }
        }
        if(arrItemDetails.count==0){
            _btn_Continue.hidden = YES;
        }
        [_tblVw_FoodList reloadData];
    }
    else{
        _btn_Continue.hidden = YES;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"No item no add on list" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)click_ContinueItem:(UIButton *)sender {
    FoodMenuSubmitViewController *mFoodMenuSubmitViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodMenuSubmitViewController"];
    mFoodMenuSubmitViewController.arrItemDetails = arrItemDetails;
    mFoodMenuSubmitViewController.strTimeSlotID = _strTimeSlotID;
    mFoodMenuSubmitViewController.strBookingDate = _strBookingDate;
    mFoodMenuSubmitViewController.strTimeSlotName = _strTimeSlotName;
    [self.navigationController pushViewController:mFoodMenuSubmitViewController animated:NO];
}


#pragma mark - SERVER DELEGATES
-(void)get_food_details:(id)result{
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
            if([[[dict valueForKey:@"data"] valueForKey:@"is_food"] integerValue]==1){
                if([[dict valueForKey:@"data"] valueForKey:@"foods"]!=nil){
                    if(arrFoodCategory.count>0){
                        [arrFoodCategory removeAllObjects];
                        [arrRowFood removeAllObjects];
                    }
                    for (int i = 0; i<[[[[dict valueForKey:@"data"] valueForKey:@"foods"] valueForKey:@"Category"] count]; i++) {
                        [arrFoodCategory addObject:[[[[dict valueForKey:@"data"] valueForKey:@"foods"] valueForKey:@"Category"] objectAtIndex:i]];
                        for (int j = 0; j<[[[arrFoodCategory objectAtIndex:i] valueForKey:@"foods"] count]; j++) {
                            [arrRowFood addObject:[[[arrFoodCategory objectAtIndex:i] valueForKey:@"foods"] objectAtIndex:j]];
                        }
                    }
                }
                else{
                }
                _tblVw_FoodList.hidden = NO;
                [_tblVw_FoodList reloadData];
            }
            else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
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
                                                                // call method whatever u need
                                    LoginViewController *mLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                    [self.navigationController pushViewController:mLoginViewController animated:NO];
                                }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

//
//  EventBookingViewController.m
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 27/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "EventBookingViewController.h"
#import "EventDescriptionCell.h"
#import "EventDetailsCell.h"
#import "EventDetailsListCell.h"
#import "EventDetailsSubmitCell.h"
#import "OTPEventViewController.h"
#import "Constant.h"

@interface EventBookingViewController ()<ServerConnectionDelegate,UITextFieldDelegate,SelectDropDownDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrTicketList;
    NSString *strTicketID;
    NSString *strTicketAmount;
    NSString *strTicketName;
    NSString *strTicketQuantity;
    NSString *strTotalAmount;
    NSMutableArray* arrQTYList;
    NSInteger Total;
    NSMutableDictionary *dictTicketList;
    NSString *strTick;
}

@property (weak, nonatomic) IBOutlet UITableView *tblVw_EventBooking;
@property (strong, nonatomic) DownPicker *downPicker;
@end

@implementation EventBookingViewController

- (void)viewDidLoad {
[super viewDidLoad];
// Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    strTick = @"NO";
    _tblVw_EventBooking.hidden = YES;
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    arrQTYList = [[NSMutableArray alloc] init];
    dictTicketList = [[NSMutableDictionary alloc] init];
    [arrQTYList addObject:@"1"];
    [arrQTYList addObject:@"2"];
    [arrQTYList addObject:@"3"];
    [arrQTYList addObject:@"4"];
    [arrQTYList addObject:@"5"];
    [arrQTYList addObject:@"6"];
    [arrQTYList addObject:@"7"];
    [arrQTYList addObject:@"8"];
    [arrQTYList addObject:@"9"];
    [arrQTYList addObject:@"10"];
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection eventDetails:_strEventPassID];
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

#pragma mark - BUTTON METHODS

- (IBAction)click_backEventBooking:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
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
    [_tblVw_EventBooking reloadData];
}

-(IBAction)click_BookNow:(UIButton *)sender{
    if([DataValidation isNullString:self.downPicker.text]==YES){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select quantity"  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    
                                                    // call method whatever u need
                                                }];
                    [alert addAction:yesButton];
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
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        [arr addObject:dictTicketList];
        NSDictionary *dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"ticket_dtls", nil];
        NSDictionary *dicCustomField = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"custom", nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             mUser.user_membership_no, @"member_id",
                             @"",@"booking_date",
                             @"2", @"type",
                             @"1", @"status",
                             _strEventPassID, @"event_id",
                             _name, @"event_name",
                             dicTemp, @"ticket_data",
                             dicCustomField, @"custom_fields", nil];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        if ([Utility isNetworkAvailable]) {
            
            [self.view setUserInteractionEnabled:NO];
            [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
            ServerConnection *mServerConnection = [[ServerConnection alloc] init];
            mServerConnection.delegate = self;
            [mServerConnection insert_event_booking:jsonString];
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

#pragma mark -  tableView Delagate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }
    return 1 + arrTicketList.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1){
        if(indexPath.row==0){
            return 74;
        }
        else if(indexPath.row==1){
            return 45;
        }
        else{
            return 136;
        }
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        CGFloat aspectRatio = 320.0f/420.0f;
        return aspectRatio * [UIScreen mainScreen].bounds.size.height;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        EventDescriptionCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EventDescriptionCell"];
        if (cell==nil)
        {
            cell =(EventDescriptionCell *)[[[NSBundle mainBundle] loadNibNamed:@"EventDescriptionCell" owner:self options:nil] objectAtIndex:0];
        }
        
        [cell.imgVw_Event sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EVENTPASSIMAGEURL,_event_image]]
        placeholderImage:nil
               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   if (error) {
                       cell.imgVw_Event.image = [UIImage imageNamed:@"default_image.jpg"];
                   }
                   else{
                       [cell.imgVw_Event setImage:image];
                   }
               }];
        
        
        cell.lbl_Name.text = _name;
        cell.lbl_Date.text = [NSString stringWithFormat:@"%@ to %@",_event_date,_event_end_date];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_strDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell.lbl_Description.attributedText = attrStr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        if(indexPath.row==0){
            EventDetailsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EventDetailsCell"];
            if (cell==nil)
            {
                cell =(EventDetailsCell *)[[[NSBundle mainBundle] loadNibNamed:@"EventDetailsCell" owner:self options:nil] objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if(indexPath.row==1){
            EventDetailsListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EventDetailsListCell"];
            if (cell==nil)
            {
                cell =(EventDetailsListCell *)[[[NSBundle mainBundle] loadNibNamed:@"EventDetailsListCell" owner:self options:nil] objectAtIndex:0];
            }
            cell.lbl_Name.text = [[arrTicketList valueForKey:@"ticket_name"] objectAtIndex:indexPath.row-1];
            cell.lbl_Cost.text = [[arrTicketList valueForKey:@"ticket_amount"] objectAtIndex:indexPath.row-1];
            self.downPicker = [[DownPicker alloc] initWithTextField:cell.txtFld_QTY withData:arrQTYList];
            cell.txtFld_QTY.tag = indexPath.row-1;
            cell.txtFld_QTY.layer.borderWidth = 1.0;
            cell.txtFld_QTY.layer.borderColor = [UIColor blackColor].CGColor;
            _downPicker.delegate = self;
            Total = [cell.lbl_Cost.text integerValue] * [self.downPicker.text integerValue];
            NSLog(@"TOTAL: %ld", (long)Total);
            cell.lbl_Total.text = [NSString stringWithFormat:@"%ld", (long)Total];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            EventDetailsSubmitCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EventDetailsSubmitCell"];
            if (cell==nil)
            {
                cell =(EventDetailsSubmitCell *)[[[NSBundle mainBundle] loadNibNamed:@"EventDetailsSubmitCell" owner:self options:nil] objectAtIndex:0];
            }
            cell.lbl_TotalValue.text = [NSString stringWithFormat:@"%ld", (long)Total];
            [cell.btn_BookNow addTarget:self action:@selector(click_BookNow:) forControlEvents:UIControlEventTouchUpInside];
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
    return nil;
}

-(void)dp_Selected {
    [self.downPicker addTarget:self action:@selector(value_Selected:) forControlEvents:UIControlEventValueChanged];
    // do what you want
    strTicketQuantity = [self.downPicker text];
    [dictTicketList setValue:strTicketQuantity forKey:@"qty"];
    [_tblVw_EventBooking reloadData];
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)eventDetails:(id)result{
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
            arrTicketList = [[NSMutableArray alloc] init];
            _strDescription = [[[dict valueForKey:@"data"] valueForKey:@"event_list"] valueForKey:@"description"];
            _event_date = [[[dict valueForKey:@"data"] valueForKey:@"event_list"] valueForKey:@"event_date"];
            _event_end_date = [[[dict valueForKey:@"data"] valueForKey:@"event_list"] valueForKey:@"event_end_date"];
            _event_image = [[[dict valueForKey:@"data"] valueForKey:@"event_list"] valueForKey:@"event_image"];
            _name = [[[dict valueForKey:@"data"] valueForKey:@"event_list"] valueForKey:@"name"];
            for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"ticket_data"] count]; i++) {
                [arrTicketList addObject:[[[dict valueForKey:@"data"] valueForKey:@"ticket_data"] objectAtIndex:i]];
            }
            dictTicketList = [[[dict valueForKey:@"data"]valueForKey:@"ticket_data"] objectAtIndex:0];
            _tblVw_EventBooking.hidden = NO;
            [_tblVw_EventBooking reloadData];
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

-(void)insert_event_booking:(id)result{
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
                                            OTPEventViewController *mOTPEventViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPEventViewController"];
                                            mOTPEventViewController.strOTP = [dict valueForKey:@"otp"];
                                            mOTPEventViewController.strBookingID = [dict valueForKey:@"booking_id"];
                                            [self.navigationController pushViewController:mOTPEventViewController animated:NO];
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

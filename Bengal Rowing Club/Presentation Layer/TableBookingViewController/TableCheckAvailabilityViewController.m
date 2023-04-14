//
//  TableCheckAvailabilityViewController.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 10/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "TableCheckAvailabilityViewController.h"
#import "ThankYouTableBook.h"
#import "BookTableCell.h"
#import "CustomImageFlowLayout.h"
#import "Constant.h"

@interface TableCheckAvailabilityViewController ()<ServerConnectionDelegate>{
    NSMutableArray *arrayOfSelectedBoolValues;
    NSString *strDinningTableID;
    NSString *strTick;
    SpinnerView *mSpinnerView;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_tableType;
@property (weak, nonatomic) IBOutlet UICollectionView *clcTnView_Book;
@property (weak, nonatomic) IBOutlet UIButton *btn_Tick;

@end

@implementation TableCheckAvailabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
    _lbl_tableType.text = _strTableName;
    _clcTnView_Book.collectionViewLayout = [[CustomImageFlowLayout alloc] init];
    strTick = @"NO";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_arrCheckList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerNib:[UINib nibWithNibName:@"BookTableCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BookTableCell"];
    BookTableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookTableCell" forIndexPath:indexPath];;
    
    if (cell==nil)
    {
        cell =(BookTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"BookTableCell" owner:self options:nil] objectAtIndex:0];
    }
    if([_strDinnigAreaID isEqualToString:@"20"]){
        if([[[_arrCheckList valueForKey:@"available"] objectAtIndex:indexPath.row] isEqualToString:@"available"]){
            cell.lbl_Booked.hidden = YES;
            if([[[_arrCheckList valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@"NO"]){
                cell.vw_BookTable.backgroundColor = [UIColor brownColor];
            }
            else{
                cell.vw_BookTable.backgroundColor = [UIColor systemGreenColor];
            }
        }
        else{
            cell.lbl_Booked.hidden = NO;
            cell.lbl_Booked.text = @"Booked";
            cell.vw_BookTable.backgroundColor = [UIColor redColor];
        }
        cell.lbl_TableSeater.text = @"8 Seater";
    }
    else{
        if([[[_arrCheckList valueForKey:@"available"] objectAtIndex:indexPath.row] isEqualToString:@"available"]){
            cell.lbl_Booked.hidden = YES;
            if([[[_arrCheckList valueForKey:@"table_select"] objectAtIndex:indexPath.row] isEqualToString:@"NO"]){
                cell.vw_BookTable.backgroundColor = [UIColor brownColor];
            }
            else{
                cell.vw_BookTable.backgroundColor = [UIColor systemGreenColor];
            }
        }
        else{
            cell.lbl_Booked.hidden = NO;
            cell.lbl_Booked.text = @"Booked";
            cell.vw_BookTable.backgroundColor = [UIColor redColor];
        }
        if(([[NSString stringWithFormat:@"%@",[[_arrCheckList valueForKey:@"table_id"] objectAtIndex:indexPath.row]] isEqualToString:@"1"]) || ([[NSString stringWithFormat:@"%@",[[_arrCheckList valueForKey:@"table_id"] objectAtIndex:indexPath.row]] isEqualToString:@"5"])){
            cell.lbl_TableSeater.text = @"4 Seater";
        }
        else if(([[NSString stringWithFormat:@"%@",[[_arrCheckList valueForKey:@"table_id"] objectAtIndex:indexPath.row]] isEqualToString:@"2"])){
            cell.lbl_TableSeater.text = @"6 Seater";
        }
        else if(([[NSString stringWithFormat:@"%@",[[_arrCheckList valueForKey:@"table_id"] objectAtIndex:indexPath.row]] isEqualToString:@"3"])){
            cell.lbl_TableSeater.text = @"10 Seater";
        }
        else if(([[NSString stringWithFormat:@"%@",[[_arrCheckList valueForKey:@"table_id"] objectAtIndex:indexPath.row]] isEqualToString:@"4"])){
            cell.lbl_TableSeater.text = @"12 Seater";
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([_strDinnigAreaID isEqualToString:@"20"]){
        if([[[_arrCheckList valueForKey:@"available"] objectAtIndex:indexPath.row] isEqualToString:@"available"]){
            for (int i = 0; i < [_arrCheckList count]; i++)
            {
                if([[[_arrCheckList valueForKey:@"available"] objectAtIndex:i] isEqualToString:@"available"]){
                    NSMutableDictionary *dic = [_arrCheckList objectAtIndex:i];
                    [dic setValue:@"NO" forKey:@"table_select"];
                    [_arrCheckList removeObjectAtIndex:i];
                    [_arrCheckList insertObject:dic atIndex:i];
                }
            }
            NSMutableDictionary *dic = [_arrCheckList objectAtIndex:indexPath.row];
            [dic setValue:@"YES" forKey:@"table_select"];
            [_arrCheckList removeObjectAtIndex:indexPath.row];
            [_arrCheckList insertObject:dic atIndex:indexPath.row];
            strDinningTableID = [NSString stringWithFormat:@"%@",[[_arrCheckList valueForKey:@"table_id"] objectAtIndex:indexPath.row]];
            [self.clcTnView_Book reloadData];
        }
        
    }
    else{
        if([[[_arrCheckList valueForKey:@"available"] objectAtIndex:indexPath.row] isEqualToString:@"available"]){
            for (int i = 0; i < [_arrCheckList count]; i++)
            {
                if([[[_arrCheckList valueForKey:@"available"] objectAtIndex:i] isEqualToString:@"available"]){
                    NSMutableDictionary *dic = [_arrCheckList objectAtIndex:i];
                    [dic setValue:@"NO" forKey:@"table_select"];
                    [_arrCheckList removeObjectAtIndex:i];
                    [_arrCheckList insertObject:dic atIndex:i];
                }
            }
            NSMutableDictionary *dic = [_arrCheckList objectAtIndex:indexPath.row];
            [dic setValue:@"YES" forKey:@"table_select"];
            [_arrCheckList removeObjectAtIndex:indexPath.row];
            [_arrCheckList insertObject:dic atIndex:indexPath.row];
            strDinningTableID = [NSString stringWithFormat:@"%@",[[_arrCheckList valueForKey:@"table_id"] objectAtIndex:indexPath.row]];
            [self.clcTnView_Book reloadData];
        }
    }
}

#pragma mark - BUTTON METHOD

- (IBAction)click_backCheckAvailability:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)click_ConfirmBooking:(UIButton *)sender {
    if([DataValidation isNullString:strDinningTableID]==YES){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Please select table" preferredStyle:UIAlertControllerStyleAlert];
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
                             _strDinnigAreaID, @"dining_areas_id",
                             strDinningTableID, @"dining_tables_id",
                             _strTimeSlotID, @"timeslot_id",
                             mUser.user_membership_no, @"member_id",
                             _strBookingDate, @"booking_date",
                             @"3", @"dining_type",
                             nil];
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        [arr addObject:dic];
        NSDictionary *dictJsonData = [NSDictionary dictionaryWithObjectsAndKeys:[arr mutableCopy],@"data",nil];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictJsonData options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString;
        if (jsonData && !error)
        {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"JSON: %@", jsonString);
        }
        if ([Utility isNetworkAvailable]) {
            
            [self.view setUserInteractionEnabled:NO];
            [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
            ServerConnection *mServerConnection = [[ServerConnection alloc] init];
            mServerConnection.delegate = self;
            [mServerConnection insert_table_booking:jsonString];
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
- (IBAction)click_Accept:(UIButton *)sender {
    if(![sender isSelected]){
        [sender setSelected:YES];
        strTick = @"YES";
        [sender setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    }
    else{
        [sender setSelected:NO];
        strTick = @"NO";
        [sender setImage:[UIImage imageNamed:@"untick.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - SERVER CONNECTION DELEGATE

-(void)insert_table_booking:(id)result{
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
            ThankYouTableBook *mThankYouTableBook = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouTableBook"];
            mThankYouTableBook.strThankYouMsg = [NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]];
            [self.navigationController pushViewController:mThankYouTableBook animated:NO];
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

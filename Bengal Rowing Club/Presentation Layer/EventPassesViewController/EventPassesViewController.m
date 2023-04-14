//
//  EventPassesViewController.m
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 24/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "EventPassesViewController.h"
#import "EventBookingViewController.h"
#import "EventListCell.h"
#import "Constant.h"

@interface EventPassesViewController ()<ServerConnectionDelegate>{
    SpinnerView *mSpinnerView;
    NSMutableArray *arrEventList;
}
@property (weak, nonatomic) IBOutlet UITableView *tblVw_EventList;

@end

@implementation EventPassesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mSpinnerView = [[SpinnerView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tblVw_EventList.hidden = YES;
    User *mUser = [User new];
    mUser = [Utility getUserInfo];
    arrEventList = [[NSMutableArray alloc] init];
    if ([Utility isNetworkAvailable]) {
        
        [self.view setUserInteractionEnabled:NO];
        [mSpinnerView setOnView:self.view withTextTitle:@"Loading..." withTextColour:[UIColor whiteColor] withBackgroundColour:[UIColor blackColor] animated:YES];
        ServerConnection *mServerConnection = [[ServerConnection alloc] init];
        mServerConnection.delegate = self;
        [mServerConnection event_list:mUser.token];
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
- (IBAction)click_backEventPass:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)click_viewDetails:(UIButton *)sender{
    EventBookingViewController *mEventBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventBookingViewController"];
    mEventBookingViewController.strEventPassID = [[arrEventList valueForKey:@"id"] objectAtIndex:sender.tag];
    [self.navigationController pushViewController:mEventBookingViewController animated:NO];
}

#pragma mark -  tableView Delagate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrEventList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat aspectRatio = 320.0f/420.0f;
    return aspectRatio * [UIScreen mainScreen].bounds.size.height;
    //return 617;//UITableViewAutomaticDimension;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 617;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EventListCell"];
    if (cell==nil)
    {
        cell =(EventListCell *)[[[NSBundle mainBundle] loadNibNamed:@"EventListCell" owner:self options:nil] objectAtIndex:0];
    }
    NSLog(@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EVENTPASSIMAGEURL,[[arrEventList objectAtIndex:indexPath.row]valueForKey:@"event_image"]]]);
   
    
    [cell.imgVw_EventList sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EVENTPASSIMAGEURL,[[arrEventList objectAtIndex:indexPath.row]valueForKey:@"event_image"]]]
    placeholderImage:nil
           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
               if (error) {
                   cell.imgVw_EventList.image = [UIImage imageNamed:@"default_image.jpg"];
               }
               else{
                   [cell.imgVw_EventList setImage:[Utility resizeImageKeepingAspectRatio:image byHeight:cell.imgVw_EventList.frame.size.height]];
               }
           }];
    
    
    cell.lbl_EventName.text = [[arrEventList valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.lbl_EventDate.text = [NSString stringWithFormat:@"%@ to %@",[[arrEventList valueForKey:@"event_date"] objectAtIndex:indexPath.row],[[arrEventList valueForKey:@"event_end_date"] objectAtIndex:indexPath.row]];
    cell.btn_EventDetails.tag = indexPath.row;
    [cell.btn_EventDetails addTarget:self action:@selector(click_viewDetails:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - SERVER CONNECTION DELEGATES

-(void)event_list:(id)result{
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
            
            if([[dict valueForKey:@"data"] valueForKey:@"event_list"]!=nil){
                //[_lbl_NoMsg setHidden:YES];
                for (int i = 0; i<[[[dict valueForKey:@"data"] valueForKey:@"event_list"] count]; i++) {
                    [arrEventList addObject:[[[dict valueForKey:@"data"] valueForKey:@"event_list"] objectAtIndex:i]];
                }
            }
            else{
                //[_lbl_NoMsg setHidden:NO];
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
            _tblVw_EventList.hidden = NO;
            [_tblVw_EventList reloadData];
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

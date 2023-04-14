//
//  MyEventBookingCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 26/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyEventBookingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BookingID;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BookingDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SubmittedDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Status;
@property (weak, nonatomic) IBOutlet UIButton *btn_EventDetails;
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;

@end

NS_ASSUME_NONNULL_END

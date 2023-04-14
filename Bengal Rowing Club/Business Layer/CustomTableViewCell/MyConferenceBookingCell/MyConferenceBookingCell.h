//
//  MyConferenceBookingCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 29/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyConferenceBookingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BookingID;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DinningArea;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimeSlot;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BookingDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimePeriod;
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;

@end

NS_ASSUME_NONNULL_END

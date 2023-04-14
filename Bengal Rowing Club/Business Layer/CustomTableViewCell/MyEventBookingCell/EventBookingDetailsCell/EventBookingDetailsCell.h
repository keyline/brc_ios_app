//
//  EventBookingDetailsCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 26/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventBookingDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BookingID;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PassName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PassNo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoOfPass;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Amount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BookingDate;

@end

NS_ASSUME_NONNULL_END

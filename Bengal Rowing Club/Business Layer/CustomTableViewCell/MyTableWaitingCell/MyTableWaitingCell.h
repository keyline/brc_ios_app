//
//  MyTableWaitingCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 08/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTableWaitingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Member;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DinningArea;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BookingDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimePeriod;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Heads;
@end

NS_ASSUME_NONNULL_END

//
//  WaitingTableBookingCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 05/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaitingTableBookingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_WaitingList;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WaitingName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimeWaiting;
@property (weak, nonatomic) IBOutlet UIButton *btn_Pax;
@property (weak, nonatomic) IBOutlet UIButton *btn_WaitingList;

@end

NS_ASSUME_NONNULL_END

//
//  SportsSlotCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 12/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SportsSlotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_Slot;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimeSlot;

@end

NS_ASSUME_NONNULL_END

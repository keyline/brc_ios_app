//
//  SquashWithMemberCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 25/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SquashWithMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_SportsName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BookingDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimePeriod;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Member1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Member2;
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;
@property (weak, nonatomic) IBOutlet UIView *vw_Back;
@end

NS_ASSUME_NONNULL_END

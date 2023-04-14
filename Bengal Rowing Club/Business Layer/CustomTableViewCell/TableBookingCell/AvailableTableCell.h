//
//  AvailableTableCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 05/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvailableTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_Available;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_Available;
@property (weak, nonatomic) IBOutlet UILabel *lbl_nameAvailable;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TimeAvailable;

@end

NS_ASSUME_NONNULL_END

//
//  DashboardCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 22/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashboardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_MenuName;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_Menu;

@end

NS_ASSUME_NONNULL_END

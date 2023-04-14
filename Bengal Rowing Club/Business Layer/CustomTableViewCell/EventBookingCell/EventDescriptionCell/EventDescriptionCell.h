//
//  EventDescriptionCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 27/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventDescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_Event;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Description;

@end

NS_ASSUME_NONNULL_END

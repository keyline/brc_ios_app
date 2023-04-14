//
//  EventListCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 27/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_EventList;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventDate;
@property (weak, nonatomic) IBOutlet UIButton *btn_EventDetails;

@end

NS_ASSUME_NONNULL_END

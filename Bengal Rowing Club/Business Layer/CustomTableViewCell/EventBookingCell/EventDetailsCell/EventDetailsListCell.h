//
//  EventDetailsListCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 27/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventDetailsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Cost;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Total;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_QTY;

@end

NS_ASSUME_NONNULL_END

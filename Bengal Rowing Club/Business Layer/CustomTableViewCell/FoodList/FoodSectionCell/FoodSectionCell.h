//
//  FoodSectionCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 01/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodSectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_Section;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SectionTitle;

@end

NS_ASSUME_NONNULL_END

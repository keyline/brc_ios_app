//
//  BookTableCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 10/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookTableCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_BookTable;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Booked;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TableSeater;

@end

NS_ASSUME_NONNULL_END

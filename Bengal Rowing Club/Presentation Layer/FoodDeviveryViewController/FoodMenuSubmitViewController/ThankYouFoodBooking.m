//
//  ThankYouFoodBooking.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 13/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "ThankYouFoodBooking.h"
#import "FoodDeviveryViewController.h"

@interface ThankYouFoodBooking ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_ThankYouMessage;
@end

@implementation ThankYouFoodBooking

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lbl_ThankYouMessage.text = _strThankYouMsg;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)click_btnBookAnotherTable:(UIButton *)sender {
    FoodDeviveryViewController *mFoodDeviveryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodDeviveryViewController"];
    [self.navigationController pushViewController:mFoodDeviveryViewController animated:NO];
}

@end

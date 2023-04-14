//
//  ThankYouTableBook.m
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 11/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import "ThankYouTableBook.h"
#import "TableBookingViewController.h"

@interface ThankYouTableBook ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_ThankYouMessage;

@end

@implementation ThankYouTableBook

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
    TableBookingViewController *mTableBookingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableBookingViewController"];
    [self.navigationController pushViewController:mTableBookingViewController animated:NO];
}

@end

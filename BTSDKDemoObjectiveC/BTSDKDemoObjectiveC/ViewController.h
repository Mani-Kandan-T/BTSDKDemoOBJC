//
//  ViewController.h
//  BTSDKDemoObjectiveC
//
//  Created by Manikandan Thiagu on 25/09/25.
//

#import <UIKit/UIKit.h>

@import BraintreeCore;
@import BraintreePayPal;

@interface ViewController : UIViewController

@property (nonatomic, strong) BTPayPalClient *payPalClient;
@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end


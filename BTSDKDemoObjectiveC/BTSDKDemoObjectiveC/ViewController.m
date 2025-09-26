//
//  ViewController.m
//  BTSDKDemoObjectiveC
//
//  Created by Manikandan Thiagu on 25/09/25.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *clientAuthorizationToken = @"sandbox_f252zhq7_hh4cpc39zq4rgjcg";
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:clientAuthorizationToken];
    self.payPalClient = [[BTPayPalClient alloc] initWithAPIClient:self.braintreeClient];
    
    // Initialize and add loading indicator ONCE
    [self setUpLoadingIndicator];
}

- (void)setUpLoadingIndicator {
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.loadingIndicator.center = self.view.center;
    self.loadingIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.loadingIndicator];
}

- (void)testPayPalCheckoutTokenization {
    [self.loadingIndicator startAnimating];
    NSLog(@"Starting PayPal Checkout tokenization...");
    
    BTPayPalCheckoutRequest *request = [[BTPayPalCheckoutRequest alloc]initWithUserAuthenticationEmail:@"" enablePayPalAppSwitch:YES amount:@"10" intent:BTPayPalRequestIntentAuthorize userAction:BTPayPalRequestUserActionContinue offerPayLater:NO currencyCode:@"USD" requestBillingAgreement:YES contactPreference:BTContactPreferenceNone];
    
    // Optional: Configure additional properties
    //    request.userAuthenticationEmail = @"test@example.com";
    //    request.intent = BTPayPalRequestIntentAuthorize; // or BTPayPalRequestIntentSale
    //    request.userAction = BTPayPalRequestUserActionPayNow;
    
    // Optional: Add line items
    //    BTPayPalLineItem *lineItem = [[BTPayPalLineItem alloc] initWithQuantity:@"1"
    //                                                                 unitAmount:@"10.00"
    //                                                                       name:@"Test Item"
    //                                                                       kind:BTPayPalLineItemKindDebit];
    //    request.lineItems = @[lineItem];
    
    // Tokenize
    [self.payPalClient tokenizeWithCheckoutRequest:request completion:^(BTPayPalAccountNonce * _Nullable nonce, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Hide loading indicator
            [self.loadingIndicator stopAnimating];
            if (error) {
                NSLog(@"PayPal Checkout tokenization failed: %@", error.localizedDescription);
                [self showAlert:@"Error" message:error.localizedDescription];
            } else if (nonce) {
                NSLog(@"PayPal Checkout tokenization successful!");
                NSLog(@"Nonce: %@", nonce.nonce);
                NSLog(@"Email: %@", nonce.email);
                NSLog(@"First Name: %@", nonce.firstName);
                NSLog(@"Last Name: %@", nonce.lastName);
                
                // Create detailed message for alert
                NSString *message = [NSString stringWithFormat:@"✅ PayPal Tokenization Successful!\n\n🔑 Nonce:\n%@\n\n📧 Email:\n%@\n\n👤 Name:\n%@ %@\n",
                                     nonce.nonce ?: @"N/A",
                                     nonce.email ?: @"N/A",
                                     nonce.firstName ?: @"N/A",
                                     nonce.lastName ?: @"N/A"];
                
                [self showAlert:@"PayPal Success" message:message];
            }
        });
    }];
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Alert dismissed");
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)createCheckout:(id)sender {
    [self testPayPalCheckoutTokenization];
}

@end

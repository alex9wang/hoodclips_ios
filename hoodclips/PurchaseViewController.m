//
//  PurchaseViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "PurchaseViewController.h"
#import "InAppPurchaseController.h"
#import "UIUtils.h"
#import "AppDelegate.h"

@interface PurchaseViewController ()

@end

@implementation PurchaseViewController

- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemProductId199]) {
            APPDELEGATE.isPurchased = 1;
            [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isPurchased"];
            return;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIUTIL setNavigation:self withTitle:@"SHOP" withImageName:@"icon_shop"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successInAppPurchase:)
                                                 name:IAPHelperProductPurchasedNotification object:nil];
}


- (IBAction)onCart:(id)sender {
    if (![InAppPurchaseController canPurchaseItems]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"You couldn't purchase items in your device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSInteger kPurchaseItemIndex = 0;
    
    InAppPurchaseController* iap = [InAppPurchaseController sharedController];
    [iap requestProductsAtDoneIndex:kPurchaseItemIndex withCompletionHandler:^(BOOL success, NSArray *products) {
        if (success && products.count > 0) {
            [iap buyProductAtIndex:kPurchaseItemIndex];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Something went wrong to connect iTunes."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
}

- (IBAction)onRestore:(id)sender {
    if (![InAppPurchaseController canPurchaseItems]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"You couldn't purchase items in your device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    InAppPurchaseController* iap = [InAppPurchaseController sharedController];
    [iap restoreCompletedProducts];
}




@end

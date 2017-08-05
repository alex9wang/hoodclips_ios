//
//  SearchViewController.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController {
    NSMutableArray      *serverParams;
    NSInteger           currentPageNum;
    NSInteger           currentMaxIndex;
    NSInteger           currentMinIndex;
    BOOL                isRecevied;
    UIRefreshControl*    refreshControl;
    UIRefreshControl*   topRefreshControl;
    NSString *          searchKey;
}
@property(nonatomic, strong) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *vSearchBar;
@property (weak, nonatomic) IBOutlet UIView *vSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@end

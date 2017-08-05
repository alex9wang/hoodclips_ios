//
//  FavoriteViewController.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteViewController : UIViewController
{
    NSMutableArray      *serverParams;
    NSInteger           currentPageNum;
    NSInteger           currentMaxIndex;
    NSInteger           currentMinIndex;
    BOOL                isRecevied;
    UIRefreshControl*   refreshControl;
    UIRefreshControl*   topRefreshControl;
}
@property(nonatomic, strong) IBOutlet UITableView *table;

@end

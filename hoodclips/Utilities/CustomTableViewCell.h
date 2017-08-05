//
//  CustomTableViewCell.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServerParam;
@interface CustomTableViewCell : UITableViewCell
{
    NSString * videoId;
    BOOL  featured;
    ServerParam *item;
}
-(void)setThumbPath : (NSString*) url;
-(void)setDecription : (NSString*) description;
-(void)setViews : (NSString*)site_view;
-(void)setDate : (NSString*) added_date;
-(void)setFeatured : (NSString*) feature;
-(void)setVideoId : (NSString *)vId;
-(void)setItem : (ServerParam *)data;
@property (strong, nonatomic) IBOutlet UIImageView *videoImage;
@property (strong, nonatomic) IBOutlet UILabel *txtDesc;
@property (strong, nonatomic) IBOutlet UILabel *txtViews;
@property (strong, nonatomic) IBOutlet UILabel *txtDate;
@property (strong, nonatomic) IBOutlet UIButton *btnFavorite;

- (IBAction)setFavorite:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblAddedToFavorites;
@property (weak, nonatomic) IBOutlet UIView *tranparentView;

@end

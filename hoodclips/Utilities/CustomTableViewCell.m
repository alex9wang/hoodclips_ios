//
//  CustomTableViewCell.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "WebService.h"
#import "AppDelegate.h"
#import "AllVideoViewController.h"


@implementation CustomTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _videoImage.layer.cornerRadius = 5.0f;
    _videoImage.layer.masksToBounds = YES;
    _lblAddedToFavorites.layer.cornerRadius = 5.0f;
    _lblAddedToFavorites.layer.masksToBounds = YES;
 
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setThumbPath : (NSString*) url
{
    [_videoImage sd_setImageWithURL:[[NSURL alloc] initWithString:url] placeholderImage:[UIImage imageNamed: @"thumb"]];
    
}
-(void)setDecription : (NSString*) description
{
    _txtDesc.text = description;
    
}
-(void)setViews : (NSString*)site_view
{
    _txtViews.text = site_view;
}
-(void)setDate : (NSString*) added_date
{
    _txtDate.text = added_date;
}
-(void)setFeatured : (NSString*) feature
{
    if([feature isEqualToString: @"0"]) {
        [_btnFavorite setImage:[UIImage imageNamed: @"ic_favorite_off"] forState:UIControlStateNormal];
        featured = NO;
    }
    else {
        [_btnFavorite setImage:[UIImage imageNamed: @"ic_favorite_on"] forState:UIControlStateNormal];
        featured = YES;
    }
}
-(void)setVideoId : (NSString *)vId{
    videoId = vId;
}

-(void)setItem : (ServerParam *)data {
    item = data;
}

- (IBAction)setFavorite:(id)sender {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%@", [[AppDelegate shardAppDeleget] getUUID]] forKey:POST_PARAM_DEVICEID];
    [param setObject:[NSString stringWithFormat:@"%@", videoId ] forKey:POST_PARAM_VIDEOID];
    if (featured == YES) {
        [param setObject:POST_PARAM_WEBAPI_REMOVEFAVORITE forKey:post_param_webapi_mode_key];
    }
    else {
        [param setObject:POST_PARAM_WEBAPI_ADDFAVORITE forKey:post_param_webapi_mode_key];
        
    }

    [WEBSERVICE postRequest:SUB_URL_ALLVIDEOS param:param success:^(id responseObject) {
        NSDictionary *json = [responseObject objectFromJSONString];
        NSString* status = [NSString stringWithFormat:@"%@", [json objectForKey:@"status"]] ;
        if ([status isEqualToString:@"success"]) {
            featured = !featured;
            if (featured) {
                [UIView animateWithDuration:1.0f animations:^{
                    
                    [_tranparentView setAlpha:1.0f];
                
                } completion:^(BOOL finished) {
                    
                    //fade out
                    [UIView animateWithDuration:2.0f animations:^{
                        [_btnFavorite setImage:[UIImage imageNamed: @"ic_favorite_on"] forState:UIControlStateNormal];
                        [_tranparentView setAlpha:0.0f];
                        
                    } completion:nil];
                    
                }];
                [item setfavourite:@"1"];
            }
            else {
                [_btnFavorite setImage:[UIImage imageNamed: @"ic_favorite_off"] forState:UIControlStateNormal];
                [item setfavourite:@"0"];

            }
        }
    } failure:^(NSError *error) {
    
    }];

    
}
@end

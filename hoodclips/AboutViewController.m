//
//  AboutViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "AboutViewController.h"
#import "UIUtils.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIUTIL setNavigation:self withTitle:@"ABOUT" withImageName:@"icon_about"];
    
    abouts = @{
                @"CONTACT"  : @[
                                    @{@"name" : @"Facebook",
                                      @"url"  : @"https://www.facebook.com/TheHoodClips"
                                    },
                                    @{@"name" : @"Twitter",
                                      @"url"  : @"https://twitter.com/thehoodclips"
                                      },
                                    @{@"name" : @"Instagram",
                                      @"url"  : @"https://instagram.com/hoodclips/"
                                      },
                                    @{@"name" : @"Website",
                                      @"url"  : @"http://www.hoodclips.com/"
                                      },
                                    @{@"name" : @"Rate This App",
                                      @"url"  : @"https://itunes.apple.com/app/id1013596666"
                                      },
                                ],
                @"LEGAL"    : @[
                                    @{@"name" : @"Terms of Service",
                                      @"url"  : @"http://www.hoodclips.com/page.php?name=terms"
                                      },
                                    @{@"name" : @"Privacy Policy",
                                      @"url"  : @"http://www.hoodclips.com/page.php?name=privacy-policy"
                                      },
                                    @{@"name" : @"DMCA",
                                      @"url"  : @"http://www.hoodclips.com/page.php?name=dmca"
                                      },
                                ]
                };
                    
    aboutSectionTitles = [[abouts allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return aboutSectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *sectionTitle = [aboutSectionTitles objectAtIndex:section];
    NSArray *sectionAbouts = [abouts objectForKey:sectionTitle];
    return sectionAbouts.count;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"AboutCellID"];
    
    NSString *sectionTitle = [aboutSectionTitles objectAtIndex:section];
    
    cell.textLabel.text = sectionTitle;
    [cell setBackgroundColor:[UIColor lightGrayColor]];

    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"AboutCellID" forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"AboutCellID"];
    }
    NSString *sectionTitle = [aboutSectionTitles objectAtIndex:indexPath.section];
    NSArray *sections = [abouts objectForKey:sectionTitle];
    NSDictionary *about = [sections objectAtIndex:indexPath.row];
    NSString *name = [about objectForKey:@"name"];
    
    cell.textLabel.text = name;
    [cell setBackgroundColor:[UIColor whiteColor]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = [aboutSectionTitles objectAtIndex:indexPath.section];
    NSArray *sections = [abouts objectForKey:sectionTitle];
    NSDictionary *about = [sections objectAtIndex:indexPath.row];
    NSString *strUrl = [about objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:strUrl];
    [[UIApplication sharedApplication] openURL:url];
}




@end

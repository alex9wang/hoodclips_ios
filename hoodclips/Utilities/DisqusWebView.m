//
//  DisqusWebView.m
//  hoodclips
//
//  Created by Bong Bong on 27/11/15.
//  Copyright © 2015 mrt. All rights reserved.
//

#import "DisqusWebView.h"
#import "Constants.h"

@implementation DisqusWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) loadThread:(NSString*) threadId {
    
    NSString *htmlString = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"disqus"
                                                                                               ofType:@"html"]
                                                 usedEncoding:NULL
                                                        error: nil];
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"your_thread_id" withString: threadId];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?vid=%@", HOODCLIPS_NET_JOSHUA, WATCH_PHP, threadId];
    //NSString *urlString = [NSString stringWithFormat:@"%@%@", HOODCLIPS_DSIQUS_COM, threadId];
    
    [self loadHTMLString: htmlString baseURL: [NSURL URLWithString: urlString]];
}
@end

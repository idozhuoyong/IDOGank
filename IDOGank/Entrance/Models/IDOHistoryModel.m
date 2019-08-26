//
//  IDOHistoryModel.m
//  IDOGank
//
//  Created by  hrxj_csii_ios on 2018/8/8.
//  Copyright © 2018年 激情工作室. All rights reserved.
//

#import "IDOHistoryModel.h"

@implementation IDOHistoryModel

- (void)setContent:(NSString *)content {
    _content = content;
    
    self.imageArray = [self getImageArrayWithContent:content];
}

-(NSArray*)getImageArrayWithContent:(NSString *)content
{
    if (content == nil || content.length == 0) {
        return nil;
    }
    
    NSMutableArray * imageUrlArray = [NSMutableArray array];
    
    NSError *error;
    NSString *regulaStr = @"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    
    for (NSTextCheckingResult *item in arrayOfAllMatches) {
        NSString *imgHtml = [content substringWithRange:item.range];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];

            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                if (src.length > 0) {
                    [imageUrlArray addObject:src];
                }
                /*
                if (src.length > 0) {
                    int imageWidth = (int)((KUIScreenWidth)-70)/3;
                    if ([src containsString:@"imageView2/2/w/460"]) {
                        src = [src stringByReplacingOccurrencesOfString:@"imageView2/2/w/460" withString:[NSString stringWithFormat:@"imageMogr2/thumbnail/%dx/format/jpg", imageWidth]];
                    }
                    else {
                        src = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/%d/format/jpg",src,imageWidth];
                    }
                    
                    [imageUrlArray addObject:src];
                }
                 */
            }
        }
    }
    
    return [imageUrlArray copy];
}


@end

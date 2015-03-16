//
//  Tweeter.m
//  dmcmrClient
//
//  Created by ryu on 2015/03/07.
//  Copyright (c) 2015年 hanahana. All rights reserved.
//

#import "Tweeter.h"

@implementation Tweeter

-(void)getTweet:(NSString*)TWITTERAPIURL
{
    
    // 生成と同時に各種設定も完了させる例
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"snsデータ更新します" message:@"snsデータ更新を行います" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if(granted){
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            if (accounts != nil && [accounts count] != 0) {
                ACAccount *twAccount = [accounts objectAtIndex:0];
                NSURL *url = [NSURL URLWithString:TWITTERAPIURL];
                NSDictionary *params = [NSDictionary dictionaryWithObject:@"1" forKey:@"include_entities"];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                request.account = twAccount;
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    NSMutableString *tweetstr = [NSMutableString string];
                    
                    if (urlResponse){
                        NSError *jsonError;
                        NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                        
                        if(timeline){
                            
                            for(NSDictionary *tweet in timeline){
                                
                                NSString *tweettext =[tweet objectForKey:@"text"];
                                
                                tweettext = [self rep:tweettext Pattern:@"(https?://[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]+)" Replacement:@"URL"];
                                
                                tweettext = [self rep:tweettext Pattern:@"#[^ ]*" Replacement:@"TAG"];
                                tweettext = [self rep:tweettext Pattern:@"@[^ ]*" Replacement:@"NAME"];
                                
                                //NSLog(@"%@",tweettext);
                                
                                [tweetstr appendString:tweettext];
                                
                            }
                            
                        }else{
                            NSLog(@"error: %@",jsonError);
                        }
                    }
                    
                    NSLog(@"str:%@",tweetstr);
                    
                    
                    [self requestWithURL: [NSURL URLWithString:@"http://ec2-54-178-47-120.ap-northeast-1.compute.amazonaws.com/UserUpdate.php"] parameterWithString:tweetstr];
                    
                }];
            }
        }
    }];
}

-(NSString*)rep:(NSString*)source Pattern:(NSString*)pattern Replacement:(NSString*) replacement{
    
    NSRegularExpression *regexp = [NSRegularExpression
                                   regularExpressionWithPattern:pattern
                                   options:NSRegularExpressionCaseInsensitive
                                   error:nil
                                   ];
    
    NSString *str = [regexp
                     stringByReplacingMatchesInString:source
                     options:NSMatchingReportProgress
                     range:NSMakeRange(0, source.length)
                     withTemplate:replacement
                     ];
    
    return str;
    
}



- (id) requestWithURL:(NSURL *)urlWithString parameterWithString:(NSString *)parameterWithString
{
    // URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlWithString];
    // set header XML
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-type"];
    // set POST
    [request setHTTPMethod:@"POST"];
    // set XML to body
    [request setHTTPBody:[parameterWithString dataUsingEncoding:NSUTF8StringEncoding]];
    // response（結果）
    NSHTTPURLResponse *response = nil;
    // error
    NSError *error = nil;
    
    // 戻り値, 送信
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    // error
    if (error)
    {
        NSLog(@"url error");
    }
    
    return data;
}



@end

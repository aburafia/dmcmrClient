//
//  TestViewController.m
//  dmcmrClient
//
//  Created by ryu on 2015/03/07.
//  Copyright (c) 2015年 hanahana. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//クリック時にキーワードをサーバーに登録。ユーザーIDをキーにする
- (IBAction)onTouchDownRegist:(id)sender {
    
    NSString *urs_str = [NSString stringWithFormat:@"http://%@/index.php?uuid=%@&lastkeyword=%@", @"ec2-54-150-206-156.ap-northeast-1.compute.amazonaws.com", [[UIDevice currentDevice] identifierForVendor].UUIDString, _KeywordsTextView.text];
    
    NSLog(@"%@",urs_str);
    
    // 送信するリクエストを生成する。
    NSURL *url = [NSURL URLWithString:urs_str];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // リクエストを送信する。
    // 第３引数のブロックに実行結果が渡される。
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            // エラー処理を行う。
            if (error.code == -1003) {
                NSLog(@"not found hostname. targetURL=%@", url);
            } else if (-1019) {
                NSLog(@"auth error. reason=%@", error);
            } else {
                NSLog(@"unknown error occurred. reason = %@", error);
            }
            
        } else {
            int httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (httpStatusCode == 404) {
                NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
                // } else if (・・・) {
                // 他にも処理したいHTTPステータスがあれば書く。
                
            } else {
                NSLog(@"success request!!");
                NSLog(@"statusCode = %ld", (long)((NSHTTPURLResponse *)response).statusCode);
                NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                
                // ここはサブスレッドなので、メインスレッドで何かしたい場合には
                dispatch_async(dispatch_get_main_queue(), ^{
                    // ここに何か処理を書く。
                });
            }
        }
    }];
    
    
    //
    
    
}
@end

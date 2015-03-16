//
//  TestViewController.h
//  dmcmrClient
//
//  Created by ryu on 2015/03/07.
//  Copyright (c) 2015年 hanahana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *KeywordsTextView;

- (IBAction)onTouchDownRegist:(id)sender;

@end

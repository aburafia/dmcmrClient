//
//  BootViewController.m
//  dmcmrClient
//
//  Created by ryu on 2014/07/06.
//  Copyright (c) 2014年 hanahana. All rights reserved.
//

#import "BootViewController.h"

@interface BootViewController ()

@end

@implementation BootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //この辺りで、別スレッド起こして、SNSデータの収集と、集計、送信をやるんだとおもう。
    //この辺りの処理はappDelegateにまかせていいのかな    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickLogin:(id)sender {
    
}
@end

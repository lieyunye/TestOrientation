//
//  ViewController.m
//  TestOrientation
//
//  Created by lieyunye on 2/23/16.
//  Copyright © 2016 lieyunye. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "OrientationHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)portraitAction:(id)sender {
    [[OrientationHelper sharedClient] setToPortraitMode];

}

- (IBAction)landscapeAction:(id)sender {
    [[OrientationHelper sharedClient] setToLandScapeMode];
}



- (IBAction)popAction:(id)sender {
    
    ViewController1 *vc = [[ViewController1 alloc] initWithNibName:NSStringFromClass([ViewController1 class]) bundle:nil];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}


- (IBAction)pushAction:(id)sender {
    ViewController2 *vc = [[ViewController2 alloc] initWithNibName:NSStringFromClass([ViewController2 class]) bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

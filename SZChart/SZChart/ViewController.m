//
//  ViewController.m
//  SZChart
//
//  Created by Shuze Pang on 2017/3/28.
//  Copyright © 2017年 suze. All rights reserved.
//

#import "ViewController.h"
#import "SZChartKit.h"
#import "SZChartManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bottomImgView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgView.image = [[SZChartManager sharedInstance] drawImage:[_imgView frame] withType:SZChartTypeSolidLine withScale:1.0];
    _bottomImgView.image = [[SZChartManager sharedInstance] drawImage:[_imgView frame] withType:SZChartTypeSmoothLine withScale:1.0];

}


#pragma mark - action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

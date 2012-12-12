//
//  VCTest3.m
//  Test3D
//
//  Created by gdlab on 12/12/3.
//
//

#import "VCTest3.h"

@interface VCTest3 ()

@end

@implementation VCTest3
@synthesize vEditView;

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
    [super viewDidLoad];
	
    [CCDirector setDirectorType:kCCDirectorTypeDisplayLink];
    CCDirector *director = [CCDirector sharedDirector];
    [director setAnimationInterval:1.0/30];
    [director setDisplayFPS:YES];
    
    EAGLView *glView = [CC3EAGLView viewWithFrame:self.view.frame
                                      pixelFormat:kEAGLColorFormatRGBA8
                                      depthFormat:GL_DEPTH24_STENCIL8_OES
                               preserveBackbuffer:NO
                                       sharegroup:Nil
                                    multiSampling:NO
                                  numberOfSamples:4];
    
    [glView setMultipleTouchEnabled:YES];
    
    [director setOpenGLView:glView];
    
    if (![director enableRetinaDisplay:YES]) {
        CCLOG(@"Retina Display Not supported");
    }
    
    self.view = glView;
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    CCScene *scene = [CCScene node];
    [scene addChild:[MainLayer node]];
    [[CCDirector sharedDirector] runWithScene:scene];
    
    //uiview 顯示題目
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 200)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor blackColor];
    title.frame = CGRectMake(384 - 50, 5, 100, 50);
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [title setFont:[UIFont fontWithName:@"Arial"  size:32]];
    title.text = @"活動三";
    
    UILabel *content = [[UILabel alloc] init];
    content.textColor = [UIColor blackColor];
    content.frame = CGRectMake(384 - 370, 55, 740, 150);
    content.textAlignment = NSTextAlignmentLeft;
    content.backgroundColor = [UIColor clearColor];
    [content setFont:[UIFont fontWithName:@"Arial"  size:16]];
    content.text = @"        這裡有一些圖形，現在要請你想出一幅完整的圖畫或是一件新發明，讓它包含下列所有的圖形。\n        你可以將這些圖形轉方向、擴大、縮小或是將幾個圖形組合成一個圖形，但是必須符合這些圖形原來的形狀；除了這些圖形之外，可以加上其他的東西；\n        請你儘量想出別人想不到的圖案、故事或發明，畫完之後幫它取一個名字或下一個標題，寫在底下畫線的地方。同樣的，也請你想出一個特別的標題，讓圖畫變得更有意思，（請你根據下面的圖形，將你要畫的圖案或物品，畫在下一頁的空白處，注意：不能改變下列圖形原有的形狀，並且每個圖形只能出現一次）。（十分鐘）";;
    content.lineBreakMode = NSLineBreakByCharWrapping;
    content.numberOfLines = 0;
    
    [view addSubview:title];
    [view addSubview:content];
    [self.view addSubview:view];
}

- (void)dealloc
{
    [vEditView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

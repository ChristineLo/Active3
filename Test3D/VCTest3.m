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

@synthesize ulCountDownTime;
@synthesize toolBar;
@synthesize smallView;

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
    director = [CCDirector sharedDirector];
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
    
    [self.smallView addSubview:glView];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    CCScene *scene = [CCScene node];
    [scene addChild:[MainLayer node]];
    [[CCDirector sharedDirector] runWithScene:scene];
        
    //計時器
    iActionTime = 20;
    //iActionTime = iActionTime * 60;
    tCountDownTimer = [[NSTimer alloc] init];
    tCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownSelector) userInfo:nil repeats:YES];
}
//update count down label
- (void) countDownSelector
{
    
    
    if (iActionTime == 30) {
        ulCountDownTime.textColor = [UIColor redColor];
    }
    else if (iActionTime == 0)
    {
        [tCountDownTimer invalidate];
        tCountDownTimer = Nil;
        [self addLeafAlert];
    }
    if (iActionTime/60 < 10) {
        ulCountDownTime.text = [NSString stringWithFormat:@"0%d:",iActionTime/60];
    }
    else
    {
        ulCountDownTime.text = [NSString stringWithFormat:@"%d:",iActionTime/60];
    }
    if (iActionTime%60 < 10) {
        ulCountDownTime.text = [ulCountDownTime.text stringByAppendingFormat:@"0%d", iActionTime%60];
    }
    else
    {
        ulCountDownTime.text = [ulCountDownTime.text stringByAppendingFormat:@"%d", iActionTime%60];
    }
    --iActionTime;
}
//離開提示
- (void) addLeafAlert
{
    UIAlertView *leafAlert = [[UIAlertView alloc] initWithTitle:@"作答結束！" message:Nil delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
    [leafAlert show];
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //移除3Dscene
    [director popScene];
    NSLog(@"cancel button index:%d",buttonIndex);
    UIStoryboard *secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"Word4"] animated:YES completion:Nil];
}

-(IBAction)leafButtonClicked:(id)sender
{
    [director popScene];
    UIStoryboard *secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"Word4"] animated:YES completion:Nil];
}

- (void)dealloc
{
    NSLog(@"dealloc");
    [toolBar release];
    [ulCountDownTime release];
    [smallView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"ReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

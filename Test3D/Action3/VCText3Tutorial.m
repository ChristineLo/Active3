//
//  VCText3Tutorial.m
//  Test3D
//
//  Created by gdlab on 12/12/27.
//
//

#import "VCText3Tutorial.h"

@interface VCText3Tutorial ()

@end

@implementation VCText3Tutorial
@synthesize undoButton;
@synthesize redoButton;
@synthesize clearButton;
@synthesize eraserButton;
@synthesize whitePenButton;
@synthesize blackPenButton;
@synthesize defaultButton;
@synthesize rotateButton;
@synthesize depthButton;
@synthesize switchButton;
@synthesize curColor;

@synthesize ulCountDownTime;
@synthesize toolBar;
@synthesize smallView;

- (void)viewDidLoad
{
    [self showTeachImage];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //沒有顯示的時候
    if ([self isViewLoaded] && self.view.window == nil) {
        NSLog(@"VCT3T MemoryWarning");
        [[CCDirector sharedDirector] purgeCachedData];
    }
    //正在顯示
    else if ([self isViewLoaded] && self.view.window != nil) {
        NSLog(@"VCT3 單頁記憶體不足");
        Test3DAppDelegate *delegate = (Test3DAppDelegate*)[[UIApplication sharedApplication] delegate];
        //儲存後從新載入畫布
        [slv save2File:kFILE_ANS filefolder:delegate.TestNumberString];
        [self reloadDrawImage:delegate];
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCDirector sharedDirector] stopAnimation];
    [[director openGLView] removeFromSuperview];
    [director end];
    self.view = nil;
}

-(void) reloadDrawImage:(Test3DAppDelegate*)del {
    NSString  *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/Active3.png",del.TestNumberString]];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image) {
        [slv loadFromAlbumButtonClicked:image];
    }
    //[path release];
}

- (void) initAct3t{
    [super viewDidLoad];
    
    [self init3D];
    [self initDraw];
    
    [self initButton];
    
    editState = TWO_D;
    [self checkEditState];
    
    UIButton *skipButton = (UIButton*) [self.view viewWithTag: 2001];
    [skipButton addTarget:self action:@selector(switchNextAction) forControlEvents:UIControlEventTouchUpInside];
    if (skipButton == NULL) {
        NSLog(@"button is null");
    }
}

-(void) showTeachImage {
    backNum = 0;
    teach = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"act3t%d",backNum]]];
    [self.view addSubview:teach];
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [skipButton setTag:5001];
    [skipButton setFrame: CGRectMake(300, 950, 200, 40)];
    [skipButton setTitle:@"下一個" forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(nextTeachImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
}

-(void) nextTeachImage {
    if (teach.image) {
        teach.image = nil;
    }
    if (++backNum < 3) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"act3t%d",backNum] ofType:@"png"];
        [teach setImage:[UIImage imageWithContentsOfFile:path]];
        path = nil;
    }
    else {
        //最後一個教學圖離開時，要delay？
        id ob = [self.view viewWithTag:5001];
        [ob removeFromSuperview];
         
        [teach removeFromSuperview];
        [self initAct3t];
        teach.image = nil;
        [teach release];
    }
}

//進入活動三頁面
-(void)switchNextAction{
    [director popScene];
    
    UIStoryboard *secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACT3"] animated:YES completion:Nil];
}

- (void)init3D
{
    [CCDirector setDirectorType:kCCDirectorTypeDisplayLink];
    director = [CCDirector sharedDirector];
    [director setAnimationInterval:1.0/30];
    [director setDisplayFPS:NO];
    
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
    
    threeDLayer = [MainLayer node];
    CCScene *scene = [CCScene node];
    [scene addChild:threeDLayer];
    [[CCDirector sharedDirector] runWithScene:scene];
    //一開始的編輯模式
    [threeDLayer setEditMode:EMode3DTransfer];
}

- (void)initDraw
{
    slv = [[[SmoothLineView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + kMENU_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - kMENU_HEIGHT)] autorelease];
    slv.delegate = self;
    
    [smallView addSubview:slv];
    
    self.curColor = [UIColor blackColor];
}

-(void) dealloc {
    [[CCDirector sharedDirector] release];
    [threeDButtons dealloc];
    [twoDButtons dealloc];
    [slv dealloc];
    [tCountDownTimer dealloc];
    [ulCountDownTime dealloc];
    [threeDLayer dealloc];
    [super dealloc];
}

-(void)setButtonAttrib:(UIGlossyButton*)_button
{
    [_button useWhiteLabel: YES];
    _button.buttonCornerRadius = 2.0; _button.buttonBorderWidth = 1.0f;
	[_button setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    _button.tintColor = _button.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

- (void) initButton
{
    undoButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1001];
    [self setButtonAttrib:undoButton];
    
    redoButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1002];
    [self setButtonAttrib:redoButton];
    
    clearButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1003];
    [self setButtonAttrib:clearButton];
    
    eraserButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1004];
    [self setButtonAttrib:eraserButton];
        
    blackPenButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1005];
    [self setButtonAttrib:blackPenButton];
    
    whitePenButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1006];
    [self setButtonAttrib:whitePenButton];
    
    [blackPenButton setEnabled: YES];
    [whitePenButton setEnabled: YES];
    
    if (twoDButtons == NULL) {
        twoDButtons = [[NSArray arrayWithObjects:undoButton, redoButton, clearButton, eraserButton, blackPenButton, whitePenButton, nil] retain];
    }
    
    defaultButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1008];
    [self setButtonAttrib:defaultButton];
    
    rotateButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1009];
    [self setButtonAttrib:rotateButton];
    
    depthButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1010];
    [self setButtonAttrib:depthButton];
    
    if (threeDButtons == NULL) {
        threeDButtons = [[NSArray arrayWithObjects:defaultButton, rotateButton, depthButton, nil] retain];
    }
    
    switchButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1007];
    [self setButtonAttrib:switchButton];
    [switchButton setEnabled:YES];
}

-(void) setThreeDButtonVisible:(BOOL) isEnable
{
    for (UIGlossyButton *aButton in threeDButtons) {
        [aButton setHidden:!isEnable];
        [aButton setEnabled:isEnable];
    }
}

-(void) setTwoDButtonVisible:(BOOL) isEnable
{
    for (UIGlossyButton *aButton in twoDButtons) {
        [aButton setHidden:!isEnable];
    }
}

-(void) checkEditState {
    switch (editState) {
        case THREE_D:
            [[CCDirector sharedDirector] startAnimation];
            [slv setUserInteractionEnabled:NO];
            [slv setIsAccessibilityElement:NO];

            [smallView setMultipleTouchEnabled:YES];
            UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGuestureHandler:)];
            [smallView addGestureRecognizer:pinch];
            
            [self setThreeDButtonVisible:YES];
            [self setTwoDButtonVisible:NO];
            break;
        case TWO_D:
            [[CCDirector sharedDirector] stopAnimation];
            [slv setUserInteractionEnabled:YES];
            [slv setIsAccessibilityElement:YES];
            [smallView removeGestureRecognizer:[smallView.gestureRecognizers lastObject]];
            
            [self setThreeDButtonVisible:NO];
            [self setTwoDButtonVisible:YES];
            break;
        default:
            break;
    }
}

#pragma mark Guesture Movement
-(void) pinchGuestureHandler:(UIPinchGestureRecognizer*) guesture
{
    [threeDLayer scaleModel:guesture.scale];
}

#pragma mark Button Click Event

-(IBAction)undoButtonClicked:(id)sender
{
    [slv undoButtonClicked];
    
}

-(IBAction)redoButtonClicked:(id)sender
{
    [slv redoButtonClicked];
    
}

-(IBAction)clearButtonClicked:(id)sender
{
    [slv clearButtonClicked];
}

-(IBAction)eraserButtonClicked:(id)sender
{
    [slv eraserButtonClicked];
}

-(IBAction)blackPenButtonClicked:(id)sender
{
    [slv drawButtonClicked];
    slv.lineColor = [UIColor blackColor];
}

-(IBAction)whitePenButtonClicked:(id)sender
{
    [slv drawButtonClicked];
    slv.lineColor = [UIColor whiteColor];
}

-(IBAction)defaultButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DTransfer];
}
-(IBAction)rotateButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DRotate];
}
-(IBAction)depthButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DZDepth];
}

-(IBAction)switchEditStateButtonClicked:(id)sender
{
    (editState == THREE_D)? (editState = TWO_D): (editState = THREE_D);
    [self checkEditState];
}

#pragma mark toolbarDelegate
-(void) setUndoButtonEnable:(NSNumber*)isEnable
{
    [undoButton setEnabled:[isEnable boolValue]];
}
-(void) setRedoButtonEnable:(NSNumber*)isEnable
{
    [redoButton setEnabled:[isEnable boolValue]];
}
-(void) setClearButtonEnable:(NSNumber*)isEnable
{
    [clearButton setEnabled:[isEnable boolValue]];
}
-(void) setEraserButtonEnable:(NSNumber*)isEnable
{
    [eraserButton setEnabled:[isEnable boolValue]];
}
-(void) setBlackPenButtonEnable:(NSNumber*)isEnable
{
    [blackPenButton setEnabled:[isEnable boolValue]];
}
-(void) setWhitePenButtonEnable:(NSNumber*)isEnable
{
    [whitePenButton setEnabled:[isEnable boolValue]];
}
/*cocos2d*/
- (void)applicationWillResignActive:(UIApplication *)application {
    
     [[CCDirector sharedDirector] pause];
}

/** Resume the cocos3d/cocos2d action. */
-(void) resumeApp { [[CCDirector sharedDirector] resume];
}

- (void)applicationDidBecomeActive: (UIApplication*) application {
	
     // Workaround to fix the issue of drop to 40fps on iOS4.X on app resume.
     // Adds short delay before resuming the app.
     [NSTimer scheduledTimerWithTimeInterval: 0.5f
     target: self
     selector: @selector(resumeApp)
     userInfo: nil
     repeats: NO];
     
     // If dropping to 40fps is not an issue, remove above, and uncomment the following to avoid delay.
     //	[self resumeApp];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[director openGLView] removeFromSuperview];
     [director end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}
@end

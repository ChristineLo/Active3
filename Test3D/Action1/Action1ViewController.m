//
//  Action1ViewController.m
//  Test3D
//
//  Created by Mac06 on 13/1/9.
//
//

#import "Action1ViewController.h"

@interface Action1ViewController ()

@end

@implementation Action1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    minutes = seconds= PressCount =0;
    secondsLeft = 300;
    
    AnswerDic = [[NSMutableDictionary alloc]init];
    saveFile = [[FileOPs alloc]init];
    addTeachingWord = [[addTeachWord alloc] init];
    [addTeachingWord addTeachingWordString:@"    假想你能夠直接跟這個世界上各種動物溝通，你可能會碰到什麼樣的問題？請列舉越多問題越好。請特別注意！你是跟動物溝通發生問題，而不是「你要問動物什麼問題」或是「動物要問你什麼問題」。\n\n這個活動時間是五分鐘。" title:@"活動一"];
    //[addTeachingWord addTeachingWordImage:@"TeachingWord1.png" :70 :350 :620 :120];
    addTeachingWord.delegate = self;
    [self.view addSubview:addTeachingWord.view];
    [self addChildViewController:addTeachingWord];
#if DEMO
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [skipButton setFrame: CGRectMake(712, 5, 50, 44)];
    [skipButton setTitle:@"下一步" forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(OkBtnAddToView) forControlEvents:UIControlEventTouchUpInside];
    if (skipButton == NULL) {
        NSLog(@"button is null");
    }
    [self.view addSubview:skipButton];
#endif
}

//按下後開始計時
-(void)StartCountDownTimer:(id)sender{
    tellTimeStart = [[UIAlertView alloc] initWithTitle:@"活動一" message:@"五分鐘計時開始!!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    tellTimeStart.tag = 0;
    [tellTimeStart show];
}

-(void) viewDidDisappear:(BOOL)animated {
    image = nil;
    if (timer)
    {
        [timer invalidate];
    }
}

//顯示題目一，時間
-(void)Question1AddToView{
    
    image = [UIImage imageNamed:@"ActionQuestion1.png"];
    imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(10, 70, 750, 190);
    [self.view addSubview:imageView];
    
    tip = [[UILabel alloc]initWithFrame:CGRectMake(50, 650, 700, 60)];
    tip.backgroundColor = [UIColor clearColor];
    tip.textColor = [UIColor redColor];
    tip.font = [UIFont systemFontOfSize:25];
    tip.text = @"請按照順序填寫，填寫格可用手指往上拖移,下面還有喔!!!";
    [self.view addSubview:tip];
    
    countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(340, 20, 200, 60)];
    countdownLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:countdownLabel];
    [self setAnswerText];
}

//更新時間
-(void)updateCountDownTimer{
    
    if (secondsLeft>0) {
        //NSLog(@"count down");
        secondsLeft--;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        countdownLabel.font = [UIFont systemFontOfSize:25];
        countdownLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    else{
        [timer invalidate];
        timer=nil;
        [self OkBtnAddToView];
    }
    
}

//設定填寫格
-(void) setAnswerText {
    int dis = 60;
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(70, 250, 650, 400)];
    scrollView.contentSize = CGSizeMake(650, 2800);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i=0; i<45; i++) {
        UILabel *Number = [[UILabel alloc]initWithFrame:CGRectMake(0, 0+i*dis, 40, 50)];
        Number.text=[NSString stringWithFormat:@"%d.",i+1];
        [scrollView addSubview:Number];
        [Number release];
        
        UITextView *QText = [[UITextView alloc]initWithFrame:CGRectMake(40, 0+i*dis, 600, 50)];
        
        [QText setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1]];
        QText.font = [UIFont systemFontOfSize:20];
        QText.tag = i+1;
        //NSLog(@"QText tag :%i\n",QText.tag);
        [scrollView addSubview:QText];
        
    }
    
    
}

//填寫完成，時間停止
-(void) OkBtnAddToView{
    
    tellTimeStop = [[UIAlertView alloc] initWithTitle:@"活動一" message:@"時間到，停止作答!!\n進入下一活動" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    tellTimeStop.tag = 1;
    [tellTimeStop show];
    
}


//將封面個人資料取出，整合活動一資料存檔，並跳到活動二
-(void) saveAnswerText{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    tempDic = [saveFile readFromJsonFile];//取出封面個人資料
    [AnswerDic setDictionary:tempDic];
    //NSLog(@"%@-----------------------------",[AnswerDic description]);
    
    UITextField *QText1 = (UITextField*)[scrollView viewWithTag:1];
    
    if ([QText1.text isEqualToString:@""] || QText1.text ==NULL) {
        [AnswerDic setObject:@"無" forKey:@"Ac1Q1"];
        [QText1 release];
        
        for (int i=1; i<44; i++) {
            UITextField *QText = (UITextField*)[scrollView viewWithTag:i+1];
            if (![QText.text isEqualToString:@""] && QText.text != NULL) {
                [AnswerDic setObject:QText.text forKey:[NSString stringWithFormat:@"Ac1Q%d",i+1]];
            }
            [QText release];
        }
    }
    else{
        for (int i=0; i<45; i++) {
            UITextField *QText = (UITextField*)[scrollView viewWithTag:i+1];
            if (![QText.text isEqualToString:@""] && QText.text != NULL) {
                [AnswerDic setObject:QText.text forKey:[NSString stringWithFormat:@"Ac1Q%d",i+1]];
            }
            [QText release];
        }
    }
    /*
    for (int i = 0; i<[AnswerDic count]; i++) {
        NSLog(@"%@ = %@", [[AnswerDic allKeys] objectAtIndex:i], [[AnswerDic allValues] objectAtIndex:i]);
    }*/
    
    [saveFile saveToJsonFile:AnswerDic];//將上述資料存檔
    [tempDic release];
    [self switchToAction2];//跳到活動二
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 0:
            //printf("alertView tag 0 ");
            switch (buttonIndex) {
                case 0:
                    break;
                case 1:
                    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountDownTimer) userInfo:nil repeats:YES];
                    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
                    [addTeachingWord.view removeFromSuperview];
                    [addTeachingWord removeFromParentViewController];
                    [self Question1AddToView];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (buttonIndex) {
                case 0:
                    [self saveAnswerText];
                    break;
            }
            break;
        default:
            break;
    }
    
}

//進入活動二頁面
-(void)switchToAction2{
    Storyboard = self.storyboard;
    [self presentViewController:[Storyboard instantiateViewControllerWithIdentifier:@"ACT2"] animated:YES completion:Nil];
}

-(void)dealloc{
    NSLog(@"Action1 release");
    [scrollView release];
    [countdownLabel release];
    [image release];
    [imageView release];
    
    [StartBtn release];
    [OkBtn release];
    [saveFile release];
    [AnswerDic release];
    [addTeachingWord release];
    [tip release];
    [tellTimeStart release];
    [tellTimeStop release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if([self isViewLoaded] && self.view.window == nil)
    {
        image = nil;
        self.view = nil;
    }
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
@end

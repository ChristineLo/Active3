//
//  Action2ViewController.m
//  Test3D
//
//  Created by Mac06 on 13/1/9.
//
//

#import "Action2ViewController.h"

@interface Action2ViewController ()

@end

@implementation Action2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    minutes = seconds =0;
    secondsLeft = 300;
    
    saveFile = [[FileOPs alloc]init];
    AnswerDic = [[NSMutableDictionary alloc]init];
    addTeachingWord = [[addTeachWord alloc] init];
    [addTeachingWord addTeachingWordString:@"    假想這是一個真實發生的情境：「這時候正在下大雨，但是路上的行人們走在雨中，且沒有拿任何雨具（雨衣或雨傘）或遮蔽物，卻沒有淋溼。」是什麼原因，才會導致這樣的情形發生呢？請你儘量列出各種可能的原因，寫在下面的格子中;請你儘可能猜測各種原因，而不必擔心這個想法不好。\n\n這個活動時間是五分鐘。" title:@"活動二"];
    //[addTeachingWord addTeachingWordImage:@"TeachingWord2.png" :90 :300 :620 :160];
    addTeachingWord.delegate = self;
    [self.view addSubview:addTeachingWord.view];
    [self addChildViewController:addTeachingWord];
#if DEMO
    UIButton *skipButton = (UIButton*) [self.view viewWithTag: 2001];
    [skipButton addTarget:self action:@selector(OkBtnAddToView) forControlEvents:UIControlEventTouchUpInside];
    if (skipButton == NULL) {
        NSLog(@"button is null");
    }
    
#else
    UIButton *skipButton = (UIButton*) [self.view viewWithTag: 2001];
    [skipButton removeFromSuperview];
#endif
}

-(void) viewDidDisappear:(BOOL)animated {
    [timer invalidate];
}

//按下後開始計時
-(void)StartCountDownTimer:(id)sender{
    tellTimeStart = [[UIAlertView alloc] initWithTitle:@"活動二" message:@"五分鐘計時開始!!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    tellTimeStart.tag = 0;
    [tellTimeStart show];
}

//顯示題目二，時間
-(void)Question1AddToView{
    
    image = [UIImage imageNamed:@"ActionQuestion2.png"];
    imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(10, 70, 750, 325);
    [self.view addSubview:imageView];
    
    tip = [[UILabel alloc]initWithFrame:CGRectMake(50, 810, 700, 60)];
    tip.backgroundColor = [UIColor clearColor];
    tip.textColor = [UIColor redColor];
    tip.font = [UIFont systemFontOfSize:25];
    tip.text = @"請按照順序填寫，填寫格可用手指往上拖移,下面還有喔!!!";
    [self.view addSubview:tip];
    
    countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 20, 200, 60)];
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
        timer = nil;
        [self OkBtnAddToView];
    }
    
}

//設定填寫格
-(void) setAnswerText {
    int dis = 60;
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(70, 400, 650, 400)];
    scrollView.contentSize = CGSizeMake(650, 2600);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i=0; i<42; i++) {
        UILabel *Number = [[UILabel alloc]initWithFrame:CGRectMake(0, 0+i*dis, 40, 50)];
        Number.text=[NSString stringWithFormat:@"%d.",i+1];
        [scrollView addSubview:Number];
        [Number release];
        
        UITextView *QText = [[UITextView alloc]initWithFrame:CGRectMake(40, 0+i*dis, 600, 50)];
        //QText.borderStyle = UITextBorderStyleBezel;
        [QText setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1]];
        QText.font = [UIFont systemFontOfSize:20];
        QText.tag = i+1;
        //NSLog(@"QText tag :%i\n",QText.tag);
        [scrollView addSubview:QText];
        
    }
    
    
}

//填寫完成，時間停止
-(void) OkBtnAddToView{
    
    tellTimeStop = [[UIAlertView alloc] initWithTitle:@"活動二" message:@"時間到，停止作答!!\n進入下一活動" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    tellTimeStop.tag = 1;
    [tellTimeStop show];
}

//將個人資料、活動一資料取出，整合活動二資料存檔，並跳到活動三
-(void) saveAnswerText{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    tempDic = [saveFile readFromJsonFile];//取出個人資料、活動一資料
    [AnswerDic setDictionary:tempDic];
    
    UITextField *QText1 = (UITextField*)[scrollView viewWithTag:1];
    
    if ([QText1.text isEqualToString:@""] || QText1.text ==NULL) {
        [AnswerDic setObject:@"無" forKey:@"Ac2Q1"];
        [QText1 release];
        
        for (int i=1; i<41; i++) {
            UITextField *QText = (UITextField*)[scrollView viewWithTag:i+1];
            if (![QText.text isEqualToString:@""] && QText.text != NULL) {
                [AnswerDic setObject:QText.text forKey:[NSString stringWithFormat:@"Ac2Q%d",i+1]];
            }
            [QText release];
        }
    }
    else{
        for (int i=0; i<42; i++) {
            UITextField *QText = (UITextField*)[scrollView viewWithTag:i+1];
            if (![QText.text isEqualToString:@""] && QText.text != NULL) {
                [AnswerDic setObject:QText.text forKey:[NSString stringWithFormat:@"Ac2Q%d",i+1]];
            }
            [QText release];
        }
    }
    
    for (int i = 0; i<[AnswerDic count]; i++) {
        NSLog(@"%@ = %@", [[AnswerDic allKeys] objectAtIndex:i], [[AnswerDic allValues] objectAtIndex:i]);
    }
    
    [saveFile saveToJsonFile:AnswerDic];//將上述資料存檔
    [tempDic release];
    [self switchToAction3];//跳到活動三
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
                    //NSLog(@"timer start");
                    [addTeachingWord.view removeFromSuperview];
                    [addTeachingWord removeFromParentViewController];
                    [self Question1AddToView];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            //printf("alertView tag 1 ");
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

//進入活動三頁面
-(void)switchToAction3{
    secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"VT3T"] animated:YES completion:Nil];
}
-(void)dealloc{
    NSLog(@"Action2 release");
    [scrollView release];
    [countdownLabel release];
    [imageView release];
    [image release];
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
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
@end

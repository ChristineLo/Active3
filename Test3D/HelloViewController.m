//
//  HelloViewController.m
//  Test3D
//
//  Created by gdlab on 12/12/3.
//
//

#import "HelloViewController.h"
#import "VCTest3.h"

@implementation HelloViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    //uiview 顯示題目
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 200)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor blackColor];
    title.frame = CGRectMake(384 - 100, 10, 200, 60);
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [title setFont:[UIFont fontWithName:@"Arial"  size:40]];
    title.text = @"活動三";
    
    UILabel *content = [[UILabel alloc] init];
    content.textColor = [UIColor blackColor];
    content.frame = CGRectMake(384 - 350, title.bounds.origin.y + title.bounds.size.height + 20, 700, 500);
    content.textAlignment = NSTextAlignmentLeft;
    content.backgroundColor = [UIColor clearColor];
    [content setFont:[UIFont fontWithName:@"Arial"  size:30]];
    content.text = @"        這裡有一些圖形，現在要請你想出一幅完整的圖畫或是一件新發明，讓它包含下列所有的圖形。\n\n        你可以將這些圖形轉方向、擴大、縮小或是將幾個圖形組合成一個圖形，但是必須符合這些圖形原來的形狀；除了這些圖形之外，可以加上其他的東西；\n\n        請你儘量想出別人想不到的圖案、故事或發明，畫完之後幫它取一個名字或下一個標題，寫在底下畫線的地方。同樣的，也請你想出一個特別的標題，讓圖畫變得更有意思，（請你根據下面的圖形，將你要畫的圖案或物品，畫在下一頁的空白處，注意：不能改變下列圖形原有的形狀，並且每個圖形只能出現一次）。\n\n（計時十分鐘）";
    content.lineBreakMode = NSLineBreakByCharWrapping;
    content.numberOfLines = 0;
    
    [view addSubview:title];
    [view addSubview:content];
    [self.view addSubview:view];
}

- (IBAction)start:(UIButton *)sender {
    UIStoryboard *secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACT3"] animated:YES completion:Nil];
    //[self presentViewController:[[VCTest3 alloc] init] animated:YES completion:Nil];
}
@end

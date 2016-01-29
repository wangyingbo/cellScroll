//
//  ViewController.m
//  demo
//
//  Created by 王迎博 on 15/12/22.
//  Copyright © 2015年 王迎博. All rights reserved.
//

#import "ViewController.h"
#import "YBTestCell.h"
#import "YBTestHeader.h"
#import "YBCustomButton.h"
#import "YBCustomGesture.h"

#define UIColorFromOXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//屏幕的宽和高
#define FULL_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define FULL_SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

typedef enum
{
    //以下是枚举成员
    TestA = 0,
    TestB,
    TestC,
    TestD
}Test;//枚举名称

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSIndexPath *indexTest;
}





-(UIColor *) randomColor;

@end

@implementation ViewController

//生成随机色
-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = UIColorFromOXRGB(0xF8F8F8);
    
}


//-------------------------------------data source---------------------------------
#pragma mark   --data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


//定义cell里的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.layer setBorderWidth:0.5];
    [cell.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    cell.backgroundColor = [self randomColor];
    
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width-15, cell.frame.size.width)];
    cellView.backgroundColor = [self randomColor];
   
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, cellView.frame.size.width-15, cellView.frame.size.height)];
    scroll.delegate = self;
    //scroll.pagingEnabled = YES;//属性为YES时，设置为每次翻页翻一页
    
    //contentSize是scrollview可以滚动的区域,水平滚动和竖直滚动,滚动范围为5屏宽。
    scroll.contentSize = CGSizeMake(scroll.frame.size.width*5, cellView.frame.size.height);
    scroll.backgroundColor = [self randomColor];
    
    NSArray *array = @[@"新闻",@"房产",@"体育",@"美女",@"文化"];
    NSArray *btnArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"];
    
    
    YBCustomButton *button;
    UILabel *label;
    
    for (int i = 0; i < 5; i ++)
    {
        label = [[UILabel alloc]initWithFrame:CGRectMake(scroll.frame.size.width*i , 0, scroll.frame.size.width, 50)];
        label.text = [array objectAtIndex:i];
        label.backgroundColor = [self randomColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [label setUserInteractionEnabled:YES];//设置可用
        YBCustomGesture *labelGesture = [[YBCustomGesture alloc]initWithTarget:self action:@selector(labelTest:)];
        [labelGesture setTag:i];
        labelGesture.numberOfTouchesRequired = 1; //手指数
        labelGesture.numberOfTapsRequired = 1; //tap次数
        [label addGestureRecognizer:labelGesture];

        [scroll addSubview:label];
        
     }

    CGFloat btnWidth =(scroll.frame.size.width*5-150)/15;
    for (int j = 0; j < 15; j ++)
    {
        button = [[YBCustomButton alloc]initWithFrame:CGRectMake(btnWidth*j + 10*(j+1), label.frame.size.height, btnWidth, 50)];
        [button setTitle:[btnArr objectAtIndex:j] forState:UIControlStateNormal];
        [button setTintColor:[UIColor blackColor]];
        [button setBackgroundColor:[self randomColor]];
        button.tag = 100000+j;
        
        if (j < 14)
        {
            
            [button addTarget:self action:@selector(btnMethod:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:j];
            [button setTestStr:@"我是测试信息么么哒"];
        }
        
        if (j == 14)
        {
            [button setTitle:@"全部" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(checkAll) forControlEvents:UIControlEventTouchUpInside];
            
        }
  
        [scroll addSubview:button];

    }
    
    
    /**
     *获取indexPath，可以在代理方法外使用.
     */
      indexTest = [collectionView indexPathForCell:cell];
    
    
    [cellView addSubview:scroll];
    [cell addSubview:cellView];
    
    return cell;
}




//label的添加的点击手势方法
- (void)labelTest:(YBCustomGesture *)sender
{
    /**
     *  用自定义的UIGestureRecognizer来传递参数，达到传参目的。
     */
    NSInteger integer = sender.tag;
    NSLog(@"+++++++%ld",(long)integer);
    
    /**只能用在UITableView里的方法
     *  indexPathForSelectedRow可以传递被选中的row，此方法可借鉴。
     */
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    
    /**只能用在collectionView里的方法
     * 可以获取collectionView当前所有被选中的cell的下标,但是只能获取到第一个位置，需要传入参数来使用。
     */
    //NSIndexPath *firstIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    
    
    /**用在collectionView里的方法
     * 将collectionView在控制器view的中心点转化成collectionView上的坐标,获取collectionView被选中的cell
     */
    //CGPoint pInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    //NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    
    
    
    
}

///button的点击方法
- (void)btnMethod:(YBCustomButton *)sender
{
    /**
     *  button响应点击方法传入参数，传入的是tag
     */

    NSInteger i = [sender tag];
    NSString *string = sender.testStr;
    NSLog(@"..................%ld",(long)i+1);
    NSLog(@"...%@",string);
    
}

//查看全部的点击方法
- (void)checkAll
{
    NSLog(@"查看全部");
}

//scroll的代理方法，
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);


}


//cell的选中点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

   
    
}





//-------------------------------------headerView---------------------------------
//添加headerview的方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        static NSString *CellIdentifier = @"header";
        YBTestHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        //header.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, 190);
        header.backgroundColor = [self randomColor];
        [header.layer setBorderWidth:0.5];
        [header.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(test)];
        gesture.numberOfTouchesRequired = 1; //手指数
        gesture.numberOfTapsRequired = 1; //tap次数

        [header addGestureRecognizer:gesture];
        
        reusableView = header;
    }
    
    return reusableView;
}

//headerView上添加的手势点击方法
- (void)test
{
    NSLog(@"======");
}


//section的四边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}


//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 160);
    
    return size;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end

//
//  GameViewController.m
//  SpeedMath
//
//  Created by wupeng on 2018/1/22.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import "GameViewController.h"
#import "GridTile.h"
#import "BoardUtils.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGame];

    //HEADER
    CGFloat gap = 10;
    CGFloat x=10;
    CGFloat y = 120;
    CGFloat size = (([UIScreen mainScreen].bounds.size.width)-2*(gap-2))/3;
    for (int i =0; i<3; i++) {
        for (int j=0; j<3; j++) {
            GridTile *tile = [[GridTile alloc] initWithSize:size x:i y:j];
            [tile setFrame:CGRectMake(x+i*(size-2),y+j*(size-2), size, size)];
            [self.view addSubview:tile];
            [allTiles addObject:tile];
        }
    }

    labelDebug = [[UILabel alloc] initWithFrame:CGRectMake(0, [[allTiles lastObject] frame].origin.y+size+20, self.view.frame.size.width,30)];
    [labelDebug setTextAlignment:NSTextAlignmentCenter];
    [labelDebug setText:@"Hello!"];
    
    quesView = [[UIView alloc] initWithFrame:CGRectMake(10, labelDebug.frame.origin.y-10, self.view.frame.size.width-20,120)];
    [quesView setBackgroundColor:[UIColor whiteColor]];
    quesView.layer.cornerRadius = 10;//设置那个圆角的有多圆
    quesView.layer.borderWidth = 4;//设置边框的宽度，当然可以不要
    quesView.layer.borderColor = [[UIColor redColor] CGColor];//设置边框的颜色
    quesView.layer.masksToBounds = YES;//设为NO去试试

    [self.view addSubview:quesView];
    [self.view addSubview:labelDebug];
    
    [self renderLevel];


    // Do any additional setup after loading the view.
}

-(void)initLevel{
    dictAnswer = [[NSMutableDictionary alloc] initWithDictionary:@{@2:@-1,@3:@-1,@4:@-1}];
    [[BoardUtils sharedBoardUtils] randomForLevel:level];
    
}

-(void)renderLevel{
    for (GridTile * tile in allTiles) {
        int tag =[tile tag];
        NSDictionary *dict = [[BoardUtils sharedBoardUtils] dict];
        NSString *str = [dict objectForKey:[NSString stringWithFormat:@"%d",tag]];
        [tile setStr:str];
    }
    for (UIView *subView in [quesView subviews]) {
        [subView removeFromSuperview];
    }
    
    for (NSArray *arr in [[BoardUtils sharedBoardUtils] array]) {
        int numCount = [arr[0] intValue];
        NSArray *questions = arr[1];
        if([questions count]>0){
            int currentQues = [questions[0] intValue];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(quesView.frame.size.width/[[[BoardUtils sharedBoardUtils] array] count]*(numCount-2), 40,quesView.frame.size.width/[[[BoardUtils sharedBoardUtils] array] count] , 40)];
            [label setTag:1000+numCount];
            [label setText:[NSString stringWithFormat:@"%d",currentQues]];
            [label setFont:[UIFont boldSystemFontOfSize:30]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setBackgroundColor:[UIColor redColor]];
            [quesView addSubview:label];
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(quesView.frame.size.width/[[[BoardUtils sharedBoardUtils] array] count]*(numCount-2), 80,quesView.frame.size.width/[[[BoardUtils sharedBoardUtils] array] count] , 30)];
            [label2 setTag:10000+numCount];
            [label2 setBackgroundColor:[UIColor clearColor]];
            [label2 setText:[NSString stringWithFormat:@"x%d",numCount]];
            [label2 setFont:[UIFont systemFontOfSize:20]];
            [label2 setTextAlignment:NSTextAlignmentCenter];
            [quesView addSubview:label2];
        }
        
        
    }
}

-(BOOL)isLevelDoneWithNumCount:(int)numCount{
    for (NSArray *arr in [[BoardUtils sharedBoardUtils] array]) {
        if([arr[0] intValue]==numCount){
            if ([arr[1] count]==0) {
                return YES;
            }
            if ((2+[[dictAnswer objectForKey:arr[0]] intValue]) < (2+[arr[1] count]-1)) {
                return NO;
            }
        }
    }
    return YES;
}

-(BOOL)isLevelDone{
    for (int i =2; i<=4; i++) {
        if (![self isLevelDoneWithNumCount:i]) {
            return NO;
        }
    }
    return YES;
}

-(void)initGame{
    beginX = -1;
    beginY = -1;
    selectedTiles = [[NSMutableArray alloc] init];
    allTiles = [[NSMutableArray alloc] init];
    currentStr = @"";
    level = 1;
    [labelLevel setText:[NSString stringWithFormat:@"Level %d",level]];
    score = 0;
    [labelScore setText:[NSString stringWithFormat:@"%d",score]];
    time = 300;
    [labelTimer setText:[NSString stringWithFormat:@"%02d:%02d",time/60,time%60]];
    [self initLevel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if([selectedTiles count]>0)return;
    currentTouch = [touches anyObject];
    for (GridTile * tile in allTiles) {
        CGPoint point = [currentTouch locationInView:self.view];
        if(CGRectContainsPoint(tile.frame,point)){
            if ((tile.x+tile.y)%2==0) {
                [tile setSelected:YES];
                 beginX = tile.x;
                beginY = tile.y;
                [selectedTiles addObject:tile];
                currentStr = [NSString stringWithFormat:@"%@%@",currentStr,tile.str];
                [labelDebug setText:currentStr];
            }
            break;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if( beginX+beginY<0){return;}
    for (GridTile * tile in allTiles) {
        CGPoint point = [currentTouch locationInView:self.view];
        if(CGRectContainsPoint(tile.frame,point)){
            if (![tile selected]){
                GridTile *lastTitle = [selectedTiles lastObject];
                if(tile.x == lastTitle.x || tile.y == lastTitle.y){
                    [tile setSelected:YES];
                    [selectedTiles addObject:tile];
                    currentStr = [NSString stringWithFormat:@"%@%@",currentStr,tile.str];
                    [labelDebug setText:currentStr];
                }
            }else{
                long tileIndexInSelectedTiles = [selectedTiles indexOfObject:tile];
                if (tileIndexInSelectedTiles != [selectedTiles count]-1){
                    for (long p=[selectedTiles count]-1; p>=tileIndexInSelectedTiles; p--) {
                       GridTile *dTile = [selectedTiles objectAtIndex:p];
                        [selectedTiles removeObject:dTile];
                        [dTile setSelected:NO];
                        currentStr = [currentStr substringToIndex:p];
                    }
                }
            }
            break;
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if( beginX+beginY<0){return;}
    GridTile *lastTile = [selectedTiles lastObject];
    for (GridTile *tile in allTiles) {
        [tile setSelected:NO];
    }
    int numUsed = ([selectedTiles count]+1)/2;
    [selectedTiles removeAllObjects];
    if (([lastTile x]+[lastTile y])%2!=0) {
        currentStr = @"";
        return;
    }

    beginY = -1;
    beginX = -1;
    NSString *expressionStr= [[currentStr stringByReplacingOccurrencesOfString:@"×" withString:@"*"]stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    char *expression = (char*)[expressionStr UTF8String];
    int a = ExpressionParser(expression);
    [labelDebug setText:[NSString stringWithFormat:@"%@=%d",currentStr,a]];

    NSNumber *indexNum = [dictAnswer objectForKey:@(numUsed)];
    if (indexNum) {
        NSArray *quesArray = [[BoardUtils sharedBoardUtils] array];
        for (NSArray *ques in quesArray) {
            if ([ques[0] intValue]==numUsed){
                NSArray *questions = ques[1];
                if ([questions count]>0) {
                    BOOL test = ((2+[indexNum integerValue]+1) <(2+[questions count]));//WHY？？？？ +2去掉试试就是false
                    if (test){
                        int currentValue = [questions[[indexNum intValue]+1] intValue];
                        if(currentValue==a){
                            UILabel *label =(UILabel *) [quesView viewWithTag:1000+numUsed];
                            UILabel *label2 =(UILabel *) [quesView viewWithTag:10000+numUsed];
                            [label setBackgroundColor:[UIColor greenColor]];
                            NSLog(@"hahaha corect");
                            [dictAnswer setObject:@([indexNum intValue]+1) forKey:@(numUsed)];
                            [self addScore:numUsed*2-1];

                            
                            if ([self isLevelDoneWithNumCount:numUsed]) {
                                [label2 setText:@"OK"];
                                if ([self isLevelDone]) {
                                    NSLog(@"NextLevel");
                                    [self nextLevel];
                                }
                            }else{
                                int nextValue = [questions[[indexNum intValue]+2] intValue];
                                [label setText:[NSString stringWithFormat:@"%d",nextValue]];
                            }
                        }
                    }
                }
            }
        }
    }
    
    currentStr = @"";
}

-(void)nextLevel{
    level++;
    [labelLevel setText:[NSString stringWithFormat:@"Level %d",level]];
    [self initLevel];
    [self renderLevel];
}

-(void)addScore:(int)addScore{
    score+=addScore;
    [labelScore setText:[NSString stringWithFormat:@"%d",score]];
}


@end

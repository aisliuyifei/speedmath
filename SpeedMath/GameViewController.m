//
//  GameViewController.m
//  SpeedMath
//
//  Created by wupeng on 2018/1/22.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import "GameViewController.h"
#import "GridTile.h"

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
            if ((i+j)%2==0) {
                [tile setStr:[NSString stringWithFormat:@"%d",(arc4random()%9 )+1]];
            }else{
                [tile setStr:[@[@"+",@"-",@"×"] objectAtIndex:(arc4random()%3)]];
            }
            [self.view addSubview:tile];
            [allTiles addObject:tile];
        }
    }
    labelDebug = [[UILabel alloc] initWithFrame:CGRectMake(0, [[allTiles lastObject] frame].origin.y+size+20, self.view.frame.size.width,30)];
    [labelDebug setTextAlignment:NSTextAlignmentCenter];
    [labelDebug setText:@"Hello!"];
    [self.view addSubview:labelDebug];

    // Do any additional setup after loading the view.
}

-(void)initGame{
    beginX = -1;
    beginY = -1;
    CGFloat size = ([UIScreen mainScreen].bounds.size.width)/3;
    selectedTiles = [[NSMutableArray alloc] init];
    allTiles = [[NSMutableArray alloc] init];
    currentStr = @"";
  
    level = 1;
    [labelLevel setText:[NSString stringWithFormat:@"Level %d",level]];
    score = 0;
    [labelScore setText:[NSString stringWithFormat:@"%d",score]];
    time = 300;
    [labelTimer setText:[NSString stringWithFormat:@"%02d:%02d",time/60,time%60]];

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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
    for (GridTile *tile in allTiles) {
        [tile setSelected:NO];
    }
    [selectedTiles removeAllObjects];
    beginY = -1;
    beginX = -1;
    NSString *expressionStr= [[currentStr stringByReplacingOccurrencesOfString:@"×" withString:@"*"]stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    char *expression = (char*)[expressionStr UTF8String];
    int a = ExpressionParser(expression);
    [labelDebug setText:[NSString stringWithFormat:@"%@=%d",currentStr,a]];
    currentStr = @"";

}



@end

//
//  BoardUtils.m
//  SpeedMath
//
//  Created by wupeng on 2018/1/24.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import "BoardUtils.h"
#import "GridTile.h"
#import "ExpressionParser.h"
@implementation BoardUtils
static BoardUtils *_sharedBoardUtils = nil;

-(id)init{
    if (self=[super init]) {
    }
    return self;
}
+(BoardUtils*)sharedBoardUtils{
    if (!_sharedBoardUtils) {
        _sharedBoardUtils = [[self alloc] init];
    }
    return _sharedBoardUtils;
}


-(void)randomForLevel:(int)level{
    NSMutableDictionary * tmp = [[NSMutableDictionary alloc] init];
    for (int i=0;i<3;i++){
        for (int j=0;j<3;j++){
            int tag = [GridTile getTagForX:i andY:j];
            if ((i+j)%2==0){
                //数字
                [tmp setValue:[NSString stringWithFormat:@"%d",(arc4random()%9 )+1] forKey:[NSString stringWithFormat:@"%d",tag]];
            }else{
                //二元操作符
                if (level < 5){
                    [tmp setValue:@"+" forKey:[NSString stringWithFormat:@"%d",tag]];
                }else if (level==5){
                    if(i==2 && j==1){
                        [tmp setValue:@"-" forKey:[NSString stringWithFormat:@"%d",tag]];
                    }else{
                        [tmp setValue:@"+" forKey:[NSString stringWithFormat:@"%d",tag]];
                    }
                }
                else if (level<10){
                    if(i==1){
                        [tmp setValue:@"+" forKey:[NSString stringWithFormat:@"%d",tag]];
                    }else{
                        [tmp setValue:@"-" forKey:[NSString stringWithFormat:@"%d",tag]];
                    }
                }else if (level==10){
                    if(i==1 && j==2){
                        [tmp setValue:@"×" forKey:[NSString stringWithFormat:@"%d",tag]];
                    }else{
                        [tmp setValue:@"+" forKey:[NSString stringWithFormat:@"%d",tag]];
                    }
                }else{
                    [tmp setValue:@[@"+",@"-",@"×"][arc4random()%2] forKey:[NSString stringWithFormat:@"%d",tag]];
                }
                
            }
        }
    }
    self.dict = [[NSDictionary alloc] initWithDictionary:tmp];
    //出题
    NSArray * r234 =@[@2,@2,@1];
    switch (level) {
        case 1:
            r234 = @[@2,@0,@0];
            break;
        case 2:
            r234 = @[@3,@0,@0];
        case 3:
            r234 = @[@2,@1,@0];
        case 4:
            r234 = @[@2,@2,@0];
        case 5:
            r234 = @[@2,@1,@0];
        case 6:
            r234 = @[@2,@2,@0];
        case 7:
            r234 = @[@2,@2,@1];
        case 8:
            r234 = @[@2,@2,@2];
        case 9:
            r234 = @[@2,@3,@2];
        default:
            r234 = @[@2,@2,@2];
    }
    if(level%11==0){
        r234 = @[@2,@3,@3];
    }
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for(int i=0;i<3;i++){
        int quesCount = [r234[i] intValue];
        NSArray *arrRoutes = [self allRoutesForNumCount:i+2];
        NSMutableArray *stepTmpArr =[[NSMutableArray alloc] init];
        int tries = 0;
        while ([stepTmpArr count]<quesCount && tries <10) {
            tries+=1;
            NSArray *route = arrRoutes[arc4random()%[arrRoutes count]];
            NSString *expS = @"";
            for(NSNumber *num in route){
                int tag = [num intValue];
                NSString *s = [self.dict objectForKey:[NSString stringWithFormat:@"%d",tag]];
                expS = [NSString stringWithFormat:@"%@%@",expS,s];
                
            }
            char *expression = (char*)[expS UTF8String];
            int a = ExpressionParser(expression);
            BOOL exist = NO;
            for (NSNumber *v in stepTmpArr) {
                if([v intValue] == a){
                    exist = YES;
                }
            }
            if(!exist){
                NSLog(@"%@=%d",expS,a);
                [stepTmpArr addObject:@(a)];
            }
        }
        [tmpArray addObject:@[@(i),stepTmpArr]];
    }
    self.array = [[NSArray alloc] initWithArray:tmpArray];
}

-(NSArray *)allRoutesForNumCount:(int)numCount{
    assert(numCount>=1);
    assert(numCount<=5);
    int arraySize = numCount *2-1;
    
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    int step = 0;
    while(step<arraySize){
        NSMutableArray *stepTmp = [[NSMutableArray alloc] init];
        for(int i=0;i<3;i++){
            for(int j=0;j<3;j++){
                if ((i+j)%2==step%2){
                    if ([tmp count]==0){
                        [stepTmp addObject:@[[NSNumber numberWithInt:[GridTile getTagForX:i andY:j]]]];
                    }else{
                        for (NSArray *arr in tmp) {
                            int lastTag = [[arr lastObject] intValue];
                            int lastX = [GridTile getXForTag:lastTag];
                            int lastY = [GridTile getYForTag:lastTag];
                            if (i==lastX || j==lastY){
                                BOOL exist = NO;
                                for (NSNumber * num in arr) {
                                    if ([num intValue] == [GridTile getTagForX:i andY:j]){
                                        exist = YES;
                                    }
                                }
                                if(!exist){
                                    NSArray * thisRoute = [arr arrayByAddingObject:[NSNumber numberWithInt:[GridTile getTagForX:i andY:j]]];
                                    [stepTmp addObject:[NSArray arrayWithArray: thisRoute]];
                                }
                            }
                        }
                    }
                }
            }
        }
        tmp = [[NSMutableArray alloc] initWithArray:stepTmp];
        step+=1;
    }
    return [[NSArray alloc] initWithArray:tmp];
}


@end

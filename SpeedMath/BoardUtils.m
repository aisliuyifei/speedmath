//
//  BoardUtils.m
//  SpeedMath
//
//  Created by wupeng on 2018/1/24.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import "BoardUtils.h"
#import "GridTile.h"
@implementation BoardUtils
static BoardUtils *_sharedBoardUtils = nil;

-(id)init{
    if (self=[super init]) {
    }
    return self;
}
+(id)sharedBoardUtils{
    if (!_sharedBoardUtils) {
        _sharedBoardUtils = [[self alloc] init];
    }
    return _sharedBoardUtils;
}

-(void)randomDictForLevel:(int)level{
    
    
    
    NSMutableDictionary * tmp = [[NSMutableDictionary alloc] init];
    for (int i=0;i<3;i++){
        for (int j=0;j<3;j++){
            int tag = [GridTile getTagForX:i andY:j];
            
        }
    }
}


@end

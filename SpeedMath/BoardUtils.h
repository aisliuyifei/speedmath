//
//  BoardUtils.h
//  SpeedMath
//
//  Created by wupeng on 2018/1/24.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardUtils : NSObject{
    
}
+(id)sharedBoardUtils;
@property(nonatomic,retain)NSDictionary *dict;
@property(nonatomic,retain)NSArray *array;

-(void)randomForLevel:(int)level;
-(NSArray *)allRoutesForNumCount:(int)numCount;



@end

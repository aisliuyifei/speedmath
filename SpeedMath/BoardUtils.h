//
//  BoardUtils.h
//  SpeedMath
//
//  Created by wupeng on 2018/1/24.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardUtils : NSObject{
    NSDictionary *dict;
}
+(id)sharedBoardUtils;

-(void)randomDictForLevel:(int)level;



@end

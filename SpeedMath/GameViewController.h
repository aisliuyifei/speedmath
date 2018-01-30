//
//  GameViewController.h
//  SpeedMath
//
//  Created by wupeng on 2018/1/22.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/NSTextCheckingResult.h>
#import "ExpressionParser.h"

@interface GameViewController : UIViewController{
    UITouch *currentTouch;
    int beginX;
    int beginY;
    NSMutableArray *selectedTiles;
    NSMutableArray *allTiles;
    NSString *currentStr;
    UILabel *labelDebug;
    int score;
    IBOutlet UILabel *labelScore;
    int level;
    IBOutlet UILabel *labelLevel;
    int time;
    IBOutlet UILabel *labelTimer;
    NSMutableDictionary * dictAnswer;
    UIView *quesView;
    BOOL paused;

}

@end

//
//  GridTile.h
//  SpeedMath
//
//  Created by wupeng on 2018/1/22.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridTile : UIView{
    int _x;
    int _y;
    CGFloat _size;
    NSString *str;
    UILabel *_labelContent;
    BOOL selected;
}
-(void)setStr:(NSString *)title;
-(NSString *)str;
-(int)x;
-(int)y;

-(void)setSelected:(BOOL)isSel;
-(BOOL)selected;

- (id)initWithSize:(CGFloat)size x:(int)x y:(int)y;
+ (int)getTagForX:(int)x andY:(int)y;
@end

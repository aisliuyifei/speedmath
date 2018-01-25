//
//  GridTile.m
//  SpeedMath
//
//  Created by wupeng on 2018/1/22.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import "GridTile.h"

@implementation GridTile

- (id)initWithSize:(CGFloat)size x:(int)x y:(int)y{
    assert(x<=2);
    assert(x>=0);
    assert(y<=2);
    assert(y>=0);
    _size = size;
    _x = x;
    _y = y;
    CGRect rect = CGRectMake(0, 0,size, size);
    self = [super initWithFrame:rect];
    if (self) {
        self.tag = [GridTile getTagForX:x andY:y];
    }
    return self;
}

-(void)setStr:(NSString *)title{
    NSArray *digits =@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *cals = @[@"+",@"-",@"×"];
    if((_x+_y)%2==0){
        assert([digits containsObject:title]);
    }else{
        assert([cals containsObject:title]);
    }    
    str = title;
    [_labelContent setText:str];

}
-(NSString *)str{
    return str;
}

-(int)x{
    return  _x;
}
-(int)y{
    return _y;
}


-(void)setSelected:(BOOL)isSel{
    if (isSel){
        [self setBackgroundColor:[UIColor blueColor]];
    }else{
        if((_x+_y)%2==0){
            [self setBackgroundColor:[UIColor grayColor]];
            
        }else{
            [self setBackgroundColor:[UIColor darkGrayColor]];

        }
    }
    selected = isSel;
}

-(BOOL)selected{
    return selected;
}

+ (int)getTagForX:(int)x andY:(int)y{
    return x*10+y;
}
+ (int)getXForTag:(int)tag{
    return tag/10;
}
+ (int)getYForTag:(int)tag{
    return tag%10;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    _labelContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _size, _size)];
    [_labelContent setBackgroundColor:[UIColor clearColor]];
    [_labelContent setText:self.str];
    [self addSubview:_labelContent];
    if((_x+_y)%2==0){
        [self setBackgroundColor:[UIColor grayColor]];
        
    }else{
        [self setBackgroundColor:[UIColor darkGrayColor]];
        
    }    [_labelContent setTextAlignment:NSTextAlignmentCenter];
    [_labelContent setFont:[UIFont boldSystemFontOfSize:50]];
    [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self setClipsToBounds:NO];
    [self.layer setBorderWidth:2.0f];
}

@end

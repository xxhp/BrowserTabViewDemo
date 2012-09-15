//
//
//  BrowserTab.m
//  BrowserTabViewDemo
//
//  Created by xiao haibo on 9/9/12.
//  Copyright (c) 2012 xiao haibo. All rights reserved.

//  github:https://github.com/xxhp/BrowserTabViewDemo
//  Email:xiao_hb@qq.com

//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "BrowserTab.h"
//define width of a tab ,here is the width of the image used to render tab;
#define TAB_WIDTH 154 
#define TAB_HEIGHT 38 
@implementation BrowserTab
@synthesize title;
@synthesize titleFont;
@synthesize selected=_selected;
@synthesize tabNormalImage;
@synthesize tabSelectedImage;
@synthesize normalTitleColor;
@synthesize selectedTitleColor;
@synthesize reuseIdentifier;
@synthesize imageView;
@synthesize imageViewClose;
@synthesize textLabel;
@synthesize index;
@synthesize delegate;

#pragma mark -
#pragma mark init
-(id)initWithReuseIdentifier:(NSString *)aReuseIdentifier andDelegate:(id)aDelegate
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        delegate = aDelegate;
        reuseIdentifier = [aReuseIdentifier retain];
        self.normalTitleColor = [UIColor whiteColor];
        self.selectedTitleColor = [UIColor blackColor];
        
        self.tabSelectedImage = [UIImage imageNamed:@"tab_selected.png"]; 
        self.tabNormalImage = [UIImage imageNamed:@"tab_normal.png"] ;
        
        
        
        self.titleFont = [UIFont systemFontOfSize:18];
        
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.imageView.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:imageView];
        
        textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        textLabel.textAlignment = UITextAlignmentCenter;
        
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        imageViewClose = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.imageViewClose.backgroundColor = [UIColor clearColor];
        imageViewClose.image = [UIImage imageNamed:@"tab_close.png"];
        imageViewClose.hidden = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:imageViewClose];
        [self addSubview:textLabel]; 
        
        [self setSelected:YES];
        panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:delegate    
                                                       action:@selector(handlePanGuesture:)];
        panGuesture.delegate = delegate;
        [self addGestureRecognizer:panGuesture];
        
    }
    return self;
}

-(void)setSelected:(BOOL)isSelected
{
    _selected = isSelected;
    
    if (isSelected) {
        self.textLabel.textColor = selectedTitleColor;
        imageView.image = self.tabSelectedImage;
        if (self.delegate.numberOfTabs>1) {
            imageViewClose.hidden = NO;
        }else{
            imageViewClose.hidden = YES;
        }
        
    }else{
        self.textLabel.textColor = normalTitleColor;
        imageView.image = self.tabNormalImage;
        imageViewClose.hidden = YES;    
    }
}
-(void)prepareForReuse
{
    self.textLabel.text = nil;
    self.index = 0;
    self.delegate = nil;
    _selected = NO;    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}
*/

-(void)layoutSubviews
{
    title = self.textLabel.text;
    CGSize titleSize = [title sizeWithFont:titleFont];
    imageView.frame = self.bounds;
    
    self.textLabel.frame = CGRectMake((self.bounds.size.width - titleSize.width)/2 , (self.bounds.size.height - titleSize.height)/2, titleSize.width,titleSize.height);
       
    imageViewClose.frame =  CGRectMake(self.bounds.origin.x+115, self.bounds.origin.y+12, 19, 18);
    
    [super layoutSubviews];
}


#pragma mark -
#pragma mark - TouchEvent

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    previousSelected =  _selected;
    [self setSelected:YES];
    [self.delegate setSelectedTabIndex:self.index animated:NO];

    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	if (self.delegate.numberOfTabs > 0) {
        UITouch *touch = [touches anyObject];
        CGFloat x = [touch locationInView:self].x;
        if (x >120 && x <= TAB_WIDTH -8 && previousSelected) {
            [self.delegate removeTabAtIndex:self.index animated:YES];
        }
    }
}
@end

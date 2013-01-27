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

@interface BrowserTab () {
    NSString *__weak reuseIdentifier;
    BOOL previousSelected;
    UIPanGestureRecognizer *panGuesture;
}

@end

@implementation BrowserTab

@synthesize reuseIdentifier;

#pragma mark - init

- (id)initWithReuseIdentifier:(NSString *)aReuseIdentifier andDelegate:(id)aDelegate
{
    if (self = [super initWithFrame:CGRectZero]) {
        _height = 38;
        _delegate = aDelegate;
        reuseIdentifier = aReuseIdentifier;
        self.normalTitleColor = [UIColor whiteColor];
        self.selectedTitleColor = [UIColor blackColor];
        self.tabSelectedImage = [[UIImage imageNamed:@"tab_selected"] stretchableImageWithLeftCapWidth:40 topCapHeight:0];
        self.tabNormalImage = [[UIImage imageNamed:@"tab_normal"] stretchableImageWithLeftCapWidth:40 topCapHeight:0] ;
        
        self.titleFont = [UIFont systemFontOfSize:16];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.imageView.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_imageView];
        
        _titleField = [[UITextField alloc] initWithFrame:self.bounds];
        _titleField.textAlignment = UITextAlignmentCenter;
        _titleField.enabled = NO;
        _titleField.delegate = _delegate;
        _titleField.returnKeyType = UIReturnKeyDone;
        
        self.titleField.backgroundColor = [UIColor clearColor];
        
        _imageViewClose = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.imageViewClose.backgroundColor = [UIColor clearColor];
        _imageViewClose.image = [UIImage imageNamed:@"tab_close.png"];
        _imageViewClose.hidden = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_imageViewClose];
        [self addSubview:_titleField];
        
        [self setSelected:YES];
        panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:_delegate
                                                       action:@selector(handlePanGuesture:)];
        panGuesture.delegate = _delegate;
        [self addGestureRecognizer:panGuesture];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:_delegate action:@selector(handleLongPress:)];
        longPressGR.allowableMovement = 5.f;
        longPressGR.minimumPressDuration = 0.7f;
        [self addGestureRecognizer:longPressGR];
        
    }
    return self;
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    self.bounds = CGRectMake(0, 0, width, CGRectGetHeight(self.bounds));
}

- (void)setSelected:(BOOL)isSelected
{
    _selected = isSelected;
    
    if (isSelected) {
        self.titleField.textColor = _selectedTitleColor;
        _imageView.image = self.tabSelectedImage;
        _imageViewClose.hidden = !(self.delegate.numberOfTabs > 1);
        
    }else{
        self.titleField.textColor = _normalTitleColor;
        _imageView.image = self.tabNormalImage;
        _imageViewClose.hidden = YES;
    }
}

- (void)prepareForReuse
{
    self.titleField.text = nil;
    self.index = 0;
    self.delegate = nil;
    _selected = NO;    
}

- (void)layoutSubviews
{
    _title = self.titleField.text;
    CGSize titleSize = [_title sizeWithFont:_titleFont];
    titleSize.width = CGRectGetWidth(self.bounds) - 30;
    _imageView.frame = self.bounds;
    self.titleField.frame = CGRectMake((self.bounds.size.width - titleSize.width)/2 , (self.bounds.size.height - titleSize.height)/2, titleSize.width,titleSize.height);
    _imageViewClose.frame =  CGRectMake(CGRectGetMaxX(self.bounds) - 40, self.bounds.origin.y+12, 19, 18);
    [super layoutSubviews];
}


#pragma mark - TouchEvent

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    previousSelected =  _selected;
    [self setSelected:YES];
    [self.delegate setSelectedTabIndex:self.index animated:NO];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	if (self.delegate.numberOfTabs > 0) {
        UITouch *touch = [touches anyObject];
        CGFloat x = [touch locationInView:self].x;
        if (x > 0.8 * self.width && x <= self.width - 8 && previousSelected) {
            [self.delegate removeTabAtIndex:self.index animated:YES];
        }
    }
}

@end

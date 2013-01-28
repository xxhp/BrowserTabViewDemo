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
#import "BrowserTabView.h"

@interface BrowserTab () {
    NSString *__weak reuseIdentifier;
    BOOL previousSelected;
}

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *imageView;

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
        self.tabSelectedImage = [[UIImage imageNamed:@"tab_selected"] stretchableImageWithLeftCapWidth:30 topCapHeight:0];
        self.tabNormalImage = [[UIImage imageNamed:@"tab_normal"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] ;
        
        self.titleFont = [UIFont systemFontOfSize:16];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.imageView.backgroundColor = [UIColor clearColor];
    
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_imageView];
        
        _titleField = [[UITextField alloc] initWithFrame:self.bounds];
        _titleField.textAlignment = UITextAlignmentCenter;
        _titleField.enabled = NO;
        _titleField.delegate = _delegate;
        _titleField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _titleField.returnKeyType = UIReturnKeyDone;
        
        self.titleField.backgroundColor = [UIColor clearColor];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"tab_close"] forState:UIControlStateNormal];
        _closeButton.hidden = YES;
        [_closeButton addTarget:self action:@selector(onCloseTap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_closeButton];
        [self addSubview:_titleField];
        
        [self setSelected:YES];
        UIPanGestureRecognizer *panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:_delegate
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

- (void)setCloseButtonImage:(UIImage *)closeButtonImage {
    [self.closeButton setImage:closeButtonImage forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)isSelected
{
    _selected = isSelected;
    
    if (isSelected) {
        self.titleField.textColor = _selectedTitleColor;
        _imageView.image = self.tabSelectedImage;
        _closeButton.hidden = !(self.delegate.numberOfTabs > 1);
        
    }else{
        self.titleField.textColor = _normalTitleColor;
        _imageView.image = self.tabNormalImage;
        _closeButton.hidden = YES;
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
    self.titleField.center = self.center;
    self.titleField.frame = CGRectMake((self.bounds.size.width - (titleSize.width - 44))/2,
                                       (self.bounds.size.height - titleSize.height)/2,
                                       titleSize.width - 44,
                                       titleSize.height);
    _closeButton.frame =  CGRectMake(CGRectGetMaxX(self.bounds) - 50, 0, 44, 44);
    [super layoutSubviews];
}


#pragma mark - TouchEvent

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    previousSelected =  _selected;
    [self setSelected:YES];
    [self.delegate setSelectedTabIndex:self.index animated:NO];
}

#pragma mark - Actions

- (void)onCloseTap:(id)sender {
    if (self.delegate.numberOfTabs > 0) {
        [self.delegate removeTabAtIndex:self.index animated:YES];
    }
}

@end

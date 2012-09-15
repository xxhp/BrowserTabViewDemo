//
//  ViewController.m
//  BrowserTabViewDemo
//
//  Created by xiao haibo on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize label;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    tabController= [[BrowserTabView alloc] initWithTabTitles:[NSArray arrayWithObjects:@"Tab 1",@"Tab 2",@"Tab 3", nil]
                                                 andDelegate:self];
    tabController.delegate = self;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tab_new_add.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(1024-40, 5, 27 , 27);
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:tabController];
    [self.view addSubview:addButton];

}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
-(void)add:(id)sender
{
    [tabController addTabWithTitle:nil];
}
#pragma mark -
#pragma mark BrowserTabViewDelegate
-(void)BrowserTabView:(BrowserTabView *)browserTabView didSelecedAtIndex:(NSUInteger)index
{
    self.label.text = [NSString stringWithFormat:@"Tab selected at: %d",index +1];
}

-(void)BrowserTabView:(BrowserTabView *)browserTabView didRemoveTabAtIndex:(NSUInteger)index{
    NSLog(@"BrowserTabView did Remove Tab at index:  %d",index);
}
-(void)BrowserTabView:(BrowserTabView *)browserTabView exchangeTabAtIndex:(NSUInteger)fromIndex withTabAtIndex:(NSUInteger)toIndex{

 NSLog(@"BrowserTabView exchange Tab  at index:  %d with Tab at index :%d ",fromIndex,toIndex);
}


- (void)dealloc {
    [label release];
    [super dealloc];
}
@end

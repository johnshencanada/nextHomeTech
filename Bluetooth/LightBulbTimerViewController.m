//
//  LightBulbTimerViewController.m
//  nextHome
//
//  Created by john on 8/29/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "LightBulbTimerViewController.h"
#import "MyNavigationController.h"
#import "ClockCell.h"
#import "VBFPopFlatButton.h"

@interface LightBulbTimerViewController ()
@property CGRect screenRect;
@property (nonatomic) MyNavigationController *nav;
@property (nonatomic) UIVibrancyEffect *vibrancyEffect;
@property  (nonatomic) UIVisualEffectView *vibrancyView;
@property (strong,nonatomic) VBFPopFlatButton *flatRoundedButton;

@property NSMutableArray *clocks;

@end

@implementation LightBulbTimerViewController

#pragma mark - MVC

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.screenRect = [[UIScreen mainScreen]bounds];
        self.clocks = [[NSMutableArray alloc]init];
        
        UIImage *timer = [UIImage imageNamed:@"timer"];
        UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Action" image:timer tag:0];
        self.tabBarItem = homeTab;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(320, 150);
        layout.minimumInteritemSpacing = 1.0;
        layout.minimumLineSpacing = 1.0;
        layout.headerReferenceSize = CGSizeMake(0,0);
        self = [super initWithCollectionViewLayout:layout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/4 - 15, 320, 400);
}

- (void)viewDidLoad
{
    [self setUpView];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [self setUpBlurAndVibrancy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpView
{
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/3 - 15, 320, 350);
    [self.collectionView registerClass:[ClockCell class] forCellWithReuseIdentifier:@"Clock"];
    [self setupAddButton];
}

- (void)setupAddButton
{
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(130, 220, 60, 60)
                                                         buttonType:buttonAddType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    
    self.flatRoundedButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.flatRoundedButton.lineThickness = 2;
    self.flatRoundedButton.tintColor = [UIColor colorWithWhite:255 alpha:0.6];
    [self.flatRoundedButton addTarget:self
                               action:@selector(insertNewObject:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flatRoundedButton];
}

- (void) setUpBlurAndVibrancy
{
    self.nav = (MyNavigationController *)self.navigationController;
    self.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:self.nav.blurEffect];
    self.vibrancyView = [[UIVisualEffectView alloc]initWithEffect:self.vibrancyEffect];
    self.vibrancyView.frame = self.view.bounds;
    [self.nav.blurView addSubview:self.vibrancyView];
}

- (void)insertNewObject:(id)sender {
    
    if (!self.clocks) {
        self.clocks = [[NSMutableArray alloc] init];
    }
    
    [self.clocks insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)createNewAction
{
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClockCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Clock" forIndexPath:indexPath];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

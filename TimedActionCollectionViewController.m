//
//  TimedActionCollectionViewController.m
//  nextHome
//
//  Created by john on 12/18/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "TimedActionCollectionViewController.h"
#import "NewActionViewController.h"
#import "ClockCell.h"
#import "VBFPopFlatButton.h"
#import "ProximityViewController.h"

@interface TimedActionCollectionViewController ()
@property CGRect screenRect;
@property NSMutableArray *clocks;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *back;
@property (strong,nonatomic) VBFPopFlatButton *flatRoundedButton;
@property (strong,nonatomic) NSMutableArray *actions;
@end

@implementation TimedActionCollectionViewController

static NSString * const reuseIdentifier = @"Clock";

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.screenRect = [[UIScreen mainScreen]bounds];
        self.devices = [NSArray arrayWithArray:devices];
        UIImage *timer = [UIImage imageNamed:@"alarm-small"];
        UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Timer" image:timer tag:0];
        self.tabBarItem = homeTab;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(320, 130);
        layout.minimumInteritemSpacing = 2.0;
        layout.minimumLineSpacing = 1.0;
        layout.headerReferenceSize = CGSizeMake(0,0);
        self = [super initWithCollectionViewLayout:layout];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.actions = [NSMutableArray arrayWithArray:[defaults objectForKey:@"actions"]];
    self.collectionView.alwaysBounceVertical = YES;

    if (self.actions) {
        [self.collectionView reloadData];
    }
    
    if ([self.actions count] == 0) {
        [self initActions];
    }
}

-(void)initActions
{
    /* first add an proximity to turn off */
    NSString * key1 = @"actionType";    // 0 as alarm triggered action; 1 as proximity triggered action; 2 as timer triggered action
                                        // 2 as timer triggered action;
    NSString * key2 = @"OnOff";         // on or off
    NSString * key3 = @"time";          // the time of the action
    NSString * key4 = @"proximity";     // 0 as strong, 1 as okay, 2 as weak
    
    NSNumber *obj1 = [NSNumber numberWithLong:1];
    NSNumber *obj2 = [NSNumber numberWithBool:1];
    NSDate *obj3 = [NSDate date];
    NSNumber *obj4 = [NSNumber numberWithInt:0];
    NSDictionary * dictionary = [NSDictionary dictionaryWithObjects:@[obj1,obj2,obj3,obj4] forKeys:@[key1,key2,key3,key4]];
    
    obj1 = [NSNumber numberWithLong:2];
    obj2 = [NSNumber numberWithBool:0];
    obj3 = [NSDate date];
    obj4 = [NSNumber numberWithInt:90];
    NSDictionary * dictionary2 =[NSDictionary dictionaryWithObjects:@[obj1,obj2,obj3,obj4] forKeys:@[key1,key2,key3,key4]];
    
    [self.actions addObject:dictionary];
    [self.actions addObject:dictionary2];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.actions forKey:@"actions"];
    [defaults synchronize];
}

- (void)setUpView
{
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/3 - 15, 320, 350);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[ClockCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    /* set up image view */
    UIImage *image = [UIImage imageNamed:@"back"];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/16,
                                                          self.screenRect.size.width/16,
                                                          self.screenRect.size.width/8,
                                                          self.screenRect.size.width/8)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];
    
    /* Do any additional setup after loading the view */
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 60)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    self.titleLabel.text = [NSString stringWithFormat:@"Add Action"];
    [self.view addSubview:self.titleLabel];
    
    [self setupAddButton];
}


- (void)setupAddButton
{
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(130, 80, 60, 60)
                                                         buttonType:buttonAddType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    
    self.flatRoundedButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.flatRoundedButton.lineThickness = 2;
    [self.flatRoundedButton setTintColor:[UIColor colorWithWhite:255 alpha:0.3]forState:UIControlStateNormal];
    [self.flatRoundedButton setTintColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.flatRoundedButton addTarget:self
                               action:@selector(createNewAction)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flatRoundedButton];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)createNewAction
{
    NewActionViewController *newAcitonVC = [[NewActionViewController alloc]initWithDevices:self.devices];
    [self.navigationController pushViewController:newAcitonVC animated:NO];
}


#pragma mark - Schedule Alarms
- (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = fireDate;
    notification.alertBody = @"Turning On";
//    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *timedActionArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"actions"]];
    return [timedActionArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ClockCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UILongPressGestureRecognizer* gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startDeleteMode:)];
    gestureRecognizer.minimumPressDuration = 1.5;
    [cell addGestureRecognizer:gestureRecognizer];
    
    if (self.actions) {
        NSDictionary *dictionary = [self.actions objectAtIndex:indexPath.row];
        NSNumber *actionType = [dictionary objectForKey:@"actionType"];
        NSNumber *onOff = [dictionary objectForKey:@"OnOff"];
//        NSNumber *enable = [dictionary objectForKey:@"enbale"];
        
        //Alarm
        if ([actionType intValue] == 0) {
            [cell setActionLabelName:@"alarm"];
            NSDate *date = [dictionary objectForKey:@"time"];
            [self scheduleLocalNotificationWithDate:date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"hh:mm a"];
            NSString *dateString = [dateFormatter stringFromDate:date];
            cell.alarmLabel.text = dateString;
        }
        
        //Proximity
        else if ([actionType intValue] == 1)
        {
            [cell setActionLabelName:@"proximity"];
            NSNumber *proximity = [dictionary objectForKey:@"proximity"];
            
            if ([proximity intValue] == 0) {
                cell.proximityLabel.text = @"Strong";
                [cell.circleGaugeView setValue:0.8 animated:YES];
                cell.circleGaugeView.gaugeTintColor = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:0.8];

            }
            
            else if ([proximity intValue] == 1) {
                cell.proximityLabel.text = @"Okay";
                [cell.circleGaugeView setValue:0.5 animated:YES];
                cell.circleGaugeView.gaugeTintColor =  [UIColor colorWithRed:1 green:0.859 blue:0.298 alpha:0.8];

            }
            
            else {
                cell.proximityLabel.text = @"Weak";
                [cell.circleGaugeView setValue:0.3 animated:YES];
                cell.circleGaugeView.gaugeTintColor = [UIColor colorWithRed:1 green:0.231 blue:0.298 alpha:0.8];
            }
        }
        
        //Timer
        else {
            [cell setActionLabelName:@"timer"];
        }

        
        if ([onOff intValue] == 1) {
            cell.actionLabel.text = @"Turn On";
        }
        
        else {
            cell.actionLabel.text = @"Turn Off";
        }
    }
    
    // Configure the cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClockCell *cell = (ClockCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dictionary = [self.actions objectAtIndex:indexPath.row];
    NSNumber *actionType = [dictionary objectForKey:@"actionType"];
    
    if ([actionType intValue] == 1) {
        ProximityViewController *vc = [[ProximityViewController alloc]initWithDevices:self.devices];
        [self.navigationController pushViewController:vc animated:NO];
    }
    
    else {
        
    }
}

- (void) startDeleteMode:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonPosition];
    NSLog(@"%ld", (long)indexPath.row);
//
//    UICollectionViewCell *cell = (UICollectionViewCell *)sender;
//    cell.backgroundColor = [UIColor blackColor];
//    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSLog(@"Delete");
//    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

#pragma mark <Shaking animation>

- (void) startShake:(UIView *)view
{
    CGAffineTransform normal = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform leftShake = CGAffineTransformMakeTranslation(-5, 0);
    CGAffineTransform rightShake = CGAffineTransformMakeTranslation(5, 0);
    
    view.transform = leftShake;  // starting point
    
    [UIView beginAnimations:@"shake_button"context:NULL];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:1000];
    [UIView setAnimationDuration:0.02];
    [UIView setAnimationDelegate:self];
    view.transform = rightShake;
    view.transform = normal;  // end here & auto-reverse
    [UIView commitAnimations];
}

@end

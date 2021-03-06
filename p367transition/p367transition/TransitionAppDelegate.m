

#import "TransitionAppDelegate.h"
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TransitionAppDelegate


@synthesize window=_window;
@synthesize iv;
@synthesize b;
@synthesize v;
@synthesize v2;

#define which 1 // try also "2" for block-based transition

// I've slowed down all the animations to make them clearer

- (void) animate {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                           forView:iv cache:YES];
    [UIView setAnimationDuration:2];
    iv.image = [UIImage imageNamed:@"Saturn.gif"];
    [UIView commitAnimations];
    // =======
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                           forView:b cache:YES];
    [UIView setAnimationDuration:2];
    [b setTitle:(stopped ? @"Start" : @"Stop") forState:UIControlStateNormal];
    [UIView commitAnimations];
    // =======
    switch (which) {
        case 1:
        {
            v.reverse = !v.reverse;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                   forView:v cache:YES];
            [UIView setAnimationDuration:2];
            [v setNeedsDisplay];
            [UIView commitAnimations];
            break;
        }
        case 2:
        {
            v.reverse = !v.reverse;
            void (^anim) (void) = ^{
                [v setNeedsDisplay];
            };    
            NSUInteger opts = UIViewAnimationOptionTransitionFlipFromLeft;
            [UIView transitionWithView:v duration:2 options:opts 
                            animations:anim completion:nil];
            break;
        }
    }
    // =======
    CALayer* layer = [v2.layer.sublayers lastObject];
    CATransition* t = [CATransition animation];
    t.type = kCATransitionPush;
    t.subtype = kCATransitionFromBottom;
    t.duration = 2;
    [CATransaction setDisableActions:YES];
    layer.contents = (id)[[UIImage imageNamed: @"Saturn.gif"] CGImage];
    [layer addAnimation: t forKey: nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self performSelector:@selector(animate) withObject:nil afterDelay:1.0];
    CALayer* layer = [CALayer layer];
    layer.frame = v2.layer.bounds;
    [v2.layer addSublayer:layer];
    layer.contents = (id)[[UIImage imageNamed:@"Mars.png"] CGImage];
    layer.contentsGravity = kCAGravityCenter;
    v2.layer.masksToBounds = YES; // try making this NO to see what difference it makes
    v2.layer.borderWidth = 2;
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [iv release];
    [b release];
    [v release];
    [v2 release];
    [super dealloc];
}

@end

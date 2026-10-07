#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define MY_NAME @"Yourname"

static void ShowName(int attempt)
{
    UIWindow *window = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows) {
            if (w.isKeyWindow) { window = w; break; }
        }
        if (window) break;
    }

    if (!window) {
        if (attempt < 10) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{ ShowName(attempt + 1); });
        }
        return;
    }

    UILabel *label = [UILabel new];
    label.text = MY_NAME;
    label.font = [UIFont boldSystemFontOfSize:24.0];
    label.textColor = UIColor.blackColor;
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.bounds.size.width, label.bounds.size.height);

    UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(
        (window.bounds.size.width - label.bounds.size.width) / 2.0, 80,
        label.bounds.size.width, label.bounds.size.height)];
    holder.userInteractionEnabled = NO;

    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = holder.bounds;
    grad.colors = @[
        (id)[UIColor colorWithRed:0.50 green:0.47 blue:0.87 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.83 green:0.33 blue:0.49 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.94 green:0.62 blue:0.15 alpha:1].CGColor
    ];
    grad.startPoint = CGPointMake(0, 0.5);
    grad.endPoint = CGPointMake(1, 0.5);
    grad.mask = label.layer;

    [holder.layer addSublayer:grad];
    [window addSubview:holder];
}

__attribute__((constructor))
static void NameInit(void)
{
    dispatch_async(dispatch_get_main_queue(), ^{ ShowName(0); });
}

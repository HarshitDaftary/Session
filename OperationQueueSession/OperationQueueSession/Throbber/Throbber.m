//
//  Throbber.m
//

#import "Throbber.h"


#if !defined(CGRectGetMidPoint)
#define CGRectGetMidPoint(rect) CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
#endif

//
// RoundProgressView
//

@interface RoundProgressView : UIView {
@private
    float progress;
}
@property(nonatomic, assign) float progress;

@end


@implementation RoundProgressView

- (id)init {
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 37.0f)];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (float)progress {
    return progress;
}

- (void)setProgress:(float)aProgress {
    progress = aProgress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGRect allRect = self.bounds;
    CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw background
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.1f); // translucent white
    CGContextSetLineWidth(context, 2.0f);
    CGContextFillEllipseInRect(context, circleRect);
    CGContextStrokeEllipseInRect(context, circleRect);
    
    // Draw progress
    CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
    CGFloat radius = (allRect.size.width - 4) / 2;
    CGFloat startAngle = -((float)M_PI / 2);  // 90 degrees
    CGFloat endAngle = (progress * 2 * (float)M_PI) + startAngle;
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);  // white
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end


//
// Throbber
//

static Throbber *defaultThrobber = nil;

@implementation Throbber
@synthesize title, details, customView, mode, progress, blockNavigation;

+ (Throbber *)defaultThrobber {
    return defaultThrobber;
}

+ (void)defaultThrobberOnView:(UIView *)parentView withTitle:(NSString *)title details:(NSString *)details displayMode:(ZPMode)aMode blockNavigation:(BOOL)aBlockNavigation
{
    if (defaultThrobber.superview != parentView)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [defaultThrobber removeFromSuperview];
        [defaultThrobber release], defaultThrobber = nil;
    }
    
    if (parentView != nil)
    {
        defaultThrobber = [[Throbber alloc] initWithFrame:parentView.bounds];
        [parentView addSubview:defaultThrobber];
        
        defaultThrobber.title = title;
        defaultThrobber.details = details;
        defaultThrobber.mode = aMode;
        defaultThrobber.blockNavigation = aBlockNavigation;
        
        [[NSNotificationCenter defaultCenter] addObserver:defaultThrobber
                                                 selector:@selector(changeOrientationCallback:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        gradient = NO;
        opacity = 0.8;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.alpha = 0.0;
        self.backgroundColor = [UIColor clearColor];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kHUDSize.width, kHUDSize.height)];
        [self addSubview:contentView];
        [contentView release];
        contentView.autoresizingMask = UIViewAutoresizingNone;
        contentView.backgroundColor = [UIColor clearColor];
        contentView.center = CGRectGetMidPoint(self.bounds);
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.hidesWhenStopped = NO;
        [contentView addSubview:activityView];
        [activityView release];
        activityView.center = CGRectGetMidPoint(contentView.bounds);
        
        progressView = [[RoundProgressView alloc] initWithFrame:activityView.frame];
        [contentView addSubview:progressView];
        [progressView release];
        progressView.center = CGRectGetMidPoint(contentView.bounds);
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [contentView addSubview:titleLabel];
        [titleLabel release];
        
        detailsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailsLabel.backgroundColor = [UIColor clearColor];
        detailsLabel.textAlignment = NSTextAlignmentCenter;
        detailsLabel.textColor = [UIColor whiteColor];
        detailsLabel.font = [UIFont boldSystemFontOfSize:13];
        detailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        detailsLabel.numberOfLines = 2;
        [contentView addSubview:detailsLabel];
        [detailsLabel release];
        
        self.mode = ZPModeActivity;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -

- (void)setCustomView:(UIView *)aCustomView
{
    if (customView != aCustomView)
    {
        [customView removeFromSuperview];
        customView = [aCustomView retain];
        
        [contentView addSubview:customView];
        [customView release];
        customView.center = CGRectGetMidPoint(contentView.bounds);
        
        if (mode == ZPModeCustomView)
            [self setMode:mode];
    }
}

- (void)setMode:(ZPMode)aMode
{
    mode = aMode;
    
    if (customView && mode >= ZPModeCustomView) {
        [activityView stopAnimating];
        activityView.hidden = YES;
        progressView.hidden = YES;
        if (mode > ZPModeCustomView) {
            titleLabel.hidden = YES;
            detailsLabel.hidden = YES;
        }
        customView.hidden = NO;
    }
    else if (mode == ZPModeActivity) {
        customView.hidden = YES;
        titleLabel.hidden = NO;
        detailsLabel.hidden = NO;
        progressView.hidden = YES;
        activityView.hidden = NO;
        [activityView startAnimating];
    }
    else {
        titleLabel.hidden = NO;
        detailsLabel.hidden = NO;
        progressView.hidden = NO;
        [activityView stopAnimating];
        activityView.hidden = YES;
        customView.hidden = YES;
    }
}

- (void)setProgress:(CGFloat)aProgress
{
    progress = aProgress;
    [progressView setProgress:progress];
}

- (void)setBlockNavigationControls:(BOOL)aBlockNavigation
{
    blockNavigation = aBlockNavigation;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (NSString *)title
{
    return titleLabel.text;
}

- (void)setTitle:(NSString *)aTitle
{
    titleLabel.text = aTitle;
    [self setNeedsLayout];
}

- (NSString *)details
{
    return detailsLabel.text;
}

- (void)setDetails:(NSString *)aDetails
{
    detailsLabel.text = aDetails;
    [self setNeedsLayout];
}

#pragma mark -

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (gradient) {
        //Gradient colours
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient_ = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace);
        
        //Gradient center
        CGPoint gradCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        //Gradient radius
        float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height);
        //Gradient draw
        CGContextDrawRadialGradient (context, gradient_, gradCenter,
                                     0, gradCenter, gradRadius,
                                     kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient_);
    }
    
    // Center HUD
    //CGRect allRect = self.bounds;
    // Draw rounded HUD bacgroud rect
    CGRect boxRect = contentView.frame;
    // Corner radius
    float r = 10.0f;
    CGFloat minx = CGRectGetMinX(boxRect), maxx = CGRectGetMaxX(boxRect);
    CGFloat miny = CGRectGetMinY(boxRect), maxy = CGRectGetMaxY(boxRect);
    
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 0.0f, opacity);
    CGContextMoveToPoint(context, minx + r, CGRectGetMinY(boxRect));
    CGContextAddArc(context, maxx - r, miny + r, r, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, maxx - r, maxy - r, r, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, minx + r, maxy - r, r, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, minx + r, miny + r, r, (float)M_PI, 3 * (float)M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)layoutSubviews
{
    CGRect rect = self.superview.bounds;
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    
    if ([self.superview isKindOfClass:[UIWindow class]])
    {
        float dTop    = 20.;
        float dBottom = 0.;
        if (!blockNavigation)
        {
            dTop    += NAVBAR_HEIGHT;
            dBottom += TABBAR_HEIGHT;
        }
    }    
    self.frame = rect;
    contentView.transform = transform;
    contentView.center = CGRectGetMidPoint(self.bounds);
    
    activityView.center = CGRectGetMidPoint(contentView.bounds);
    progressView.center = CGRectGetMidPoint(contentView.bounds);
    customView.center   = CGRectGetMidPoint(contentView.bounds);
    
    float x = CGRectGetMinX(contentView.bounds);
    float y = CGRectGetMidY(contentView.bounds);
    float w = CGRectGetWidth(contentView.bounds);
    
    CGRect titleRect = CGRectMake(x, y, w, 0);
    if (!titleLabel.hidden && titleLabel.text && ![titleLabel.text isEqualToString:@""])
    {
        CGSize titleSize = [titleLabel.text sizeWithFont:titleLabel.font];
        titleRect = CGRectMake(x, y+kHUDTitleY, w, titleSize.height);
    }
    titleLabel.frame = titleRect;
    
    CGRect detailsRect = CGRectMake(x, y, w, 0);
    if (!detailsLabel.hidden && detailsLabel.text && ![detailsLabel.text isEqualToString:@""])
    {
        CGSize detailsSize = [detailsLabel.text sizeWithFont:detailsLabel.font constrainedToSize:kHUDSize lineBreakMode:detailsLabel.lineBreakMode];
        detailsRect = CGRectMake(x, y+kHUDDetailsY, w, detailsSize.height);
    }
    detailsLabel.frame = detailsRect;
    
    CGFloat miny = CGFLOAT_MAX;
    CGFloat maxy = 0;
    
    for (UIView *view in contentView.subviews)
    {
        miny = MIN(miny, CGRectGetMinY(view.frame));
        maxy = MAX(maxy, CGRectGetMaxY(view.frame));
    }
    
    CGFloat delta = CGRectGetMidY(contentView.bounds) - 0.5 * (maxy + miny);
    
    for (UIView *view in contentView.subviews)
    {
        view.center = CGPointMake(view.center.x, view.center.y + delta);
    }
}

- (void)changeOrientationCallback:(NSNotification *)notification
{
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark -

- (void)showWithBlockNavigation:(BOOL)aBlockNavigation
{
    [self setBlockNavigationControls:aBlockNavigation];
    [self show];
}

- (void)showWithTitle:(NSString *)aTitle
{
    self.title = aTitle;
    [self show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)showWithTitle:(NSString *)aTitle details:(NSString *)aDetails {
    self.title = aTitle;
    self.details = aDetails;
    [self show];
}

- (void)show
{
    [UIView beginAnimations:@"Throbber.show" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishHide:)];
    [self setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)dismiss:(SEL)action
{
    NSValue *actionValue = [NSValue valueWithBytes:&action objCType:@encode(SEL)];
    [UIView beginAnimations:@"Throbber.dismiss" context:[actionValue retain]];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissAnimationDidFinished:finished:context:)];
    [self setAlpha:0.0];
    [UIView commitAnimations];  
}

- (void)dismissAnimationDidFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    NSValue *value = (__bridge NSValue *)context;
    SEL action = NULL;  
    // Guard against buffer overflow
    if (strcmp([value objCType], @encode(SEL)) == 0) {
        [value getValue:&action];
        if ([self respondsToSelector:action])
            [self performSelector:action];
    }
    [value release];
}

- (void)dismiss
{
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [self dismiss:NULL];
}

@end
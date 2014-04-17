//
//  Throbber.h
//  

#import <UIKit/UIKit.h>
#define NAVBAR_HEIGHT 44
#define TABBAR_HEIGHT 44

@class RoundProgressView;


#define kHUDSize      CGSizeMake(160.0, 120.0)
#define kHUDTitleY    25.0
#define kHUDDetailsY  50.0


typedef enum {
  ZPModeActivity = 0,
  ZPModeProgress = 1,
  ZPModeCustomView = 3,
  ZPModeCustomViewWithoutTitles = 4,
} ZPMode;


//
// Throbber
//

@interface Throbber : UIView
{
  UIView                  *contentView;
  UIActivityIndicatorView *activityView;
  RoundProgressView       *progressView;
  UIView                  *customView;
  UILabel                 *titleLabel, *detailsLabel;
  ZPMode                  mode;
  CGFloat                 progress;
  BOOL                    blockNavigation;
  
  CGFloat                 opacity;
  BOOL                    gradient;
}
@property(nonatomic, retain) NSString *title, *details;
@property(nonatomic, retain) UIView *customView;
@property(nonatomic, assign) ZPMode mode;
@property(nonatomic, assign) CGFloat progress;
@property(nonatomic, assign) BOOL blockNavigation;

+ (Throbber *)defaultThrobber;
+ (void)defaultThrobberOnView:(UIView *)parentView withTitle:(NSString *)title details:(NSString *)details displayMode:(ZPMode)aMode blockNavigation:(BOOL)aBlockNavigation;

- (id)initWithFrame:(CGRect)frame;
- (void)showWithBlockNavigation:(BOOL)blockNavigation;
- (void)showWithTitle:(NSString *)aTitle;
- (void)showWithTitle:(NSString *)aTitle details:(NSString *)aDetails;
- (void)show;
- (void)dismiss;

@end
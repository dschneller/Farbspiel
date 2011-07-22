#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface ColorfulButton : UIButton {
    UIColor *_highColor;
    UIColor *_lowColor;
    
    CAGradientLayer *gradientLayer;
}

@property (nonatomic,retain) UIColor *_highColor;
@property (nonatomic,retain) UIColor *_lowColor;
@property (nonatomic, retain) CAGradientLayer *gradientLayer;

- (void)setHighColor:(UIColor*)color;
- (void)setLowColor:(UIColor*)color;


@end

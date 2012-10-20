@interface CustomColoredAccessory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}
 
@property (nonatomic) UIColor *accessoryColor;
@property (nonatomic) UIColor *highlightedColor;
 
+ (CustomColoredAccessory *)accessoryWithColor:(UIColor *)color;
 
@end
# BlurryModalSegue

BlurryModalSegue is a UIStoryboardSegue subclass that provides a blur effect for modal storyboard segues.  It provides the look and feel of a transparent modal overalay without deviating from the modal presentation model provided by Apple.

## Demo
![](assets/blurry_modal.gif)

## Installation
Via [Cocoapods](http://cocoapods.org):
```ruby
pod 'BlurryModalSegue'
```

## Usage

### Storyboard Usage

Change your modal storyboard segues from this:

![](assets/modal_storyboard.png)

To this:

![](assets/blurry_modal_storyboard.png)

Done!

### Customized Usage

To customize the blur before presentation, implement ```prepareForSegue:sender:```:
```objc
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[BlurryModalSegue class]])
    {
        BlurryModalSegue* bms = (BlurryModalSegue*)segue;
        
        bms.backingImageBlurRadius = @(20);
        bms.backingImageSaturationDeltaFactor = @(.45);
        bms.backingImageTintColor = [[UIColor greenColor] colorWithAlphaComponent:.1];
    }
}

```

## Compatibility/Restrictions
* iOS7+ only, as we take advantage of the new ```UIViewControllerTransitionCoordinator```.
* Only ```UIModalTransitionStyleCoverVertical``` is supported right now.
* Eagle-eyed developers will notice that the effect is better during presentation than dismissal.  This is because ```UIViewController -(id<UIViewControllerTransitionCoordinator>)transitionCoordinator``` only seems to support the presentation, not the dismissal.  I believe the dismissal could be implented using the ```UIViewController -(id<UIViewControllerTransitioningDelegate>)transitioningDelegate```, but that is TBD.

## Acknowledgements
* The blur effect in this library is courtesy of [UIImage-BlurredFrame](https://github.com/Adrian2112/UIImage-BlurredFrame) library.

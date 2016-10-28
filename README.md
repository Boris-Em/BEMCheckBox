# BEMCheckBox
[![Build Status](https://travis-ci.org/Boris-Em/BEMCheckBox.svg)](https://travis-ci.org/Boris-Em/BEMCheckBox)
[![Version](https://img.shields.io/cocoapods/v/BEMCheckBox.svg?style=flat)](http://cocoadocs.org/docsets/BEMCheckBox)
[![License](https://img.shields.io/cocoapods/l/BEMCheckBox.svg?style=flat)](http://cocoadocs.org/docsets/BEMCheckBox)
[![Platform](https://img.shields.io/cocoapods/p/BEMCheckBox.svg?style=flat)](http://cocoadocs.org/docsets/BEMCheckBox)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

<p align="center"><img src="http://s1.postimg.org/mcnwdl88v/BEMCheck_Box.jpg"/></p>	

**BEMCheckBox** is an open source library making it easy to create beautiful, highly customizable, animated checkboxes for iOS. 

## Table of Contents

* [**Project Details**](#project-details)  
  * [Requirements](#requirements)
  * [License](#license)
  * [Support](#support)
  * [Sample App](#sample-app)
  * [React Native] (#react-native)
* [**Getting Started**](#getting-started)
  * [Installation](#installation)
  * [Setup](#setup)
* [**Documentation**](#documentation)
  * [Enabling / Disabling the Checkbox](#enabling--disabling-the-checkbox) 
  * [Reloading](#reloading)
  * [Group / Radio Button Functionality](#group--radio-button-functionality)
  * [Delegate] (#delegate)
  * [Customization](#customization)

## Project Details
Learn more about the **BEMCheckBox** project, licensing, support etc.

<p align="center"><img src="http://s12.postimg.org/vn2irahjx/BEMCheck_Box.gif"/></p>	

### Requirements
 - Requires iOS 7 or later. The sample project is optimized for iOS 9.
 - Requires Automatic Reference Counting (ARC).
 - Optimized for ARM64 Architecture.

### License
See the [License](https://github.com/Boris-Em/BEMCheckBox/blob/master/LICENSE). You are free to make changes and use this in either personal or commercial projects. Attribution is not required, but highly appreciated. A little "Thanks!" (or something to that affect) is always welcome. If you use **BEMCheckBox** in your app, please let us know!

### Support
[![Gitter chat](https://badges.gitter.im/Boris-Em/BEMCheckBox.png)](https://gitter.im/Boris-Em/BEMCheckBox)  
Join us on [Gitter](https://gitter.im/Boris-Em/BEMCheckBox) if you need any help or want to talk about the project.

### Sample App
The iOS Sample App included with this project demonstrates one way to correctly setup and use **BEMCheckBox**. It also offers the possibility to customize the checkbox within the app.

### React Native  
**BEMCheckBox** can now be used with React Native: [React-Native-BEMCheckBox](https://github.com/torifat/react-native-bem-check-box)

## Getting Started
It only takes a few simple steps to install and setup **BEMCheckBox** to your project.

### Installation

#### CocoaPods
The easiest way to install **BEMCheckBox** is to use <a href="http://cocoapods.org/" target="_blank">CocoaPods</a>. To do so, simply add the following line to your `Podfile`:
	<pre><code>pod 'BEMCheckBox'</code></pre>


#### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

Run `carthage update` after adding **BEMCheckBox** to your Cartfile to build the framework. Drag the built `BEMCheckBox.framework` into your Xcode project.

#### Manually	
Finally, you can install **BEMCheckBox** manually. Simply drag and drop the *Classes* folder into your Xcode project. When you do so, make sure to check the "*Copy items into destination group's folder*" box.

### Setup
Setting up **BEMCheckBox** to your project couldn't be more simple. It is modeled after `UISwitch`. In fact, you could just replace instances of `UISwitch` by **BEMCheckBox** in your project!  
Here are the steps to follow to get everything up and running:

 1. Import `"BEMCheckBox.h"` to the header of your view controller:

 ```objective-c
 #import "BEMCheckBox.h"
 ```

 2. **BEMCheckBox** can either be initialized programatically (through code) or with Interface Builder (Storyboard file). Use the method that makes the most sense for your project.
 
 **Programmatical Initialization**  
 Just add the following code to your implementation (usually in the `viewDidLoad` method of your View Controller).

 ```objective-c
 BEMCheckBox *myCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
 [self.view addSubview:myCheckBox];
 ```
 
 **Interface Builder Initialization**  
 1 - Drag a `UIView` to your `UIViewController`.  
 2 - Change the class of the new `UIView` to `BEMCheckBox`.  
 3 - Select the `BEMCheckBox` and open the Attributes Inspector. Most of the customizable properties can easily be set from the Attributes Inspector. The Sample App demonstrates this capability.

## Documentation
All of the methods and properties available for **BEMCheckBox** are documented below.

### Enabling / Disabling the Checkbox
##### The `on` Property
Just like `UISwitch`, **BEMCheckBox** provides the boolean property `on` that allows you to retrieve and set (without animation) a value determining wether the BEMCheckBox object is `on` or `off`. Defaults to `NO`.  
Example usage:
```objective-c
self.myCheckBox.on = YES;
```
##### `setOn:animated:`
Just like `UISwitch`, **BEMCheckBox** provides an instance method `setOn:animated:` that sets the state of the checkbox to On or Off, optionally animating the transition.  
Example usage:
```objective-c
[self.myCheckBox setOn:YES animated:YES];
```

### Reloading
The instance method `reload` lets you redraw the entire checkbox, keeping the current `on` value.  
Example usage:  
```objective-c
[self.myCheckBox reload]
```

### Group / Radio Button Functionality
**BEMCheckBox**es can easily be grouped together to form radio button functionality. This will automatically manage the state of each checkbox in the group, so that only one is selected at a time, and can optionally require that the group has a selection at all times.

```objective-c
self.group = [BEMCheckBoxGroup groupWithCheckBoxes:@[self.checkBox1, self.checkBox2, self.checkBox3]];
self.group.selectedCheckBox = self.checkBox2; // Optionally set which checkbox is pre-selected
self.group.mustHaveSelection = YES; // Define if the group must always have a selection
```

To see which checkbox is selected in that group, just ask for it:
```objective-c
BEMCheckBox *selection = self.group.selectedCheckBox;
```

To manually update the selection for a group, just set it:
```objective-c
self.group.selectedCheckBox = self.checkBox1;
```

### Delegate
**BEMCheckBox** uses a delegate to receive check box events. The delegate object must conform to the `BEMCheckBoxDelegate` protocol, which is composed of two optional methods:

- `didTapCheckBox:`  
Sent to the delegate every time the check box gets tapped, after its properties are updated (`on`), but before the animations are completed.

- `animationDidStopForCheckBox:`  
Sent to the delegate every time the check box finishes being animated.

### Customization
**BEMCheckBox** is exclusively customizable though properties.  
The following diagram provides a good overview:  
<p align="center"><img src="http://s12.postimg.org/6bmtv86jx/BEMCheck_Box_Properties.jpg"/></p>


##### Apparence Properties
`lineWidth` - CGFloat  
The width of the lines of the check mark and box. Defaults to 2.0.  

<img align="right" width="100" height="86" src="http://s30.postimg.org/w89156q0x/BEMCheck_Box_hide_box.jpg">
`hideBox` - BOOL  
BOOL to control if the box should be hidden or not. Setting this property to `YES` will basically turn the checkbox into a check mark. Defaults to `NO`.

`boxType` - BEMBoxType   
The type of box to use. See `BEMBoxType` for possible values. Defaults to `BEMBoxTypeCircle`. 
<p align="center"><img src="http://s10.postimg.org/uui5vyry1/BEMCheck_Box_box_type.jpg"/></p>

`tintColor` - UIColor  
The color of the box when the checkbox is Off.

`onCheckColor` - UIColor  
The color of the check mark when it is On.

`onFillColor` - UIColor  
The color of the inside of the box when it is On.

`onTintColor` - UIColor  
The color of the line around the box when it is On.

##### Animations
`animationDuration` - CGFloat  
The duration in seconds of the animations. Defaults to `0.5`.

`onAnimationType` - BEMAnimationType  
The type of animation to use when the checkbox gets checked. Defaults to `BEMAnimationTypeStroke`. See `BEMAnimationType` bellow for possible values.

`offAnimationType` - BEMAnimationType  
The type of animation to use when the checkbox gets unchecked. Defaults to `BEMAnimationTypeStroke`. See `BEMAnimationType` bellow for possible values.

`BEMAnimationType`  
The possible values for `onAnimationType` and `offAnimationType`.  
- `BEMAnimationTypeStroke`
<p align="left"><img src="http://s28.postimg.org/yjzlxyap5/BEMAnimation_Type_Stroke.gif"/></p>

- `BEMAnimationTypeFill`
<p align="left"><img src="http://s14.postimg.org/6ap9fka3x/BEMAnimation_Type_Fill.gif"/></p>

- `BEMAnimationTypeBounce`
<p align="left"><img src="http://s4.postimg.org/9twu6pn61/BEMAnimation_Type_Bounce.gif"/></p>

- `BEMAnimationTypeFlat`
<p align="left"><img src="http://s11.postimg.org/7op754xe7/BEMAnimation_Type_Flat.gif"/></p>

- `BEMAnimationTypeOneStroke`
<p align="left"><img src="http://s7.postimg.org/jaabag2p3/BEMAnimation_Type_One_Stroke.gif"/></p>

- `BEMAnimationTypeFade`
<p align="left"><img src="http://s24.postimg.org/3n1rre1cx/BEMAnimation_Type_Fade.gif"/></p>

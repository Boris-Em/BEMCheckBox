# BEMCheckBox

<p align="center"><img src="http://s1.postimg.org/mcnwdl88v/BEMCheck_Box.jpg"/></p>	

**BEMCheckBox** is an open source library making it easy to create beautiful, highly customizable, animated checkboxes for iOS. 

## Table of Contents

* [**Project Details**](#project-details)  
  * [Requirements](#requirements)
  * [License](#license)
  * [Support](#support)
  * [Sample App](#sample-app)
* [**Getting Started**](#getting-started)
  * [Installation](#installation)
  * [Setup](#setup)

## Project Details
Learn more about the **BEMCheckBox** project, licensing, support etc.

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
The iOS Sample App included with this project demonstrates one way to correctly setup and use **BEMCheckBox**.

## Getting Started
It only takes a few simple steps to install and setup **BEMCheckBox** to your project.

###Installation
The easiest way to install **BEMCheckBox** is to use <a href="http://cocoapods.org/" target="_blank">CocoaPods</a>. To do so, simply add the following line to your `Podfile`:
	<pre><code>pod 'BEMCheckBox'</code></pre>
	
The other way to install **BEMCheckBox**, is to drag and drop the *Classes* folder into your Xcode project. When you do so, make sure to check the "*Copy items into destination group's folder*" box.

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


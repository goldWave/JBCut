# JBCut  
![big_icon](https://user-images.githubusercontent.com/15025129/63579222-b86e2980-c5c4-11e9-8b67-32ffc44c6320.png)

JBCut is a simple clipboard buffer app for macOS, which have some logic and ui resources is transformed from jumpcut. 

Because the jumpcut is not support 64bit, so develop the JBCut for use.

# Requirement
- macOS Sierra 10.12 or higher

# Development Environment
- xcode 10.3
- swift 5.0.1

# Package
v1.0.0 is the fist version

[Download v1.0.0 release](https://github.com/goldWave/JBCut/releases/tag/v1.0.0)

# Usage
- JBCut will store the code piece your copied. And Use `Shift-Command-V` of `Shift-Command-K` to search the clip histoy，when release the modify flags kyes (`Shift Command Option Ctrl`) will paste this code.
- you can also use the custom hotkey which is defined in preferences to paste it.
- you can also change other setting and app appearance in preferences.

# App Appearance

![appearence](https://user-images.githubusercontent.com/15025129/63584464-93cb7f00-c5cf-11e9-84ca-f5f81e08415c.gif)

![appearence](https://user-images.githubusercontent.com/15025129/63582291-64b30e80-c5cb-11e9-8b0d-38f7789ed7ed.gif)

# Licence
JBCut is MIT license.

# other 
- Since macOS 10.14 Mojave need accessibility permission to paste the code. So you should confirm `System preferences/Securtiy & Privacy/Privacy/Accessibility/JBCut` the is checked
- if you can open the JBCut, Please check `System preferences/Securtiy & Privacy/General/` is allowed apps download from anywhere.

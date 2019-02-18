MLHudAlert
==========

Hud style alert window for Mac OS X

## Screenshot

<img src='https://raw.github.com/MacLabs/MLHudAlert/master/example.png' style='width:295px;' />

## Usage

```objective-c
// Show hud window
[MLHudAlert alertWithWindow:self.window type:MLHudAlertTypeSuccess message:@"Login successed."];
```

## Installation

You need use Cocoapods, and add follow code in you `Podfile`

```ruby
pod 'MLHudAlert', git: 'https://github.com/MacLabs/MLHudAlert.git'
```

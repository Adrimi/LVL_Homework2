#Homework 2

View with a buildings that can be infinite swiped in vertical directions.
`UIScrollView` is looped around the center of itself, with a space buffer.
Added an subView to the `UIScrollView`, which is representing a moon, that can be moved around the screen, but when screen get swiped, it stay in place. In horizntal direction Moon is drawed with slight parallax. 
Moon can be grabbed BEHIND the Container with buildings using: 

```swift 
override func point 
```

After this action, moon is sended behind buildings.

Implemented: scrollViewDidScroll, layoutSubviews, gestureDelegate.
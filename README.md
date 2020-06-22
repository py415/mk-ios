# MK

## Table of Contents
1. [Overview](#Overview)
2. [Product Specs](#Product-Specs)
3. [App Walkthrough](#App-Walkthrough)
4. [Libraries](#Libraries)
5. [Credits](#Credits)

## Overview
### Description

MK an app that allows users to interact with characters from the iconic video game, Mario Kart, panning, scaling, rotating and then sending them zooming off the screen!

## Product Specs
### User Stories

- [X] User shall be able to move karts around the screen using a pan gesture.
- [X] User shall be able to adjust the size of the kart using a pinch gesture.
- [X] User shall be able to rotate a kart using a rotation gesture.
- [X] User shall be able to single tap a kart to make it zoom (animate) off the screen.
- [X] User shall be able to tap the refresh button the background to reset the kart position.
- [X] User shall be able to use the pinch and rotation gestures simultaneously.
- [X] User shall be able to see the kart slightly scale up and back down to simulate being picked up and put down when using the pan gesture.
- [X] User shall be able to single tap a kart and:
  - [X] Animate backwards slightly before racing off to simulate winding up.
  - [X] Pop a wheelie by rotating up and back down as it races off.
  - [X] Finish racing off the screen and the kart fades back to its original position.
- [X] User shall be able to tap the play button to make all karts on the track zoom (animate) off at different speeds.
- [X] User shall be able to see a character with a stop light float down, animate through the lights (gif sequence) ending on green to signal the race. The kart then go racing off.
- [X] User shall be able to see a card drop down from the top of the screen, showing the winner.
- [X] User shall be able to see the karts reset its position after the race ends.
- [X] User shall be able to add new karts by pressing the add button.
- [X] User shall be able to remove all karts in view by tapping the trash button.

## App Walkthrough

Here's a GIF of how the app works:

<img src="https://github.com/py415/app-resources/blob/master/ios/ios-mk.gif" width=250>

## Libraries

- [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage) - A performant animated GIF engine for iOS.

## Credits

>This is a companion project to CodePath's Professional iOS Course, check out the full course at [www.codepath.org](https://codepath.org/).

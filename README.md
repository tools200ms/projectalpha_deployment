
# BeMy

Alpine Linux is a light-weight, wellsuitable for embedded devices Linux distribution.

Raspberry pi is an extremely popular microcomputer featured by GPIO pins that let users create various projects related to IoT.

The aim of this project is to provide means for building 'automated' Alpine Linux image. When it is copied to SD card and inserted into pi, system after powering on will perform automatic setup for desired configuration.

Project's principle are: 
1. Do not use default passwords, device access should be granted once when user touches button, sensor or, in other words after physical interaction with device
2. Once when device receives "grant access" signal it should be heedful about it, meaning: 
   1. there should be timeout
   2. system should monitor access attempts letting exactly one user to access
3. When access is granted user can set password, or other authentication methods

The aim is to promote properly sealed devices.

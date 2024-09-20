
# AlpBase Linux Distribution

Alpine Linux is a light-weight Linux distribution that is well suited for embedded devices.

Raspberry pi is a very popular (martians migh not hear about it) microcomputer featured by GPIO pins that let on easy extencion of its capabilities by displays.

The aim of this project is to provide means for building 'automated' Alpine Linux image. When it is copied to SD card and inserted into Pi, system after powering on will perform automatic setup for a desired configuration.

Project's principle are:


Unfortunately it is quite common to meet projects that setup default user and password with a trust that it will be changed on time. 

Handshake -password less access.
1. 'Phisical contact' Do not use default passwords, device access should be granted once when user touches button or sensor, in other words after physical interaction with a device
2. Once when device opens access, user anters 
3. 
4. openning password-less  it should be heedful about it, meaning: 
   1. there should be timeout
   2. system should monitor access attempts letting exactly one user to access
3. When access is granted user can set password, or other authentication methods

The aim is to promote properly sealed devices.

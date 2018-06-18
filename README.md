# Looking for someone to maintain this project

Hi, I'm looking for someone to take over this project as I no longer have time to dedicate to it.

If you would like to do so, please contact me via an issue, make a fork and do your first change.
I can help you set up the CI and indicate on this README who is maintaining the project (name & url).

-------------------------------------------------------------

# VSTS Extension

Nsis build extension for VSTS

This extension can be used to build nsis script or to make nsis available for other tasks (as an environment variable).

[Nsis](http://nsis.sourceforge.net/Main_Page) version used is version 3.03

# Usage

* Go to VSTS Marketplace and install the extension
* In your build definition add the task "Nsis"
* Either select your nsi script (and build arguments: http://nsis.sourceforge.net/Docs/Chapter3.html#usagereference)
* Or just include NSIS as an environnement variable called NSIS_EXE that you can use in the following tasks.

There is also an option called "Include additional plugins". If you check this option, the content of the folder [nsis/plugins](../master/nsis/plugins/) will be copied to the nsis plugin folder and thos plugins will be made available to you nsis script.

To test that the task works properly, you can download [install.nsi](../master/install.nsi) and use it as a test script.

## Plugins

The nsis/plugins folder contains multiple plugins that were found on nsis web site:
* [SimpleSC](http://nsis.sourceforge.net/NSIS_Simple_Service_Plugin) NSIS Simple Service Plugin (license MPL / LGPL)
* ``Services2``, another plugin to manage services
Examples:
```
services2::IsServiceRunning "w3svc"
Pop $0
  ${If} $0 == "Yes"
...
  ${Else}
...
  ${EndIf}
```
``services2::IsServiceInstalled "w3wp"`` work the same
Also:
```
services2::SendServiceCommandWait "start" "w3wp" "120"
  Pop $0
  ${If} $0 == "Ok"
...
  ${Else}
  ...
  ${Endif}
```
* there are other plugins _to be documented_


# Availability

This extension is publicly available on VSTS Marketplace: https://marketplace.visualstudio.com/items?itemName=ThomasP.nsis-task

It is build in VSTS using VSTS Developer Tools Build Task (https://marketplace.visualstudio.com/items?itemName=ms-devlabs.vsts-developer-tools-build-tasks).
Here is the status: ![Build status](https://tomap.visualstudio.com/_apis/public/build/definitions/6d190468-0f5e-4624-9d49-8446c00b4b51/1/badge)

The build number is automatically incremented on each commit by the VSTS Build task by a pattern like "0.2.$(Build.BuildId)". See https://www.visualstudio.com/en-us/docs/build/define/variables#predefined-variables for reference.

# License

This extension is published under MIT license. See [license file](../master/LICENSE).

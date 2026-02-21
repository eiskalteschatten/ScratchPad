# ScratchPad

Take notes, keep them organized. ScratchPad is a free, simple, easy-to-use, multi-page scratchpad application for macOS.

*Note: This is the repository for ScratchPad v2. If you are looking for the source code for ScratchPad v1.x, you can find it in the old respository here: https://github.com/eiskalteschatten/ScratchPad-v1*

## System Requirements

ScratchPad doesn't need much since it is a small application. The cheapest Macs will run it just fine. The only requirement is macOS 26 Tahoe since it uses the latest APIs.

## Contributing

ScratchPad is an open source project and contributions are always welcome to improve the application! However, the goal of ScratchPad isn't to be a feature-rich program, but rather a simple one with only the basics so that users can jot down their notes quickly without thinking much about it.

As such, it is recommended to get in touch with [Alex Seifert](https://www.alexseifert.com/contact/) before you contribute any new features. Bug fixes are always welcome, however!

### Setting Up The Development Environment

ScratchPad was built with Xcode and you will need at least Xcode 26.2. After you clone the repository, you will need to open the project folder, then open the Xcode project file `ScratchPad.xcodeproj`.

Once it is open, you will need to add your Apple developer account for signing. To do so, open the project settings by clicking on the upper-most "ScratchPad" in the sidebar, then under Targets, click "ScratchPad" again. In the tab bar on top, click on "Signing & Capabilities". That is where you can add your account to sign your local builds.

After that, ScratchPad should build and run locally.

### Localization

ScratchPad is currently offered in the following languages:

* English
* German
* French
* Spanish
* Italian
* Dutch
* Russian
* Japanese
* Chinese (traditional)
* Chinese (simplified)

If you would like to add a language, feel free to open a pull request.

*Note: All languages except English and German were translated using an LLM. If you see any mistakes, please don't hesitate to fix them or let me know!*

---

[Alex Seifert](https://www.alexseifert.com/)

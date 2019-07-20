# Extension Version Checker
A small script that checks for chrome extension updates.

This is only useful if you use ungoogled chromium, because there is currently not auto-updater [Issue #285](https://github.com/Eloston/ungoogled-chromium/issues/285).

## Usage
The first two steps are only needed for the first time usage
* Create extensions.json file
* The content of the extensions.file should look like this:
```json
{
  "Extension name": {
    "url": "https://chrome.google.com/webstore/detail/extension-name/aaaaaaaaaa",
    "version": "your installed version"
}
```
* Run the script
* If there is a new version of one or more extensions open the extension-files folder and install the extensions

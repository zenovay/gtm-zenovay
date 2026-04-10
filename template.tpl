___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Zenovay Analytics",
  "categories": ["ANALYTICS"],
  "brand": {
    "id": "brand_dummy",
    "displayName": "Zenovay"
  },
  "description": "Deploy Zenovay Analytics on your website through Google Tag Manager — no code changes required. Enter your tracking code from the Zenovay dashboard, choose optional settings, and publish.",
  "containerContexts": ["WEB"]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "trackingCode",
    "displayName": "Tracking Code",
    "simpleValueType": true,
    "help": "Your unique Zenovay tracking code. Find it in your Zenovay dashboard under <strong>Settings → General</strong>.",
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "errorMessage": "Tracking Code is required. Find it in your Zenovay dashboard under Settings → General."
      }
    ],
    "alwaysInSummary": true,
    "placeholder": "e.g. abc123xyz"
  },
  {
    "type": "CHECKBOX",
    "name": "cookielessMode",
    "checkboxText": "Cookieless Mode",
    "simpleValueType": true,
    "help": "Track visitors without cookies using anonymized fingerprinting. Recommended for strict GDPR implementations — no consent banner needed.",
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "trackOutboundLinks",
    "checkboxText": "Track Outbound Links",
    "simpleValueType": true,
    "help": "Automatically send an event when visitors click links that navigate away from your website.",
    "defaultValue": false
  },
  {
    "type": "GROUP",
    "name": "advancedGroup",
    "displayName": "Advanced Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "TEXT",
        "name": "apiUrl",
        "displayName": "Custom API URL (First-Party Proxy)",
        "simpleValueType": true,
        "help": "Leave blank to use the default Zenovay CDN (<code>https://api.zenovay.com</code>). If you have set up a first-party proxy on your own domain, enter your proxy URL here to bypass ad-blockers.",
        "placeholder": "https://api.zenovay.com",
        "valueValidators": [
          {
            "type": "REGEX",
            "args": [
              "^$|^https://.+"
            ],
            "errorMessage": "Must be a valid https:// URL or leave blank for default."
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "debugMode",
        "checkboxText": "Debug Mode",
        "simpleValueType": true,
        "help": "Enable verbose console logging. Useful during setup. <strong>Disable before publishing to production.</strong>",
        "defaultValue": false
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Zenovay Analytics — GTM Community Template
// https://github.com/zenovay/gtm-zenovay
//
// Sets window.ZENOVAY_TRACKER_CONFIG before injecting z.js so the tracker
// reads the config from its highest-priority path on startup.

var injectScript = require('injectScript');
var setInWindow   = require('setInWindow');
var makeString    = require('makeString');
var log           = require('logToConsole');

// Resolve API base URL — trim trailing slash, fall back to CDN.
var rawApiUrl = makeString(data.apiUrl || '').replace(/\/$/, '');
var apiBase   = rawApiUrl !== '' ? rawApiUrl : 'https://api.zenovay.com';

// Write config synchronously before the script loads.
var config = {
  trackingCode:       makeString(data.trackingCode),
  apiUrl:             apiBase,
  cookielessMode:     data.cookielessMode === true,
  trackOutboundLinks: data.trackOutboundLinks === true,
  debugMode:          data.debugMode === true
};

setInWindow('ZENOVAY_TRACKER_CONFIG', config, true);

if (data.debugMode) {
  log('[Zenovay GTM] Config:', config);
}

// Inject tracking script — cache key includes tracking code.
injectScript(
  apiBase + '/z.js',
  data.gtmOnSuccess,
  data.gtmOnFailure,
  'zenovay-' + makeString(data.trackingCode)
);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://api.zenovay.com/z.js"
              },
              {
                "type": 1,
                "string": "https://*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ZENOVAY_TRACKER_CONFIG"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []

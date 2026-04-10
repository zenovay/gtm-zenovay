// Copyright 2026 Zenovay Analytics

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     https://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


___TERMS_OF_SERVICE___

By creating or modifying this file, you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such URL as Google may
provide), as modified from time to time.


___INFO___

{
  "displayName": "Zenovay Analytics",
  "description": "Deploy Zenovay Analytics on your website through Google Tag Manager — no code changes required. Enter your tracking code from the Zenovay dashboard and publish.",
  "categories": ["ANALYTICS"],
  "securityGroups": [],
  "id": "cvt_temp_public_id",
  "type": "TAG",
  "version": 1,
  "brand": {
    "thumbnail": "",
    "displayName": "",
    "id": "brand_dummy"
  },
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "displayName": "Tracking Code",
    "name": "trackingCode",
    "type": "TEXT",
    "simpleValueType": true,
    "help": "Your unique Zenovay tracking code. Find it in your Zenovay dashboard under Settings → General.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "checkboxText": "Cookieless Mode",
    "name": "cookielessMode",
    "type": "CHECKBOX",
    "simpleValueType": true,
    "help": "Track visitors without cookies. Recommended for strict GDPR compliance — no consent banner needed.",
    "defaultValue": false
  },
  {
    "checkboxText": "Track Outbound Links",
    "name": "trackOutboundLinks",
    "type": "CHECKBOX",
    "simpleValueType": true,
    "help": "Automatically track clicks on links that navigate to external domains.",
    "defaultValue": false
  },
  {
    "checkboxText": "Debug Mode",
    "name": "debugMode",
    "type": "CHECKBOX",
    "simpleValueType": true,
    "help": "Enable verbose console logging. Disable before publishing to production.",
    "defaultValue": false
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Zenovay Analytics — GTM Community Template
// https://github.com/zenovay/gtm-zenovay

var injectScript = require('injectScript');
var setInWindow   = require('setInWindow');
var makeString    = require('makeString');
var log           = require('logToConsole');

// Write config to window BEFORE the script loads.
// z.js reads window.ZENOVAY_TRACKER_CONFIG as its highest-priority config path.
setInWindow('ZENOVAY_TRACKER_CONFIG', {
  trackingCode:       makeString(data.trackingCode),
  cookielessMode:     data.cookielessMode === true,
  trackOutboundLinks: data.trackOutboundLinks === true,
  debugMode:          data.debugMode === true
}, true);

if (data.debugMode) {
  log('[Zenovay GTM] Tracking code:', makeString(data.trackingCode));
}

injectScript(
  'https://api.zenovay.com/z.js',
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
            "string": "debug"
          }
        }
      ]
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
              }
            ]
          }
        }
      ]
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
    "isRequired": true
  }
]


___NOTES___

Zenovay Analytics GTM Community Template.
Documentation: https://docs.zenovay.com/integrations/gtm
GitHub: https://github.com/zenovay/gtm-zenovay

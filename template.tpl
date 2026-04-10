___INFO___

{
  "displayName": "Zenovay Analytics",
  "categories": ["ANALYTICS"],
  "id": "cvt_zenovay_analytics_tag",
  "type": "TAG",
  "version": 1,
  "description": "Deploy Zenovay Analytics on your website through Google Tag Manager — no code changes required. Enter your tracking code from the Zenovay dashboard, choose optional settings, and publish. Supports cookieless tracking, outbound link tracking, and first-party proxy for ad-blocker bypass.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "trackingCode",
    "displayName": "Tracking Code",
    "simpleValueType": true,
    "help": "Your unique Zenovay tracking code. Find it in your Zenovay dashboard under <strong>Settings → General</strong> or in the onboarding flow.",
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
    "help": "Track visitors without cookies using anonymized fingerprinting (IP subnet + User Agent). Recommended for strict GDPR implementations. No consent banner needed.",
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
        "help": "Leave blank to use the default Zenovay CDN (<code>https://api.zenovay.com</code>). If you have set up a first-party proxy on your own domain (Scale+ plan), enter your proxy URL here to bypass ad-blockers. Example: <code>https://analytics.yourdomain.com</code>",
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
        "help": "Enable verbose console logging. Useful during setup and testing. <strong>Disable before publishing to production.</strong>",
        "defaultValue": false
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Zenovay Analytics — GTM Community Template
// https://github.com/zenovay/gtm-zenovay
//
// This template injects the Zenovay tracking script (z.js) from the Zenovay
// CDN (or a first-party proxy URL) and passes configuration via the
// window.ZENOVAY_TRACKER_CONFIG global, which the tracker reads as its
// highest-priority config source.

var injectScript = require('injectScript');
var setInWindow   = require('setInWindow');
var makeString    = require('makeString');
var log           = require('logToConsole');

// Resolve the API base URL: use the custom proxy URL if provided,
// otherwise fall back to the standard Zenovay CDN.
var rawApiUrl = makeString(data.apiUrl || '').replace(/\/$/, '');
var apiBase   = rawApiUrl !== '' ? rawApiUrl : 'https://api.zenovay.com';

// Build the config object that z.js reads on startup via INJECTED_CONFIG.
// MUST be set synchronously BEFORE injectScript fires so the tracker
// finds it when the IIFE runs.
var config = {
  trackingCode:       makeString(data.trackingCode),
  apiUrl:             apiBase,
  cookielessMode:     data.cookielessMode  === true,
  trackOutboundLinks: data.trackOutboundLinks === true,
  debugMode:          data.debugMode       === true
};

// Write the config to window before the script loads.
setInWindow('ZENOVAY_TRACKER_CONFIG', config, true);

if (data.debugMode) {
  log('[Zenovay GTM] Config set:', config);
}

// Inject the Zenovay tracking script.
// The cache token includes the tracking code so multiple containers
// on the same page with different tracking codes don't share a cache slot.
var scriptUrl = apiBase + '/z.js';

injectScript(
  scriptUrl,
  data.gtmOnSuccess,
  data.gtmOnFailure,
  'zenovay-' + makeString(data.trackingCode)
);


___WEB_PERMISSIONS___

[
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
            "type": 1,
            "listItem": [
              {
                "type": 2,
                "mapItem": [
                  {
                    "key": "url",
                    "value": {
                      "type": 1,
                      "string": "https://api.zenovay.com/z.js"
                    }
                  }
                ]
              },
              {
                "type": 2,
                "mapItem": [
                  {
                    "key": "url",
                    "value": {
                      "type": 1,
                      "string": "https://*"
                    }
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isRequired": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 1,
            "listItem": [
              {
                "type": 2,
                "mapItem": [
                  {
                    "key": "key",
                    "value": {
                      "type": 1,
                      "string": "ZENOVAY_TRACKER_CONFIG"
                    }
                  },
                  {
                    "key": "read",
                    "value": {
                      "type": 8,
                      "boolean": false
                    }
                  },
                  {
                    "key": "write",
                    "value": {
                      "type": 8,
                      "boolean": true
                    }
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isRequired": true
    },
    "isRequired": true
  },
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
            "listItem": [
              {
                "type": 1,
                "string": "debug"
              }
            ]
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

[
  {
    "name": "Test: fires gtmOnSuccess when tracking code is provided",
    "code": "const mockData = {\n  trackingCode: 'test_abc123',\n  cookielessMode: false,\n  trackOutboundLinks: false,\n  debugMode: false,\n  apiUrl: '',\n  gtmOnSuccess: function() {},\n  gtmOnFailure: function() {}\n};\n\nmock('injectScript', function(url, onSuccess, onFailure) {\n  onSuccess();\n});\n\nmock('setInWindow', function(key, value, override) {\n  assertThat(key).isEqualTo('ZENOVAY_TRACKER_CONFIG');\n  assertThat(value.trackingCode).isEqualTo('test_abc123');\n  assertThat(value.apiUrl).isEqualTo('https://api.zenovay.com');\n  assertThat(value.cookielessMode).isEqualTo(false);\n});\n\nmock('logToConsole', function() {});\n\nrunCode(mockData);\nassertApi('gtmOnSuccess').wasCalled();\n"
  },
  {
    "name": "Test: uses custom apiUrl when first-party proxy is configured",
    "code": "const mockData = {\n  trackingCode: 'test_proxy',\n  cookielessMode: false,\n  trackOutboundLinks: false,\n  debugMode: false,\n  apiUrl: 'https://analytics.example.com',\n  gtmOnSuccess: function() {},\n  gtmOnFailure: function() {}\n};\n\nmock('injectScript', function(url, onSuccess, onFailure) {\n  assertThat(url).isEqualTo('https://analytics.example.com/z.js');\n  onSuccess();\n});\n\nmock('setInWindow', function(key, value) {\n  assertThat(value.apiUrl).isEqualTo('https://analytics.example.com');\n});\n\nmock('logToConsole', function() {});\n\nrunCode(mockData);\nassertApi('gtmOnSuccess').wasCalled();\n"
  },
  {
    "name": "Test: cookieless mode is passed through to config",
    "code": "const mockData = {\n  trackingCode: 'test_cookieless',\n  cookielessMode: true,\n  trackOutboundLinks: false,\n  debugMode: false,\n  apiUrl: '',\n  gtmOnSuccess: function() {},\n  gtmOnFailure: function() {}\n};\n\nmock('injectScript', function(url, onSuccess) { onSuccess(); });\n\nmock('setInWindow', function(key, value) {\n  assertThat(value.cookielessMode).isEqualTo(true);\n});\n\nmock('logToConsole', function() {});\n\nrunCode(mockData);\nassertApi('gtmOnSuccess').wasCalled();\n"
  },
  {
    "name": "Test: fires gtmOnFailure when script injection fails",
    "code": "const mockData = {\n  trackingCode: 'test_fail',\n  cookielessMode: false,\n  trackOutboundLinks: false,\n  debugMode: false,\n  apiUrl: '',\n  gtmOnSuccess: function() {},\n  gtmOnFailure: function() {}\n};\n\nmock('injectScript', function(url, onSuccess, onFailure) {\n  onFailure();\n});\n\nmock('setInWindow', function() {});\nmock('logToConsole', function() {});\n\nrunCode(mockData);\nassertApi('gtmOnFailure').wasCalled();\n"
  },
  {
    "name": "Test: trailing slash stripped from custom apiUrl",
    "code": "const mockData = {\n  trackingCode: 'test_slash',\n  cookielessMode: false,\n  trackOutboundLinks: false,\n  debugMode: false,\n  apiUrl: 'https://analytics.example.com/',\n  gtmOnSuccess: function() {},\n  gtmOnFailure: function() {}\n};\n\nmock('injectScript', function(url, onSuccess) {\n  assertThat(url).isEqualTo('https://analytics.example.com/z.js');\n  onSuccess();\n});\n\nmock('setInWindow', function() {});\nmock('logToConsole', function() {});\n\nrunCode(mockData);\nassertApi('gtmOnSuccess').wasCalled();\n"
  }
]

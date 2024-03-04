'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js": "5b1ca6b45b96e7a820e9a479893504d5",
"version.json": "389a6e6e6f34312743ca5f36467c84b5",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "c54cf8ce2e9cf050ed79bbc2a53efaf3",
"/": "c54cf8ce2e9cf050ed79bbc2a53efaf3",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"assets/NOTICES": "b89d3fa3392a50ff22b8ac289381fed8",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/fonts/MaterialIcons-Regular.otf": "2213312d04d9c13c00725d65e3190839",
"assets/assets/images/3.5x/back.png": "85db134e26410547037485447f659277",
"assets/assets/images/3.5x/settings.png": "c977a1e6c59e8cfd5cd88a0c973928fc",
"assets/assets/images/3.5x/restart.png": "583169ac365d9515fc12f29e3b530de0",
"assets/assets/images/back.png": "3c82301693d5c4140786184a06c23f7e",
"assets/assets/images/settings.png": "840fd7e3337c743046bf992ef18a10b8",
"assets/assets/images/2x/back.png": "85cda8f41a13153d6f3fb1c403f272ea",
"assets/assets/images/2x/settings.png": "8404e18c68ba99ca0b181bd96ace0376",
"assets/assets/images/2x/restart.png": "83aea4677055df9b0d8171f5315f2a60",
"assets/assets/images/3x/back.png": "88a977a654df5a490037340f90a5a19e",
"assets/assets/images/3x/settings.png": "21ff2cc135a762f74ed1a80aac6502bb",
"assets/assets/images/3x/restart.png": "429270ce832c881b80fbd592e5ff1e0e",
"assets/assets/images/restart.png": "d3d2e3f3b2f6cb1e1a69b8b2529096f7",
"assets/assets/fonts/Madimi_One/MadimiOne-Regular.ttf": "0b217da0e6bb96f122de239d016b7527",
"assets/assets/fonts/Permanent_Marker/PermanentMarker-Regular.ttf": "c863f8028c2505f92540e0ba7c379002",
"assets/assets/sfx/dsht1.mp3": "c99ece72f0957a9eaf52ade494465946",
"assets/assets/sfx/wehee1.mp3": "5a986231104c9f084104e5ee1c564bc4",
"assets/assets/sfx/sh1.mp3": "f695db540ae0ea850ecbb341a825a47b",
"assets/assets/sfx/sh2.mp3": "e3212b9a7d1456ecda26fdc263ddd3d0",
"assets/assets/sfx/p2.mp3": "ab829255f1ef20fbd4340a7c9e5157ad",
"assets/assets/sfx/wssh1.mp3": "cf92e8d8483097569e3278c82ac9f871",
"assets/assets/sfx/yay1.mp3": "8d3b940e33ccfec612d06a41ae616f71",
"assets/assets/sfx/fwfwfwfwfw1.mp3": "46355605b43594b67a39170f89141dc1",
"assets/assets/sfx/hash2.mp3": "d26cb7676c3c0d13a78799b3ccac4103",
"assets/assets/sfx/swishswish1.mp3": "219b0f5c2deec2eda0a9e0e941894cb6",
"assets/assets/sfx/ws1.mp3": "5cfa8fda1ee940e65a19391ddef4d477",
"assets/assets/sfx/k1.mp3": "37ffb6f8c0435298b0a02e4e302e5b1f",
"assets/assets/sfx/hh1.mp3": "fab21158730b078ce90568ce2055db07",
"assets/assets/sfx/hash3.mp3": "38aad045fbbf951bf5e4ca882b56245e",
"assets/assets/sfx/wssh2.mp3": "255c455d9692c697400696cbb28511cc",
"assets/assets/sfx/haw1.mp3": "00db66b69283acb63a887136dfe7a73c",
"assets/assets/sfx/kch1.mp3": "a832ed0c8798b4ec95c929a5b0cabd3f",
"assets/assets/sfx/spsh1.mp3": "2e1354f39a5988afabb2fdd27cba63e1",
"assets/assets/sfx/ehehee1.mp3": "52f5042736fa3f4d4198b97fe50ce7f3",
"assets/assets/sfx/hash1.mp3": "f444469cd7a5a27062580ecd2b481770",
"assets/assets/sfx/fwfwfwfw1.mp3": "d0f7ee0256d1f0d40d77a1264f23342b",
"assets/assets/sfx/hh2.mp3": "4d39e7365b89c74db536c32dfe35580b",
"assets/assets/sfx/kss1.mp3": "fd0664b62bb9205c1ba6868d2d185897",
"assets/assets/sfx/README.md": "33033a0943d1325f78116fcf4b8a96ec",
"assets/assets/sfx/p1.mp3": "ad28c0d29ac9e8adf9a91a46bfbfac82",
"assets/assets/sfx/lalala1.mp3": "b0b85bf59814b014ff48d6d79275ecfd",
"assets/assets/sfx/k2.mp3": "8ec44723c33a1e41f9a96d6bbecde6b9",
"assets/assets/sfx/oo1.mp3": "94b9149911d0f2de8f3880c524b93683",
"assets/assets/music/Mr_Smith-Azul.mp3": "9463595498dc48b3d3d6805fb7c19dc7",
"assets/assets/music/Mr_Smith-Sonorus.mp3": "9353b7bb732002062e2c9107a95f3d2a",
"assets/assets/music/Mr_Smith-Sunday_Solitude.mp3": "5fb1f2fbf4314eb5df35b62706942698",
"assets/assets/music/README.md": "035041cfb2070f794172dedb2aa709b6",
"assets/AssetManifest.json": "ff025b90a231a7910efddc246c32fff1",
"assets/FontManifest.json": "777002fc31a0bd793fac6a3e6cc20130",
"assets/AssetManifest.bin": "ee0d849aaad5d04c1e45593929dac18f",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/canvaskit.wasm": "19d8b35640d13140fe4e6f3b8d450f04",
"canvaskit/chromium/canvaskit.wasm": "1165572f59d51e963a5bf9bdda61e39b",
"canvaskit/chromium/canvaskit.js": "96ae916cd2d1b7320fff853ee22aebb0",
"canvaskit/canvaskit.js": "bbf39143dfd758d8d847453b120c8ebb",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"manifest.json": "56128fc6ec7568b99d6fc24cfa34a218"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

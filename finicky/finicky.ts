import type { FinickyConfig } from "/Applications/Finicky.app/Contents/Resources/finicky.d.ts";

export default {
  defaultBrowser: "Zen",
  options: {
    // Check for updates. Default: true
    checkForUpdates: true,
    // Log every request to file. Default: false
    logRequests: false,
    // Keep Finicky running in the background
    keepRunning: false,
    // Hide the Finicky icon from the menu bar
    hideIcon: false,
  },
  rewrite: [
    'https://reddit.com/r/hello';
    {
      match: "reddit.com/*",
      url: "https://r.til.io",
    },
    {
      match: (m) => true,
      url: (url) => {
        const lower = (s: string) => String(s || "").toLowerCase();
        const removeExact = new Set([
          "fbclid",
          "gclid",
          "dclid",
          "gbraid",
          "wbraid",
          "msclkid",
          "ttclid",
          "twclid",
          "li_fat_id",
          "mkt_tok",
          "mc_cid",
          "mc_eid",
          "igsh",
          "si",
          "feature",
          "ref",
          "ref_src",
          "spm",
        ]);
        const removePrefixes = ["utm_", "uta_", "ga_", "pk_", "vero_"];
        const removeByValue = new Set([
          "share",
          "social",
          "social_media",
          "social_network",
        ]);

        const keys = [...url.searchParams.keys()];

        for (const key of keys) {
          const k = lower(key),
            v = lower(url.searchParams.get(key) ?? "");
          const isExact = removeExact.has(k);
          const isPrefix = removePrefixes.some((p) => k.startsWith(p));
          const isValueNoise =
            (k === "source" || k === "src" || k === "medium") &&
            removeByValue.has(v);

          if (isExact || isPrefix || isValueNoise) {
            url.searchParams.delete(key);
          }
        }

        return url.href;
      },
    },
  ],
  handlers: [
    {
      match: "zoom.us/*",
      browser: "Helium",
    },
  ],
} satisfies FinickyConfig;

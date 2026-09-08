#!/usr/bin/env Rscript

url <- "http://localhost:7567/"
out <- NULL
out_try <- paste0(c("", "website/"), "assets/open-graph-card.png")
for (p in out_try) {
  p <- here::here(p)
  if (dir.exists(dirname(p))) {
    out <- p
  }
}
stopifnot(!is.null(out))


available <- tryCatch(
  {
    resp <- curl::curl_fetch_memory(url)
    resp$status_code == 200
  },
  error = function(e) FALSE
)

if (!available) {
  stop(
    "Preview site is not available at ",
    url,
    ". Run `make preview` first.",
    call. = FALSE
  )
}

b <- chromote::ChromoteSession$new(width = 765, height = 400)

b$Page$navigate(url, wait_ = TRUE)
b$Page$loadEventFired()
Sys.sleep(1)

b$Runtime$evaluate(
  "const style = document.createElement('style');
   style.textContent = `
     #quarto-announcement, #quarto-header, .navbar { display: none !important; }
     .quarto-title-banner {
       height: 400px !important;
       max-height: 400px !important;
       min-height: 400px !important;
       box-sizing: border-box !important;
       margin-top: 0 !important;
     }
     body { margin-top: 0 !important; padding-top: 0 !important; }
   `;
   document.head.appendChild(style);
   window.scrollTo(0, 0);",
  wait_ = TRUE
)

b$screenshot(out, cliprect = c(0, 0, 765, 400))

b$close()

img <- png::readPNG(out)
cat(sprintf("Screenshot saved to %s (%dx%d)\n", out, ncol(img), nrow(img)))

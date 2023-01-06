const fs = require('fs')

async function main() {
  const platformSuffix = 'x86_64-unknown-linux-gnu'
  fs.copyFileSync(
    require.resolve('./_build/dev/rel/ectoprint/bin/server'),
    `src-tauri/ectoprint-binaries/server-${platformSuffix}`
  )
  fs.copyFileSync(
    require.resolve('./_build/dev/rel/ectoprint/bin/ectoprint'),
    `src-tauri/ectoprint-binaries/ectoprint-${platformSuffix}`
  )
}

main().catch((e) => {
  throw e
})

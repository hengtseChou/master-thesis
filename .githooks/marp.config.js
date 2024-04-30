const marpHideSlidesPlugin = require('./hide-slides-plugin')

module.exports = {
  engine: ({ marp }) => marp.use(marpHideSlidesPlugin)
}
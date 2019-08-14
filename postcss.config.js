const purgecss = require('@fullhuman/postcss-purgecss')({
  content: [
    './app/components/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb'
  ],
  keyframes: true,
  fontFace: true,
  defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || [],
  whitelistPatterns: [
    /([a-z0-9]+(_[a-z0-9]+)?)+(--)([a-z0-9]+(-[a-z0-9]+)?)+/g,
    /([a-z0-9]+(_[a-z0-9]+)?)+__([a-z0-9]+(_[a-z0-9]+)?)+/,
    /CodeMirror-*/,
    /cm-*/,
    /tippy*/,
    /popper*/
  ]
})

module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('tailwindcss')('./app/javascript/tailwind.js'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    }),
    purgecss
  ]
}
